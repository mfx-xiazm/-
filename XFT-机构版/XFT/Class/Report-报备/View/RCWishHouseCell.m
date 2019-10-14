//
//  RCWishHouseCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCWishHouseCell.h"
#import "RCReportHouse.h"

@interface RCWishHouseCell ()
@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *selctBtn;

@end
@implementation RCWishHouseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setHouse:(RCReportHouse *)house
{
    _house = house;
    self.houseName.text = _house.proName;
    self.areaLabel.text = [NSString stringWithFormat:@"%@ %@",_house.geoCityName,_house.geoAreaName];
    self.price.text = [NSString stringWithFormat:@"均价%@元/m²",_house.price];
    if (_house.isSelected) {
        self.selctBtn.selected = YES;
        self.selctBtn.backgroundColor = HXRGBAColor(255, 159, 8, 0.2);
    }else{
        self.selctBtn.selected = NO;
        self.selctBtn.backgroundColor = UIColorFromRGB(0xF6F7FB);
    }
}
- (IBAction)selectBtnClicked:(UIButton *)sender {
    if (self.selectHouseCall) {
        self.selectHouseCall();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
