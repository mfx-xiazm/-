//
//  RCHouseNearbyVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseNearbyVC : HXBaseViewController
/* 楼盘uuid */
@property(nonatomic,copy) NSString *uuid;
/* 楼盘名字 */
@property(nonatomic,copy) NSString *name;
/* 经纬度 */
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@end

NS_ASSUME_NONNULL_END
