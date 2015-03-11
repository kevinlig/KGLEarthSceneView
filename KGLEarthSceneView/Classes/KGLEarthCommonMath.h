//
//  KGLEarthCommonMath.h
//
//  Created by Kevin Li on 2/25/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RADIANS_TO_DEGREES(radians) (radians * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(degrees) (degrees * (M_PI/180.0))

/*!
 @struct HorizontalCoords
 @abstract Represents the X and Z coordinates of a point in the scene universe. These coordinates represent a point on a 2D circle lying horizontally in the scene.
 @field x The X coordinate in the 3D scene universe.
 @field z The Z coordinate in the 3D scene universe.

 */
typedef struct {
    float x;
    float z;
} HorizontalCoords;


@interface KGLEarthCommonMath : NSObject

/*!
 * @discussion Calculates the radius of a circle lying on a horizontal plane that cuts through a sphere of the given radius (positioned at the center of the scene) at the specified height.
 * @param radius The radius of the sphere that the horizontal circle should cut through.
 * @param height The Y position the horizontal circle should be cutting through the sphere at.
 * @return The radius of the horizontal circle.
 */
+ (float)radiusOfCircleBisectingSphereOfRadius:(float)radius atHeight:(float)height;

/*!
 * @discussion Calculates the X and Z positions (coordinates on a horizontal plane in the scene) that fall on a circle's arc (starting from the center of the scene), given the specified circle radius and the specified angle.
 * @param degrees The angle of the arc, in degrees.
 * @param radius The radius of the horizontal circle that the point should fall on.
 * @return Returns a HorizontalCoords struct, which contains X and Z fields.
 */
+ (HorizontalCoords)horizontalCoordinatesAtDegrees:(float)degrees ofSphereRadius:(float)radius;

@end
