//
//  HXBaseViewController.m
//  KYPX
//
//  Created by hxrc on 17/7/13.
//  Copyright © 2017年 KY. All rights reserved.
//

#import "HXBaseViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <sys/utsname.h>
#import "FBShimmeringView.h"

@interface HXBaseViewController ()
/** Shimmering */
@property (strong, nonatomic) FBShimmeringView *shimmer;
@end

@implementation HXBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self isiPhoneXLater]) {
        self.iPhoneXLater = YES;
        self.HXNavBarHeight = 88.f;
        self.HXTabBarHeight = 83.f;
        self.HXButtomHeight = 34.f;
        self.HXStatusHeight = 44.f;
    }else{
        self.iPhoneXLater = NO;
        self.HXNavBarHeight = 64.f;
        self.HXTabBarHeight = 49.f;
        self.HXButtomHeight = 0.f;
        self.HXStatusHeight = 20.f;
    }

    self.shimmer = [[FBShimmeringView alloc] initWithFrame:self.view.bounds];
    self.shimmer.backgroundColor = [UIColor whiteColor];
    self.shimmer.shimmering = NO;
    self.shimmer.shimmeringPauseDuration = 0.15;
    self.shimmer.shimmeringBeginFadeDuration = 0.2;
    self.shimmer.shimmeringEndFadeDuration = 0.2;
    self.shimmer.shimmeringOpacity = 0.2;
    self.shimmer.shimmeringSpeed = 360;
    self.shimmer.hidden = YES;
    [self.view addSubview:self.shimmer];
    
    UILabel *shimmerLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    shimmerLabel.text = @"壹企帮";
    shimmerLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 26];
    shimmerLabel.textColor = HXControlBg;
    shimmerLabel.textAlignment = NSTextAlignmentCenter;
    shimmerLabel.backgroundColor = [UIColor whiteColor];
    self.shimmer.contentView = shimmerLabel;
}
-(void)reloadDataRequest
{
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.shimmer.frame = self.view.bounds;
}
-(BOOL)isiPhoneXLater
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*phoneType = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    /*
     if([phoneType  isEqualToString:@"iPhone10,3"]) return@"iPhone X";
     
     if([phoneType  isEqualToString:@"iPhone10,6"]) return@"iPhone X";
     
     if([phoneType  isEqualToString:@"iPhone11,8"]) return@"iPhone XR";
     
     if([phoneType  isEqualToString:@"iPhone11,2"]) return@"iPhone XS";
     
     if([phoneType  isEqualToString:@"iPhone11,4"]) return@"iPhone XS Max";
     
     if([phoneType  isEqualToString:@"iPhone11,6"]) return@"iPhone XS Max";
     */
    if([phoneType  isEqualToString:@"iPhone10,3"] || [phoneType  isEqualToString:@"iPhone10,6"] || [phoneType  isEqualToString:@"iPhone11,8"] || [phoneType  isEqualToString:@"iPhone11,2"] || [phoneType  isEqualToString:@"iPhone11,4"] || [phoneType  isEqualToString:@"iPhone11,6"]) {
        return YES;
    }else{
        return NO;
    }
}
-(void)startShimmer
{
    self.shimmer.hidden = NO;
    self.shimmer.shimmering = YES; // 开启闪烁
}
-(void)stopShimmer
{
    self.shimmer.hidden = YES;
    self.shimmer.shimmering = NO; // 关闭闪烁
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 隐私->照片界面
 
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"]];
 隐私->相机界面
 
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];

 */
/**
 判断是否有相册权限

 @return yes有权限；no无权限
 */
- (BOOL)isCanUsePhotos {
//    if (@available(iOS 8.0, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
//    }else{
//        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
//        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
//            //无权限
//            return NO;
//        }
//    }
    return YES;
}
/**
 检测相机是否授权
 */
- (BOOL)isCanUseCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    /*
    AVAuthorizationStatusNotDetermined = 0,// 系统还未知是否访问，第一次开启相机时
    AVAuthorizationStatusRestricted, // 受限制的
    AVAuthorizationStatusDenied, //不允许
    AVAuthorizationStatusAuthorized // 允许状态
    */
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}
- (BOOL)isCanUseLocation
{
    if(![CLLocationManager locationServicesEnabled]){
       return NO;
    }
    CLAuthorizationStatus locationStatus =  [CLLocationManager authorizationStatus];
    if (locationStatus == kCLAuthorizationStatusRestricted || locationStatus == kCLAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}


@end
