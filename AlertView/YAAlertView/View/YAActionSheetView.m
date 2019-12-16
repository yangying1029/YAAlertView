//
//  YAActionSheetView.m
//  YAAlertView
//
//  Created by 辰远 on 2017/11/17.
//  Copyright © 2017年 chenyuan. All rights reserved.
//

#import "YAActionSheetView.h"

@interface YAActionSheetView ()
// 背景view
@property (nonatomic, strong) UIView *alertBgView;
// 按钮背景view
@property (nonatomic, strong) UIScrollView *buttonBgView;
@end

@implementation YAActionSheetView

/**
 创建ActionSheetView
 
 @param title 标题
 @param message 信息
 @param cancelTitle 取消按钮标题
 @param btnTitlesArray 按钮数组
 @param clickBtnBlock 点击回调
 @param dismissViewBlock 消失回调
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
               btnTitlesArray:(NSArray<NSString *> *)btnTitlesArray
                clickBtnBlock:(void (^) (NSInteger tag))clickBtnBlock
             dismissViewBlock:(void (^) (UIView *view))dismissViewBlock {
    self = [super initWithTitle:title message:message cancelTitle:cancelTitle btnTitlesArray:btnTitlesArray clickBtnBlock:clickBtnBlock dismissViewBlock:dismissViewBlock];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithAttributedTitle:(NSMutableAttributedString *)attributedTitle
                      attributedMessage:(NSMutableAttributedString *)attributedMessage
                            cancelTitle:(NSString *)cancelTitle
                         btnTitlesArray:(NSArray<NSString *> *)btnTitlesArray
                          clickBtnBlock:(void (^)(NSInteger))clickBtnBlock
                       dismissViewBlock:(void (^)(UIView *))dismissViewBlock {
    self = [super initWithAttributedTitle:attributedTitle
                        attributedMessage:attributedMessage
                              cancelTitle:cancelTitle
                           btnTitlesArray:btnTitlesArray
                            clickBtnBlock:clickBtnBlock
                         dismissViewBlock:dismissViewBlock];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    [self setupBgView];
    [self setupTitle];
    [self setupButtons];
}

- (void)setupBgView {
    _alertBgView = [[UIView alloc] init];
    _alertBgView.width = self.width * 0.9;
    _alertBgView.x = ([UIScreen mainScreen].bounds.size.width - _alertBgView.width) / 2.0f;
    _alertBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_alertBgView];
    
    _buttonBgView = [[UIScrollView alloc] init];
    _buttonBgView.x = 0;
    _buttonBgView.y = 0;
    _buttonBgView.width = _alertBgView.width;
    
    _buttonBgView.layer.cornerRadius = 20.0f;
    _buttonBgView.layer.masksToBounds = YES;
    _buttonBgView.showsHorizontalScrollIndicator = NO;
    _buttonBgView.scrollEnabled = NO;
    _buttonBgView.backgroundColor = [UIColor whiteColor];
    [_alertBgView addSubview:_buttonBgView];
}

- (void)setupTitle {
    if (self.title != nil || self.attributedTitle != nil) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.width = _buttonBgView.width - 2 * MARGIN;
        self.titleLabel.x = (_buttonBgView.width - self.titleLabel.width)/2.0f;
        self.titleLabel.y = MARGIN;
        if (self.attributedTitle.length != 0 && ![self.attributedTitle isKindOfClass:[NSNull class]] && self.attributedTitle != nil) {
            self.titleLabel.attributedText = self.attributedTitle;
        }else {
            self.titleLabel.text = self.title;
        }
        self.titleLabel.height = [self getTextHeight:self.titleLabel];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 0;
        [self.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightBold]];
        [_buttonBgView addSubview:self.titleLabel];
    }
    
    if (self.message != nil || self.attributedMessage != nil) {
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.width = _buttonBgView.width - 2 * MARGIN;
        self.messageLabel.x = (_buttonBgView.width - self.messageLabel.width)/2.0f;
        if (self.titleLabel) {
            self.messageLabel.y = CGRectGetMaxY(self.titleLabel.frame) + MARGIN;
        }else {
            self.messageLabel.y = MARGIN;
        }
        
        if (self.attributedMessage.length != 0 && ![self.attributedMessage isKindOfClass:[NSNull class]] && self.attributedMessage != nil) {
            self.messageLabel.attributedText = self.attributedMessage;
        }else {
            self.messageLabel.text = self.message;
        }
        self.messageLabel.height = [self getTextHeight:self.messageLabel];
        self.messageLabel.textColor = [UIColor blackColor];
        [self.messageLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.numberOfLines = 0;
        [_buttonBgView addSubview:self.messageLabel];
    }
    
}

- (void)setupButtons {
    if (self.btnTitlesArray.count > 0) {
        _buttonBgView.scrollEnabled = NO;
        [self initItems];
    }
    
    self.cancelBtn = [[UIButton alloc] init];
    self.cancelBtn.x = 0;
    self.cancelBtn.width = _alertBgView.width;
    self.cancelBtn.height = BUTTON_HEIGHT;
    
    [self.cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [self.cancelBtn setTitleColor:[UIColor colorWithRed:60/255.0 green:145/255.0 blue:251/255.0 alpha:1.0]  forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightUltraLight]];
    [self.cancelBtn setTag:0];
    CAShapeLayer *roundLayer = [CAShapeLayer layer];
    roundLayer.frame = CGRectMake(0, 0, self.cancelBtn.width, self.cancelBtn.height);
    roundLayer.path = [UIBezierPath bezierPathWithRoundedRect:roundLayer.bounds cornerRadius:15].CGPath;
    [self.cancelBtn.layer addSublayer:roundLayer];
    self.cancelBtn.layer.mask = roundLayer;
    [self.cancelBtn addTarget:self action:@selector(onTapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_alertBgView addSubview:self.cancelBtn];
    
    if ((self.title == nil && self.attributedTitle == nil) && (self.message == nil && self.attributedMessage == nil)) {
        _buttonBgView.height = self.btnTitlesArray.count * (BUTTON_HEIGHT + LINE_HEIGHT);
    }else if ((self.title != nil || self.attributedTitle != nil) && (self.message != nil || self.attributedMessage != nil)) {
        _buttonBgView.height = CGRectGetMaxY(self.messageLabel.frame) + MARGIN + self.btnTitlesArray.count * (BUTTON_HEIGHT + LINE_HEIGHT);
    }else {
        if ((self.title != nil || self.attributedTitle != nil) && (self.message == nil && self.attributedMessage == nil)) {
            _buttonBgView.height = CGRectGetMaxY(self.titleLabel.frame) + MARGIN + self.btnTitlesArray.count * (BUTTON_HEIGHT + LINE_HEIGHT);
        }else if ((self.title == nil && self.attributedTitle == nil) && (self.message != nil || self.attributedMessage != nil)) {
            _buttonBgView.height = CGRectGetMaxY(self.messageLabel.frame) + MARGIN + self.btnTitlesArray.count * (BUTTON_HEIGHT + LINE_HEIGHT);
        }
    }
    
    if (@available(iOS 11.0, *)) {
        if (_buttonBgView.height >= [UIScreen mainScreen].bounds.size.height - 2 * MARGIN - [UIApplication sharedApplication].keyWindow.safeAreaInsets.top - self.cancelBtn.height - BUTTON_HEIGHT - [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom) {
            _buttonBgView.scrollEnabled = YES;
            _buttonBgView.contentSize = CGSizeMake(_buttonBgView.width, self.btnTitlesArray.count  * (BUTTON_HEIGHT + LINE_HEIGHT) + self.titleLabel.height + self.messageLabel.height + 3 *MARGIN);
            _buttonBgView.height = [UIScreen mainScreen].bounds.size.height - 2 * MARGIN - [UIApplication sharedApplication].keyWindow.safeAreaInsets.top - self.cancelBtn.height - BUTTON_HEIGHT - [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        }
    } else {
        if (_buttonBgView.height >= [UIScreen mainScreen].bounds.size.height - 2 * MARGIN - [UIApplication sharedApplication].statusBarFrame.size.height - self.cancelBtn.height - BUTTON_HEIGHT) {
            _buttonBgView.scrollEnabled = YES;
            _buttonBgView.contentSize = CGSizeMake(_buttonBgView.width, self.btnTitlesArray.count  * (BUTTON_HEIGHT + LINE_HEIGHT) + self.titleLabel.height + self.messageLabel.height + 3 *MARGIN);
            _buttonBgView.height = [UIScreen mainScreen].bounds.size.height - 2 * MARGIN - [UIApplication sharedApplication].statusBarFrame.size.height - self.cancelBtn.height - BUTTON_HEIGHT;
        }
    }
    
    self.cancelBtn.y = CGRectGetMaxY(_buttonBgView.frame) + 2 * MARGIN;
    _alertBgView.height = CGRectGetMaxY(self.cancelBtn.frame);
    if (@available(iOS 11.0, *)) {
        _alertBgView.y = [UIScreen mainScreen].bounds.size.height - _alertBgView.height - MARGIN - [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    } else {
        _alertBgView.y = [UIScreen mainScreen].bounds.size.height - _alertBgView.height - MARGIN;
    }
}

- (void)initItems {
    CGFloat height = BUTTON_HEIGHT;
    NSArray *deascendArray = [self deascendArray];
    
    for (int i = 0; i < self.btnTitlesArray.count ; i ++ ) {
        CGFloat margin = 0.0;
        CGFloat originY = 0;
        if (i == 0) {
            if ((self.title == nil && self.attributedTitle == nil) && (self.message == nil && self.attributedMessage == nil)) {
                margin = 0;
                originY = 0;
            }else {
                margin = MARGIN;
                if ((self.title != nil || self.attributedTitle != nil) && (self.message == nil && self.attributedMessage == nil)) {
                    originY = CGRectGetMaxY(self.titleLabel.frame);
                }else if ((self.title == nil  && self.attributedTitle == nil) && (self.message != nil || self.attributedMessage != nil)) {
                    originY = CGRectGetMaxY(self.messageLabel.frame);
                }else {
                    originY = CGRectGetMaxY(self.messageLabel.frame);
                }
            }
        }else {
            margin = MARGIN;
            if ((self.title != nil || self.attributedTitle != nil) && (self.message == nil && self.attributedMessage == nil)) {
                originY = CGRectGetMaxY(self.titleLabel.frame);
            }else if ((self.title == nil  && self.attributedTitle == nil) && (self.message != nil || self.attributedMessage != nil)) {
                originY = CGRectGetMaxY(self.messageLabel.frame);
            }else  if ((self.title != nil || self.attributedTitle != nil) && (self.message != nil || self.attributedMessage != nil)) {
                originY = CGRectGetMaxY(self.messageLabel.frame);
            }else {
                margin = 0;
            }
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, (i * height) + originY + margin, _buttonBgView.width, BUTTON_HEIGHT)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:deascendArray[i] forState:UIControlStateNormal];
        [button setTag:[self.btnTitlesArray indexOfObject:button.currentTitle] + 1];
        [button setTitleColor:[UIColor colorWithRed:60/255.0 green:145/255.0 blue:251/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightUltraLight]];
        [button addTarget:self action:@selector(onTapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.title || self.attributedTitle || self.message || self.attributedMessage) {
            UIView *divideView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(button.frame), _alertBgView.width, LINE_HEIGHT)];
            divideView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
            [_buttonBgView addSubview:divideView];
        }else {
            if (i != 0) {
                UIView *divideView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(button.frame), _alertBgView.width, LINE_HEIGHT)];
                divideView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
                [_buttonBgView addSubview:divideView];
            }
        }
        [_buttonBgView addSubview:button];
        [self.btnsArray addObject:button];
    }
}

#pragma mark - Action
- (void)onTapBtnAction:(UIButton *)button {
    if (self.dismissViewBlock) self.dismissViewBlock (self);
    if (self.clickBtnBlock) self.clickBtnBlock (button.tag);
}

- (void)onClickBlankAcion:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    if (point.x < _alertBgView.left || point.x > _alertBgView.right || point.y < _alertBgView.top || point.y > _alertBgView.bottom) {
        if (self.dismissViewBlock) self.dismissViewBlock (self);
    }
}

#pragma mark - Private method
/**
 数组倒叙
 
 @return 返回排序好的数组
 */
- (NSArray *)deascendArray {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = (int)self.btnTitlesArray.count; i > 0; i --) {
        [array addObject:self.btnTitlesArray[i - 1]];
    }
    return array;
}

/**
 计算文本高度
 */
- (CGFloat)getTextHeight:(UILabel*)label {
    return ceilf([label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)].height);
}

#pragma mark - Public Method
/**
 显示alertView
 
 @param animated 是否动画显示
 @param completion 完成回调
 */
- (void)showAlertViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [super showAlertViewAnimated:animated completion:completion];
    if (animated) {
        [[UIApplication sharedApplication].windows.firstObject addSubview:self];
        self.alpha = 0;
        self.alertBgView.alpha = 1;
        self.alertBgView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.alertBgView.frame));
        [UIView animateWithDuration:0.4 delay:0  usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.alpha = 1;
            self.alertBgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }else {
        [[UIApplication sharedApplication].windows.firstObject addSubview:self];
        if (completion) completion();
    }
}

/**
 移除alertView
 
 @param animated 是否动画移除
 @param completion 完成回调
 */
- (void)dismissAlertViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [super dismissAlertViewAnimated:animated completion:completion];
    if (animated) {
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.alpha = 0;
            self.alertBgView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.alertBgView.frame));
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (completion) completion();
        }];
    }else {
        [self removeFromSuperview];
        if (completion) completion();
    }
}

/**
 设置按钮的标题颜色
 
 @param titleColor 标题颜色
 @param state 状态
 @param index 数组下标
 */
- (void)setButtonTitleColor:(UIColor *)titleColor forState:(UIControlState)state atIndex:(NSInteger)index {
    [super setButtonTitleColor:titleColor forState:state atIndex:index];
    if (index < 0 || index > self.btnsArray.count) return;
    else {
        UIButton *btn = [self.btnsArray objectAtIndex:index];
        [btn setTitleColor:titleColor forState:state];
    }
}

/**
 设置按钮的背景颜色
 
 @param bgColor 背景颜色
 @param index 数组下标
 */
- (void)setButtonBgColor:(UIColor *)bgColor atIndex:(NSInteger)index {
    [super setButtonBgColor:bgColor atIndex:index];
    UIButton *btn = [self.btnsArray objectAtIndex:index];
    [btn setBackgroundColor:bgColor];
}

- (void)setNeedClickBlankDismiss:(BOOL)needClickBlankDismiss {
    [super setNeedClickBlankDismiss:needClickBlankDismiss];
    if (needClickBlankDismiss) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBlankAcion:)]];
    }
}

@end

