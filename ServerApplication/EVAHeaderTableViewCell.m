//
//  EVAHeaderTableViewCell.m
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import "EVAHeaderTableViewCell.h"

@implementation EVAHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightForHeader{
    
    return 50;
    
}

- (void) configureCellForHeaderViewController: (UIViewController*) vc state:(BOOL) isSelected{
    
    CGRect frameForTextLabel = CGRectMake(10, 10, CGRectGetWidth(vc.view.bounds)-50, 30);
    self.ibTitleLabel = [[UILabel alloc] initWithFrame:frameForTextLabel];
    self.ibTitleLabel.numberOfLines = 0;
    self.ibTitleLabel.font = [self.ibTitleLabel.font fontWithSize:20];
    self.ibTitleLabel.textColor = [UIColor darkGrayColor];
    
    [self.contentView addSubview:self.ibTitleLabel];
    
}
@end
