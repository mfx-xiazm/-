//
//  RCSearchCityVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/27.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^changeCityCall)(void);
@interface RCSearchCityVC : HXBaseViewController
/* 改变城市 */
@property(nonatomic,copy) changeCityCall changeCityCall;
@end

NS_ASSUME_NONNULL_END
