//
//  zhAlertView.m
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "zhAlertView.h"
#import  <objc/runtime.h>

#define zhAlertViewLineColor UIColorFromRGB(0xbfbfbf)

@interface zhAlertButton ()

@property (nonatomic, strong) CALayer *horizontalLine;
@property (nonatomic, strong) CALayer *verticalLine;
@property (nonatomic, copy) void (^buttonClickedBlock)(zhAlertButton *alertButton);

@end

@implementation zhAlertButton

+ (instancetype)buttonWithTitle:(NSString *)title handler:(void (^)(zhAlertButton * _Nonnull))handler {
    return [[self alloc] initWithTitle:title handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(zhAlertButton * _Nonnull))handler {
    if (self = [super init]) {
        self.buttonClickedBlock = handler;
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [self setTitle:title forState:UIControlStateNormal];
        [self addTarget:self action:@selector(handlerClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _horizontalLine = [CALayer layer];
        _horizontalLine.backgroundColor = zhAlertViewLineColor.CGColor;
        [self.layer addSublayer:_horizontalLine];
        
        _verticalLine = [CALayer layer];
        _verticalLine.backgroundColor = zhAlertViewLineColor.CGColor;
        _verticalLine.hidden = YES;
        [self.layer addSublayer:_verticalLine];
    }
    return self;
}

- (void)handlerClicked {
    if (self && self.buttonClickedBlock) self.buttonClickedBlock(self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat lineWidth = self.lineWidth > 0 ? self.lineWidth : 1 / [UIScreen mainScreen].scale;
    _horizontalLine.frame = CGRectMake(0, 0, self.hxn_width, lineWidth);
    _verticalLine.frame = CGRectMake(0, 0, lineWidth, self.hxn_height);
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    _verticalLine.backgroundColor = lineColor.CGColor;
    _horizontalLine.backgroundColor = lineColor.CGColor;
}

@end

@interface zhAlertView () {
//    CGSize  _contentSize;
//    CGFloat _paddingTop, _paddingBottom, _paddingLeft; // paddingRight = paddingLeft
//    CGFloat _spacing;
}
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGFloat paddingTop, paddingBottom, paddingLeft;
@property (nonatomic, assign) CGFloat spacing;

@property (nonatomic, strong) NSMutableSet *subActions;
@property (nonatomic, strong) NSMutableSet *adjoinActions;

@end

static void *SnailAlertViewActionKey = &SnailAlertViewActionKey;

@implementation zhAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message constantWidth:(CGFloat)constantWidth {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = NO;
        self.subOverflyButtonHeight = 49;
        
        _contentSize.width = 200; // default width = 200
        if (constantWidth > 0) _contentSize.width = constantWidth;
        (void)(_paddingTop = 15), (void)(_paddingBottom = 15), (void)(_paddingLeft = 20), (_spacing = 15);

        if (title.length) {
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.text = title;
            _titleLabel.numberOfLines = 0;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [self addSubview:_titleLabel];

            _titleLabel.hxn_size = [_titleLabel sizeThatFits:CGSizeMake(_contentSize.width-2*_paddingLeft, MAXFLOAT)];
            _titleLabel.hxn_y = _paddingTop;
            _titleLabel.hxn_centerX = _contentSize.width / 2;
            _contentSize.height = _titleLabel.hxn_bottom;
        }

        if (message.length) {
            _messageLabel = [[UILabel alloc] init];
            _messageLabel.numberOfLines = 0;
            _messageLabel.font = [UIFont systemFontOfSize:14];
            _messageLabel.textColor = UIColorFromRGB(0x333333);
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_messageLabel];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, message.length)];
            _messageLabel.attributedText = string;

            _messageLabel.hxn_size = [_messageLabel sizeThatFits:CGSizeMake(_contentSize.width - 2*_paddingLeft, MAXFLOAT)];
            _messageLabel.hxn_y = _titleLabel.hxn_bottom + _spacing;
            _messageLabel.hxn_centerX = _contentSize.width / 2;
            _contentSize.height = _messageLabel.hxn_bottom + 20;
        }
     
        self.hxn_size = CGSizeMake(_contentSize.width, _contentSize.height + _paddingBottom);
        if (!title.length && !message.length) {
            self.hxn_size = CGSizeZero;
        }
    }
    return self;
}

static void *zhAlertViewActionKey = &zhAlertViewActionKey;

- (void)addAction:(zhAlertButton *)action {
    [self clearActions:self.adjoinActions.allObjects];
    [self.adjoinActions removeAllObjects];
    
    void (^layout)(CGFloat) = ^(CGFloat top){
        CGFloat width = self.contentSize.width - action.edgeInsets.left - action.edgeInsets.right;
        action.hxn_size = CGSizeMake(width, self.subOverflyButtonHeight);
        action.hxn_y = top;
        action.hxn_centerX = self.contentSize.width / 2;
    };
    
    zhAlertButton *lastAction = objc_getAssociatedObject(self, zhAlertViewActionKey);
    if (lastAction) { // current
        if (![action isEqual:lastAction]) layout(lastAction.hxn_bottom + action.edgeInsets.top);
    } else { // first
        layout(_contentSize.height + action.edgeInsets.top + 10); // 增加10间距
    }
    
    action.verticalLine.hidden = YES;
    [self insertSubview:action atIndex:0];
    self.hxn_size = CGSizeMake(_contentSize.width, action.hxn_bottom + action.edgeInsets.bottom);
    objc_setAssociatedObject(self, zhAlertViewActionKey, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)adjoinWithLeftAction:(zhAlertButton *)leftAction rightAction:(zhAlertButton *)rightAction {
    [self clearActions:self.subviews];
    objc_setAssociatedObject(self, zhAlertViewActionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    leftAction.hxn_size = CGSizeMake(_contentSize.width / 2, self.subOverflyButtonHeight);
    leftAction.hxn_y = _contentSize.height + leftAction.edgeInsets.top;
    
    rightAction.frame = leftAction.frame;
    rightAction.hxn_x = leftAction.hxn_right;
    rightAction.verticalLine.hidden = NO;
    [self addSubview:leftAction];
    [self addSubview:rightAction];
    self.adjoinActions = [NSMutableSet setWithObjects:leftAction, rightAction, nil];
    self.hxn_size = CGSizeMake(_contentSize.width, leftAction.hxn_bottom);
}

- (void)clearActions:(NSArray *)subviews {
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[zhAlertButton class]]) {
            [subview removeFromSuperview];
        }
    }
}

@end
