//
//  RCHouseDetailInfoCell.h
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCHouseDetailInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

NS_ASSUME_NONNULL_END
