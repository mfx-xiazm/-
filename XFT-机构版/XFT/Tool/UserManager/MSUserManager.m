//
//  MSUserManager.m
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import "MSUserManager.h"
#import <UMShare/UMShare.h>
#import <YYCache.h>
#import <YYModel.h>

//用户信息存储键
#define KUserCacheName @"KBBUserCacheName"
#define KUserModelCache @"KBBUserModelCache"

static MSUserManager *_instance = nil;
static YYCache *_cache = nil;
@implementation MSUserManager
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
        _cache = [[YYCache alloc] initWithName:KUserCacheName];
    });
    return _instance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//+(id)copyWithZone:(nullable NSZone *)zone{
//    return _instance;
//}
-(instancetype)init{
    self = [super init];
    if (self) {
        //被踢下线（用于IM）
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(onKick)
//                                                     name:KNotificationOnKick
//                                                   object:nil];
    }
    return self;
}
#pragma mark ————— 三方登录 —————
-(void)login:(UserLoginType )loginType completion:(loginBlock)completion{
    [self login:loginType params:nil completion:completion];
}

#pragma mark ————— 带参数登录 —————
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion{
    self.loginType = loginType;
    //友盟登录类型
    UMSocialPlatformType platFormType;
    
    if (loginType == kUserLoginTypeQQ) {
        platFormType = UMSocialPlatformType_QQ;
    }else if (loginType == kUserLoginTypeWeChat){
        platFormType = UMSocialPlatformType_WechatSession;
    }else if (loginType == kUserLoginTypeSina){
        platFormType = UMSocialPlatformType_Sina;
    }else{
        platFormType = UMSocialPlatformType_UnKnown;
    }
    //第三方登录
    if (loginType == kUserLoginTypeQQ || loginType == kUserLoginTypeWeChat || loginType == kUserLoginTypeSina) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:platFormType currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                // 授权失败
                if (completion) {
                    completion(NO,error.localizedDescription,nil);
                }
            } else {
                // 授权成功
                UMSocialUserInfoResponse *resp = result;
                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                
                parameters[@"action"] = @"user_thirdlogin_set";
                if (loginType == kUserLoginTypeQQ) {
                    parameters[@"qq"] = resp.unionId;//qq号唯一标识(和微信ID二传一)
                    parameters[@"qqname"] = resp.name;//qq昵称
                    parameters[@"weixinid"] = @"";//微信唯一标识
                    parameters[@"weixinname"] = @"";//微信昵称
                }else if (loginType == kUserLoginTypeWeChat){
                    parameters[@"qq"] = @"";//qq号唯一标识(和微信ID二传一)
                    parameters[@"qqname"] = @"";//qq昵称
                    parameters[@"weixinid"] = resp.unionId;//微信唯一标识
                    parameters[@"weixinname"] = resp.name;//微信昵称
                }else {
                    parameters[@"qq"] = @"";//qq号唯一标识(和微信ID二传一)
                    parameters[@"qqname"] = @"";//qq昵称
                    parameters[@"weixinid"] = @"";//微信唯一标识
                    parameters[@"weixinname"] = @"";//微信昵称
                }
                parameters[@"photo"] = resp.iconurl;//头像
                //登录到服务器
                [self loginToServer:parameters completion:completion];
            }
        }];
    }else{
        [self loginToServer:params completion:completion];
    }
}
#pragma mark ————— 手动登录到服务器 —————
-(void)loginToServer:(NSDictionary *)params completion:(loginBlock)completion {
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL parameters:params success:^(id responseObject) {
//        NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
//        hx_strongify(weakSelf);
//        if ([state isEqualToString:@"1"]) {
//            if (strongSelf.loginType == kUserLoginTypePwd) {
//                [strongSelf LoginSuccess:responseObject completion:completion];
//            }else{
//                // 判断是否有绑定手机号
//                NSString *phone = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"phone"]];
//                if (phone && phone.length) {
//                    [strongSelf LoginSuccess:responseObject completion:completion];
//                }else{
//                    if (completion) {
//                        completion(YES,nil,[NSString stringWithFormat:@"%@",responseObject[@"result"][@"userid"]]);
//                    }
//                }
//            }
//        }else{
//            if (completion) {
//                completion(NO,responseObject[@"message"],nil);
//            }
//        }
//    } failure:^(NSError *error) {
//        if (completion) {
//            completion(NO,error.localizedDescription,nil);
//        }
//    }];
}
#pragma mark ————— 登录成功处理 —————
-(void)LoginSuccess:(id)responseObject completion:(loginBlock)completion{
    // 拿到账号和密码登录IM
    if (responseObject) {
        // 在这里可以登录IM
        // 登录IM
        // 存入用户信息
        self.curUserInfo = [MSUserInfo yy_modelWithDictionary:[responseObject objectForKey:@"result"]];
        [self saveUserInfo];
        self.isLogined = YES;
        if (completion) {
            completion(YES,nil,nil);
        }
    }else{
        if (completion) {
            completion(NO,@"IM登录失败",nil);
        }
        // 可以发布登录失败的通知
    }
}
#pragma mark ————— 储存用户信息 —————
-(void)saveUserInfo{
    if (self.curUserInfo)
    {
        NSDictionary *dic = [self.curUserInfo yy_modelToJSONObject];
        [_cache setObject:dic forKey:KUserModelCache];
        self.isLogined = YES;
    }
}

#pragma mark ————— 加载缓存的用户信息 —————
-(BOOL)loadUserInfo{
    NSDictionary * userDic = (NSDictionary *)[_cache objectForKey:KUserModelCache];
    if (userDic)
    {
        self.curUserInfo = [MSUserInfo yy_modelWithJSON:userDic];
        self.isLogined = YES;
        return YES;
    }
    return NO;
}
#pragma mark ————— 被踢下线 —————
-(void)onKick{
    [self logout:nil];
}
#pragma mark ————— 退出登录 —————
- (void)logout:(void (^)(BOOL, NSString *))completion{
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // 这里可以做被踢下线通知用户等业务操作
    
    // 在这里可以退出IM
    
    // 清空登录信息
    self.curUserInfo = nil;
    self.isLogined = NO;
    
    //移除登录信息缓存
    [_cache removeAllObjectsWithBlock:^{
        if (completion) {
            completion(YES,nil);
        }
    }];
}
@end
