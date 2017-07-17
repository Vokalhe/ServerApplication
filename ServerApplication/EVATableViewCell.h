//
//  EVATableViewCell.h
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@class ParentObject;

@interface EVATableViewCell : SWTableViewCell

@property (strong, nonatomic)  UILabel *ibNameLabel;

- (void) configureCellForName:(ParentObject*) object viewController: (UIViewController*) vc;
+ (CGFloat) heightForName:(ParentObject*) object viewController: (UIViewController*) vc;

@end
