//
//  RCNewsDetailVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNewsDetailVC.h"
#import "RCShareView.h"
#import <zhPopupController.h>

@interface RCNewsDetailVC ()

@end

@implementation RCNewsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"资讯详情"];
}
- (IBAction)detailBtnClicked:(SPButton *)sender {
    if (sender.tag == 1) {
        HXLog(@"收藏");
    }else{
        RCShareView *share = [RCShareView loadXibView];
        share.hxn_width = HX_SCREEN_WIDTH;
        share.hxn_height = 260.f;
        hx_weakify(self);
        share.shareTypeCall = ^(NSInteger type, NSInteger index) {
            if (type == 1) {
                if (index == 1) {
                    HXLog(@"微信好友");
                }else if (index == 2) {
                    HXLog(@"朋友圈");
                }else{
                    HXLog(@"链接");
                }
            }else{
                [weakSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
            }
        };
        self.zh_popupController = [[zhPopupController alloc] init];
        self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
        [self.zh_popupController presentContentView:share duration:0.25 springAnimated:NO];
    }
}


@end
