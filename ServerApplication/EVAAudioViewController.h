//
//  EVAAudioViewController.h
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/11/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParentObject;

typedef enum{
    
    TypeAnimationsFirst = 0,
    TypeAnimationsSecond = 1,
    TypeAnimationsThird = 2
    
}TypeAnimations;

@interface EVAAudioViewController : UIViewController

@property (strong, nonatomic) NSURL *url;
@property (weak, nonatomic) IBOutlet UINavigationItem *ibTitle;
@property (strong, nonatomic) NSString *titleAudio;
@property (strong, nonatomic) ParentObject *audio;
@property (assign, nonatomic) TypeAnimations type;

@end
