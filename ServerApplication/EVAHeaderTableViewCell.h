//
//  EVAHeaderTableViewCell.h
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVAHeaderTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *ibOpenButton;
@property (strong, nonatomic)  UILabel *ibTitleLabel;

- (void) configureCellForHeaderViewController: (UIViewController*) vc state:(BOOL) isSelected;
+ (CGFloat) heightForHeader;

@end
