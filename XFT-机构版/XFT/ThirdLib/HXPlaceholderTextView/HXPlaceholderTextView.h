//
//  HXPlaceholderTextView.h
//  HXXL
//
//  Created by hxrc on 17/1/16.
//  Copyright © 2017年 xgt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXPlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
