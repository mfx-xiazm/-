//
//  RCWishHouseCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCWishHouseCell.h"

@implementation RCWishHouseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)selectBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    sender.backgroundColor = sender.isSelected ?HXRGBAColor(255, 159, 8, 0.2): UIColorFromRGB(0xF6F7FB);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
