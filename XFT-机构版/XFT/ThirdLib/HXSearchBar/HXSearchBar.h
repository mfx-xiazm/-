//
//  HXSearchBar.h
//  xiaoguotu
//
//  Created by hxrc on 16/11/25.
//  Copyright © 2016年 xgt. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  用UItextfield来自定义一个搜索框，使用时要设置frame
 */
@interface HXSearchBar : UITextField

+(instancetype)searchBar;

@property(nonatomic,copy)NSString *searchIcon;

@end
