//
//  RCHouseLoanVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseLoanVC.h"
#import "RCLoanDetailVC.h"

@interface RCHouseLoanVC ()
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
/* 上一次选择的按钮 */
@property(nonatomic,strong) UIButton *lastBtn;
@end

@implementation RCHouseLoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"房贷计算器"];
    self.lastBtn = self.firstBtn;
}
- (IBAction)loanTypeClicked:(UIButton *)sender {
    self.lastBtn.selected = NO;
    sender.selected = YES;
    self.lastBtn = sender;
}

- (IBAction)loanDetailClicked:(UIButton *)sender {
    RCLoanDetailVC *dvc = [RCLoanDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
