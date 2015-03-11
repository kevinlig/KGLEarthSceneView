//
//  KGLCameraRigNode.h
//
//  Created by Kevin Li on 2/25/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface KGLCameraRigNode : SCNNode

/// @brief The node that contains the camera. This node primarily moves about the Y axis, but makes adjustments along the X and Z axes in order to maintain a constant distance from the Earth's surface.
@property (nonatomic, strong) SCNNode *cameraMount;
/// @brief The node that contains the sun light.
@property (nonatomic, strong) SCNNode *sunNode;

/// @brief The camera's distance from the center of the Earth. Defaults to 150 units, but will change based on camera zoom.
@property float cameraRadius;
/// @brief The camera rig's longitudinal angle along the Equator, in degrees.
@property float currentAngle;
/// @brief The camera mount's latitudinal angle along the North-South axis, in degrees.
@property float altitudeAngle;

/// @brief The scene that the camera belongs to. This is used to perform touch gesture translations.
@property (weak) SCNView *sceneView;

/*!
 * @discussion Convenience method for creating an instance of the KGLCameraRigNode class. This method also sets up the internal camera mount and sun light.
 * @param target The node that the camera should always be looking at/rotating around.
 * @return Returns an instance of the KGLCameraRigNode class.
 */
+ (KGLCameraRigNode *)nodeWithTarget:(SCNNode *)target;

/*!
 * @discussion Sets up the touch gestures for the camera, to allow the user to pinch to zoom and pan to rotate.
 */
- (void)associateGestures;

@end
