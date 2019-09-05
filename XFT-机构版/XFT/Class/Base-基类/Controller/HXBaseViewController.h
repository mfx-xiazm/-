//
//  HXBaseViewController.h
//  KYPX
//
//  Created by hxrc on 17/7/13.
//  Copyright © 2017年 KY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HXUIState) {
    HXSuccess,      // 网络加载成功
    HXFail,   // 网络加载失败
};
@interface HXBaseViewController : UIViewController
- (BOOL)isCanUsePhotos;
- (BOOL)isCanUseCamera;
- (BOOL)isCanUseLocation;
- (void)startShimmer;
- (void)stopShimmer;
- (void)reloadDataRequest;
/* 全面屏 */
@property(nonatomic,assign) BOOL iPhoneXLater;
/** 定义导航栏高度 */
@property (nonatomic,assign) CGFloat HXNavBarHeight;
/** 定义Tabbar高度 */
@property (nonatomic,assign) CGFloat HXTabBarHeight;
/** 定义底部安全高度 */
@property (nonatomic,assign) CGFloat HXButtomHeight;
/** 顶部电量条高度 */
@property (nonatomic,assign) CGFloat HXStatusHeight;
@end
