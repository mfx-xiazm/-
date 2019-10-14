//
//  RCClientNoteCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/31.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCClientNoteCell.h"
#import "RCMyClientNote.h"

@interface RCClientNoteCell ()
@property (weak, nonatomic) IBOutlet UILabel *cusState;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *handleUser;

@end
@implementation RCClientNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setNote:(RCMyClientNote *)note
{
    _note = note;

    //转介类型(0报备 1到访 2跟进 3认筹 4认购 5签约 6退房 7失效 8分配 9转移)
    if (_note.type == 0) {
        self.cusState.text = @"报备";
    }else if (_note.type == 1){
        self.cusState.text = @"到访";
    }else if (_note.type == 2){
        self.cusState.text = @"跟进";
    }else if (_note.type == 3){
        self.cusState.text = @"认筹";
    }else if (_note.type == 4){
        self.cusState.text = @"认购";
    }else if (_note.type == 5){
        self.cusState.text = @"签约";
    }else if (_note.type == 6){
        self.cusState.text = @"退房";
    }else if (_note.type == 7){
        self.cusState.text = @"失效";
    }else if (_note.type == 8){
        self.cusState.text = @"分配";
    }else{
        self.cusState.text = @"转移";
    }
    self.time.text = _note.time;
    self.remark.text = _note.context;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
