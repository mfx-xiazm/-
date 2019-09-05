//
//  RCAddPhoneCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^cutBtnCall)(void);
@interface RCAddPhoneCell : UITableViewCell
/* 删除 */
@property(nonatomic,copy) cutBtnCall cutBtnCall;
@end

NS_ASSUME_NONNULL_END
