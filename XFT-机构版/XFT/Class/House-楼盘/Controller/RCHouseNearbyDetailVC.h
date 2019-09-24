//
//  RCHouseNearbyDetailVC.h
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class RCHouseNearbyDetailVC,RCNearbyPOI;
@protocol RCHouseNearbyDetailVCDelegate <NSObject>

-(void)nearbyVC:(RCHouseNearbyDetailVC *)nearbyVC nearbyType:(NSInteger)type didClickedPOI:(RCNearbyPOI *)poi;//被点击

@end

@interface RCHouseNearbyDetailVC : HXBaseViewController
/* table */
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign)   CGFloat                 offsetY; // shadowView在第一个视图中的位置  就3个位置：Y1 Y2 Y3;     offsetY初始值为0 无所谓 不影响结果
/* 楼盘uuid */
@property(nonatomic,copy) NSString *uuid;
/* 经纬度 */
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property(nonatomic,weak) id<RCHouseNearbyDetailVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
