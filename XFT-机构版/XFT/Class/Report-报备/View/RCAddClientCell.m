//
//  RCAddClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddClientCell.h"

@interface RCAddClientCell ()
/* 上一次选择的性别 */
@property(nonatomic,strong) UIButton *sexBtn;
@end
@implementation RCAddClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)cutBtnClicked:(UIButton *)sender {
    if (self.cutBtnCall) {
        self.cutBtnCall();
    }
}
- (IBAction)clientSexClicked:(UIButton *)sender {
    self.sexBtn.selected = NO;
    self.sexBtn.boderColor = UIColorFromRGB(0xCCCCCC);
    sender.selected = YES;
    sender.boderColor = UIColorFromRGB(0x666666);
    self.sexBtn = sender;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
