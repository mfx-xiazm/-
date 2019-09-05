//
//  RCWebContentVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/26.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCWebContentVC : HXBaseViewController
/** url */
@property (nonatomic,copy) NSString *url;
/* 标题 */
@property(nonatomic,copy) NSString *navTitle;
@end

NS_ASSUME_NONNULL_END
