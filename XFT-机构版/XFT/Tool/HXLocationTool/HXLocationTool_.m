//
//  HXLocationTool_.m
//  KYPX
//
//  Created by hxrc on 2017/9/22.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "HXLocationTool_.h"
#import <CoreLocation/CoreLocation.h>

@interface HXLocationTool_ ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;

@end

@implementation HXLocationTool_

#pragma mark - public
- (void)beginUpdatingLocation {
    
    [self.locationManager startUpdatingLocation];
}
#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
    //获取新的位置
    CLLocation * newLocation = locations.lastObject;
    
    //存储经度
    CGFloat longitude = newLocation.coordinate.longitude;
    
    //存储纬度
    CGFloat latitude = newLocation.coordinate.latitude;
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    hx_weakify(self);
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count > 0) {
            CLPlacemark * placemark = placemarks.firstObject;
            //存储位置信息
//            HXLog(@"--%@%@%@%@%@--",placemark.locality,placemark.subLocality,placemark.name,placemark.thoroughfare,placemark.subThoroughfare);
            //设置代理方法
            if ([weakSelf.delegate respondsToSelector:@selector(locationDidEndUpdatingLongitude:latitude:city:)]) {
                
                [weakSelf.delegate locationDidEndUpdatingLongitude:longitude latitude:latitude city:placemark.locality];
            }
        }
    }];
}

#pragma mark - setter and getter
- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        // 设置定位精确度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 设置过滤器为无
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        
        // 取得定位权限，有两个方法，取决于你的定位使用情况
        // 一个是 requestAlwaysAuthorization
        // 一个是 requestWhenInUseAuthorization
        [_locationManager requestWhenInUseAuthorization];//
    }
    return _locationManager;
}
/**
 *  授权状态发生改变时调用
 *
 *  @param manager 位置管理者
 *  @param status  状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            // 用户还未决定
        case kCLAuthorizationStatusNotDetermined:{
            HXLog(@"用户还未决定");
            break;
        }
            // 问受限
        case kCLAuthorizationStatusRestricted:{
            HXLog(@"访问受限");
            break;
        }
            // 定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:{
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled]){
                HXLog(@"定位开启，但被拒");
            }else{
                HXLog(@"定位关闭，不可用");
            }
            //            NSLog(@"被拒");
            break;
        }
            // 获取前后台定位授权
            // case kCLAuthorizationStatusAuthorized: // 失效，不建议使用
        case kCLAuthorizationStatusAuthorizedAlways:{
            HXLog(@"--获取前后台定位授权--");
            [self beginUpdatingLocation];
            break;
        }
            // 获得前台定位授权
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            HXLog(@"--获得前台定位授权--");
            [self beginUpdatingLocation];
            break;
        }
        default:
            break;
    }
    
}
@end

