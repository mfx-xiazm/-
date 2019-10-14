//
//  RCWishHouseVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^wishHouseCall)(NSArray *houses);
@interface RCWishHouseVC : HXBaseViewController
/* 是否批量报备 批量报备只能选择1个房源 单独报备最多选择3个房源*/
@property(nonatomic,assign) BOOL isBatchReport;
/* 选择的意向罗盘回调 */
@property(nonatomic,copy) wishHouseCall wishHouseCall;
/* 传递进来上一次选择的楼盘 */
@property(nonatomic,strong) NSArray *lastHouses;
@end

NS_ASSUME_NONNULL_END
