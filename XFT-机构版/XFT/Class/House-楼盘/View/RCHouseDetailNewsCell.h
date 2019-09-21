//
//  RCHouseDetailNewsCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseNews;
@interface RCHouseDetailNewsCell : UITableViewCell
/* 楼盘资讯 */
@property(nonatomic,strong) RCHouseNews *news;
@end

NS_ASSUME_NONNULL_END
