//
//  RCReportResultSectionHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportResultSectionHeader.h"

@interface RCReportResultSectionHeader ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation RCReportResultSectionHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.bgView bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
}
@end
