//
//  RCClientDetailInfoVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientDetailInfoVC.h"
#import "HXPlaceholderTextView.h"
#import "RCMyClient.h"

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
}
-(void)setClientInfo:(RCMyClient *)clientInfo
{
    _clientInfo = clientInfo;
    self.phone.text = _clientInfo.phone;
    self.name.text = _clientInfo.name;
    self.remarkTime.text = [NSString stringWithFormat:@"上次备注时间：%@",_clientInfo.lastRemarkTime];
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
@end
