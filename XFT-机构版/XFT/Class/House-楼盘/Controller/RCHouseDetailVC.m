//
//  RCHouseDetailVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseDetailVC.h"
#import "RCShareView.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "RCBannerCell.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import <ZLCollectionViewVerticalLayout.h>
#import <ZLCollectionViewHorzontalLayout.h>
#import "RCHouseDetailInfoCell.h"
#import "RCHouseDetailNewsCell.h"
#import "RCHouseStyleCell.h"
#import <QMapKit/QMapKit.h>
#import "RCHouseStyleVC.h"
#import "RCHouseNewsVC.h"
#import "RCHouseNearbyVC.h"
#import "RCReportVC.h"
#import "RCNewsDetailVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorBackgroundView.h>
#import "RCHouseNearbyCell.h"
#import "RCHouseInfoVC.h"
#import "RCPanoramaVC.h"
#import "HXNavigationController.h"
#import "RCVideoFullScreenVC.h"
#import "RCHouseGoodsCell.h"
#import "RCHousePic.h"
#import "RCHouseNews.h"
#import "RCHousePicInfo.h"
#import "RCHouseDetail.h"
#import "RCNearbyPOI.h"
#import "RCCustomAnnotation.h"

static NSString *const HouseNearbyCell = @"HouseNearbyCell";
static NSString *const HouseDetailInfoCell = @"HouseDetailInfoCell";
static NSString *const HouseDetailNewsCell = @"HouseDetailNewsCell";
static NSString *const HouseStyleCell = @"HouseStyleCell";
static NSString *const HouseGoodsCell = @"HouseGoodsCell";

@interface RCHouseDetailVC ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,UITableViewDelegate,UITableViewDataSource,QMapViewDelegate,JXCategoryViewDelegate>
/** 内容滚动视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/** 轮播图 */
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cycleView;
@property (weak, nonatomic) IBOutlet UILabel *cycleNum;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewWidth;

/** 楼盘基础信息 */
@property (weak, nonatomic) IBOutlet UIView *houseInfoView;
@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UILabel *housePrice;
@property (weak, nonatomic) IBOutlet UILabel *huxingName;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *houseTags;

/** 楼盘信息展示 */
@property (weak, nonatomic) IBOutlet UITableView *houseInfoTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseInfoTableViewHeight;
/** 楼盘亮点 */
@property (weak, nonatomic) IBOutlet UILabel *houseGoodsLabel;
@property (weak, nonatomic) IBOutlet UITableView *houseGoodsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseGoodsViewHeight;
/** 楼盘动态 */
@property (weak, nonatomic) IBOutlet UITableView *houseNewsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseNewsTableViewHeight;
/** 产品户型图 */
@property (weak, nonatomic) IBOutlet UICollectionView *houseStyleCollectionView;
/** 周边配套 */
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (weak, nonatomic) IBOutlet UITableView *houseNearbyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseNearbyViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *nearbyFirstBtn;

/** 地图 */
@property (nonatomic, strong) QMapView *mapView;

/** 楼盘banner */
@property(nonatomic,strong) RCHousePic *housePic;
/** 本地处理过的banner数据 */
@property(nonatomic,strong) NSArray *handledPics;
/** 楼盘详情数据 */
@property(nonatomic,strong) NSArray *houseInfoData;
/** 楼盘亮点数据 */
@property(nonatomic,strong) NSArray *houseGoods;
/** 楼盘动态数据 */
@property(nonatomic,strong) NSArray *houseNews;
/** 楼盘全部详情数据 */
@property(nonatomic,strong) RCHouseDetail *houseDetail;
/** 周边交通 */
@property(nonatomic,strong) NSArray *nearbyBus;
/** 周边教育 */
@property(nonatomic,strong) NSArray *nearbyEducation;
/** 周边医疗 */
@property(nonatomic,strong) NSArray *nearbyMedical;
/** 周边商业 */
@property(nonatomic,strong) NSArray *nearbyBusiness;
/** 上一次选中的周边类型 1.交通 2.教育 3.医疗 4.商业 */
@property(nonatomic,strong) UIButton *lastNearbyBtn;
/** 上一次选中的周边类型 1.交通 2.教育 3.医疗 4.商业 */
@property(nonatomic,assign) NSInteger lastNearbyType;
/** 周边配套的选中打点 */
@property(nonatomic,strong) RCCustomAnnotation *nearbyPoint;
@end

@implementation RCHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"楼盘详情"];
    self.scrollView.hidden = YES;
    [self setUpCycleView];
    [self setUpCollectionView];
    [self setUpTableView];
    // 地图
    [self.mapSuperView addSubview:self.mapView];
    self.lastNearbyBtn = self.nearbyFirstBtn;
    self.lastNearbyType = 1;
    [self getHouseDetailRequest];
}
-(QMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[QMapView alloc] initWithFrame:self.mapSuperView.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 13;
        _mapView.delegate = self;
    }
    return _mapView;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.mapView.frame = self.mapSuperView.bounds;
}

#pragma mark -- 视图配置
-(void)setUpCycleView
{
    self.cycleView.isInfiniteLoop = NO;
    //self.cycleView.autoScrollInterval = 3.f;
    self.cycleView.dataSource = self;
    self.cycleView.delegate = self;
    // registerClass or registerNib
    [self.cycleView registerNib:[UINib nibWithNibName:NSStringFromClass([RCBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"BannerCell"];
    
    self.categoryView.layer.cornerRadius = 12.f;
    self.categoryView.layer.masksToBounds = YES;
    self.categoryView.titleFont = [UIFont systemFontOfSize:11];
    self.categoryView.cellSpacing = 0;
    self.categoryView.cellWidth = 50.f;
    self.categoryView.titleColor = UIColorFromRGB(0x333333);
    self.categoryView.titleSelectedColor = [UIColor whiteColor];
    self.categoryView.titleLabelMaskEnabled = YES;
    self.categoryView.delegate = self;
    
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = 24;
    backgroundView.indicatorWidthIncrement = 0;
    backgroundView.indicatorColor = HXControlBg;
    self.categoryView.indicators = @[backgroundView];
}
-(void)setUpCollectionView
{
    ZLCollectionViewHorzontalLayout *flowLayout2 = [[ZLCollectionViewHorzontalLayout alloc] init];
    flowLayout2.delegate = self;
    flowLayout2.canDrag = NO;
    self.houseStyleCollectionView.collectionViewLayout = flowLayout2;
    self.houseStyleCollectionView.dataSource = self;
    self.houseStyleCollectionView.delegate = self;
    self.houseStyleCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.houseStyleCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseStyleCell class]) bundle:nil] forCellWithReuseIdentifier:HouseStyleCell];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.houseInfoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.houseInfoTableView.rowHeight = UITableViewAutomaticDimension;//预估高度
    self.houseInfoTableView.estimatedSectionHeaderHeight = 0;
    self.houseInfoTableView.estimatedSectionFooterHeight = 0;
    
    self.houseInfoTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.houseInfoTableView.dataSource = self;
    self.houseInfoTableView.delegate = self;
    
    self.houseInfoTableView.showsVerticalScrollIndicator = NO;
    
    self.houseInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.houseInfoTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseDetailInfoCell class]) bundle:nil] forCellReuseIdentifier:HouseDetailInfoCell];
    
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.houseNewsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.houseNewsTableView.estimatedRowHeight = 0;//预估高度
    self.houseNewsTableView.estimatedSectionHeaderHeight = 0;
    self.houseNewsTableView.estimatedSectionFooterHeight = 0;
    
    self.houseNewsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.houseNewsTableView.dataSource = self;
    self.houseNewsTableView.delegate = self;
    
    self.houseNewsTableView.showsVerticalScrollIndicator = NO;
    
    self.houseNewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.houseNewsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseDetailNewsCell class]) bundle:nil] forCellReuseIdentifier:HouseDetailNewsCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.houseGoodsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.houseGoodsTableView.estimatedRowHeight = 0;//预估高度
    self.houseGoodsTableView.estimatedSectionHeaderHeight = 0;
    self.houseGoodsTableView.estimatedSectionFooterHeight = 0;
    
    self.houseGoodsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.houseGoodsTableView.dataSource = self;
    self.houseGoodsTableView.delegate = self;
    
    self.houseGoodsTableView.showsVerticalScrollIndicator = NO;
    
    self.houseGoodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.houseGoodsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseGoodsCell class]) bundle:nil] forCellReuseIdentifier:HouseGoodsCell];
    
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.houseNearbyTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.houseNearbyTableView.estimatedRowHeight = 0;//预估高度
    self.houseNearbyTableView.estimatedSectionHeaderHeight = 0;
    self.houseNearbyTableView.estimatedSectionFooterHeight = 0;
    
    self.houseNearbyTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.houseNearbyTableView.dataSource = self;
    self.houseNearbyTableView.delegate = self;
    
    self.houseNearbyTableView.showsVerticalScrollIndicator = NO;
    
    self.houseNearbyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.houseNearbyTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RCHouseNearbyCell class]) bundle:nil] forCellReuseIdentifier:HouseNearbyCell];
}
#pragma mark -- 点击事件
- (IBAction)houseInfoClicked:(UIButton *)sender {
    RCHouseInfoVC *ivc = [RCHouseInfoVC new];
    ivc.uuid = self.uuid;
    [self.navigationController pushViewController:ivc animated:YES];
}

- (IBAction)houseNewsClicked:(UIButton *)sender {
    RCHouseNewsVC *nvc = [RCHouseNewsVC new];
    nvc.uuid = self.uuid;
    [self.navigationController pushViewController:nvc animated:YES];
}
- (IBAction)houseNearbyClicked:(UIButton *)sender {
    RCHouseNearbyVC *nvc = [RCHouseNearbyVC new];
    nvc.lat = self.houseDetail.dimension;
    nvc.lng = self.houseDetail.longitude;
    nvc.uuid = self.uuid;
    nvc.name = self.houseDetail.name;
    [self.navigationController pushViewController:nvc animated:YES];
}
- (IBAction)houseReportClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        RCReportVC *rvc = [RCReportVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else{
        hx_weakify(self);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"027-27549123" constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
        }];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"拨打" handler:^(zhAlertButton * _Nonnull button) {
            hx_strongify(weakSelf);
            [strongSelf.zh_popupController dismiss];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"13496755975"]]];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        okButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
        [alert adjoinWithLeftAction:cancelButton rightAction:okButton];
        self.zh_popupController = [[zhPopupController alloc] init];
        [self.zh_popupController presentContentView:alert duration:0.25 springAnimated:NO];
    }
}
- (IBAction)nearbyTypeClicked:(UIButton *)sender {
    sender.selected = YES;
    self.lastNearbyBtn.selected = NO;
    self.lastNearbyBtn = sender;
    
    self.lastNearbyType = self.lastNearbyBtn.tag;
    
    hx_weakify(self);
    if (self.lastNearbyType == 1) {
        if (self.nearbyBus && self.nearbyBus.count) {
            [self.houseNearbyTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.houseNearbyViewHeight.constant = 10.f+44.f+260.f+weakSelf.houseNearbyTableView.contentSize.height;
            });
            return;
        }
    }else if (self.lastNearbyType == 2) {
        if (self.nearbyEducation && self.nearbyEducation.count) {
            [self.houseNearbyTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.houseNearbyViewHeight.constant = 10.f+44.f+260.f+weakSelf.houseNearbyTableView.contentSize.height;
            });
            return;
        }
    }else if (self.lastNearbyType == 3) {
        if (self.nearbyMedical && self.nearbyMedical.count) {
            [self.houseNearbyTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.houseNearbyViewHeight.constant = 10.f+44.f+260.f+weakSelf.houseNearbyTableView.contentSize.height;
            });
            return;
        }
    }else{
        if (self.nearbyBusiness && self.nearbyBusiness.count) {
            [self.houseNearbyTableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.houseNearbyViewHeight.constant = 10.f+44.f+260.f+weakSelf.houseNearbyTableView.contentSize.height;
            });
            return;
        }
    }
    [self getNearbyDataRequestCompleteCall:^{
        [weakSelf.houseNearbyTableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.houseNearbyViewHeight.constant = 10.f+44.f+260.f+weakSelf.houseNearbyTableView.contentSize.height;
        });
    }];
}

#pragma mark -- 接口请求
-(void)getHouseDetailRequest
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 执行循序0
    hx_weakify(self);
//    dispatch_group_async(group, queue, ^{
//        hx_strongify(weakSelf);
//        // 楼盘banner
//        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//        NSMutableDictionary *data = [NSMutableDictionary dictionary];
//        data[@"uuid"] = self.uuid;
//        parameters[@"data"] = data;
//
//        [HXNetworkTool POST:@"http://192.168.199.176:7003/" action:@"/pro/proBaseInfo/pic" parameters:parameters success:^(id responseObject) {
//            if ([responseObject[@"code"] integerValue] == 0) {
//                strongSelf.housePic = [RCHousePic yy_modelWithDictionary:responseObject[@"data"]];
//            }else{
//                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
//            }
//            dispatch_semaphore_signal(semaphore);
//        } failure:^(NSError *error) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//            dispatch_semaphore_signal(semaphore);
//        }];
//    });
    // 执行循序1
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        // 楼盘详情
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"uuid"] = self.uuid;
        parameters[@"data"] = data;

        [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/proBaseInfo/proInfo" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                strongSelf.houseDetail = [RCHouseDetail yy_modelWithDictionary:responseObject[@"data"]];
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    // 执行循序2
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        // 楼盘动态
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"proUuid"] = self.uuid;
        parameters[@"data"] = data;

        [HXNetworkTool POST:HXRC_M_URL action:@"pro/pro/information/infListByProUuid" parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 0) {
                NSArray *arrt = [NSArray yy_modelArrayWithClass:[RCHouseNews class] json:responseObject[@"data"]];
                if (arrt.count>2) {
                    strongSelf.houseNews = [arrt subarrayWithRange:NSMakeRange(0, 2)];
                }else{
                    strongSelf.houseNews = arrt;
                }
            }else{
                [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError *error) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
            dispatch_semaphore_signal(semaphore);
        }];
    });

    // 执行循序3
    dispatch_group_async(group, queue, ^{
        hx_strongify(weakSelf);
        [strongSelf getNearbyDataRequestCompleteCall:^{
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        // 执行循序4
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 执行顺序6
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        //dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        // 执行顺序10
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新界面
            hx_strongify(weakSelf);
            [strongSelf handleHouseDetailData];
        });
    });
}
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
                    strongSelf.nearbyBus = (resultArr.count >5)?[resultArr subarrayWithRange:NSMakeRange(0, 5)]:resultArr;
                }else if (strongSelf.lastNearbyType == 2) {
                    strongSelf.nearbyEducation = (resultArr.count >5)?[resultArr subarrayWithRange:NSMakeRange(0, 5)]:resultArr;
                }else if (strongSelf.lastNearbyType == 3) {
                    strongSelf.nearbyMedical = (resultArr.count >5)?[resultArr subarrayWithRange:NSMakeRange(0, 5)]:resultArr;
                }else{
                    strongSelf.nearbyBusiness = (resultArr.count >5)?[resultArr subarrayWithRange:NSMakeRange(0, 5)]:resultArr;
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
            if (completeCall) {
                completeCall();
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completeCall) {
            completeCall();
        }
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
                strongSelf.nearbyBus = (resultArr.count >5)?[resultArr subarrayWithRange:NSMakeRange(0, 5)]:resultArr;
            }else if (strongSelf.lastNearbyType == 2) {
                strongSelf.nearbyEducation = (resultArr.count >5)?[resultArr subarrayWithRange:NSMakeRange(0, 5)]:resultArr;
            }else if (strongSelf.lastNearbyType == 3) {
                strongSelf.nearbyMedical = (resultArr.count >5)?[resultArr subarrayWithRange:NSMakeRange(0, 5)]:resultArr;
            }else{
                strongSelf.nearbyBusiness = (resultArr.count >5)?[resultArr subarrayWithRange:NSMakeRange(0, 5)]:resultArr;
            }
            [strongSelf saveNearbyDataRequest:resultArr];//将数据存入服务器，下次直接从服务器获取
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"msg"]];
        }
        if (completeCall) {
            completeCall();
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
        if (completeCall) {
            completeCall();
        }
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
/** 处理项目详情数据 */
-(void)handleHouseDetailData
{
    self.scrollView.hidden = NO;
    
//    // 处理头部banner数据
//    NSMutableArray *categoryTitles = [NSMutableArray array];
//    NSMutableArray *handledPics = [NSMutableArray array];
//    if (self.housePic.vrCover && self.housePic.vrCover.length && self.housePic.vrUrl && self.housePic.vrUrl.length) {
//        [categoryTitles addObject:@"VR"];
//        RCHousePicInfo *info = [RCHousePicInfo new];
//        info.type = RCHousePicInfoTypeVR;
//        info.url = self.housePic.vrCover;
//        [handledPics addObject:info];
//    }
//
//    if (self.housePic.videoCover && self.housePic.videoCover.length && self.housePic.videoUrl && self.housePic.videoUrl.length) {
//        [categoryTitles addObject:@"视频"];
//        RCHousePicInfo *info = [RCHousePicInfo new];
//        info.type = RCHousePicInfoTypeVideo;
//        info.url = self.housePic.videoCover;
//        [handledPics addObject:info];
//    }
//
//    if (self.housePic.picUrls && self.housePic.picUrls.count) {
//        [categoryTitles addObject:@"图片"];
//        for (NSString *url in self.housePic.picUrls) {
//            RCHousePicInfo *info = [RCHousePicInfo new];
//            info.type = RCHousePicInfoTypePicture;
//            info.url = url;
//            [handledPics addObject:info];
//        }
//    }
//    self.handledPics = handledPics;
//    [self.cycleView reloadData];
//
//    self.categoryViewWidth.constant = 50.f*categoryTitles.count;
//    self.categoryView.titles = categoryTitles;
//    [self.categoryView reloadData];
    
    
    // 处理楼盘基础信息
    self.houseName.text = self.houseDetail.name;
    self.housePrice.text = [NSString stringWithFormat:@"均价%@元/m²",self.houseDetail.price];
    self.huxingName.text = [NSString stringWithFormat:@"%@ %@m²",self.houseDetail.mainHuxingName,self.houseDetail.mainHuxingBuldArea];
    if (self.houseDetail.tag && self.houseDetail.tag.length) {
        NSArray *tagNames = [self.houseDetail.tag componentsSeparatedByString:@","];
        for (int i=0; i<self.houseTags.count; i++) {
            UILabel *tagL = self.houseTags[i];
            if ((tagNames.count-1) >= i) {
                tagL.hidden = NO;
                tagL.text = [NSString stringWithFormat:@" %@ ",tagNames[i]];
            }else{
                tagL.hidden = YES;
            }
        }
    }else{
        for (UILabel *tagL in self.houseTags) {
            tagL.hidden = YES;
        }
    }

    // 处理楼盘详情
    NSMutableArray *houseInfo = [NSMutableArray array];
    NSArray *titles = @[@"楼盘地址",@"楼盘状态",@"可售面积",@"可售户型",@"开盘时间"];
    NSArray *values = @[self.houseDetail.buldAddr,self.houseDetail.salesState,[NSString stringWithFormat:@"%@㎡", self.houseDetail.areaInterval],self.houseDetail.mainHuxingName,self.houseDetail.openTime];

    for (int i=0; i<5; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"name"] = titles[i];
        dict[@"content"] = values[i];
        [houseInfo addObject:dict];
    }
    self.houseInfoData = houseInfo;
    [self.houseInfoTableView reloadData];
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.houseInfoTableViewHeight.constant = 10.f+44.f+weakSelf.houseInfoTableView.contentSize.height+64.f;
    });

    // 处理产品户型图
    [self.houseStyleCollectionView reloadData];

    // 处理楼盘亮点
    CGFloat textHeight = [self.houseDetail.meritsIntr textHeightSize:CGSizeMake(HX_SCREEN_WIDTH-15*2, CGFLOAT_MAX) font:[UIFont fontWithName:@"PingFangSC-Medium" size: 14] lineSpacing:5.f];
    [self.houseGoodsLabel setTextWithLineSpace:5.f withString:self.houseDetail.meritsIntr withFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 14]];
    if (self.houseDetail.meritsList && self.houseDetail.meritsList.length) {
        self.houseGoods = [self.houseDetail.tag componentsSeparatedByString:@","];
    }else{
        self.houseGoods = [NSArray array];
    }
    [self.houseGoodsTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.houseGoodsViewHeight.constant = 10.f+44.f+textHeight+weakSelf.houseGoodsTableView.contentSize.height;
    });

    // 处理周边配套
    QPointAnnotation *a1 = [[QPointAnnotation alloc] init];
    a1.coordinate = CLLocationCoordinate2DMake(self.houseDetail.dimension, self.houseDetail.longitude);
    a1.title      = self.houseDetail.name;
    [self.mapView addAnnotation:a1];
    [self.mapView setCenterCoordinate:a1.coordinate animated:YES];
    
    [self.houseNearbyTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.houseNearbyViewHeight.constant = 10.f+44.f+260.f+weakSelf.houseNearbyTableView.contentSize.height;
    });

    // 处理楼盘动态
    [self.houseNewsTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.houseNewsTableViewHeight.constant = 10.f+44.f+weakSelf.houseNewsTableView.contentSize.height+64.f;
    });
}
#pragma mark -- QMap Delegate
/**
 * @brief 根据anntation生成对应的ViewQ
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id <QAnnotation>)annotation;
{
    if ([annotation isKindOfClass:[QUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[RCCustomAnnotation class]]) {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        QAnnotationView *annotationView = (QAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil){
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        }
        if (self.lastNearbyType == 1) {
            annotationView.image = [UIImage imageNamed:@"icon_bus_click"];
        }else if (self.lastNearbyType == 2){
            annotationView.image = [UIImage imageNamed:@"icon_education_click"];
        }else if (self.lastNearbyType == 3){
            annotationView.image = [UIImage imageNamed:@"icon_medical_click"];
        }else{
            annotationView.image = [UIImage imageNamed:@"icon_business_click"];
        }
        annotationView.canShowCallout               = YES;
        annotationView.annotation = annotation;
        
        return annotationView;
    }else if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QAnnotationView *annotationView = (QAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil){
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"icon_logo"];
        annotationView.canShowCallout               = YES;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
#pragma mark -- JXCategoryView代理
/**
 点击选中的情况才会调用该方法
 
 @param categoryView categoryView对象
 @param index 选中的index
 */
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    [self.cycleView scrollToItemAtIndex:index animate:YES];
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.handledPics.count;
}
- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    RCBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndex:index];
    RCHousePicInfo *picInfo = self.handledPics[index];
    cell.picInfo = picInfo;
    return cell;
}
- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 0.f;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    RCHousePicInfo *picInfo = self.handledPics[toIndex];

    if (picInfo.type == RCHousePicInfoTypePicture) {
        self.cycleNum.hidden = NO;
        self.cycleNum.text = [NSString stringWithFormat:@"%zd/%zd", (toIndex+1)-(self.categoryView.titles.count-1),self.housePic.picUrls.count];
        [self.categoryView selectItemAtIndex:self.categoryView.titles.count-1];
    }else{
        self.cycleNum.hidden = YES;
        [self.categoryView selectItemAtIndex:toIndex];
    }
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    RCHousePicInfo *picInfo = self.handledPics[index];
    
    if (picInfo.type == RCHousePicInfoTypeVR) {
        RCPanoramaVC *pvc = [RCPanoramaVC new];
        pvc.url = self.housePic.vrUrl;
        HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:pvc];
        [self presentViewController:nav animated:YES completion:nil];
    }else if (picInfo.type == RCHousePicInfoTypeVideo) {
        RCVideoFullScreenVC *fvc = [RCVideoFullScreenVC new];
        fvc.url = self.housePic.videoUrl;
        [self.navigationController pushViewController:fvc animated:NO];
    }else{
        HXLog(@"点击图片");
    }
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.houseDetail.rhxList.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ColumnLayout;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseStyleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HouseStyleCell forIndexPath:indexPath];
    RCHouseStyle *style = self.houseDetail.rhxList[indexPath.item];
    cell.style = style;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseStyleVC *svc = [RCHouseStyleVC new];
    RCHouseStyle *style = self.houseDetail.rhxList[indexPath.item];
    svc.uuid = style.uuid;
    [self.navigationController pushViewController:svc animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150.f,collectionView.hxn_height-15.f*2);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(15, 15, 15, 15);
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.houseInfoTableView) {
        return self.houseInfoData.count;
    }else if (tableView == self.houseNewsTableView) {
        return self.houseNews.count;
    }else if (tableView == self.houseGoodsTableView) {
        return self.houseGoods.count;
    }else{
        if (self.lastNearbyType == 1) {
            return self.nearbyBus.count;
        }else if (self.lastNearbyType == 2){
            return self.nearbyEducation.count;
        }else if (self.lastNearbyType == 3){
            return self.nearbyMedical.count;
        }else{
            return self.nearbyBusiness.count;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.houseInfoTableView) {
        RCHouseDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseDetailInfoCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.locationBtn.hidden = indexPath.row;
        NSDictionary *dict = self.houseInfoData[indexPath.row];
        cell.name.text = [NSString stringWithFormat:@"%@：",dict[@"name"]];
        cell.content.text = dict[@"content"];
        return cell;
    }else if (tableView == self.houseNewsTableView) {
        RCHouseDetailNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseDetailNewsCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RCHouseNews *news = self.houseNews[indexPath.row];
        cell.news = news;
        return cell;
    }else if (tableView == self.houseGoodsTableView) {
        RCHouseGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseGoodsCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.goodName.text = self.houseGoods[indexPath.row];
        return cell;
    }else{
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.houseInfoTableView) {
        return UITableViewAutomaticDimension;
    }else if (tableView == self.houseNewsTableView) {
        return 120.f;
    }else if (tableView == self.houseGoodsTableView) {
        return 36.f;
    }else{
        return 44.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.houseNewsTableView) {
        RCNewsDetailVC *dvc = [RCNewsDetailVC new];
        RCHouseNews *news = self.houseNews[indexPath.row];
        dvc.newsUuid = news.uuid;
        [self.navigationController pushViewController:dvc animated:YES];
    }else if (tableView == self.houseNearbyTableView) {
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
        if (!self.nearbyPoint) {
            self.nearbyPoint = [[RCCustomAnnotation alloc] init];
        }else{
            [self.mapView removeAnnotation:self.nearbyPoint];
        }
        self.nearbyPoint = [[RCCustomAnnotation alloc] init];
        self.nearbyPoint.coordinate = CLLocationCoordinate2DMake(nearby.location.lat, nearby.location.lng);
        self.nearbyPoint.title      = nearby.title;
        [self.mapView addAnnotation:self.nearbyPoint];
        [self.mapView setCenterCoordinate:self.nearbyPoint.coordinate animated:YES];
    }
}
@end
