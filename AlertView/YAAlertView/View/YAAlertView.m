//
//  YAAlertView.m
//  YAAlertView
//
//  Created by 辰远 on 2018/1/2.
//  Copyright © 2018年 chenyuan. All rights reserved.
//

#import "YAAlertView.h"
#import "UIView+FrameExtend.h"
#import "NSString+Check.h"
@interface YAAlertView ()
// 背景view
@property (nonatomic, strong) UIScrollView *alertBgView;
// 第一个分割线
@property (nonatomic, strong) UIView *firstDivideView;
@end
@implementation YAAlertView

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
                            cancelTitle:(NSString *)cancelTitle btnTitlesArray:(NSArray<NSString *> *)btnTitlesArray
                          clickBtnBlock:(void (^)(NSInteger))clickBtnBlock
                       dismissViewBlock:(void (^)(UIView *))dismissViewBlock {
    self = [super initWithAttributedTitle:attributedTitle
                        attributedMessage:attributedMessage
                              cancelTitle:cancelTitle btnTitlesArray:btnTitlesArray
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
    
    [self setupTitles];
    
    [self setupButtons];
}

- (void)setupBgView {
    _alertBgView = [[UIScrollView alloc] init];
    _alertBgView.scrollEnabled = NO;
    _alertBgView.width = self.frame.size.width * 0.7;
    _alertBgView.showsHorizontalScrollIndicator = NO;
    _alertBgView.layer.cornerRadius = 20.0f;
    _alertBgView.layer.masksToBounds = YES;
    _alertBgView.x = (kMAIN_SCREEN_WIDTH - _alertBgView.width)/2.0f;
    _alertBgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    [self addSubview:_alertBgView];
}

- (void)setupTitles {
    if (![NSString isNull:self.title] || (self.attributedTitle.length > 0 && self.attributedTitle != nil)) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.width = _alertBgView.width - 2 * MARGIN;
        self.titleLabel.x = (_alertBgView.width - self.titleLabel.width)/2.0f;
        self.titleLabel.y = 2 * MARGIN;
        if (self.attributedTitle.length != 0 && ![self.attributedTitle isKindOfClass:[NSNull class]] && self.attributedTitle != nil) {
            self.titleLabel.attributedText = self.attributedTitle;
        }else {
            self.titleLabel.text = self.title;
        }
        self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.height = [self getTextHeight:self.titleLabel];
        [_alertBgView addSubview:self.titleLabel];
    }
    
    if (![NSString isNull:self.message] || (self.attributedMessage.length > 0 && self.attributedMessage != nil)) {
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.width = _alertBgView.width - 2 * MARGIN;
        self.messageLabel.x = (_alertBgView.width - self.messageLabel.width)/2.0f;
        
        if (self.title != nil || self.attributedTitle != nil) {
            self.messageLabel.y = CGRectGetMaxY(self.titleLabel.frame) + MARGIN * 2;
        }else {
            self.messageLabel.y = 2 * MARGIN;
        }
        
        if (self.attributedMessage.length != 0 && ![self.attributedMessage isKindOfClass:[NSNull class]] && self.attributedMessage != nil) {
            self.messageLabel.attributedText = self.attributedMessage;
        }else {
            self.messageLabel.text = self.message;
        }
        self.messageLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.textColor = [UIColor blackColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.height = [self getTextHeight:self.messageLabel];
        [_alertBgView addSubview:self.messageLabel];
    }
    
}

- (void)setupButtons {
    //只有一个按钮
    if (![NSString isNull:self.title] || (self.attributedTitle.length > 0 && self.attributedTitle != nil)) {
        if (![NSString isNull:self.message] || (self.attributedMessage.length > 0 && self.attributedMessage != nil)) {
            _firstDivideView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame) + MARGIN * 2, _alertBgView.width, LINE_HEIGHT)];
        }else {
            _firstDivideView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + MARGIN * 2, _alertBgView.width, LINE_HEIGHT)];
        }
    }else {
       if (![NSString isNull:self.message] || (self.attributedMessage.length > 0 && self.attributedMessage != nil)) {
            _firstDivideView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame) + MARGIN * 2, _alertBgView.width, LINE_HEIGHT)];
        }
    }
    
    _firstDivideView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_firstDivideView.frame), _alertBgView.width, BUTTON_HEIGHT)];
    [self.cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor clearColor]];
    [self.cancelBtn setTag:0];
    [self.cancelBtn setTitleColor:[UIColor colorWithRed:60/255.0 green:145/255.0 blue:251/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancelBtn addTarget:self action:@selector(onTapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_alertBgView addSubview:_firstDivideView];
    [_alertBgView addSubview:self.cancelBtn];
    //有两个按钮
    if (self.btnTitlesArray.count == 1) {
        self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_firstDivideView.frame), _alertBgView.width / 2.0f - LINE_HEIGHT, BUTTON_HEIGHT);
        
        UIView *midDivideView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelBtn.frame), self.cancelBtn.y, LINE_HEIGHT, self.cancelBtn.height + MARGIN)];
        midDivideView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [_alertBgView addSubview:midDivideView];
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(midDivideView.frame), self.cancelBtn.y, self.cancelBtn.width, self.cancelBtn.height)];
        [rightBtn setTitle:self.btnTitlesArray.lastObject forState:UIControlStateNormal];
        [rightBtn setBackgroundColor:[UIColor clearColor]];
        [rightBtn setTag:1];
        [rightBtn setTitleColor:[UIColor colorWithRed:60/255.0 green:145/255.0 blue:251/255.0 alpha:1.0] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBtn addTarget:self action:@selector(onTapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertBgView addSubview:rightBtn];
    }
    
    CGFloat originY = 0;
    if (![NSString isNull:self.title] || (self.attributedTitle.length > 0 && self.attributedTitle != nil)) {
        if (![NSString isNull:self.message] || (self.attributedMessage.length > 0 && self.attributedMessage != nil)) {
            originY = CGRectGetMaxY(self.messageLabel.frame);
        }else {
            originY =CGRectGetMaxY(self.titleLabel.frame);
        }
    }else {
       if (![NSString isNull:self.message] || (self.attributedMessage.length > 0 && self.attributedMessage != nil)) {
            originY = CGRectGetMaxY(self.messageLabel.frame);
        }
    }
    
    //最多有6个按钮
    if (self.btnTitlesArray.count >= 2 && self.btnTitlesArray.count <= 5) {
        [self initItemsWithOriginY:originY];
    }
    //超过最大数可以滑动
    if (self.btnTitlesArray.count > 5) {
        _alertBgView.scrollEnabled = YES;
        [self initItemsWithOriginY:originY];
    }
    
    if (self.btnTitlesArray.count < 2) {
        _alertBgView.height = CGRectGetMaxY(self.cancelBtn.frame);
    }else if (self.btnTitlesArray.count >= 2 && self.btnTitlesArray.count <= 5) {
        _alertBgView.height = originY + MARGIN + (self.btnTitlesArray.count + 1) * (BUTTON_HEIGHT + LINE_HEIGHT);
    }else {
        _alertBgView.height = originY + MARGIN + 6 * (BUTTON_HEIGHT + LINE_HEIGHT);
        _alertBgView.contentSize = CGSizeMake(_alertBgView.width, (self.btnTitlesArray.count + 1)  * (BUTTON_HEIGHT + LINE_HEIGHT) + self.titleLabel.height + self.messageLabel.height + 3 *MARGIN);
    }
    _alertBgView.y = (kMAIN_SCREEN_HEIGHT - _alertBgView.height)/2.0f;
}

- (void)initItemsWithOriginY:(CGFloat)originY {
    CGFloat height = self.btnTitlesArray.count * BUTTON_HEIGHT;
    for (int i = 0; i < self.btnTitlesArray.count ; i ++ ) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, (i * height / self.btnTitlesArray.count) + originY + LINE_HEIGHT + MARGIN, _alertBgView.width, BUTTON_HEIGHT)];
        [button setTitle:[self deascendArray][i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTag:self.btnTitlesArray.count - i];
        [button setTitleColor:[UIColor colorWithRed:60/255.0 green:145/255.0 blue:251/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(onTapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *divideView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMinY(button.frame), _alertBgView.width, LINE_HEIGHT)];
        divideView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        if (i == self.btnTitlesArray.count - 1) {
            _firstDivideView.y = CGRectGetMaxY(button.frame);
            self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_firstDivideView.frame), button.width, button.height);
        }
        [self.btnsArray addObject:button];
        [_alertBgView addSubview:divideView];;
        [_alertBgView addSubview:button];
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
- (CGFloat)getTextHeight:(UILabel*)label {
    if (label.text == nil || label.text.length == 0) {
        return 0;
    }
    return ceilf([label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)].height);
}

- (NSArray *)deascendArray {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = (int)self.btnTitlesArray.count; i > 0; i --) {
        [array addObject:self.btnTitlesArray[i - 1]];
    }
    return array;
}

#pragma mark - Super Method
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
        self.alertBgView.alpha = 0;
        self.alertBgView.transform = CGAffineTransformMakeScale(3.0, 3.0);
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:15.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1;
            [UIView animateWithDuration:0.15 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alertBgView.alpha = 1;
            } completion:nil];
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
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:15.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0;
            [UIView animateWithDuration:0.15 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alertBgView.alpha = 0;
            } completion:nil];
            self.alertBgView.transform = CGAffineTransformMakeScale(0.9, 0.9);
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
    
    if (self.btnsArray.count > 0) {
        if (index < 0 || index > self.btnsArray.count) return;
        else {
            UIButton *btn = [self.btnsArray objectAtIndex:index];
            [btn setTitleColor:titleColor forState:state];
        }
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
