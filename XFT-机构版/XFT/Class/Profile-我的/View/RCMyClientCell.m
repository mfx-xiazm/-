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
#import "RCSearchClient.h"

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
    /** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        //[self.headerPic sd_setImageWithURL:[NSURL URLWithString:_client.cusPic]];
        self.name.text = _client.name;
        self.codeBtn.hidden = YES;
        // @[@"已报备",@"已到访",@"已认筹",@"已认购",@"已签约",@"已退房",@"已失效"];
        // 0:已报备 2:已到访 4:已认筹 5:已认购 6:已签约 7:已退房 100:已失效 (默认状态为:0)
        if (self.cusType == 0) {
            self.state.text = [NSString stringWithFormat:@"%@天失效",_client.countdownTime];
            self.time.text = [NSString stringWithFormat:@"报备时间：%@",_client.createTime];
            self.priName.text = [NSString stringWithFormat:@"报备项目：%@",self.proName];
        }else if (self.cusType == 2) {
            self.state.text = @"已到访";
            self.time.text = [NSString stringWithFormat:@"最近到访：%@",_client.editTime];
            self.priName.text = [NSString stringWithFormat:@"到访项目：%@",self.proName];
        }else if (self.cusType == 4) {
            self.state.text = @"已认筹";
            self.time.text = [NSString stringWithFormat:@"认筹时间：%@",_client.editTime];
            self.priName.text = [NSString stringWithFormat:@"认筹项目：%@",self.proName];
        }else if (self.cusType == 5) {
            self.state.text = @"已认购";
            self.time.text = [NSString stringWithFormat:@"认购时间：%@",_client.editTime];
            self.priName.text = [NSString stringWithFormat:@"认购项目：%@",self.proName];
        }else if (self.cusType == 6) {
            self.state.text = @"已签约";
            self.time.text = [NSString stringWithFormat:@"签约时间：%@",_client.editTime];
            self.priName.text = [NSString stringWithFormat:@"签约项目：%@",self.proName];
        }else if (self.cusType == 7) {
            self.state.text = @"已退房";
            self.time.text = [NSString stringWithFormat:@"退房时间：%@",_client.editTime];
            self.priName.text = [NSString stringWithFormat:@"退房项目：%@",self.proName];
        }else{
            self.state.text = @"已失效";
            self.time.text = [NSString stringWithFormat:@"失效时间：%@",_client.editTime];
            self.priName.text = [NSString stringWithFormat:@"失效项目：%@",self.proName];
        }
        
        /*报备人类型 1 顾问 2 经纪人 3 自渠专员 4 展厅专员  5 统一报备人 6 门店管理员*/
        if ([_client.accType isEqualToString:@"1"]) {
            self.reportName.text = [NSString stringWithFormat:@"报备人：%@(顾问)",_client.accName];
        }else if ([_client.accType isEqualToString:@"2"]) {
            self.reportName.text = [NSString stringWithFormat:@"报备人：%@(经纪人)",_client.accName];
        }else if ([_client.accType isEqualToString:@"3"]) {
            self.reportName.text = [NSString stringWithFormat:@"报备人：%@(自渠专员)",_client.accName];
        }else if ([_client.accType isEqualToString:@"4"]) {
            self.reportName.text = [NSString stringWithFormat:@"报备人：%@(展厅专员)",_client.accName];
        }else if ([_client.accType isEqualToString:@"5"]) {
            self.reportName.text = [NSString stringWithFormat:@"报备人：%@(统一报备人)",_client.accName];
        }else {
            self.reportName.text = [NSString stringWithFormat:@"报备人：%@(门店管理员)",_client.accName];
        }
    }else{
        
        //[self.headerPic sd_setImageWithURL:[NSURL URLWithString:_client.cusPic]];
        self.name.text = _client.name;
        
        self.time.text = [NSString stringWithFormat:@"报备时间：%@",_client.createTime];
        if (_client.salesName && _client.salesName.length) {
            self.priName.text = [NSString stringWithFormat:@"案场顾问：%@(%@-%@)",_client.salesName,_client.teamName,_client.groupName];
        }else{
            self.priName.text = @"案场顾问：暂无";
        }

        // @[@"已报备",@"已到访",@"已认筹",@"已认购",@"已签约",@"已退房",@"已失效"];
        // 0:已报备 2:已到访 4:已认筹 5:已认购 6:已签约 7:已退房 100:已失效 (默认状态为:0)
        if (self.cusType == 0) {
            self.codeBtn.hidden = NO;
            self.state.text = [NSString stringWithFormat:@"%@天失效",_client.countdownTime];
            self.time2.text = [NSString stringWithFormat:@"最后备注：%@",_client.remarkTime];
        }else if (self.cusType == 2) {
            self.codeBtn.hidden = YES;
            self.state.text = @"已到访";
            self.time2.text = [NSString stringWithFormat:@"最近到访：%@",_client.editTime];
        }else if (self.cusType == 4) {
            self.codeBtn.hidden = YES;
            self.state.text = @"已认筹";
            self.time2.text = [NSString stringWithFormat:@"认筹时间：%@",_client.editTime];
        }else if (self.cusType == 5) {
            self.codeBtn.hidden = YES;
            self.state.text = @"已认购";
            self.time2.text = [NSString stringWithFormat:@"认购时间：%@",_client.editTime];
        }else if (self.cusType == 6) {
            self.codeBtn.hidden = YES;
            self.state.text = @"已签约";
            self.time2.text = [NSString stringWithFormat:@"签约时间：%@",_client.editTime];
        }else if (self.cusType == 7) {
            self.codeBtn.hidden = YES;
            self.state.text = @"已退房";
            self.time2.text = [NSString stringWithFormat:@"退房时间：%@",_client.editTime];
        }else{
            self.codeBtn.hidden = YES;
            self.state.text = @"已失效";
            self.time2.text = [NSString stringWithFormat:@"失效时间：%@",_client.editTime];
        }
        self.remark.text = [NSString stringWithFormat:@"备注内容：%@",(_client.remarks && _client.remarks.length)?_client.remarks:@"暂无"];
    }
}
-(void)setSearchClient:(RCSearchClient *)searchClient
{
    _searchClient = searchClient;
    
    if ([MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 1 || [MSUserManager sharedInstance].curUserInfo.agentLoginInside.accRole == 3) {
        self.name.text = _searchClient.name;
        /* 状态 0:报备成功 2:到访 4:认筹 5:认购 6:签约 7:退房 8:失效 */
        if (_searchClient.cusState == 0) {
            self.state.text = [NSString stringWithFormat:@" %@天失效 ",_searchClient.day];
            self.time.text = [NSString stringWithFormat:@"报备时间：%@",_searchClient.seeTime];
        }else if (_searchClient.cusState == 2) {
            self.state.text = @" 已到访 ";
            self.time.text = [NSString stringWithFormat:@"最近到访：%@",_searchClient.lastVistTime];
        }else if (_searchClient.cusState == 4) {
            self.state.text = @" 已认筹 ";
            self.time.text = [NSString stringWithFormat:@"最近到访：%@",_searchClient.lastVistTime];
        }else if (_searchClient.cusState == 5) {
            self.state.text = @" 已认购 ";
            self.time.text = [NSString stringWithFormat:@"最近到访：%@",_searchClient.lastVistTime];
        }else if (_searchClient.cusState == 6) {
            self.state.text = @" 已签约 ";
            self.time.text = [NSString stringWithFormat:@"最近到访：%@",_searchClient.lastVistTime];
        }else if (_searchClient.cusState == 7) {
            self.state.text = @" 已退房 ";
            self.time.text = [NSString stringWithFormat:@"最近到访：%@",_searchClient.lastVistTime];
        }else{
            self.state.text = @" 已失效 ";
            self.time.text = [NSString stringWithFormat:@"报备时间：%@",_searchClient.seeTime];
        }
        self.priName.text = [NSString stringWithFormat:@"报备项目：%@",(_searchClient.proName && _searchClient.proName.length)?_searchClient.proName:@"暂无"];
        self.reportName.text = [NSString stringWithFormat:@"报备人：%@",(_searchClient.reportName && _searchClient.reportName.length)?_searchClient.reportName:@"暂无"];
    }else{
        self.name.text = _searchClient.name;
        self.time.text = [NSString stringWithFormat:@"报备时间：%@",_searchClient.createTime];
        self.priName.text = [NSString stringWithFormat:@"案场顾问：%@",(_searchClient.salesNameAndTeam && _searchClient.salesNameAndTeam.length)?_searchClient.salesNameAndTeam:@"暂无"];
        /* 状态 0:报备成功 2:到访 4:认筹 5:认购 6:签约 7:退房 8:失效 */
        if (_searchClient.cusState == 0) {
            self.state.text = [NSString stringWithFormat:@" %@天失效 ",_searchClient.day];
            self.time2.text = [NSString stringWithFormat:@"备注时间：%@",_searchClient.time];
        }else if (_searchClient.cusState == 2) {
            self.state.text = @" 已到访 ";
            self.time2.text = [NSString stringWithFormat:@"到访时间：%@",_searchClient.lastVistTime];
        }else if (_searchClient.cusState == 4) {
            self.state.text = @" 已认筹 ";
            self.time2.text = [NSString stringWithFormat:@"到访时间：%@",_searchClient.lastVistTime];
        }else if (_searchClient.cusState == 5) {
            self.state.text = @" 已认购 ";
            self.time2.text = [NSString stringWithFormat:@"到访时间：%@",_searchClient.lastVistTime];
        }else if (_searchClient.cusState == 6) {
            self.state.text = @" 已签约 ";
            self.time2.text = [NSString stringWithFormat:@"到访时间：%@",_searchClient.lastVistTime];
        }else if (_searchClient.cusState == 7) {
            self.state.text = @" 已退房 ";
            self.time2.text = [NSString stringWithFormat:@"到访时间：%@",_searchClient.lastVistTime];
        }else{
            self.state.text = @" 已失效 ";
            self.time2.text = [NSString stringWithFormat:@"备注时间：%@",_searchClient.time];
        }
        self.remark.text = [NSString stringWithFormat:@"备注内容：%@",(_searchClient.remark && _searchClient.remark.length)?_searchClient.remark:@"暂无"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

