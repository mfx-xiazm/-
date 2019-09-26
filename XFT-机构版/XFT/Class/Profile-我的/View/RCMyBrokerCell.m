//
//  RCMyBrokerCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyBrokerCell.h"
#import "RCMyBroker.h"

@interface RCMyBrokerCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *reportNum;
@property (weak, nonatomic) IBOutlet UILabel *signNum;
@property (weak, nonatomic) IBOutlet UIButton *forbiddenBtn;

@end
@implementation RCMyBrokerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)resetClicked:(UIButton *)sender {
    if (self.resetOrDeleteCall) {
        self.resetOrDeleteCall(sender.tag);
    }
}
-(void)setBroker:(RCMyBroker *)broker
{
    _broker = broker;
    self.name.text = _broker.name;
    self.reportNum.text = [NSString stringWithFormat:@"报备数：%zd    到访数：%zd",_broker.reportingNum,_broker.visitNum];
    self.signNum.text = [NSString stringWithFormat:@"认购数：%zd    签约数：%zd",_broker.subscriptionNum,_broker.signingNum];
    if ([_broker.state isEqualToString:@"1"]) {
        self.forbiddenBtn.tintColor = UIColorFromRGB(0x999999);
    }else{
        self.forbiddenBtn.tintColor = UIColorFromRGB(0xEC142D);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
