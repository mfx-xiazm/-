//
//  RCSearchTagHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCSearchTagHeader.h"

@implementation RCSearchTagHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)locationClicked:(UIButton *)sender {
    if (self.resetLocationCall) {
        self.resetLocationCall();
    }
}

@end
