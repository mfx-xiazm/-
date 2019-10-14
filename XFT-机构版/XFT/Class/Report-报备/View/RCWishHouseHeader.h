//
//  RCWishHouseHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^delectHouseCall)(void);
@interface RCWishHouseHeader : UIView
/* 罗盘列表 */
@property(nonatomic,strong) NSMutableArray *houses;
/* 楼盘删除回调 */
@property(nonatomic,copy) delectHouseCall delectHouseCall;
@end

NS_ASSUME_NONNULL_END
