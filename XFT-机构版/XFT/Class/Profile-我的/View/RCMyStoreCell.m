//
//  RCMyStoreCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyStoreCell.h"

@implementation RCMyStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)resetPwdClicked:(UIButton *)sender {
    if (self.resetPwdCall) {
        self.resetPwdCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
