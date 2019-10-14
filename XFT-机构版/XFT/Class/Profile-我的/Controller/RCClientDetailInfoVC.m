//
//  RCClientDetailInfoVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientDetailInfoVC.h"
#import "HXPlaceholderTextView.h"
#import "RCMyClientDetail.h"

@interface RCClientDetailInfoVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *remarkTime;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
/** 是否滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
@end

@implementation RCClientDetailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.remark.placeholder = @"补充备注";
    self.scrollView.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"childScrollCan" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"MainTableScroll" object:nil];
    hx_weakify(self);
    [self.updateBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.remark hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入备注内容"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf updateRemarkRequest:button];
    }];
}
-(void)setClientInfo:(RCMyClientDetail *)clientInfo
{
    _clientInfo = clientInfo;
    self.phone.text = _clientInfo.phone;
    self.name.text = _clientInfo.name;
    self.remarkTime.text = [NSString stringWithFormat:@"上次备注时间：%@",_clientInfo.lastRemarkTime];
    if (_clientInfo.remark && _clientInfo.remark.length) {
        self.remark.text = _clientInfo.remark;
    }
}
#pragma mark -- 通知处理
-(void)childScrollHandle:(NSNotification *)user{
    if ([user.name isEqualToString:@"childScrollCan"]){
        self.isCanScroll = YES;
    }else if ([user.name isEqualToString:@"MainTableScroll"]){
        self.isCanScroll = NO;
        [self.scrollView setContentOffset:CGPointZero];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.isCanScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    if (scrollView.contentOffset.y<=0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MainTableScroll" object:nil];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 跟新备注
-(void)updateRemarkRequest:(UIButton *)btn
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"context"] = self.remark.text;
    data[@"cusUuid"] = self.clientInfo.baoBeiUuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/cusInfo/addCusRemark" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"更新" image:nil textColor:nil backgroundColor:nil];
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.clientInfo.remark = strongSelf.remark.text;
                strongSelf.clientInfo.lastRemarkTime = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
                strongSelf.remarkTime.text = [NSString stringWithFormat:@"上次备注时间：%@",strongSelf.clientInfo.lastRemarkTime];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"更新" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
