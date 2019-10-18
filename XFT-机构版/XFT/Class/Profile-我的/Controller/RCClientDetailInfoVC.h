//
//  RCClientDetailInfoVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RCMyClientDetail;
typedef void(^updateRemarkCall)(NSString *remarkTime,NSString *remark);
@interface RCClientDetailInfoVC : HXBaseViewController
/** 客户基本信息 */
@property(nonatomic,strong) RCMyClientDetail *clientInfo;
/* 备注 */
@property(nonatomic,copy) updateRemarkCall updateRemarkCall;
@end

NS_ASSUME_NONNULL_END
