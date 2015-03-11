//
//  KGLEarthNode.m
//
//  Created by Kevin Li on 2/25/15.
//  Copyright (c) 2015 Kevin Li. All rights reserved.
//

#import "KGLEarthNode.h"
#import "KGLAssetHelpers.h"

@implementation KGLEarthNode

+ (KGLEarthNode *)earth {
    // create the Earth sphere
    SCNSphere *earthGeometry = [SCNSphere sphereWithRadius:50];
    KGLEarthNode *earthNode = [super node];
    earthNode.name = @"EarthNode";
    earthNode.geometry = earthGeometry;
    
    // texture the earth
    SCNMaterial *earthMaterial = [SCNMaterial material];
    earthMaterial.diffuse.contents = [UIImage earthAssetNamed:@"earth_material.jpg"];
    earthMaterial.normal.contents = [UIImage earthAssetNamed:@"bump_map.jpg"];
    earthMaterial.specular.contents = [UIImage earthAssetNamed:@"spec_map.jpg"];
    earthGeometry.materials = @[earthMaterial];
    
//    // create the clouds
//    SCNSphere *cloudGeometry = [SCNSphere sphereWithRadius:50.5f];
//    earthNode.cloudNode = [SCNNode nodeWithGeometry:cloudGeometry];
//    cloudGeometry.firstMaterial.diffuse.contents = [UIColor whiteColor];
//    cloudGeometry.firstMaterial.specular.contents = [UIColor whiteColor];
//    cloudGeometry.firstMaterial.transparent.contents = [UIImage imageNamed:@"clouds_transparent.jpg"];
//    cloudGeometry.firstMaterial.transparencyMode = SCNTransparencyModeRGBZero;
//    earthNode.cloudNode.castsShadow = NO;
//    [earthNode addChildNode:earthNode.cloudNode];
    
    // create the atmospheric glow
    SCNSphere *atmosphereGeometry = [SCNSphere sphereWithRadius:52];
    earthNode.atmosphereNode = [SCNNode nodeWithGeometry:atmosphereGeometry];
    atmosphereGeometry.firstMaterial.diffuse.contents = [UIColor colorWithHexString:@"9fd2e5"];
    atmosphereGeometry.firstMaterial.transparency = 0.2f;
    earthNode.atmosphereNode.castsShadow = NO;
    [earthNode addChildNode:earthNode.atmosphereNode];
    
    
//    // animate the clouds to rotate around the globe
//    earthNode.cloudNode.pivot = SCNMatrix4MakeRotation(M_PI_2, 0, 0, 0);
//    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"rotation"];
//    spin.fromValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, 0)];
//    spin.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, 2*M_PI)];
//    spin.duration = 600;
//    spin.repeatCount = INFINITY;
//    [earthNode.cloudNode addAnimation:spin forKey:@"spin"];

    
    return earthNode;

}


@end
