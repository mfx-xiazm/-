//
//  RCSearchHouseResultVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCSearchHouseResultVC.h"
#import "HXSearchBar.h"
#import "RCHouseCell.h"
#import "RCHouseDetailVC.h"

static NSString *const HouseCell = @"HouseCell";

@interface RCSearchHouseResultVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation RCSearchHouseResultVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUIConfig];
    [self setUpTableView];
    [self setUpEmptyView];
}
#pragma mark -- 视图相关
-(void)setUpUIConfig
{
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = UIColorFromRGB(0xf5f5f5);
    search.hxn_width = HX_SCREEN_WIDTH - 80;
    search.hxn_height = 32;
    search.layer.cornerRadius = 32/2.f;
    search.layer.masksToBounds = YES;
    search.delegate = self;
    self.navigationItem.titleView = search;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClickd) title:@"取消" font:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0xFF9F08) highlightedColor:UIColorFromRGB(0xFF9F08) titleEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"no_report" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 30.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x131D2D);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    self.tableView.ly_emptyView = emptyView;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseCell class]) bundle:nil] forCellReuseIdentifier:HouseCell];
}
#pragma mark -- 点击事件
-(void)cancelClickd
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField hasText]) {
        [MBProgressHUD showOnlyTextToView:self.view title:@"请输入关键字"];
        return NO;
    }
    [textField resignFirstResponder];//放弃响应
    
    return YES;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 120.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 44);
    label.backgroundColor = HXGlobalBg;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"   您搜索到2个楼盘";
    return label;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCHouseDetailVC *dvc = [RCHouseDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
