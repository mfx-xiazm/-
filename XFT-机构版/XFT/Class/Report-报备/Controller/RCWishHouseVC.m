//
//  RCWishHouseVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCWishHouseVC.h"
#import "RCWishHouseHeader.h"
#import "RCWishHouseFilterView.h"
#import "RCWishHouseCell.h"

static NSString *const WishHouseCell = @"WishHouseCell";

@interface RCWishHouseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 筛选 */
@property(nonatomic,strong) RCWishHouseFilterView *filterView;
/* 头部视图 */
@property(nonatomic,strong) RCWishHouseHeader *header;

@end

@implementation RCWishHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpTableHeaderView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 70);
}
-(RCWishHouseHeader *)header
{
    if (_header == nil) {
        _header = [RCWishHouseHeader loadXibView];
    }
    return _header;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"楼盘列表"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(sureClickd) title:@"确定" font:[UIFont systemFontOfSize:15] titleColor:UIColorFromRGB(0xFF9F08) highlightedColor:UIColorFromRGB(0xFF9F08) titleEdgeInsets:UIEdgeInsetsZero];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCWishHouseCell class]) bundle:nil] forCellReuseIdentifier:WishHouseCell];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCWishHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:WishHouseCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 95.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.filterView) {
        self.filterView.target = self;
        self.filterView.tableView = tableView;
        self.filterView.areas = @[@"全部",@"洪山区",@"武昌区",@"汉口区",@"汉阳区",@"蔡甸区",@"青山区"];
        self.filterView.wuye = @[@"全部",@"物业1",@"物业3",@"物业3",@"物业4"];
        self.filterView.huxing = @[@"全部",@"一居室",@"二居室",@"三居室",@"四居室"];
        self.filterView.mianji = @[@"全部",@"50-80平方",@"80-100平方",@"100-120平方",@"120-150平方"];
        return self.filterView;
    }
    RCWishHouseFilterView *fv = [RCWishHouseFilterView loadXibView];
    fv.hxn_width = HX_SCREEN_WIDTH;
    fv.hxn_height = 100.f;
    fv.target = self;
    fv.tableView = tableView;
    fv.areas = @[@"全部",@"洪山区",@"武昌区",@"汉口区",@"汉阳区",@"蔡甸区",@"青山区"];
    fv.wuye = @[@"全部",@"物业1",@"物业3",@"物业3",@"物业4"];
    fv.huxing = @[@"全部",@"一居室",@"二居室",@"三居室",@"四居室"];
    fv.mianji = @[@"全部",@"50-80平方",@"80-100平方",@"100-120平方",@"120-150平方"];
    self.filterView = fv;
    return fv;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
