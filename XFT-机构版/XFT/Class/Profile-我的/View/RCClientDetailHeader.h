//
//  RCClientDetailHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCMyClientDetail;
typedef void(^clientDetailCall)(NSInteger index);
@interface RCClientDetailHeader : UIView
/** 客户基本信息 */
@property(nonatomic,strong) RCMyClientDetail *clientInfo;
/* 点击 */
@property(nonatomic,copy) clientDetailCall clientDetailCall;
@end

NS_ASSUME_NONNULL_END
