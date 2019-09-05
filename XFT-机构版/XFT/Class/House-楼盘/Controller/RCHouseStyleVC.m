//
//  RCHouseStyleVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseStyleVC.h"
#import "RCHouseStyleHeader.h"
#import "RCHouseStyleDetailCell.h"
#import "RCShareView.h"
#import <zhPopupController.h>
#import "RCReportVC.h"

static NSString *const HouseStyleDetailCell = @"HouseStyleDetailCell";

@interface RCHouseStyleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) RCHouseStyleHeader *header;

@end

@implementation RCHouseStyleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"户型详情"];
    [self setUpNavBar];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 280);
}
-(RCHouseStyleHeader *)header
{
    if (_header == nil) {
        _header = [RCHouseStyleHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 280);
    }
    return _header;
}
-(void)setUpNavBar
{
    UIBarButtonItem *shareItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareClicked) nomalImage:HXGetImage(@"搜索") higeLightedImage:HXGetImage(@"搜索") imageEdgeInsets:UIEdgeInsetsZero];
    
    self.navigationItem.rightBarButtonItem = shareItem;
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
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseStyleDetailCell class]) bundle:nil] forCellReuseIdentifier:HouseStyleDetailCell];
    
    self.tableView.tableHeaderView = self.header;
}
#pragma mark -- 点击事件
-(void)shareClicked
{
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
- (IBAction)reportClicked:(UIButton *)sender {
    RCReportVC *rvc = [RCReportVC new];
    [self.navigationController pushViewController:rvc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseStyleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseStyleDetailCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 260.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
