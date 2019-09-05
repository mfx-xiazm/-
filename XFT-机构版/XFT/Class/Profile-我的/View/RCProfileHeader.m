//
//  RCProfileHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileHeader.h"

@implementation RCProfileHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)infoClicked:(UIButton *)sender {
    if (self.profileHeaderClicked) {
        self.profileHeaderClicked();
    }
}

@end
