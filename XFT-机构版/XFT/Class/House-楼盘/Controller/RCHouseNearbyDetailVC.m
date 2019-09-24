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
#import "RCNearbyPOI.h"

static NSString *const HouseNearbyCell = @"HouseNearbyCell";

#define Y1               150
//#define Y2               self.view.frame.size.height - 250
#define Y3               self.view.frame.size.height - 75

@interface RCHouseNearbyDetailVC ()<UITableViewDelegate,UITableViewDataSource,RCHouseNearbyHeaderDelegate>
/* 头视图 */
@property(nonatomic,strong) RCHouseNearbyHeader *header;
/** 周边交通 */
@property(nonatomic,strong) NSArray *nearbyBus;
/** 周边教育 */
@property(nonatomic,strong) NSArray *nearbyEducation;
/** 周边医疗 */
@property(nonatomic,strong) NSArray *nearbyMedical;
/** 周边商业 */
@property(nonatomic,strong) NSArray *nearbyBusiness;
/** 上一次选中的周边类型 1.交通 2.教育 3.医疗 4.商业 */
@property(nonatomic,assign) NSInteger lastNearbyType;
@end

@implementation RCHouseNearbyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastNearbyType = 1;
    
    self.view.userInteractionEnabled = YES;
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 6.f;
    
    [self.view addSubview:self.tableView];
    
    hx_weakify(self);
    [self getNearbyDataRequestCompleteCall:^{
        [weakSelf.tableView reloadData];
    }];
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
#pragma mark -- 接口请求
/** 获取项目周边配套缓存 */
-(void)getNearbyDataRequestCompleteCall:(void(^)(void))completeCall
{
    // 楼盘周边
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"type"] = @(self.lastNearbyType);//类型 1.交通 2.教育 3.医疗 4.商业
    data[@"uuid"] = self.uuid;
    parameters[@"data"] = data;
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/map/getProductPeripheralMatchingRel" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"code"] integerValue] == 0) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {//有存储的数据返回
                NSArray *resultArr = [NSArray yy_modelArrayWithClass:[RCNearbyPOI class] json:responseObject[@"data"][@"josnStr"]];
                if (strongSelf.lastNearbyType == 1) {
                    strongSelf.nearbyBus = resultArr;
                }else if (strongSelf.lastNearbyType == 2) {
                    strongSelf.nearbyEducation = resultArr;
                }else if (strongSelf.lastNearbyType == 3) {
                    strongSelf.nearbyMedical = resultArr;
                }else{
                    strongSelf.nearbyBusiness = resultArr;
                }
                if (completeCall) {
                    completeCall();
                }
            }else{// 没有存储的数据返回
                [strongSelf getNearbyDataRequestFromQServerCompleteCall:^{
                    if (completeCall) {
                        completeCall();
                    }
                }];
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 未取到周边数据缓存时向腾讯服务器请求并存入服务器 */
-(void)getNearbyDataRequestFromQServerCompleteCall:(void(^)(void))completeCall
{
    // 楼盘周边
    hx_weakify(self);
    NSString *keyword = nil;
    if (self.lastNearbyType == 1) {
        keyword = @"交通";
    }else if (self.lastNearbyType == 2) {
        keyword = @"教育";
    }else if (self.lastNearbyType == 3) {
        keyword = @"医疗";
    }else{
        keyword = @"商业";
    }
    [HXNetworkTool GET:@"https://apis.map.qq.com/ws/place/v1/search" action:nil parameters:@{@"boundary":[NSString stringWithFormat:@"nearby(%@,%@,1000)",@(self.lat),@(self.lng)],@"keyword":keyword,@"orderby":@"_distance",@"key":HXQMapKey} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if ([responseObject[@"status"] integerValue] == 0) {
            NSArray *resultArr = [NSArray yy_modelArrayWithClass:[RCNearbyPOI class] json:responseObject[@"data"]];
            if (strongSelf.lastNearbyType == 1) {
                strongSelf.nearbyBus = resultArr;
            }else if (strongSelf.lastNearbyType == 2) {
                strongSelf.nearbyEducation = resultArr;
            }else if (strongSelf.lastNearbyType == 3) {
                strongSelf.nearbyMedical = resultArr;
            }else{
                strongSelf.nearbyBusiness = resultArr;
            }
            if (completeCall) {
                completeCall();
            }
            [strongSelf saveNearbyDataRequest:resultArr];//将数据存入服务器，下次直接从服务器获取
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/** 储存项目周边配套缓存 */
-(void)saveNearbyDataRequest:(NSArray *)resultArr
{
    // 楼盘周边
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"type"] = @(self.lastNearbyType);//类型 1.交通 2.教育 3.医疗 4.商业
    data[@"jsonStr"] = [resultArr yy_modelToJSONString];
    data[@"uuid"] = self.uuid;
    parameters[@"data"] = data;
    
    [HXNetworkTool POST:HXRC_M_URL action:@"/pro/map/saveProductPeripheralMatchingRel" parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            // 周边数据上传存入成功
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- RCHouseNearbyHeader代理
-(void)nearbyHeader:(RCHouseNearbyHeader *)header didClicked:(NSInteger)index
{
    self.lastNearbyType = index;
    if (self.lastNearbyType == 1) {
        if (self.nearbyBus && self.nearbyBus.count) {
            [self.tableView reloadData];
            return;
        }
    }else if (self.lastNearbyType == 2) {
        if (self.nearbyEducation && self.nearbyEducation.count) {
            [self.tableView reloadData];
            return;
        }
    }else if (self.lastNearbyType == 3) {
        if (self.nearbyMedical && self.nearbyMedical.count) {
            [self.tableView reloadData];
            return;
        }
    }else{
        if (self.nearbyBusiness && self.nearbyBusiness.count) {
            [self.tableView reloadData];
            return;
        }
    }
    hx_weakify(self);
    [self getNearbyDataRequestCompleteCall:^{
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.lastNearbyType == 1) {
       return self.nearbyBus.count;
    }else if (self.lastNearbyType == 2){
       return self.nearbyEducation.count;
    }else if (self.lastNearbyType == 3){
       return self.nearbyMedical.count;
    }else{
       return self.nearbyBusiness.count;
    }
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseNearbyCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numRow.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
    if (self.lastNearbyType == 1) {
        RCNearbyPOI *nearby = self.nearbyBus[indexPath.row];
        cell.nearby = nearby;
    }else if (self.lastNearbyType == 2){
        RCNearbyPOI *nearby = self.nearbyEducation[indexPath.row];
        cell.nearby = nearby;
    }else if (self.lastNearbyType == 3){
        RCNearbyPOI *nearby = self.nearbyMedical[indexPath.row];
        cell.nearby = nearby;
    }else{
        RCNearbyPOI *nearby = self.nearbyBusiness[indexPath.row];
        cell.nearby = nearby;
    }
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
    if (self.header) {
        return self.header;
    }
    RCHouseNearbyHeader *header = [RCHouseNearbyHeader loadXibView];
    header.hxn_width = HX_SCREEN_WIDTH;
    header.hxn_height = 75.f;
    header.delegate = self;
    self.header = header;
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCNearbyPOI *nearby = nil;
    if (self.lastNearbyType == 1) {
        nearby = self.nearbyBus[indexPath.row];
    }else if (self.lastNearbyType == 2){
        nearby = self.nearbyEducation[indexPath.row];
    }else if (self.lastNearbyType == 3){
        nearby = self.nearbyMedical[indexPath.row];
    }else{
        nearby = self.nearbyBusiness[indexPath.row];
    }
    if ([self.delegate respondsToSelector:@selector(nearbyVC:nearbyType:didClickedPOI:)]) {
        [self.delegate nearbyVC:self nearbyType:self.lastNearbyType didClickedPOI:nearby];
    }
}

@end
