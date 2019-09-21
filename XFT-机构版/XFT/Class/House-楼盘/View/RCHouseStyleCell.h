//
//  RCHouseStyleCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseStyle;
@interface RCHouseStyleCell : UICollectionViewCell
/* 户型 */
@property(nonatomic,assign) RCHouseStyle *style;
@end

NS_ASSUME_NONNULL_END
