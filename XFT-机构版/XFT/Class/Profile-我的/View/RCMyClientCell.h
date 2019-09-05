//
//  RCMyClientCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/29.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCMyClientCell : UITableViewCell
/* 目标控制器 */
@property (nonatomic,weak) UIViewController *target;
@property (weak, nonatomic) IBOutlet UIView *brokerView;
@property (weak, nonatomic) IBOutlet UIView *mangeView;
@property (weak, nonatomic) IBOutlet UIView *remarkView;

@end

NS_ASSUME_NONNULL_END
