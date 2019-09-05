//
//  HXSearchBar.m
//  xiaoguotu
//
//  Created by hxrc on 16/11/25.
//  Copyright © 2016年 xgt. All rights reserved.
//

#import "HXSearchBar.h"

@implementation HXSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:14];
        self.placeholder = @"搜索感兴趣的内容";
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.returnKeyType = UIReturnKeySearch;
        self.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"搜索"];
        searchIcon.hxn_width = 26;
        searchIcon.hxn_height = 26;
        searchIcon.contentMode = UIViewContentModeCenter;
        
        //设置textfeld的左边的view等于imageview
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        [self setValue:UIColorFromRGB(0xBFBFBF) forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];

    }
    return self;
}

-(void)setSearchIcon:(NSString *)searchIcon
{
    _searchIcon = searchIcon;
    
    UIImageView *searchIcon1 = [[UIImageView alloc] init];
    searchIcon1.image = [UIImage imageNamed:_searchIcon];
    searchIcon1.hxn_width = 26;
    searchIcon1.hxn_height = 26;
    searchIcon1.contentMode = UIViewContentModeCenter;
    
    //设置textfeld的左边的view等于imageview
    self.leftView = searchIcon1;
    self.leftViewMode = UITextFieldViewModeAlways;
    
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10; //像右边偏10
    return iconRect;
}

+(instancetype)searchBar
{
    return [[self alloc] init];
}


@end
