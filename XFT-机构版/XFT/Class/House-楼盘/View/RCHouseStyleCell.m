//
//  RCHouseStyleCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseStyleCell.h"
#import "RCHouseStyleCell.h"
#import "RCHouseDetail.h"

@interface RCHouseStyleCell ()
@property (weak, nonatomic) IBOutlet UILabel *styleTag;
@property (weak, nonatomic) IBOutlet UIImageView *housePic;
@property (weak, nonatomic) IBOutlet UILabel *styleName;
@property (weak, nonatomic) IBOutlet UILabel *roomArea;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation RCHouseStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setStyle:(RCHouseStyle *)style
{
    _style = style;
    [self.housePic sd_setImageWithURL:[NSURL URLWithString:_style.housePic]];
    self.styleName.text = _style.name;
    self.roomArea.text = [NSString stringWithFormat:@"%@ %@㎡",_style.hxType,_style.buldArea];
    self.price.text = [NSString stringWithFormat:@"%@万",_style.totalPrice];
    //0：待售2：售磬 其他销售中
    if ([_style.salesState isEqualToString:@"0"]) {
        self.styleTag.text = @"待售";
        self.styleTag.backgroundColor = UIColorFromRGB(0x00CC99);
    }else if ([_style.salesState isEqualToString:@"2"]) {
        self.styleTag.text = @"售磬";
        self.styleTag.backgroundColor = UIColorFromRGB(0x999999);
    }else{
        self.styleTag.text = @"销售中";
        self.styleTag.backgroundColor = UIColorFromRGB(0xEC142D);
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.styleTag bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(6.f, 6.f)];
}
@end
