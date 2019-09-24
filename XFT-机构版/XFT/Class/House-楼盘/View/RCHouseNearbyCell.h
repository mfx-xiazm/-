//
//  RCHouseNearbyCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCNearbyPOI;
@interface RCHouseNearbyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numRow;
/* 周边 */
@property(nonatomic,strong) RCNearbyPOI *nearby;
@end

NS_ASSUME_NONNULL_END
