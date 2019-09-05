//
//  MSUserManager.h
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSUserInfo.h"

typedef NS_ENUM(NSInteger, UserLoginType){
    kUserLoginTypeUnKnow = 0,//未知
    kUserLoginTypeWeChat,//微信登录
    kUserLoginTypeQQ,//QQ登录
    kUserLoginTypeSina,//微博登录
    kUserLoginTypePwd,//账号登录
};

typedef void (^loginBlock)(BOOL success, NSString *errorDes,NSString *userid);

@interface MSUserManager : NSObject
+ (instancetype)sharedInstance;
/** 当前用户 */
@property (nonatomic, strong) MSUserInfo *curUserInfo;
/** 是否已经登录 */
@property (nonatomic, assign) BOOL isLogined;
/** 用户登录方式 */
@property (nonatomic,assign) UserLoginType loginType;
/** 三方登录 */
-(void)login:(UserLoginType )loginType completion:(loginBlock)completion;
/** 带参登录，账号登录 */
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion;
/** 退出登录 */
- (void)logout:(void (^)(BOOL, NSString *))completion;
/** 加载缓存用户数据 是否成功 */
-(BOOL)loadUserInfo;
/** 保存用户信息 */
-(void)saveUserInfo;
@end
