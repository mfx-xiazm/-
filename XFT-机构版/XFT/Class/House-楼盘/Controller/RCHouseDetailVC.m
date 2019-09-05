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
#import <MAMapKit/MAMapKit.h>
#import "RCHouseStyleVC.h"
#import "RCHouseNewsVC.h"
#import "RCHouseNearbyVC.h"
#import "RCReportVC.h"
#import "RCNewsDetailVC.h"

static NSString *const HouseDetailInfoCell = @"HouseDetailInfoCell";
static NSString *const HouseDetailNewsCell = @"HouseDetailNewsCell";
static NSString *const HouseStyleCell = @"HouseStyleCell";

@interface RCHouseDetailVC ()<TYCyclePagerViewDataSource, TYCyclePagerViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate>
/** 轮播图 */
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cycleView;
@property (weak, nonatomic) IBOutlet UILabel *cycleNum;
/** 楼盘基础信息 */
@property (weak, nonatomic) IBOutlet UIView *houseInfoView;
/** 楼盘信息展示 */
@property (weak, nonatomic) IBOutlet UITableView *houseInfoTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseInfoTableViewHeight;
/** 楼盘动态 */
@property (weak, nonatomic) IBOutlet UITableView *houseNewsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseNewsTableViewHeight;
/** 产品户型图 */
@property (weak, nonatomic) IBOutlet UICollectionView *houseStyleCollectionView;
/** 周边配套 */
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
@property (nonatomic, strong) MAMapView *mapView;
@end

@implementation RCHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"楼盘详情"];
    [self setUpNavBar];
    [self setUpCycleView];
    [self setUpCollectionView];
    [self setUpTableView];
    // 地图
    [self.mapSuperView addSubview:self.mapView];
    // 设置地图中心点
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(30.4865508426, 114.3347167969);
}
-(MAMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] initWithFrame:self.mapSuperView.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 13;
        _mapView.delegate = self;
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = CLLocationCoordinate2DMake(30.4865508426, 114.3347167969);
        a1.title      = @"幸福里项目基地";
        [_mapView addAnnotation:a1];
    }
    return _mapView;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.houseInfoView bezierPathByRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    
    [self.cycleView reloadData];
    
    [self.houseInfoTableView reloadData];
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.houseInfoTableViewHeight.constant = 10.f+44.f+weakSelf.houseInfoTableView.contentSize.height;
    });
    
    [self.houseNewsTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.houseNewsTableViewHeight.constant = 10.f+44.f+weakSelf.houseNewsTableView.contentSize.height;
    });
    
    self.mapView.frame = self.mapSuperView.bounds;
}

#pragma mark -- 视图配置
-(void)setUpNavBar
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareClicked) nomalImage:HXGetImage(@"搜索") higeLightedImage:HXGetImage(@"搜索") imageEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpCycleView
{
    self.cycleView.isInfiniteLoop = YES;
    self.cycleView.autoScrollInterval = 3.0;
    self.cycleView.dataSource = self;
    self.cycleView.delegate = self;
    // registerClass or registerNib
    [self.cycleView registerNib:[UINib nibWithNibName:NSStringFromClass([RCBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"BannerCell"];
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
    self.houseInfoTableView.estimatedRowHeight = UITableViewAutomaticDimension;//预估高度
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
- (IBAction)houseCollectClicked:(SPButton *)sender {
    HXLog(@"收藏");
}

- (IBAction)houseNewsClicked:(UIButton *)sender {
    RCHouseNewsVC *nvc = [RCHouseNewsVC new];
    [self.navigationController pushViewController:nvc animated:YES];
}
- (IBAction)houseNearbyClicked:(UIButton *)sender {
    RCHouseNearbyVC *nvc = [RCHouseNearbyVC new];
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
#pragma mark - Map Delegate
/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"mappin"];
        annotationView.canShowCallout               = YES;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 3;
}
- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    RCBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndex:index];
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
    self.cycleNum.text = [NSString stringWithFormat:@"%zd/3",toIndex+1];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
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
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RCHouseStyleVC *svc = [RCHouseStyleVC new];
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
    return tableView == self.houseInfoTableView?7:2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.houseInfoTableView) {
        RCHouseDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseDetailInfoCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RCHouseDetailNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseDetailNewsCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.houseInfoTableView) {
        return UITableViewAutomaticDimension;
    }else{
        return 120.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.houseNewsTableView) {
        RCNewsDetailVC *dvc = [RCNewsDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
@end
