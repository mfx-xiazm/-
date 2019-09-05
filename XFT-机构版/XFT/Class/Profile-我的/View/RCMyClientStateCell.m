//
//  RCMyClientStateCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientStateCell.h"

@interface RCMyClientStateCell ()
@property (weak, nonatomic) IBOutlet UILabel *clientNum;
@property (weak, nonatomic) IBOutlet UILabel *clientState;

@end
@implementation RCMyClientStateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.clientNum.textColor = selected ? HXControlBg :  UIColorFromRGB(0x999999);
    self.clientState.textColor = selected ? HXControlBg :  UIColorFromRGB(0x999999);
}

@end
