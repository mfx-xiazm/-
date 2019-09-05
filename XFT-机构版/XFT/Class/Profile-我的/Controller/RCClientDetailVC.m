//
//  RCClientDetailVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientDetailVC.h"
#import "RCClientNoteCell.h"
#import "RCClientDetailHeader.h"
#import "RCClientDetailFooter.h"
#import "RCGoHouseVC.h"

static NSString *const ClientNoteCell = @"ClientNoteCell";
@interface RCClientDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/* 头视图 */
@property(nonatomic,strong) RCClientDetailHeader *header;
/* 尾部视图 */
@property(nonatomic,strong) RCClientDetailFooter *footer;

@end

@implementation RCClientDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"客户详情"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(goHouseClicked) title:@"带客看房" font:[UIFont systemFontOfSize:16] titleColor:UIColorFromRGB(0x333333) highlightedColor:UIColorFromRGB(0x333333) titleEdgeInsets:UIEdgeInsetsZero];
    [self setUpTableView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 240.f);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 260.f);
}
-(RCClientDetailHeader *)header
{
    if (_header == nil) {
        _header = [RCClientDetailHeader loadXibView];
    }
    return _header;
}
-(RCClientDetailFooter *)footer
{
    if (_footer == nil) {
        _footer = [RCClientDetailFooter loadXibView];
    }
    return _footer;
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
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCClientNoteCell class]) bundle:nil] forCellReuseIdentifier:ClientNoteCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark -- 点击事件
-(void)goHouseClicked
{
    RCGoHouseVC *hvc = [RCGoHouseVC new];
    [self.navigationController pushViewController:hvc animated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCClientNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:ClientNoteCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topLine.hidden = !indexPath.row;
    cell.buttomLine.hidden = (indexPath.row == 3)?YES:NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
