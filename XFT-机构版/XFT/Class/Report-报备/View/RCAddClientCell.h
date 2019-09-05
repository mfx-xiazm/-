//
//  RCAddClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^cutBtnCall)(void);
@interface RCAddClientCell : UITableViewCell
/* 删除 */
@property(nonatomic,copy) cutBtnCall cutBtnCall;

@end

NS_ASSUME_NONNULL_END
