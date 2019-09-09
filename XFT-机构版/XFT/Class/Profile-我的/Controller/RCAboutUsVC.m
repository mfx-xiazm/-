//
//  RCAboutUsVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAboutUsVC.h"
#import "RCNavBarView.h"
#import "WSLNativeScanTool.h"

@interface RCAboutUsVC ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImg;
/* 导航栏 */
@property(nonatomic,strong) RCNavBarView *navBarView;
@end

@implementation RCAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navBarView];
    self.codeImg.image = [WSLNativeScanTool createQRCodeImageWithString:@"来一个字符串" andSize:self.codeImg.hxn_size andBackColor:[UIColor whiteColor] andFrontColor:[UIColor blackColor] andCenterImage:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
        _navBarView.titleL.text = @"关于我们";
        _navBarView.titleL.hidden = NO;
        _navBarView.titleL.textAlignment = NSTextAlignmentCenter;
        hx_weakify(self);
        _navBarView.navBackCall = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navBarView;
}
@end
