//
//  RCReportResultSectionHeader.h
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCReportResultSectionHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *resultTitle;
@property (weak, nonatomic) IBOutlet UILabel *resultNum;

@end

NS_ASSUME_NONNULL_END
