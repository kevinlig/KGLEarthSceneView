//
//  KGLAssetHelpers.m
//  Pods
//
//  Created by Kevin Li on 3/11/15.
//
//

#import "KGLAssetHelpers.h"

@implementation UIImage (KGLAssets)

+ (UIImage *)earthAssetNamed:(NSString *)name {
    
    NSString *bundlePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"KGLEarthSceneView.bundle"];
    NSString *assetFolder = [bundlePath stringByAppendingPathComponent:@"KGLEarthAssets.scnassets"];
    NSString *assetFile = [assetFolder stringByAppendingPathComponent:name];
    
    UIImage *assetImage = [UIImage imageWithContentsOfFile:assetFile];
    return assetImage;
}

@end

@implementation SCNScene (KGLAssets)

+ (SCNScene *)colladaFileNamed:(NSString *)name {
    
    SCNScene *assetDae = [SCNScene sceneNamed:[NSString stringWithFormat:@"KGLEarthSceneView.bundle/KGLEarthAssets.scnassets/%@",name]];
    return assetDae;

    
}

@end
