//
//  RCReportResultCell.h
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCReportTarget;
@interface RCReportResultCell : UITableViewCell
/* 最后一个cell */
@property(nonatomic,assign) BOOL isLast;
/* 报备结果 */
@property(nonatomic,assign) RCReportTarget *person;
@property (weak, nonatomic) IBOutlet UILabel *nnum;

@end

NS_ASSUME_NONNULL_END
