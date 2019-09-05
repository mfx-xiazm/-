//
//  AppDelegate+MSPushService.h
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import "AppDelegate.h"
/**
 推送业务的实现，减轻入口代码压力
 */

@interface AppDelegate (MSPushService)
//初始化 推送服务
-(void)initPushService:(NSDictionary *)launchOptions;
//点击通知启动已杀死的应用
-(void)checkPushNotification:(NSDictionary *)launchOptions;
@end
