//
//  RCMyStoreCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^resetPwdCall)(void);
@interface RCMyStoreCell : UITableViewCell
/* 重置密码 */
@property(nonatomic,copy) resetPwdCall resetPwdCall;
@end

NS_ASSUME_NONNULL_END
