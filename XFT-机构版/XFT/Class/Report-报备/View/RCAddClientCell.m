//
//  RCAddClientCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCAddClientCell.h"
#import "RCReportTarget.h"

@interface RCAddClientCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@end
@implementation RCAddClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.name.delegate = self;
    self.phone.delegate = self;
}
- (IBAction)cutBtnClicked:(UIButton *)sender {
    if (self.cutBtnCall) {
        self.cutBtnCall();
    }
}
-(void)setPerson:(RCReportTarget *)person
{
    _person = person;
    self.name.text = _person.cusName;
    self.phone.text = _person.cusPhone;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.name) {
        _person.cusName = [textField hasText]?textField.text:@"";
    }else{
        _person.cusPhone = [textField hasText]?textField.text:@"";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
