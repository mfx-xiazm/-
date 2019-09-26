//
//  RCAddBrokerVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^addBrokerCall)(void);
@interface RCAddBrokerVC : HXBaseViewController
/* 添加成功 */
@property(nonatomic,copy) addBrokerCall addBrokerCall;
@end

NS_ASSUME_NONNULL_END
