//
//  RCNewsCell.m
//  XFT
//
//  Created by 夏增明 on 2019/8/28.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCNewsCell.h"
#import "RCHouseNews.h"

@interface RCNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *newsImg;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lookNum;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation RCNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setNews:(RCHouseNews *)news
{
    _news = news;
    [self.newsImg sd_setImageWithURL:[NSURL URLWithString:_news.headPic]];
    self.newsTitle.text = _news.title;
    self.lookNum.text = [NSString stringWithFormat:@"已查看%zd人",_news.clickNum];
    self.time.text = _news.publishTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
