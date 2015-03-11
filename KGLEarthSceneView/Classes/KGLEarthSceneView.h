//
//  KGLEarthSceneView.h
//
//  Created by Kevin Li on 2/25/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "KGLEarthNode.h"
#import "KGLEarthCoordinate.h"
#import "KGLCameraRigNode.h"
#import "KGLPinNode.h"
#import "KGLEarthCommonMath.h"
#import "KGLAssetHelpers.h"

@protocol KGLEarthSceneViewDelegate <NSObject>

@optional
/*!
 * @discussion Delegate method called when the user taps on a map pin.
 * @discussion If a pin without an identifier is tapped, this delegate method will not be called.
 * @param identifier The string name of the pin identifier.
 */
- (void)tappedPinWithIdentifier:(NSString *)identifier;

@end

@interface KGLEarthSceneView : SCNView

@property (weak) id<KGLEarthSceneViewDelegate> delegate;

/// @brief The SceneKit scene object that contains everything.
@property (nonatomic, strong) SCNScene *scene;
/// @brief The node containing the Earth geometry and atmosphere.
@property (nonatomic, strong) KGLEarthNode *earthNode;
/// @brief The current pins dropped on the Earth.
@property (nonatomic, strong) NSMutableArray *currentPins;

/*!
 * @discussion Adds pins to the Earth.
 * @param pinArray An array of KGLEarthCoordinate objects.
 */
- (void)dropPinsAtLocations:(NSArray *)pinArray;

/*!
 * @discussion Animates the camera to the specified latitude and longitude, and also zooms the camera in to 45 units from the Earth's surface.
 * @param latitude The ending latitude position, specified in degrees.
 * @param longitude The ending longitude position, specified in degrees.
 * @param completionBlock A block that is called upon completion of the animation.
 */
- (void)swoopToLatitude:(float)latitude andLongitude:(float)longitude completion:(void(^)())completionBlock;

@end
