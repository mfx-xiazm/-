//
//  RCWishHouseFilterView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^pushHouseFilterCall)(NSInteger, NSInteger);

@interface RCWishHouseFilterView : UIView
/** 点击回调 */
@property (nonatomic,copy) pushHouseFilterCall pushHouseFilterCall;
@end

NS_ASSUME_NONNULL_END
