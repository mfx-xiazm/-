//
//  RCWishHouseCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCReportHouse;
typedef void(^selectHouseCall)(void);
@interface RCWishHouseCell : UITableViewCell
/* 意向楼盘 */
@property(nonatomic,strong) RCReportHouse *house;
/* 选择 */
@property(nonatomic,copy) selectHouseCall selectHouseCall;
@end

NS_ASSUME_NONNULL_END
