//
//  EVAVideoViewController.h
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/11/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParentObject;

@interface EVAVideoViewController : UIViewController

@property (strong, nonatomic) ParentObject *video;
@property (strong, nonatomic) NSURL *url;

@end
