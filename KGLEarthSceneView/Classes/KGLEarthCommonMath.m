//
//  KGLEarthCommonMath.m
//
//  Created by Kevin Li on 2/25/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "KGLEarthCommonMath.h"

@implementation KGLEarthCommonMath

+ (float)radiusOfCircleBisectingSphereOfRadius:(float)radius atHeight:(float)height {
    // calculate the angle of the radius line going from the center of the sphere to the specified Y position
    float radianAngle = asinf(height/radius);
    float bisectRadius = cos(radianAngle) * radius;
    return bisectRadius;
}

+ (HorizontalCoords)horizontalCoordinatesAtDegrees:(float)degrees ofSphereRadius:(float)radius {
    HorizontalCoords coordinates;
    
    float radianAngle = DEGREES_TO_RADIANS(degrees);
    float xPos = sinf(radianAngle) * radius * -1;
    float zPos = cosf(radianAngle) * radius;
    
    coordinates.x = xPos;
    coordinates.z = zPos;
    
    return coordinates;
}


@end
