//
//  RCReportResultVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportResultVC.h"
#import "RCReportResultHeader.h"
#import "RCReportResultCell.h"
#import "RCReportResultSectionHeader.h"

static NSString *const ReportResultSectionHeader = @"ReportResultSectionHeader";
static NSString *const ReportResultCell = @"ReportResultCell";
@interface RCReportResultVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) RCReportResultHeader *header;

@end

@implementation RCReportResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"推荐结果"];
    [self setUpTableView];
    [self setUpTableHeaderView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 145);
}
-(RCReportResultHeader *)header
{
    if (_header == nil) {
        _header = [RCReportResultHeader loadXibView];
    }
    return _header;
}
#pragma mark -- 视图相关
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCReportResultCell class]) bundle:nil] forCellReuseIdentifier:ReportResultCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCReportResultSectionHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:ReportResultSectionHeader];
}
-(void)setUpTableHeaderView
{
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 点击事件
-(void)sureClickd
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCReportResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ReportResultCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCReportResultSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ReportResultSectionHeader];
    if (!header) {
        header = [[RCReportResultSectionHeader alloc] initWithReuseIdentifier:ReportResultSectionHeader];
    }
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
