//
//  RCMyBrokerCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyBroker;
typedef void(^resetOrDeleteCall)(NSInteger index);
@interface RCMyBrokerCell : UITableViewCell
/* 重置密码 */
@property(nonatomic,copy) resetOrDeleteCall resetOrDeleteCall;
/* 经纪人 */
@property(nonatomic,strong) RCMyBroker *broker;
@end

NS_ASSUME_NONNULL_END
