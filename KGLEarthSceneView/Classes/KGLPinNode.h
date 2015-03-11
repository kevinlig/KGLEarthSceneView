//
//  KGLPinNode.h
//
//  Created by Kevin Li on 3/2/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "KGLEarthCommonMath.h"

@interface KGLPinNode : SCNNode

/*!
 * @discussion Convenience method for creating a pin, with internal nodes set up, at a specified location, assuming an Earth at the center of the scene with a radius of 50 units.
 * @param latitude The pin's latitude, in degrees.
 * @param longitude The pin's longitude, in degrees.
 * @return An instance of the KGLPinNode class.
 */
+ (KGLPinNode *)pinAtLatitude:(float)latitude andLongitude:(float)longitude;

/// @brief The string identifier for the pin. This will be returned by the KGLEarthSceneView delegate if the user taps on the pin.
/// @warning If no identifier is provided, the pin will never respond to a tap event.
@property (nonatomic, copy) NSString *identifier;
/// @brief The latitude of the pin, in degrees.
@property float latitude;
/// @brief The longitude of the pin, in degrees.
@property float longitude;

@end
