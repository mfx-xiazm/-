//
//  RCProfileInfoVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileInfoVC.h"
#import "FSActionSheet.h"

@interface RCProfileInfoVC ()<FSActionSheetDelegate>

@end

@implementation RCProfileInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"查看信息"];
}

-(IBAction)loginOutClicked:(UIButton *)sender
{
    FSActionSheet *as = [[FSActionSheet alloc] initWithTitle:@"确定要退出登录吗" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:nil otherButtonTitles:@[@"退出"]];
    //        hx_weakify(self);
    [as showWithSelectedCompletion:^(NSInteger selectedIndex) {
        //            hx_strongify(weakSelf);
        if (selectedIndex == 1) {
            HXLog(@"退出");
        }
    }];
}

@end
