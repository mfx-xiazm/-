//
//  RCClientFilterView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCClientFilterView,RCMyClientFilter;

#pragma mark - 协议
@protocol RCClientFilterViewDelegate <NSObject>

@optional
//点击事件
- (void)filterDidConfirm:(RCClientFilterView *)filter;

@end


@interface RCClientFilterView : UIView
/* 目标控制器 */
@property (nonatomic,weak) UIViewController *target;

@property (nonatomic, weak) id<RCClientFilterViewDelegate> delegate;

/* 用户状态 0:已报备 2:已到访 4:已认筹 5:已认购 6:已签约 7:已退房 100:已失效 (默认状态为:0) */
@property(nonatomic,assign) NSInteger cusType;

/* 筛选条件 */
@property(nonatomic,strong) RCMyClientFilter *filterModel;
@end

NS_ASSUME_NONNULL_END
