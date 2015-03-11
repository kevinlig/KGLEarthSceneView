//
//  KGLEarthCoordinate.h
//
//  Created by Kevin Li on 3/2/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGLEarthCoordinate : NSObject

/// @brief The identifier string to pass onto the KGLPinNode when it is created.
@property (nonatomic, copy) NSString *pinIdentifier;
/// @brief The latitude of the coordinate, in degrees.
@property float latitude;
/// @brief The longitude of the coordinate, in degrees.
@property float longitude;

/*!
 * @discussion Convenience method for creating an instance of KGLEarthCoordinate at a given latitude, longitude, and identifier string for the eventual KGLPinNode that will be created using these coordinates.
 * @param latitude The latitude of the coordinate, in degrees.
 * @param longitude The longitude of the coordinate, in degrees.
 * @param identifier The identifier string for any KGLPinNode objects that are created from these coordinates.
 * @return An instance of KGLEarthCoordinate.
 */
+ (KGLEarthCoordinate *)coordinateWithLatitude:(float)latitude andLongitude:(float)longitude andPinIdentifier:(NSString *)identifier;

/*!
 * @discussion Convenience method for creating an instance of KGLEarthCoordinate at a given latitude, longitude.
 * @warning If the resulting coordinates are used to create an KGLPinNode, that node will not have an identifier string and will not respond to tap events.
 * @param latitude The latitude of the coordinate, in degrees.
 * @param longitude The longitude of the coordinate, in degrees.
 * @return An instance of KGLEarthCoordinate.
 */
+ (KGLEarthCoordinate *)coordinateWithLatitude:(float)latitude andLongitude:(float)longitude;


@end
