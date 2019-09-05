//
//  RCHouseNearbyHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseNearbyHeader.h"

@interface RCHouseNearbyHeader ()
/* 第一个按键 */
@property (weak, nonatomic) IBOutlet SPButton *firstBtn;
/* 上一次选中的类型按键 */
@property(nonatomic,strong) SPButton *lastBtn;
@end
@implementation RCHouseNearbyHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.lastBtn = self.firstBtn;
}
- (IBAction)nearbyTypeClicked:(SPButton *)sender {
    self.lastBtn.selected = NO;
    sender.selected = YES;
    self.lastBtn = sender;
    if (self.nearbyTypeCall) {
        self.nearbyTypeCall(sender.tag);
    }
}

@end
