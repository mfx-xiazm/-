//
//  RCMyClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyClientCell.h"
#import "RCClientCodeView.h"
#import <zhPopupController.h>
#import "RCMyClient.h"

@interface RCMyClientCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *priName;
@property (weak, nonatomic) IBOutlet UILabel *reportName;
@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet UILabel *remark;

@end
@implementation RCMyClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clientBtnClicked:(UIButton *)sender {
    if (self.clientHandleCall) {
        self.clientHandleCall(sender.tag);
    }
}
-(void)setClient:(RCMyClient *)client
{
    _client = client;
    [self.headerPic sd_setImageWithURL:[NSURL URLWithString:_client.cusPic]];
    self.name.text = _client.name;
     //@[@"已到访",@"已认筹",@"已认购",@"已签约",@"已退房",@"已失效",@"已报备"];
    if (self.cusType == 1) {
        self.time.text = [NSString stringWithFormat:@"到访时间：%@",_client.lastVistTime];
        self.priName.text = [NSString stringWithFormat:@"到访项目：%@",_client.proName];
    }else if (self.cusType == 2) {
        self.time.text = [NSString stringWithFormat:@"认筹时间：%@",_client.recognitionTime];
        self.priName.text = [NSString stringWithFormat:@"认筹项目：%@",_client.proName];
    }else if (self.cusType == 3) {
        self.time.text = [NSString stringWithFormat:@"认购时间：%@",_client.buyTime];
        self.priName.text = [NSString stringWithFormat:@"认购项目：%@",_client.proName];
    }else if (self.cusType == 4) {
        self.time.text = [NSString stringWithFormat:@"签约时间：%@",_client.signTime];
        self.priName.text = [NSString stringWithFormat:@"签约项目：%@",_client.proName];
    }else if (self.cusType == 5) {
        self.time.text = [NSString stringWithFormat:@"退房时间：%@",_client.checkOutTime];
        self.priName.text = [NSString stringWithFormat:@"退房项目：%@",_client.proName];
    }else if (self.cusType == 6) {
        self.time.text = [NSString stringWithFormat:@"失效时间：%@",_client.invalidTime];
        self.priName.text = [NSString stringWithFormat:@"失效项目：%@",_client.proName];
    }else{
        self.time.text = [NSString stringWithFormat:@"报备时间：%@",_client.seeTime];
        self.priName.text = [NSString stringWithFormat:@"报备项目：%@",_client.proName];
    }
   
    self.reportName.text = [NSString stringWithFormat:@"报备人：%@(%@)",_client.reportName,_client.reportRole];    
}
-(void)setClient1:(RCMyClient *)client1
{
    _client1 = client1;
    
    [self.headerPic sd_setImageWithURL:[NSURL URLWithString:_client1.cusPic]];
    self.name.text = _client1.name;
    self.time.text = [NSString stringWithFormat:@"报备时间：%@",_client1.seeTime];
    self.priName.text = [NSString stringWithFormat:@"案场顾问：%@",_client1.salesName];
    //@[@"已到访",@"已认筹",@"已认购",@"已签约",@"已退房",@"已失效",@"已报备"];
    if (self.cusType == 1) {
        self.codeBtn.hidden = YES;

        self.time2.text = [NSString stringWithFormat:@"最近到访：%@",_client1.lastVistTime];
    }else if (self.cusType == 2) {
        self.codeBtn.hidden = YES;

        self.time2.text = [NSString stringWithFormat:@"认筹时间：%@",_client1.recognitionTime];
    }else if (self.cusType == 3) {
        self.codeBtn.hidden = YES;

        self.time2.text = [NSString stringWithFormat:@"认购时间：%@",_client1.buyTime];
    }else if (self.cusType == 4) {
        self.codeBtn.hidden = YES;

        self.time2.text = [NSString stringWithFormat:@"签约时间：%@",_client1.signTime];
    }else if (self.cusType == 5) {
        self.codeBtn.hidden = YES;

        self.time2.text = [NSString stringWithFormat:@"退房时间：%@",_client1.checkOutTime];
    }else if (self.cusType == 6) {
        self.codeBtn.hidden = YES;

        self.time2.text = [NSString stringWithFormat:@"失效时间：%@",_client1.invalidTime];
    }else{
        self.codeBtn.hidden = NO;

        self.time2.text = [NSString stringWithFormat:@"最后备注：%@",_client1.time];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

