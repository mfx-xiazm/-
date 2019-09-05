//
//  AppDelegate+MSAppService.h
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import "AppDelegate.h"

/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
@interface AppDelegate (MSAppService)

//初始化 app服务
-(void)initService;

//初始化 window
-(void)initWindow;

//初始化用户系统
-(void)initUserManager;


//监听网络状态
- (void)monitorNetworkStatus;

//单例
+ (AppDelegate *)shareAppDelegate;

@end
