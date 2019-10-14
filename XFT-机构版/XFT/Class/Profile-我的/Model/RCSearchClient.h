//
//  RCSearchClient.h
//  XFT
//
//  Created by 夏增明 on 2019/10/9.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSearchClient : NSObject
@property (nonatomic, strong) NSString * baoBeiUuid;//报备表uuid
@property (nonatomic, assign) NSInteger cusState;//状态 0:报备成功 2:到访 4:认筹 5:认购 6:签约 7:退房 100:失效
@property (nonatomic, strong) NSString * cusUuid;//客户uuid
@property (nonatomic, strong) NSString * day;//day天后失效
@property (nonatomic, strong) NSString * lastRemarkTime;//备注时间
@property (nonatomic, strong) NSString * lastVistTime;//最近到访时间
@property (nonatomic, strong) NSString * name;//姓名
@property (nonatomic, strong) NSString * proName;//项目名称
@property (nonatomic, strong) NSString * proUuid;//项目uuid
@property (nonatomic, strong) NSString * remark;//备注内容
@property (nonatomic, strong) NSString * reportGroupUuid;//
@property (nonatomic, strong) NSString * reportName;//报备人
@property (nonatomic, strong) NSString * reportUuid;//
@property (nonatomic, strong) NSString * seeTime;//主机构/子机构管理员报备时间;门店经纪人/统一报备人预约时间
@property (nonatomic, strong) NSString * phone;//客户电话
@property (nonatomic, strong) NSString * createTime;//门店经纪人/统一报备人报备时间
@property (nonatomic, strong) NSString * salesNameAndTeam;//案场顾问+团队名称
@property (nonatomic, strong) NSString * time;//门店经纪人/统一报备人最后备注时间

/* 是否隐号 */
@property(nonatomic,assign) BOOL isHidden;

@end

NS_ASSUME_NONNULL_END
