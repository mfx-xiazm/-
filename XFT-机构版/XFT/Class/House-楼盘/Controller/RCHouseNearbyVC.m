//
//  RCHouseNearbyVC.m
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseNearbyVC.h"
#import <QMapKit/QMapKit.h>
#import "RCHouseNearbyDetailVC.h"
#import "RCNearbyPOI.h"
#import "RCCustomAnnotation.h"

#define Y1               150
//#define Y2               self.view.frame.size.height - 250
#define Y3               self.view.frame.size.height - 75

@interface RCHouseNearbyVC ()<QMapViewDelegate,UIGestureRecognizerDelegate,RCHouseNearbyDetailVCDelegate>
/** 城市选择 */
@property (nonatomic, strong) RCHouseNearbyDetailVC  *vc;
/** 用来显示阴影的view，里面装的是 self.vc.view也就是城市选择控制器的view */
@property (nonatomic, strong) UIView  *shadowView;
/** 地图 */
@property (nonatomic, strong) QMapView *mapView;
/* 导航栏 */
@property(nonatomic,strong) UIView *navBarView;
/** 周边配套的选中打点 */
@property(nonatomic,strong) RCCustomAnnotation *nearbyPoint;
/** 正在展示的周边类型 1.交通 2.教育 3.医疗 4.商业 */
@property(nonatomic,assign) NSInteger nearbyType;
@end

@implementation RCHouseNearbyVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 地图
    [self.view addSubview:self.mapView];
    
    // 设定地图中心点
    QPointAnnotation *a1 = [[QPointAnnotation alloc] init];
    a1.coordinate = CLLocationCoordinate2DMake(self.lat, self.lng);
    a1.title      = self.name;
    [self.mapView addAnnotation:a1];
    [self.mapView setCenterCoordinate:a1.coordinate animated:YES];
    
    [self.view addSubview:self.navBarView];
    
    [self addChildViewController:self.vc];
    [self.shadowView addSubview:self.vc.view];
    [self.view addSubview:self.shadowView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.view.bounds;
    
    self.navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
    
    self.shadowView.frame = CGRectMake(0, Y3, self.view.frame.size.width, self.view.frame.size.height);
}
#pragma mark - 懒加载
-(UIView *)navBarView
{
    if (_navBarView == nil) {
        _navBarView = [UIView new];
        _navBarView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, self.HXNavBarHeight);
        _navBarView.backgroundColor = [UIColor whiteColor];
        UILabel *title = [UILabel new];
        title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        title.textColor = UIColorFromRGB(0x333333);
        title.textAlignment = NSTextAlignmentCenter;
        title.frame = CGRectMake(0, self.HXStatusHeight, HX_SCREEN_WIDTH, 44);
        title.text = @"周边配套";
        [_navBarView addSubview:title];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, self.HXStatusHeight, 44, 44);
        [backBtn setImage:HXGetImage(@"返回") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:backBtn];
    }
    return _navBarView;
}
-(RCHouseNearbyDetailVC *)vc
{
    if (!_vc) {
        _vc = [[RCHouseNearbyDetailVC alloc] init];
        _vc.uuid = self.uuid;
        _vc.lng = self.lng;
        _vc.lat = self.lat;
        _vc.delegate = self;
        // -------------- 添加手势 轻扫手势  -----------
        UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipe1.direction = UISwipeGestureRecognizerDirectionDown ; // 设置手势方向
        swipe1.delegate = self;
        [_vc.tableView addGestureRecognizer:swipe1];
        
        UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipe2.direction = UISwipeGestureRecognizerDirectionUp; // 设置手势方向
        swipe2.delegate = self;
        [_vc.tableView addGestureRecognizer:swipe2];
    }
    return _vc;
}
-(UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.frame = CGRectMake(0, Y3, HX_SCREEN_WIDTH, self.view.frame.size.height);
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowRadius = 6;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView.layer.shadowOpacity = 0.1;
    }
    return _shadowView;
}
-(QMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.zoomLevel = 13;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
//        _mapView.userTrackingMode = QUserTrackingModeFollow;
    }
    return _mapView;
}
#pragma mark - AMapSearchDelegate
/**
 * @brief 根据anntation生成对应的View
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
        if (self.nearbyType == 1) {
            annotationView.image = [UIImage imageNamed:@"icon_bus_click"];
        }else if (self.nearbyType == 2){
            annotationView.image = [UIImage imageNamed:@"icon_education_click"];
        }else if (self.nearbyType == 3){
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
        if (annotationView == nil)
        {
            annotationView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = HXGetImage(@"icon_logo");
        annotationView.canShowCallout               = YES;
        annotationView.annotation = annotation;
        return annotationView;
    }
    return nil;
}
#pragma mark -- 手势处理
// 城市列表可滑动时，swipe默认不再响应 所以要打开
- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    float stopY = 0;     // 停留的位置
    float animateY = 0;  // 做弹性动画的Y
    float margin = 10;   // 动画的幅度
    //float offsetY = self.shadowView.frame.origin.y; // 这是上一次Y的位置
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        // 向下轻扫
        // 当vc.table滑到头 且是下滑时，让vc.table禁止滑动
        if (self.vc.tableView.contentOffset.y == 0) {
            self.vc.tableView.scrollEnabled = NO;
        }
        
        // 停在y3的位置
        stopY = Y3;
        
        animateY = stopY + margin;
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        // 向上轻扫
        // 停在y1的位置
        stopY = Y1;
        // 当停在Y1位置 且是上划时，让vc.table不再禁止滑动
        self.vc.tableView.scrollEnabled = YES;
        
        animateY = stopY - margin;
    }
    
    hx_weakify(self);
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.shadowView.frame = CGRectMake(0, animateY, HX_SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.shadowView.frame = CGRectMake(0, stopY, HX_SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height);
        }];
    }];
    // 记录shadowView在第一个视图中的位置
    self.vc.offsetY = stopY;
}
/**
 返回值为NO  swipe不响应手势 collectionView响应手势
 返回值为YES swipe、collectionView也会响应手势, 但是把collectionView的scrollEnabled为No就不会响应table了
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 触摸事件，一响应 就把searchBar的键盘收起来
    // 收起键盘
    
    // 当table Enabled且offsetY不为0时，让swipe响应
    if (self.vc.tableView.scrollEnabled == YES && self.vc.tableView.contentOffset.y != 0) {
        return NO;
    }
    if (self.vc.tableView.scrollEnabled == YES) {
        return YES;
    }
    
    return NO;
}
#pragma mark -- 点击事件
-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- RCHouseNearbyDetailVC代理
-(void)nearbyVC:(RCHouseNearbyDetailVC *)nearbyVC nearbyType:(NSInteger)type didClickedPOI:(RCNearbyPOI *)poi
{
    self.nearbyType = type;

    if (!self.nearbyPoint) {
        self.nearbyPoint = [[RCCustomAnnotation alloc] init];
    }else{
        [self.mapView removeAnnotation:self.nearbyPoint];
    }
    
    self.nearbyPoint = [[RCCustomAnnotation alloc] init];
    self.nearbyPoint.coordinate = CLLocationCoordinate2DMake(poi.location.lat, poi.location.lng);
    self.nearbyPoint.title      = poi.title;
    [self.mapView addAnnotation:self.nearbyPoint];
    [self.mapView setCenterCoordinate:self.nearbyPoint.coordinate animated:YES];
    
    
    float stopY = Y3;     // 停留的位置
    float margin = 10;   // 动画的幅度
    float animateY = stopY + margin;  // 做弹性动画的Y
  
    hx_weakify(self);
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.shadowView.frame = CGRectMake(0, animateY, HX_SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.shadowView.frame = CGRectMake(0, stopY, HX_SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height);
            weakSelf.vc.tableView.contentOffset = CGPointMake(0, 0);//设置回到顶部
            weakSelf.vc.tableView.scrollEnabled = NO;
        }];
    }];
    // 记录shadowView在第一个视图中的位置
    self.vc.offsetY = stopY;
}

@end
