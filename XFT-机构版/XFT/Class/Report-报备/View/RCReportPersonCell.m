//
//  RCReportPersonCell.m
//  XFT
//
//  Created by 夏增明 on 2019/9/5.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCReportPersonCell.h"
#import "RCReporter.h"

@interface RCReportPersonCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

@end
@implementation RCReportPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setReporter:(RCReporter *)reporter
{
    _reporter = reporter;
    self.name.text = _reporter.shopname;
    self.setBtn.selected = _reporter.isSelected;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
