//
//  RCAddStoreVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^addStoreCall)(void);
@interface RCAddStoreVC : HXBaseViewController
/* 添加成功 */
@property(nonatomic,copy) addStoreCall addStoreCall;
@end

NS_ASSUME_NONNULL_END
