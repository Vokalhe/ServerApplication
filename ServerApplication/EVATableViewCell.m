//
//  EVATableViewCell.m
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import "EVATableViewCell.h"

#import "ParentObject.h"

@implementation EVATableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat) heightForText:(NSString *)text viewController: (UIViewController*) vc{
   
    CGFloat widthView = CGRectGetWidth(vc.view.bounds);
    
    CGFloat offset = 10.0;
    UIFont *font = [UIFont systemFontOfSize:16.f];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName,
                                paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize: CGSizeMake(widthView-2*offset, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    
    return CGRectGetHeight(rect);
    
}

+ (CGFloat) heightForName:(ParentObject*) object viewController: (UIViewController*) vc {

    
    CGFloat heightImageButton = 30;
    
    CGFloat heightForText = [EVATableViewCell heightForText:object.name viewController:vc];
    
    if (heightForText > heightImageButton) {
        return heightForText + 10;
    }else{
        return heightImageButton + 10;
    }
    
}

- (void) configureCellForName:(ParentObject*) object viewController: (UIViewController*) vc{

    CGFloat heightForText = [EVATableViewCell heightForText:object.name viewController:vc];
    CGRect frameForTextLabel = CGRectMake(10, 5, CGRectGetWidth(vc.view.bounds)-10, heightForText);
   
    if (self.ibNameLabel == nil) {
        self.ibNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.ibNameLabel];
        
        self.ibNameLabel.numberOfLines = 0;
        self.ibNameLabel.font = [self.ibNameLabel.font fontWithSize:14];
        self.ibNameLabel.textColor = [UIColor darkGrayColor];
    }
    
    self.ibNameLabel.frame = frameForTextLabel;

    
}
@end
