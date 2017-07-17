//
//  UIImage+Color.h
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)tintImage:(UIImage *)baseImage color:(UIColor *)theColor;
- (UIImage *)imageTintedWithColor:(UIColor *)color;

@end
