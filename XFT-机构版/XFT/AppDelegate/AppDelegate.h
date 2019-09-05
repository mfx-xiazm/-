//
//  AppDelegate.h
//  LBB
//
//  Created by hxrc on 2019/3/1.
//  Copyright © 2019 xzm. All rights reserved.
//

#import <UIKit/UIKit.h>
//// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
//#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

