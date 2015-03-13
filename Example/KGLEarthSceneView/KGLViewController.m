//
//  KGLViewController.m
//  KGLEarthSceneView
//
//  Created by Kevin Li on 03/11/2015.
//  Copyright (c) 2014 Kevin Li. All rights reserved.
//

#import "KGLViewController.h"

@interface KGLViewController ()

@end

@implementation KGLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // drop some pins
    KGLEarthCoordinate *washingtonPin = [KGLEarthCoordinate coordinateWithLatitude:38.889752f andLongitude:-77.009074f andPinIdentifier:@"Washington, DC"];
    KGLEarthCoordinate *canberraPin = [KGLEarthCoordinate coordinateWithLatitude:-35.308229f andLongitude:149.124460f andPinIdentifier:@"Canberra"];
    KGLEarthCoordinate *londonPin = [KGLEarthCoordinate coordinateWithLatitude:51.499970f andLongitude:-0.124696f andPinIdentifier:@"London"];
    
    [self.earthScene dropPinsAtLocations:@[washingtonPin,canberraPin, londonPin]];
    
    
    // format the label
    self.countryLabel.backgroundColor = [UIColor colorWithHexString:@"5d5d5d" alpha:0.5f];
    self.countryLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)flyToLondon:(id)sender {
    [self.earthScene swoopToLatitude:51.499970f andLongitude:-0.124696f completion:^{
        // animation has completed
        self.countryLabel.text = @"London";
    }];
}

#pragma mark - Earth delegate method
- (void)tappedPinWithIdentifier:(NSString *)identifier {
    self.countryLabel.text = identifier;
}

@end
