//
//  RCClientFilterTimeView.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientFilterTimeView.h"

@interface RCClientFilterTimeView ()

@end

@implementation RCClientFilterTimeView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)timeClicked:(UIButton *)sender {
    if (self.filterTimeCall) {
        self.filterTimeCall(sender.tag == 1?self.beginTime:self.endTime);
    }
}

@end
