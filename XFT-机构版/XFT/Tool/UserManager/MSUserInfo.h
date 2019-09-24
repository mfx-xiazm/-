//
//  MSUserInfo.h
//  KYPX
//
//  Created by hxrc on 2018/2/9.
//  Copyright © 2018年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSUserShowInfo,MSUserAccessInfo,MSOrgInfoInfo,MSDropValues;
@interface MSUserInfo : NSObject
@property (nonatomic,strong) MSUserShowInfo *agentLoginInside;
@property (nonatomic,strong) MSUserAccessInfo *userAccessInfo;
@property (nonatomic,strong) MSOrgInfoInfo *orgInfo;
@property (nonatomic,strong) NSArray<MSDropValues *> *dropValueDTOS;
@property (nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *userAccessStr;
@end


@interface MSUserShowInfo : NSObject
@property (nonatomic, strong) NSString * accNo;
/** 账号角色 1:中介管理员 2:中介报备人 3:门店主管 4:中介经纪人 */
@property (nonatomic, assign) NSInteger accRole;
@property (nonatomic, strong) NSString * addr;
@property (nonatomic, strong) NSString * bankAccNo;
@property (nonatomic, strong) NSString * bankOpen;
@property (nonatomic, strong) NSString * bankPhone;
@property (nonatomic, strong) NSString * cardNo;
/** 身份证件类别 1:身份证 */
@property (nonatomic, strong) NSString * cardType;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger editTime;
@property (nonatomic, strong) NSString * headpic;
/** 删除状态 0：正常 1：删除 */
@property (nonatomic, assign) NSInteger isDel;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * nick;
@property (nonatomic, strong) NSString * pwd;
@property (nonatomic, strong) NSString * realName;
@property (nonatomic, strong) NSString * regPhone;
@property (nonatomic, strong) NSString * remarks;
/** 性别 1 男 2 女 */
@property (nonatomic, assign) NSInteger sex;
/** 状态 0：关闭 1：启用 */
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) NSString * uuid;
@end

@interface MSUserAccessInfo : NSObject
@property (nonatomic, strong) NSString * accessTime;
@property (nonatomic, strong) NSString * accessToken;
@property (nonatomic, strong) NSString * bizParam;
@property (nonatomic, strong) NSString * domain;
@property (nonatomic, strong) NSString * extParam;
@property (nonatomic, strong) NSString * ip;
@property (nonatomic, strong) NSString * loginId;
@property (nonatomic, strong) NSString * receiveTime;
@property (nonatomic, strong) NSString * traceId;
@property (nonatomic, strong) NSString * userDevice;
@property (nonatomic, strong) NSString * userLbs;
@end

@interface MSOrgInfoInfo : NSObject
@property (nonatomic, strong) NSString * cityUuid;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger editTime;
@property (nonatomic, assign) NSInteger isDel;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * remarks;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * uuid;
@end

@interface MSDropValues : NSObject
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * value;

@end
