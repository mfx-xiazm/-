//
//  RCHouseNearbyDetailVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseNearbyDetailVC.h"
#import "RCHouseNearbyCell.h"
#import "RCHouseNearbyHeader.h"

static NSString *const HouseNearbyCell = @"HouseNearbyCell";

#define Y1               150
//#define Y2               self.view.frame.size.height - 250
#define Y3               self.view.frame.size.height - 75

@interface RCHouseNearbyDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RCHouseNearbyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 6.f;
    
    [self.view addSubview:self.tableView];
}
#pragma mark -- 视图相关
-(UITableView *)tableView
{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT-Y1)];
        // 针对 11.0 以上的iOS系统进行处理
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        } else {
            // 针对 11.0 以下的iOS系统进行处理
            // 不要自动调整inset
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 100;//预估高度
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces =  NO;
        _tableView.userInteractionEnabled = YES;
        _tableView.scrollEnabled = NO; // 让collectionView默认禁止滚动
        _tableView.backgroundColor = [UIColor whiteColor];
        
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseNearbyCell class]) bundle:nil] forCellReuseIdentifier:HouseNearbyCell];
    }
    return _tableView;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseNearbyCell forIndexPath:indexPath];
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
    return 75.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RCHouseNearbyHeader *header = [RCHouseNearbyHeader loadXibView];
    header.hxn_width = HX_SCREEN_WIDTH;
    header.hxn_height = 75.f;
    header.nearbyTypeCall = ^(NSInteger index) {
        if (index == 1) {
            HXLog(@"交通");
        }else if (index == 2) {
            HXLog(@"教育");
        }else if (index == 3) {
            HXLog(@"医疗");
        }else{
            HXLog(@"商业");
        }
    };
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
