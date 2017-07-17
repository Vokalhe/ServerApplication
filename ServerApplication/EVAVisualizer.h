//
//  EVAVisualizer.h
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EVAAudioViewController.h"

@interface EVAVisualizer : UIView

@property (nonatomic, retain) UIColor* barColor;
@property (nonatomic, readonly) NSInteger numberOfBars;

- (id)initWithNumberOfBars:(int)numberOfBars;

- (void)startTypeOfAnimations:(TypeAnimations) type;

-(void)stop;

@end
