//
//  RCReportPersonVC.h
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RCReporter;
typedef void(^selectReporterCall)(RCReporter *reporter);
@interface RCReportPersonVC : HXBaseViewController
/* 选中经纪人回调 */
@property(nonatomic,copy) selectReporterCall selectReporterCall;
/* 选中的那个报备人 */
@property(nonatomic,strong) RCReporter *selectReporter;
@end

NS_ASSUME_NONNULL_END
