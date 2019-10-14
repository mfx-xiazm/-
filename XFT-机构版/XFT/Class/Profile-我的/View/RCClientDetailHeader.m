//
//  RCClientDetailHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientDetailHeader.h"
#import "RCMyClientDetail.h"

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
-(void)setClientInfo:(RCMyClientDetail *)clientInfo
{
    _clientInfo = clientInfo;
//    [self.headPic sd_setImageWithURL:[NSURL URLWithString:_clientInfo.cusPic]];
    self.name.text = _clientInfo.name;
    
    // 0:已报备 2:已到访 4:已认筹 5:已认购 6:已签约 7:已退房 100:已失效 (默认状态为:0)
    if (_clientInfo.cusState == 0) {
        self.cusState.text = [NSString stringWithFormat:@"%zd天失效",_clientInfo.yuqiTime];
        self.time.text = [NSString stringWithFormat:@"备注时间：%@",_clientInfo.lastRemarkTime];
    }else if (_clientInfo.cusState == 2) {
        self.cusState.text = @" 已到访 ";
        self.time.text = [NSString stringWithFormat:@"到访时间：%@",_clientInfo.lastVistTime];
    }else if (_clientInfo.cusState == 4) {
        self.cusState.text = @" 已认筹 ";
        self.time.text = [NSString stringWithFormat:@"认筹时间：%@",_clientInfo.transTime];
    }else if (_clientInfo.cusState == 5) {
        self.cusState.text = @" 已认购 ";
        self.time.text = [NSString stringWithFormat:@"认购时间：%@",_clientInfo.transTime];
    }else if (_clientInfo.cusState == 6) {
        self.cusState.text = @" 已签约 ";
        self.time.text = [NSString stringWithFormat:@"签约时间：%@",_clientInfo.transTime];
    }else if (_clientInfo.cusState == 7) {
        self.cusState.text = @" 已退房 ";
        self.time.text = [NSString stringWithFormat:@"退房时间：%@",_clientInfo.transTime];
    }else{
        self.cusState.text = @" 已失效 ";
        self.time.text = [NSString stringWithFormat:@"失效时间：%@",_clientInfo.invalidTime];
    }
    self.guwen.text = [NSString stringWithFormat:@"案场顾问:%@",(_clientInfo.salesName && _clientInfo.salesName.length)?_clientInfo.salesName:@"暂无"];
    [self.phoneBtn setTitle:_clientInfo.phone forState:UIControlStateNormal];
}
- (IBAction)clientClicked:(SPButton *)sender {
    if (self.clientDetailCall) {
        self.clientDetailCall(sender.tag);
    }
}

@end
