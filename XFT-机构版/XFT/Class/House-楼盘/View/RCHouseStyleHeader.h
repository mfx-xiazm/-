//
//  RCHouseStyleHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseInfo;
typedef void(^loanDetailCall)(void);
@interface RCHouseStyleHeader : UIView
/* 算价详情 */
@property(nonatomic,copy) loanDetailCall loanDetailCall;
/* 户型详情 */
@property(nonatomic,strong) RCHouseInfo *houseInfo;
@end

NS_ASSUME_NONNULL_END
