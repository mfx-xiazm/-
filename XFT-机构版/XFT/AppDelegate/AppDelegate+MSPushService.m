//
//  AppDelegate+MSPushService.m
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import "AppDelegate+MSPushService.h"
//#import <UMShare/UMShare.h>
//#import "UMessage.h"
//#import "BBSetDetailVC.h"
//#import "BBRemindDetailVC.h"

@implementation AppDelegate (MSPushService)
-(void)initPushService:(NSDictionary *)launchOptions
{
//    /* 打开调试日志 */
//    [[UMSocialManager defaultManager] openLog:NO];
//
//    [UMessage startWithAppkey:HXUMengKey launchOptions:launchOptions httpsenable:YES];
//    [UMessage setLogEnabled:NO];
//    //注册通知
//    [UMessage registerForRemoteNotifications];
//
//    //iOS10必须加下面这段代码。
//    if (@available(iOS 10.0, *)){
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate=self;
//        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
//        [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (granted) {
//                //点击允许
//                //这里可以添加一些自己的逻辑
//            } else {
//                //点击不允许
//                //这里可以添加一些自己的逻辑
//            }
//        }];
//    }else if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {
//        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]){
//            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
//            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        }
//    }
}
-(void)checkPushNotification:(NSDictionary *)launchOptions
{
    // 判断是否有通知
    NSDictionary *pushNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (pushNotification != nil) {
        HXLog(@"###应用杀死点击通知进入应用###");
        [self doHandleRemoteNotification:pushNotification];
    }
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenString = [NSString  stringWithFormat:@"%@",deviceToken];
    //解析token值,去掉前后尖括号
    tokenString = [tokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //去掉token值中的空格
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];

    // 保存tokenString
    [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:HXDeviceTokens];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
//    [UMessage registerDeviceToken:deviceToken];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    HXLog(@"Failed to get token, error:%@", error_str);
}
#pragma mark -- 处理远程通知
// iOS10以下使用这个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
//    [UMessage setAutoAlert:NO];
//    if([[[UIDevice currentDevice] systemVersion] intValue] < 10) {
//        [UMessage didReceiveRemoteNotification:userInfo];
//
//        if(application.applicationState == UIApplicationStateActive) {
//            HXLog(@"####iOS 10下 前台推送通知####");
//        }else {
//            // 处理推送通知,跳转页面
//            HXLog(@"####iOS 10下 后台推送通知####");
//            [self doHandleRemoteNotification:userInfo];
//        }
//    }
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
        HXLog(@"####iOS 10 前台收到推送通知--%@####",userInfo);
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        HXLog(@"####iOS 10 后台点击推送通知####");
        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self doHandleRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
    completionHandler();
}
#pragma mark -- 处理通知点击事件
-(void)doHandleRemoteNotification:(NSDictionary *)userInfo
{
//    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
//    UINavigationController *nav = tab.viewControllers[tab.selectedIndex];
    
    if (userInfo[@"type"]) {
//        NSString *type = [NSString stringWithFormat:@"%@",userInfo[@"type"]];
//        if ([type isEqualToString:@"100"]) {//订阅提醒
//            NSString *value = [userInfo objectForKey:@"value"];
//            BBRemindDetailVC *dvc = [BBRemindDetailVC new];
//            dvc.msg_type = @"100";
//            dvc.msg_id = value;
//            [nav pushViewController:dvc animated:YES];
//        }else if ([type isEqualToString:@"101"]){//套餐详情
//            NSString *value = [userInfo objectForKey:@"value"];
//            BBSetDetailVC *dvc = [BBSetDetailVC new];
//            dvc.item_id = value;
//            [nav pushViewController:dvc animated:YES];
//        }
    }
}
#pragma mark -- 程序进入活跃 角标清零
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}

@end
