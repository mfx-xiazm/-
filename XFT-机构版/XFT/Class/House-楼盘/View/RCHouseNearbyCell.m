//
//  RCHouseNearbyCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseNearbyCell.h"
#import "RCNearbyPOI.h"

@interface RCHouseNearbyCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end
@implementation RCHouseNearbyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setNearby:(RCNearbyPOI *)nearby
{
    _nearby = nearby;
    self.name.text = _nearby.title;
    self.distance.text = [NSString stringWithFormat:@"距离%.2f米",_nearby._distance];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
