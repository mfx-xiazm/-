//
//  RCHouseNearbyHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseNearbyHeader;
@protocol RCHouseNearbyHeaderDelegate <NSObject>

-(void)nearbyHeader:(RCHouseNearbyHeader *)header didClicked:(NSInteger)index;//被点击

@end
@interface RCHouseNearbyHeader : UIView

@property(nonatomic,weak) id<RCHouseNearbyHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
