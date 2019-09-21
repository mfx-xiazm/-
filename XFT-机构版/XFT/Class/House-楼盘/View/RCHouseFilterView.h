//
//  RCHouseFilterView.h
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCHouseFilterData;
typedef void(^HouseFilterCall)(NSInteger, NSInteger);

@interface RCHouseFilterView : UIView
@property (nonatomic,weak) UIViewController *target;
@property(nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *wuyeLabel;
@property (weak, nonatomic) IBOutlet UILabel *huxingLabel;
@property (weak, nonatomic) IBOutlet UILabel *mianjiLabel;
/* 筛选数据 */
@property(nonatomic,strong) RCHouseFilterData *filterData;
/** 筛选点击回调 */
@property (nonatomic,copy) HouseFilterCall HouseFilterCall;
@end

NS_ASSUME_NONNULL_END
