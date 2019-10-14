//
//  RCMyStoreCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/3.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCMyStoreCell.h"
#import "RCMyStore.h"

@interface RCMyStoreCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shopPic;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *reportNum;
@property (weak, nonatomic) IBOutlet UILabel *signNum;
@property (weak, nonatomic) IBOutlet UILabel *manager;

@end
@implementation RCMyStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)resetPwdClicked:(UIButton *)sender {
    if (self.resetPwdCall) {
        self.resetPwdCall();
    }
}
-(void)setStore:(RCMyStore *)store
{
    _store = store;
    [self.shopPic sd_setImageWithURL:[NSURL URLWithString:_store.shopPic]];
    self.shopName.text = _store.shopName;
    self.reportNum.text = [NSString stringWithFormat:@"报备数：%zd  到访数：%zd",_store.reportNum,_store.visitNum];
    self.signNum.text = [NSString stringWithFormat:@"认购数：%zd  签约数：%zd",_store.subscriptionNum,_store.signNum];
    self.manager.text = [NSString stringWithFormat:@"管理员：%@(%@)",_store.managerName,_store.managerPhone];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
