//
//  RCHouseStyleDetailCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseStyleDetailCell.h"

@interface RCHouseStyleDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *houseImg;

@end
@implementation RCHouseStyleDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setPicUrl:(NSString *)picUrl
{
    _picUrl = picUrl;
    [self.houseImg sd_setImageWithURL:[NSURL URLWithString:_picUrl]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
