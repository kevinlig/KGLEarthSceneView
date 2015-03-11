//
//  KGLEarthSceneView.m
//
//  Created by Kevin Li on 2/25/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "KGLEarthSceneView.h"

@interface KGLEarthSceneView ()

@property (nonatomic, strong) KGLCameraRigNode *rigNode;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

- (void)createCamera;
- (void)createLights;
- (void)createSkybox;

- (void)tapEvent:(id)sender;

@end

@implementation KGLEarthSceneView

- (void)awakeFromNib {
    
    self.scene = [SCNScene scene];
    
    // create the earth
    self.earthNode = [KGLEarthNode earth];
    [self.scene.rootNode addChildNode:self.earthNode];
    
    // set up an array for holding pins
    self.currentPins = [NSMutableArray array];
    
    // light the scene
    [self createLights];
    
    // create the skybox
    [self createSkybox];
    
    // create the camera
    [self createCamera];
    
    self.autoenablesDefaultLighting = NO;
    
    // set up a gesture recognizer for taps
    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent:)];
    [self addGestureRecognizer:self.tapGesture];

}

- (void)createCamera {
    self.rigNode = [KGLCameraRigNode nodeWithTarget:self.earthNode];
    self.rigNode.sceneView = self;
    [self.rigNode associateGestures];
    [self.scene.rootNode addChildNode:self.rigNode];
}


- (void)createLights {
    // create an ambient light (this stays in a constant location in the scene)
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeAmbient;
    lightNode.light.color = [UIColor colorWithWhite:0.8f alpha:0.67f];
    [self.scene.rootNode addChildNode:lightNode];
    
    
}


- (void)createSkybox {
    // add in the starfield
    self.scene.background.contents = @[[UIImage earthAssetNamed:@"star_01.jpg"],[UIImage earthAssetNamed:@"star_02.jpg"],[UIImage earthAssetNamed:@"star_03.jpg"],[UIImage earthAssetNamed:@"star_04.jpg"],[UIImage earthAssetNamed:@"star_05.jpg"],[UIImage earthAssetNamed:@"star_06.jpg"]];
    self.backgroundColor = [UIColor blackColor];
}

- (void)dropPinsAtLocations:(NSArray *)pinArray {
    
    // remove any existing pins
    for (SCNNode *node in self.currentPins) {
        [node removeFromParentNode];
    }
    self.currentPins = [NSMutableArray array];
    
    // create new pins
    for (KGLEarthCoordinate *coord in pinArray) {
        KGLPinNode *newPin = [KGLPinNode pinAtLatitude:coord.latitude andLongitude:coord.longitude];
        if (coord.pinIdentifier) {
            newPin.identifier = coord.pinIdentifier;
        }
        [self.scene.rootNode addChildNode:newPin];
        [self.currentPins addObject:newPin];
    }
    
}

- (void)swoopToLatitude:(float)latitude andLongitude:(float)longitude completion:(void(^)())completionBlock {

    // determine the final position of the camera rig, based on the longitude and latitude
    // remember that camera rig stays at a Y position of 0 and is locked in a orbit around the Earth's equator at a radius of 150 units
    HorizontalCoords finalPos = [KGLEarthCommonMath horizontalCoordinatesAtDegrees:longitude ofSphereRadius:150.0f];
    
    float currentDegrees = -1 * self.rigNode.currentAngle;
    
    // since keyframe animation will find the shortest path between points, anything more than a short distance away will cause the camera to fly through the Earth
    // workaround to this is to create an array of actions that draw a circular arc around the planet
    NSMutableArray *animationPoints = [NSMutableArray array];
    
    // calculate how many turn points are necessary; we're going to set a turn point every 8 degrees of longitude
    int turnPoints = ceil(fabsf(longitude - currentDegrees) / 8.0f);
    float increment = (longitude - currentDegrees) / turnPoints;
    float newAngle = currentDegrees;
    
    // total animation time is 1.5 seconds; the duration of each subanimation will depend on the calculated number of turn points
    float totalAnimationTime = 1.5f;
    float unitAnimationTime = totalAnimationTime / turnPoints;
    
    // iterate through the turn points and create an animation for that segment. Push the new animation into the animation array
    for (int i = 1; i <= turnPoints; i++) {
        newAngle = (i * increment) + currentDegrees;
        HorizontalCoords newPos = [KGLEarthCommonMath horizontalCoordinatesAtDegrees:newAngle ofSphereRadius:150.0f];
        SCNAction *turnAction = [SCNAction moveTo:SCNVector3Make(-1 * newPos.x, 0, newPos.z) duration:unitAnimationTime];
        turnAction.timingFunction = SCNActionTimingModeLinear;
        [animationPoints addObject:turnAction];
    }
    
    // if we aren't at the final destination yet (though we should be less than 8 degrees away), add one more animation to get there
    if (newAngle != longitude) {
        SCNAction *turnAction = [SCNAction moveTo:SCNVector3Make(-1 * finalPos.x, 0, finalPos.z) duration:unitAnimationTime];
        turnAction.timingFunction = SCNActionTimingModeLinear;
        [animationPoints addObject:turnAction];
        
    }
    
    // now we need to animate the camera mount (the node inside the camera rig that handles Y axis movement) to the correct Y position based on the latitude
    // we're going to also zoom into the pin, such that the camera is 45 units away from the surface of the Earth (45 units + 50 unit Earth radius = total radius of 95 units)
    float yPos = sinf(DEGREES_TO_RADIANS(latitude)) * 95.0f;
    
    // since the Earth is a sphere, we need to offset the camera mount's X and Z positions at the Y position to maintain a constant 45 unit distance from the surface
    float localRadius = [KGLEarthCommonMath radiusOfCircleBisectingSphereOfRadius:95.0f atHeight:yPos];
    HorizontalCoords mountPos = [KGLEarthCommonMath horizontalCoordinatesAtDegrees:longitude ofSphereRadius:localRadius];
    
    // combine the subanimations in the animation array into one big animation
    SCNAction *rigSequence = [SCNAction sequence:animationPoints];

    // animate the camera rig
    if ([animationPoints count] > 0) {
        [self.rigNode runAction:rigSequence];
    }
    
    // simulatenously, animate the camera mount
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:totalAnimationTime];
    [SCNTransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // camera mount position is relative to the parent camera rig node position, so we need to calculate an offset
    self.rigNode.cameraMount.position = SCNVector3Make(-1 * (mountPos.x - finalPos.x), yPos, mountPos.z - finalPos.z);
    
    [SCNTransaction setCompletionBlock:^{
        // we'll call the method's completion block here, since this should correspond to both sets of animations finishing
        if (completionBlock) {
            completionBlock();
        }
        
    }];
    
    [SCNTransaction commit];
    
    // pass the angles and zoom information for the completed animation state back into the camera rig node, so that subsequent pan, tilt, and zoom operations (as well as future animations) will pick up from where the animation finishes
    self.rigNode.currentAngle = -1 * longitude;
    self.rigNode.cameraRadius = 95.0f;
    self.rigNode.altitudeAngle = latitude;
    
}

- (void)tapEvent:(id)sender {
    // user has tapped on the scene, check to see if they tapped a pin
    // get the location of the tap
    CGPoint tapLocation = [sender locationInView:self];
    NSArray *hits = [self hitTest:tapLocation options:@{SCNHitTestIgnoreHiddenNodesKey: @(NO)}];
    
    // iterate through all the nodes that the tap has touched (all nodes in a straight line from the touch point)
    for (SCNHitTestResult *result in hits) {
        
        // pins are wrapped inside a node called TouchPin to give them greater touch areas
        if ([result.node.name isEqualToString:@"TouchPin"]) {
            
            // return the pin's identifier
            KGLPinNode *parentNode = (KGLPinNode *)result.node.parentNode;
            
            // stop the iteration, we only want the closest pin (the hit result array is ordered by distance)
            if (parentNode.identifier) {
                [self.delegate tappedPinWithIdentifier:parentNode.identifier];
                break;
            }
        }
        
        else if ([result.node.name isEqualToString:@"EarthNode"]) {
            // we've hit the Earth, stop iterating (anything after this is on the other side of the planet)
            break;
        }
    }
}

@end
