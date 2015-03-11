//
//  KGLCameraRigNode.m
//
//  Created by Kevin Li on 2/25/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "KGLCameraRigNode.h"
#import "KGLEarthCommonMath.h"

@interface KGLCameraRigNode ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;


- (void)detectedPanGesture:(UIPanGestureRecognizer *)sender;
- (void)detectedPinchGesture:(UIPinchGestureRecognizer *)sender;


@end

@implementation KGLCameraRigNode

+ (KGLCameraRigNode *)nodeWithTarget:(SCNNode *)target {
    
    KGLCameraRigNode *rigNode = [super node];
    
    // create the camera in the jib
    rigNode.cameraMount = [SCNNode node];
    rigNode.cameraMount.camera = [SCNCamera camera];
    rigNode.cameraMount.camera.automaticallyAdjustsZRange = YES;
    
    // position the jib node 150 units from the center
    rigNode.position = SCNVector3Make(0, 0, 150);
    rigNode.cameraRadius = 150.0f;
    [rigNode addChildNode:rigNode.cameraMount];
    
    // add in the sun
    rigNode.sunNode = [SCNNode node];
    rigNode.sunNode.light = [SCNLight light];
    rigNode.sunNode.light.type = SCNLightTypeOmni;
    rigNode.sunNode.light.color = [UIColor colorWithWhite:0.75f alpha:1.0f];
    
    // the sun is 23.5 degrees north of the Earth's equator
    // position the sun appropriately, at a distance of 175 units from the center of the planet
    float yCoord = sinf(DEGREES_TO_RADIANS(23.5f)) * 175.0f;
    float zPos = [KGLEarthCommonMath radiusOfCircleBisectingSphereOfRadius:175 atHeight:yCoord];
    rigNode.sunNode.position = SCNVector3Make(0, yCoord, zPos - 150.0f);
    [rigNode addChildNode:rigNode.sunNode];
 
    // force the camera to always look at the Earth, also prevent camera roll
    SCNLookAtConstraint *cameraConstraint = [SCNLookAtConstraint lookAtConstraintWithTarget:target];
    cameraConstraint.gimbalLockEnabled = YES;
    rigNode.cameraMount.constraints = @[cameraConstraint];
    
    // set up the touch gestures
    rigNode.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:rigNode action:@selector(detectedPanGesture:)];
    rigNode.pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:rigNode action:@selector(detectedPinchGesture:)];
    
    // set up the default angles for gesture handlers
    rigNode.currentAngle = 0;
    rigNode.altitudeAngle = 0;
    
    // set up the default camera radius for the pinch gesture
    rigNode.cameraRadius = 150.0f;
    
    
    
    return rigNode;
}

- (void)associateGestures {
    [self.sceneView addGestureRecognizer:self.panGesture];
    [self.sceneView addGestureRecognizer:self.pinchGesture];
}

- (void)detectedPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint panMovement = [sender translationInView:self.sceneView];
    float newAngle = self.currentAngle + panMovement.x;

    // calculate the position of the CameraRigNode (which will always have a Y position along the Earth's equator) such that it will have a horizontal angle from 0,0 equal to newAngle degrees
    HorizontalCoords horizontalPos = [KGLEarthCommonMath horizontalCoordinatesAtDegrees:newAngle ofSphereRadius:150.0f];
    self.position = SCNVector3Make(horizontalPos.x, self.position.y, horizontalPos.z);
    
    // it is possible that the user wants the camera to move vertically along the Earth's latitudinal axis
    // in this case, we will move the cameraMount child node relative to the parent cameraRigNode, primarily along the Y axis, but also with modifications to the X and Z axes in order to maintain a constant 150 unit distance from the center of the Earth
    float yPos = self.cameraMount.position.y;
    // use the finger's Y axis movement as the change in the vertical vertex angle between the Earth's center and the camera mount's universal Y position
    float proposedYAngle = fmodf(self.altitudeAngle + (panMovement.y / 5), 360);
    
    // don't allow the angle to exceed 60 degrees
    float acceptedYAngle = self.altitudeAngle;
    if (fabsf(proposedYAngle) <= 60.0f) {
        acceptedYAngle = proposedYAngle;
    }
    
    // calculate the Y position the camera will need to be relative to the Earth's equator in order to create the proposed vertex angle, given a distance of 150 units (or other camera radius, if the camera has tracked in/out for different zoom levels) from the center of the Earth
    yPos = sinf(DEGREES_TO_RADIANS(acceptedYAngle)) * self.cameraRadius;

    // calculate the radius of the circle that is formed if a circle with radius equal to cameraRadius horizontally bisects the Earth at the Y position
    float localRadius = [KGLEarthCommonMath radiusOfCircleBisectingSphereOfRadius:self.cameraRadius atHeight:yPos];
    
    // recalculate the X and Z coordinates for the camera using the same horizontal angle, but this time using the localRadius to adjust for the Y position
    HorizontalCoords localCoords = [KGLEarthCommonMath horizontalCoordinatesAtDegrees:newAngle ofSphereRadius:localRadius];
    
    // move the camera mount, but remember the camera mount is relative to the camera rig position, so we'll need to adjust the universal coordinates to relative coordinates
    self.cameraMount.position = SCNVector3Make(localCoords.x - horizontalPos.x, yPos, localCoords.z - horizontalPos.z);
    
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.currentAngle = newAngle;
        self.altitudeAngle = acceptedYAngle;
    }
    
}

- (void)detectedPinchGesture:(UIPinchGestureRecognizer *)sender {

    self.cameraRadius = self.cameraRadius - (sender.scale * sender.velocity * [UIScreen mainScreen].scale);
    
    // don't allow the camera to get closer than 80 units from the center of the Earth or further away than 180 units
    if (self.cameraRadius <= 80.0f) {
        self.cameraRadius = 80.0f;
    }
    else if (self.cameraRadius >= 180.0f) {
        self.cameraRadius = 180.0f;
    }
    else if (isnan(self.cameraRadius)) {
        self.cameraRadius = 150.0f;
    }
    
    // calculate the Y position of the camera mount, given the new camera distance from the center of the Earth
    float yPos = sinf(DEGREES_TO_RADIANS(self.altitudeAngle)) * self.cameraRadius;
    
    // calculate the radius of the circle that is formed if a circle with radius equal to cameraRadius horizontally bisects the Earth at the Y position
    float localRadius = [KGLEarthCommonMath radiusOfCircleBisectingSphereOfRadius:self.cameraRadius atHeight:yPos];
    
    // recalculate the X and Z coordinates for the camera using the same horizontal angle as the camera rig node's current angle, but this time using the localRadius to adjust for the Y position
    HorizontalCoords localCoords = [KGLEarthCommonMath horizontalCoordinatesAtDegrees:self.currentAngle ofSphereRadius:localRadius];
    
    // move the camera mount, but remember the camera mount is relative to the camera rig position, so we'll need to adjust the universal coordinates to relative coordinates
    self.cameraMount.position = SCNVector3Make(localCoords.x - self.position.x, yPos, localCoords.z - self.position.z);
    
}

@end
