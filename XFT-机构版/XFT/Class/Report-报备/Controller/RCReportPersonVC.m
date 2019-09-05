//
//  RCReportPersonVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportPersonVC.h"
#import "RCReportPersonHeader.h"
#import "RCReportPersonSectionHeader.h"
#import "RCReportPersonCell.h"
#import "HXSearchBar.h"

static NSString *const ReportPersonSectionHeader = @"ReportPersonSectionHeader";
static NSString *const ReportPersonCell = @"ReportPersonCell";

@interface RCReportPersonVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) RCReportPersonHeader *header;
@end

@implementation RCReportPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpTableHeaderView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 75);
}
-(RCReportPersonHeader *)header
{
    if (_header == nil) {
        _header = [RCReportPersonHeader loadXibView];
    }
    return _header;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = UIColorFromRGB(0xf5f5f5);
    search.hxn_width = HX_SCREEN_WIDTH - 80;
    search.hxn_height = 32;
    search.layer.cornerRadius = 32/2.f;
    search.layer.masksToBounds = YES;
    search.delegate = self;
    self.navigationItem.titleView = search;
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
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCReportPersonCell class]) bundle:nil] forCellReuseIdentifier:ReportPersonCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCReportPersonSectionHeader class]) bundle:nil] forHeaderFooterViewReuseIdentifier:ReportPersonSectionHeader];
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
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCReportPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:ReportPersonCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCReportPersonSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ReportPersonSectionHeader];
    if (!header) {
        header = [[RCReportPersonSectionHeader  alloc] initWithReuseIdentifier:ReportPersonSectionHeader];
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
    footer.backgroundColor = UIColorFromRGB(0xF6F7FB);
    return footer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
