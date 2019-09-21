//
//  RCNewsCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseNews;
@interface RCNewsCell : UITableViewCell
/* 新闻资讯 */
@property(nonatomic,copy) RCHouseNews *news;
@end

NS_ASSUME_NONNULL_END
