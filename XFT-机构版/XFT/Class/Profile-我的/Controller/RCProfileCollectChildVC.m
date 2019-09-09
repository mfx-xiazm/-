//
//  RCProfileCollectChildVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCProfileCollectChildVC.h"
#import "RCNewsCell.h"
#import "RCHouseCell.h"
#import "RCHouseDetailVC.h"
#import "RCNewsDetailVC.h"

static NSString *const NewsCell = @"NewsCell";
static NSString *const HouseCell = @"HouseCell";

@interface RCProfileCollectChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RCProfileCollectChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.hxn_width = HX_SCREEN_WIDTH;
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 100;//预估高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCNewsCell class]) bundle:nil] forCellReuseIdentifier:NewsCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseCell class]) bundle:nil] forCellReuseIdentifier:HouseCell];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.collectType == 0) {
        RCHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    if (self.collectType == 0) {
        return 120.f;
    }else{
        return 130.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectType == 0) {
        RCHouseDetailVC *dvc = [RCHouseDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        RCNewsDetailVC *dvc = [RCNewsDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

@end
