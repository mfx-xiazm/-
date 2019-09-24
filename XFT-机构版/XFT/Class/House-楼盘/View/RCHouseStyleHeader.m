//
//  RCHouseStyleHeader.m
//  XFT
//
//  Created by 夏增明 on 2019/8/30.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCHouseStyleHeader.h"
#import "RCHouseInfo.h"

@interface RCHouseStyleHeader ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *hxName;
@property (weak, nonatomic) IBOutlet UILabel *buildArea;
@property (weak, nonatomic) IBOutlet UILabel *roomArea;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *houseFace;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation RCHouseStyleHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (IBAction)loanDetailClicked:(UIButton *)sender {
    if (self.loanDetailCall) {
        self.loanDetailCall();
    }
}
-(void)setHouseInfo:(RCHouseInfo *)houseInfo
{
    _houseInfo = houseInfo;
    self.name.text = [NSString stringWithFormat:@"%@户型详情",_houseInfo.name];
    self.hxName.text = _houseInfo.areaType;
    self.buildArea.text = [NSString stringWithFormat:@"%@㎡",_houseInfo.buldArea];
    self.roomArea.text = [NSString stringWithFormat:@"%@㎡",_houseInfo.roomArea];
    self.houseFace.text = _houseInfo.houseFace;
    self.totalPrice.text = [NSString stringWithFormat:@"%@万",_houseInfo.totalPrice];
    self.price.text = [NSString stringWithFormat:@"%@元/㎡",_houseInfo.price];


}
@end
