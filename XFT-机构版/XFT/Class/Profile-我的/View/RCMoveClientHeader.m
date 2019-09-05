//
//  RCMoveClientHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMoveClientHeader.h"

@implementation RCMoveClientHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)clientTypeClicked:(SPButton *)sender {
    if (self.clientTypeCall) {
        self.clientTypeCall();
    }
}

@end
