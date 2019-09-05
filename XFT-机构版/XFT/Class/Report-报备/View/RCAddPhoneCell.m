//
//  RCAddPhoneCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddPhoneCell.h"

@implementation RCAddPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)cutBtnClicked:(UIButton *)sender {
    if (self.cutBtnCall) {
        self.cutBtnCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
