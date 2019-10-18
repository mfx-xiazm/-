//
//  RCGoHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCGoHouseVC.h"
#import "RCNavBarView.h"
#import "WSLNativeScanTool.h"

@interface RCGoHouseVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UILabel *reportTime;

/* 导航栏 */
@property(nonatomic,strong) RCNavBarView *navBarView;
@end

@implementation RCGoHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navBarView];
    self.contentView.hidden = YES;
    [self getCusCodeRequest];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
}
-(RCNavBarView *)navBarView
{
    if (_navBarView == nil) {
        _navBarView = [RCNavBarView loadXibView];
        _navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
        _navBarView.backBtn.hidden = NO;
        [_navBarView.backBtn setImage:HXGetImage(@"icon_wback") forState:UIControlStateNormal];
        _navBarView.titleL.text = @"带看码";
        _navBarView.titleL.hidden = NO;
        _navBarView.titleL.textAlignment = NSTextAlignmentCenter;
        hx_weakify(self);
        _navBarView.navBackCall = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navBarView;
}
-(void)getCusCodeRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"uuid"] = self.cusUuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"cus/cus/mechanism/findCode" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showCodeInfo:responseObject[@"data"]];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)showCodeInfo:(NSDictionary *)dict
{
    self.contentView.hidden = NO;
    
    //self.codeImg.image = [WSLNativeScanTool createQRCodeImageWithString:[NSString stringWithFormat:@"%@",dict[@"code"]] andSize:self.codeImg.hxn_size andBackColor:[UIColor whiteColor] andFrontColor:[UIColor blackColor] andCenterImage:nil];
    [self.codeImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"code"]]]];

    self.name.text = [NSString stringWithFormat:@"客户姓名：%@",dict[@"name"]];
    [self.phone setTitle:[NSString stringWithFormat:@"%@****%@",[dict[@"phone"] substringToIndex:3],[dict[@"phone"] substringFromIndex:((NSString *)dict[@"phone"]).length-4]] forState:UIControlStateNormal];
    self.proName.text = [NSString stringWithFormat:@"报备项目：%@",dict[@"proName"]];
    self.reportTime.text = [NSString stringWithFormat:@"报备时间：%@",[[NSString stringWithFormat:@"%@",dict[@"createTime"]] getTimeFromTimestamp:@"yyyy-MM-dd HH:mm"]];
}
@end
