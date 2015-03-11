//
//  KGLAssetHelpers.h
//  Pods
//
//  Created by Kevin Li on 3/11/15.
//
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface UIImage (KGLAssets)

/*!
 * @discussion Loads a UIImage from the SCNAsset folder inside the Cocoapod resource bundle.
 * @param name File name of the image.
 * @return The file as a UIImage.
 */
+ (UIImage *)earthAssetNamed:(NSString *)name;

@end

@interface SCNScene (KGLAssets)

/*!
 * @discussion Loads a SCNScene from the SCNAsset folder inside the Cocoapod resource bundle.
 * @param name File name of the COLLADA file.
 * @return The file as a SCNScene.
 */
+ (SCNScene *)colladaFileNamed:(NSString *)name;

@end
