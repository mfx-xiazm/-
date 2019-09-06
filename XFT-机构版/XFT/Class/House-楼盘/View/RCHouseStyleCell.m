//
//  RCHouseStyleCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseStyleCell.h"

@interface RCHouseStyleCell ()
@property (weak, nonatomic) IBOutlet UILabel *styleTag;

@end
@implementation RCHouseStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.styleTag bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(6.f, 6.f)];
}
@end
