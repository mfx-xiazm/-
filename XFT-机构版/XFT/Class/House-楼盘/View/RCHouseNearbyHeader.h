//
//  RCHouseNearbyHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^nearbyTypeCall)(NSInteger index);
@interface RCHouseNearbyHeader : UIView
/* 类型按键 */
@property(nonatomic,assign) nearbyTypeCall nearbyTypeCall;
@end

NS_ASSUME_NONNULL_END
