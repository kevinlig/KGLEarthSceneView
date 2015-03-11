//
//  KGLPinNode.m
//
//  Created by Kevin Li on 3/2/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "KGLPinNode.h"
#import "KGLAssetHelpers.h"

@interface KGLPinNode ()

@end

@implementation KGLPinNode

+ (KGLPinNode *)pinAtLatitude:(float)latitude andLongitude:(float)longitude {
    KGLPinNode *pin = [super node];

    if (pin) {
        pin.latitude = latitude;
        pin.longitude = longitude;
    }
    
    pin.name = @"pinWrapper";
    
    // extract the pin geometry from the COLLADA file
    SCNScene *pinScene = [SCNScene colladaFileNamed:@"pin.dae"];
    SCNNode *pinNode = [pinScene.rootNode childNodeWithName:@"pin" recursively:NO];
    pinNode.scale = SCNVector3Make(300, 300, 300);
    
    // add the pin geometry to the pin node
    [pin addChildNode:pinNode];
    
    // pins are small, especially from directly above or zoomed out, so wrap a larger rectangular node around the pin
    // this will create a greater touch area
    SCNBox *touchBrick = [SCNBox boxWithWidth:5.0f height:7.5f length:5.0f chamferRadius:0];
    SCNNode *touchNode = [SCNNode nodeWithGeometry:touchBrick];
    touchNode.hidden = YES;
    touchNode.name = @"TouchPin";
    [pin addChildNode:touchNode];
    
    // position the pin
    // calculate the pin's position along the Y axis of the Earth, based on the given latitude
    float yPos = sinf(DEGREES_TO_RADIANS(latitude)) * 50.0f;
    // calculate what the radius of the horizontal circle that cuts through the Earth is at the given Y position
    float localRadius = [KGLEarthCommonMath radiusOfCircleBisectingSphereOfRadius:50.0f atHeight:yPos];
    // using the local radius, calculate the X and Z positions of the pin, based on the given longitude
    HorizontalCoords coords = [KGLEarthCommonMath horizontalCoordinatesAtDegrees:longitude ofSphereRadius:localRadius];
    pin.position = SCNVector3Make(-1 * coords.x, yPos, coords.z);
    
    // rotate the pin so it stands vertically at 90 degrees from the surface of the Earth
    // first, set the pin's euler angles such that it lies flat against the surface of the Earth, given the pin's location
    // the yaw angle positions the pin so it faces out from the surface of the Earth at its location
    float yawAngle = atan2f(-1 * coords.x, coords.z);
    // the pitch angle tilts the pin so it lies on the ground
    float pitchAngle = -1 * DEGREES_TO_RADIANS(latitude);
    pin.eulerAngles = SCNVector3Make(pitchAngle, yawAngle, 0);
    
    // now rotate the pin by 180 degrees vertically, so it stands up
    SCNMatrix4 latRotation = SCNMatrix4MakeRotation(DEGREES_TO_RADIANS(180),1, 0, 0);
    pin.transform = SCNMatrix4Mult(latRotation, pin.transform);
    
    return pin;
}

@end
