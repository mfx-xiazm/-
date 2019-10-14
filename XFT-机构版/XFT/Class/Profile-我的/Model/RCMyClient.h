//
//  RCMyClient.h
//  XFT
//
//  Created by 夏增明 on 2019/9/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyClient : NSObject
// 以下是最新接口对应的字段
@property (nonatomic, strong) NSString * uuid;//报备uuid
@property (nonatomic, strong) NSString * name;//客户姓名
@property (nonatomic, strong) NSString * phone;//客户电话
@property (nonatomic, strong) NSString * editTime;//状态时间
@property (nonatomic, strong) NSString * createTime;//报备时间
@property (nonatomic, strong) NSString * countdownTime;//失效倒计时
@property (nonatomic, strong) NSString * projectId;//项目id
@property (nonatomic, strong) NSString * reporter;//报备人
@property (nonatomic, strong) NSString * reporterId;//报备人Id
@property (nonatomic, strong) NSString * remarks;//备注内容
@property (nonatomic, strong) NSString * remarkTime;//备注时间
/* 是否隐号 0 否  1 是 */
@property(nonatomic,assign) BOOL isHidden;
@property (nonatomic, strong) NSString * salesUuid;//顾问uuid
@property (nonatomic, strong) NSString * salesName;//顾问名称
@property (nonatomic, strong) NSString * groupName;//顾问归属小组名称
@property (nonatomic, strong) NSString * groupUuid;//顾问归属小组uuid
@property (nonatomic, strong) NSString * teamName;//归属团队名称
@property (nonatomic, strong) NSString * teamUuid;//归属团队uuid
@property (nonatomic, strong) NSString * accTeamName;//团队/机构名称
@property (nonatomic, strong) NSString * accGroupName;//小组/门店名称
@property (nonatomic, strong) NSString * accName;//报备人名称
@property (nonatomic, strong) NSString * accType;//报备人类型 1 顾问 2 经纪人 3 自渠专员 4 展厅专员  5 统一报备人 6 门店管理员

@end

NS_ASSUME_NONNULL_END
