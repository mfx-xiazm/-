//
//  RCPanoramaVC.m
//  XFT
//
//  Created by 夏增明 on 2019/9/6.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "RCPanoramaVC.h"
#import "BSPanoramaView.h"

@interface RCPanoramaVC ()
@property(nonatomic,strong) BSPanoramaView *panoView;
@end

@implementation RCPanoramaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"全景看房"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    button.hxn_size = CGSizeMake(44, 44);
    // 让按钮内部的所有内容左对齐
    //        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [button addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.view addSubview:self.panoView];
    
    __weak typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568357199&di=5f8fc3cda21f13a468d3c8322292b6ca&imgtype=jpg&er=1&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171031%2Fc0b5b4a9aa494ffe83c3d740061383b1.jpeg"] options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.panoView setImageWithName:image];
        });
    }];
}
-(void)backClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.panoView.frame = self.view.bounds;
}
-(BSPanoramaView *)panoView
{
    if (_panoView == nil) {
        _panoView = [[BSPanoramaView alloc] initWithFrame:self.view.bounds];
    }
    return _panoView;
}

@end
