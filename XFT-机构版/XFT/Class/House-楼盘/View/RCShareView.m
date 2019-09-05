//
//  RCShareView.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCShareView.h"

@implementation RCShareView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)shareTypeClicked:(SPButton *)sender {
    if (self.shareTypeCall) {
        self.shareTypeCall(1,sender.tag);
    }
}
- (IBAction)cancelClicked:(UIButton *)sender {
    if (self.shareTypeCall) {
        self.shareTypeCall(0,sender.tag);
    }
}

@end
