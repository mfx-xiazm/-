//
//  RCClientDetailVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^remarkSuccessCall)(NSString *remarkTime,NSString *remark);
@interface RCClientDetailVC : HXBaseViewController
/* 客户uuid 代表客户报备id */
@property(nonatomic,copy) NSString *cusUuid;
/* 备注成功 */
@property(nonatomic,copy) remarkSuccessCall remarkSuccessCall;
@end

NS_ASSUME_NONNULL_END
