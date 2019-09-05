//
//  RCMyBrokerCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyBrokerCell.h"

@implementation RCMyBrokerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)resetClicked:(UIButton *)sender {
    if (self.resetPwdCall) {
        self.resetPwdCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
