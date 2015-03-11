//
//  KGLEarthNode.h
//
//  Created by Kevin Li on 2/25/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <HexColors/HexColor.h>

@interface KGLEarthNode : SCNNode

/// @brief The node containing the atmosphere geometry.
@property (nonatomic, strong) SCNNode *atmosphereNode;

/// @brief The node containing the cloud geometry.
/// @deprecated Deprecated in this version. Cloud node will not be rendered.
@property (nonatomic, strong) SCNNode *cloudNode;

/*!
 * @discussion Convenience method for creating an instance of the KGLEarthNode class, with the internal geometries and atmosphere already setup.
 * @return Returns an instance of the KGLEarthNode class.
 */
+ (KGLEarthNode *)earth;

@end
