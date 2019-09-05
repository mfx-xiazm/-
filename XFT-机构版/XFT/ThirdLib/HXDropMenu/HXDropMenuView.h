//
//  HXDropMenuView.h
//  KYPX
//
//  Created by hxrc on 2018/8/29.
//  Copyright © 2018年 XZM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXDropMenuView;

#pragma mark - 协议
@protocol HXDropMenuDelegate <NSObject>

@required
//出现位置
- (CGPoint)menu_positionInSuperView;
//点击事件
- (void)menu:(HXDropMenuView *)menu  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - 数据源
@protocol HXDropMenuDataSource <NSObject>

@required
//设置title
- (NSString *)menu_titleForRow:(NSInteger)row;
//设置size
- (NSInteger)menu_numberOfRows;

@end

@interface HXDropMenuView : UIView

@property (nonatomic, assign) CGFloat menuCellHeight;
@property (nonatomic, assign) CGFloat menuMaxHeight;
@property (nonatomic, strong) UIColor *titleHightLightColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign ,readonly) BOOL show;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *transformImageView;
@property (nonatomic, weak) id<HXDropMenuDataSource> dataSource;
@property (nonatomic, weak) id<HXDropMenuDelegate> delegate;

- (void)reloadData;
- (void)menuHidden;
- (void)menuShowInSuperView:(UIView *)view;

@end
