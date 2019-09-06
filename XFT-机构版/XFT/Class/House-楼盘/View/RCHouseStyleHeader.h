//
//  RCHouseStyleHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^loanDetailCall)(void);
@interface RCHouseStyleHeader : UIView
/* 算价详情 */
@property(nonatomic,copy) loanDetailCall loanDetailCall;
@end

NS_ASSUME_NONNULL_END
