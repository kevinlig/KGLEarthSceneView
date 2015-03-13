//
//  KGLViewController.h
//  KGLEarthSceneView
//
//  Created by Kevin Li on 03/11/2015.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KGLEarthSceneView/KGLEarthSceneView.h>

@interface KGLViewController : UIViewController <KGLEarthSceneViewDelegate>

@property (weak) IBOutlet KGLEarthSceneView *earthScene;
@property (weak) IBOutlet UILabel *countryLabel;

- (IBAction)flyToLondon:(id)sender;

@end
