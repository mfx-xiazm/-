//
//  RCMyClientFilter.h
//  XFT
//
//  Created by 夏增明 on 2019/10/8.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyFilterModel;
@interface RCMyClientFilter : NSObject
/* 经纪人 */
@property(nonatomic,strong) NSArray<RCMyFilterModel *> *brokerList;
/* 报备人 */
@property(nonatomic,strong) NSArray<RCMyFilterModel *> *reporter;
/* 门店 */
@property(nonatomic,strong) NSArray<RCMyFilterModel *> *storeList;
/* 报备时间开始 */
@property(nonatomic,assign) NSInteger reportStart;
/* 报备时间结束 */
@property(nonatomic,assign) NSInteger reportEnd;
/* 首次到访时间开始 */
@property(nonatomic,assign) NSInteger firstVisitStart;
/* 首次到访时间结束 */
@property(nonatomic,assign) NSInteger firstVisitEnd;
/* 报备开始时间字符串 */
@property(nonatomic,copy,nullable) NSString *reportStartStr;
/* 报备结束时间字符串 */
@property(nonatomic,copy,nullable) NSString *reportEndStr;
/* 到访开始时间字符串 */
@property(nonatomic,copy,nullable) NSString *visitStartStr;
/* 到访结束时间字符串 */
@property(nonatomic,copy,nullable) NSString *visitEndStr;
/* 选中的经纪人 */
@property(nonatomic,strong,nullable) RCMyFilterModel *selectBroker;
/* 选中的报备人 */
@property(nonatomic,strong,nullable) RCMyFilterModel *selectReporter;
/* 选中的经纪人 */
@property(nonatomic,strong,nullable) RCMyFilterModel *selectStore;
@end


@interface RCMyFilterModel : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *uuid;
/* 是否选中 */
@property(nonatomic,assign) BOOL isSelected;
@end
NS_ASSUME_NONNULL_END
