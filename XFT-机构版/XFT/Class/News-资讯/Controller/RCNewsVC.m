//
//  RCNewsVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNewsVC.h"
#import "RCNewsCell.h"
#import "RCNewsDetailVC.h"
#import <JXCategoryView.h>
#import "RCHouseBannerHeader.h"
#import "RCSearchCityVC.h"

static NSString *const NewsCell = @"NewsCell";
@interface RCNewsVC ()<UITableViewDelegate,UITableViewDataSource,JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 切换控制器 */
@property (strong, nonatomic) JXCategoryTitleView *categoryView;
/* 头部视图 */
@property(nonatomic,strong) RCHouseBannerHeader *header;
@end

@implementation RCNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"资讯"];
    [self setUpNavBar];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 10.f+170.f);
}
-(JXCategoryTitleView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.frame = CGRectMake(0, 60.f-44.f, HX_SCREEN_WIDTH, 44);
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.titles = @[@"楼盘动态"];
        _categoryView.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _categoryView.cellSpacing = 45.f;
        _categoryView.contentEdgeInsetLeft = 20.f;
        _categoryView.titleColor = UIColorFromRGB(0x666666);
        _categoryView.titleSelectedColor = UIColorFromRGB(0x333333);
        _categoryView.delegate = self;

        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.verticalMargin = 15.f;
        lineView.indicatorCornerRadius = 0.f;
        lineView.indicatorHeight = 6.f;
        lineView.indicatorWidthIncrement = 8.f;
        lineView.indicatorColor = HXRGBAColor(255, 159, 8, 0.6);
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}
-(RCHouseBannerHeader *)header
{
    if (_header == nil) {
        _header = [RCHouseBannerHeader loadXibView];
    }
    return _header;
}
-(void)setUpNavBar
{
    SPButton *item = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
    item.hxn_size = CGSizeMake(70, 30);
    item.imageTitleSpace = 5.f;
    item.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [item setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [item setImage:HXGetImage(@"搜索") forState:UIControlStateNormal];
    [item setTitle:@"武汉" forState:UIControlStateNormal];
    [item addTarget:self action:@selector(cityClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    
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
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 点击事件
-(void)cityClicked
{
    RCSearchCityVC *hvc = [RCSearchCityVC new];
    [self.navigationController pushViewController:hvc animated:YES];
}
#pragma mark -- UITableView数据源和代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    header.hxn_height = 60.f;
    header.hxn_width = HX_SCREEN_WIDTH;
    [header addSubview:self.categoryView];
    return header;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 130.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCNewsDetailVC *dvc = [RCNewsDetailVC new];
    [self.navigationController pushViewController:dvc animated:YES];
}
@end
