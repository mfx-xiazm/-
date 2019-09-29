//
//  RCClientDetailHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientDetailHeader.h"
#import "RCMyClient.h"

@interface RCClientDetailHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *cusState;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *guwen;
@property (weak, nonatomic) IBOutlet SPButton *phoneBtn;

@end
@implementation RCClientDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}
-(void)setClientInfo:(RCMyClient *)clientInfo
{
    _clientInfo = clientInfo;
    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_clientInfo.cusPic]];
    self.name.text = _clientInfo.name;
    self.cusState.text = @" 客户状态 ";
    self.time.text = [NSString stringWithFormat:@"根据客户状态显示对应时间"];
    self.guwen.text = [NSString stringWithFormat:@"缺少案场顾问"];
    [self.phoneBtn setTitle:_clientInfo.phone forState:UIControlStateNormal];
}
- (IBAction)clientClicked:(SPButton *)sender {
    if (self.clientDetailCall) {
        self.clientDetailCall(sender.tag);
    }
}

@end
