//
//  YAAlertStyleView.m
//  YAAlertView
//
//  Created by 辰远 on 2018/1/2.
//  Copyright © 2018年 chenyuan. All rights reserved.
//

#import "YAAlertStyleView.h"
#import "YAAlertView.h"
#import "YAActionSheetView.h"
@interface YAAlertStyleView () {
@private
    NSMutableArray *queueArray;
}
// 用于标识view是否显示
@property (nonatomic, assign) BOOL isShow;
// 持有的alertView
@property (nonatomic ,strong) YAAlertView *alertView;
// 持有的alertViewactionSheetView
@property (nonatomic, strong) YAActionSheetView *actionSheetView;
@end

@implementation YAAlertStyleView
#pragma mark --  类方法
+ (YAAlertStyleView *)shareInstance {
    static YAAlertStyleView *alertStyleView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertStyleView = [[self alloc] init];
    });
    return alertStyleView;
}

/**
显示alertView

@param title 标题
@param message 信息
@param perferStyle 样式
@param cancelButtonTitle 取消标题
@param otherButtonTitles 按钮数组
@param clickBlock 点击回调
*/
+ (YAAlertStyleView *)showAlertWithTitle:(NSString *)title
                                 message:(NSString *)message
                             perferStyle:(YAAlertViewStyle)perferStyle
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                       otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                              clickBlock:(void (^) (NSInteger buttonIndex))clickBlock {
    return [[self shareInstance] showAlertViewWithTitle:title
                                                message:message
                                            perferStyle:perferStyle
                                            cancelTitle:cancelButtonTitle
                                         btnTitlesArray:otherButtonTitles
                                          clickBtnBlock:clickBlock];
}

/**
显示富文本的alertView

@param attributedTitle 富文本标题
@param attributedMessage 富文本信息
@param perferStyle 样式
@param cancelButtonTitle 取消标题
@param otherButtonTitles 按钮数组
@param clickBlock 点击回调
*/
+ (YAAlertStyleView *)showAlertWithAttributedTitle:(NSMutableAttributedString *)attributedTitle
                                 attributedMessage:(NSMutableAttributedString *)attributedMessage
                                       perferStyle:(YAAlertViewStyle)perferStyle
                                 cancelButtonTitle:(NSString *)cancelButtonTitle
                                 otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                                        clickBlock:(void (^) (NSInteger buttonIndex))clickBlock {
    return [[self shareInstance] showAlertViewWithAttributedTitle:attributedTitle
                                                attributedMessage:attributedMessage
                                                      perferStyle:perferStyle
                                                      cancelTitle:cancelButtonTitle
                                                   btnTitlesArray:otherButtonTitles
                                                    clickBtnBlock:clickBlock];
}

/**
 *  显示菜单栏
 *
 *  @param cancelTitle 取消按钮标题
 *  @param otherTitles 其它按钮标题
 *  @param clickBlock  点击回调
 */
+ (YAAlertStyleView *)showAcionSheetWithCancelTitle:(NSString *)cancelTitle
                                        otherTitles:(NSArray *)otherTitles
                                         clickBlock:(void(^)(NSInteger buttonIndex))clickBlock {
    return [[self shareInstance] showAlertViewWithTitle:nil message:nil perferStyle:(YAAlertViewStyleActionSheet) cancelTitle:cancelTitle btnTitlesArray:otherTitles clickBtnBlock:clickBlock];
}

/**
 移除所有alertView
 */
+ (void)ya_dismissAllAlertViewWithAnimate:(BOOL)animate {
    [[self shareInstance] ya_dismissAllAlertViewWithAnimate:animate];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        queueArray = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 显示alertView
 
 @param title 标题
 @param message 信息
 @param perferStyle 样式
 @param cancelTitle 取消标题
 @param btnTitlesArray 按钮数组
 @param clickBtnBlock 点击回调
 */
- (YAAlertStyleView *)showAlertViewWithTitle:(NSString *)title
                                     message:(NSString *)message
                                 perferStyle:(YAAlertViewStyle)perferStyle
                                 cancelTitle:(NSString *)cancelTitle
                              btnTitlesArray:(NSArray <NSString *>*)btnTitlesArray
                               clickBtnBlock:(void (^) (NSInteger tag))clickBtnBlock {
    if (perferStyle == YAAlertViewStyleAlert) {
        if ((title.length == 0 || [title isKindOfClass:[NSNull class]] || title == nil) && (message.length == 0 || [message isKindOfClass:[NSNull class]] || message == nil)) {
            return nil;
        }
    }
    
    [self initAlertViewWithTitle:title
                 AttributedTitle:nil
                         message:message
               attributedMessage:nil
                     perferStyle:perferStyle
                     cancelTitle:cancelTitle
                  btnTitlesArray:btnTitlesArray
                   clickBtnBlock:clickBtnBlock];
    return self;
}

/**
 显示富文本的alertView
 
 @param attributedTitle 富文本标题
 @param attributedMessage 富文本信息
 @param perferStyle 样式
 @param cancelTitle 取消标题
 @param btnTitlesArray 按钮数组
 @param clickBtnBlock 点击回调
 */
- (YAAlertStyleView *)showAlertViewWithAttributedTitle:(NSAttributedString *)attributedTitle
                                     attributedMessage:(NSAttributedString *)attributedMessage
                                           perferStyle:(YAAlertViewStyle)perferStyle
                                           cancelTitle:(NSString *)cancelTitle
                                        btnTitlesArray:(NSArray<NSString *> *)btnTitlesArray
                                         clickBtnBlock:(void (^) (NSInteger tag))clickBtnBlock {
    if (perferStyle == YAAlertViewStyleAlert) {
        if ((attributedTitle.length == 0 || [attributedTitle isKindOfClass:[NSNull class]] || attributedTitle == nil) && (attributedMessage.length == 0 || [attributedMessage isKindOfClass:[NSNull class]] || attributedMessage == nil)) {
            return nil;
        }
    }
    
    [self initAlertViewWithTitle:nil
                 AttributedTitle:attributedTitle
                         message:nil
               attributedMessage:attributedMessage
                     perferStyle:perferStyle
                     cancelTitle:cancelTitle
                  btnTitlesArray:btnTitlesArray
                   clickBtnBlock:clickBtnBlock];
    return self;
}

/**
 移除所有alertView
 */
- (void)ya_dismissAllAlertViewWithAnimate:(BOOL)animate {
    if (queueArray.count > 0) {
        [queueArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self dismissAlertView:obj animated:animate];
        }];
    }
}

#pragma mark - UI
- (void)initAlertViewWithTitle:(NSString *)title
               AttributedTitle:(NSAttributedString *)attributedTitle
                       message:(NSString *)message
             attributedMessage:(NSAttributedString *)attributedMessage
                   perferStyle:(YAAlertViewStyle)perferStyle
                   cancelTitle:(NSString *)cancelTitle
                btnTitlesArray:(NSArray<NSString *> *)btnTitlesArray
                 clickBtnBlock:(void (^) (NSInteger tag))clickBtnBlock {
    switch (perferStyle) {
        case YAAlertViewStyleAlert:
        {
            if ((attributedMessage == nil || attributedMessage.length == 0) && (attributedTitle == nil || attributedTitle.length == 0)) {
                _alertView = [[YAAlertView alloc] initWithTitle:title message:message cancelTitle:cancelTitle btnTitlesArray:btnTitlesArray clickBtnBlock:clickBtnBlock dismissViewBlock:^(UIView *view) {
                    [self dismissAlertView:view animated:YES];
                }];
            }else if ((title == nil || title.length == 0 || [title isKindOfClass:[NSNull class]]) && (message == nil || message.length == 0 || [message isKindOfClass:[NSNull class]])) {
                _alertView = [[YAAlertView alloc] initWithAttributedTitle:attributedTitle attributedMessage:attributedMessage cancelTitle:cancelTitle btnTitlesArray:btnTitlesArray clickBtnBlock:clickBtnBlock dismissViewBlock:^(UIView *view) {
                    [self dismissAlertView:view animated:YES];
                }];
            }
            if (_alertView) {
                [self prepareAlertToDisplay:_alertView];
            }
        }
            break;
        case YAAlertViewStyleActionSheet:
        {
            if ((attributedMessage == nil || attributedMessage.length == 0 || [attributedMessage isKindOfClass:[NSNull class]]) && (attributedTitle == nil || attributedTitle.length == 0 || [attributedTitle isKindOfClass:[NSNull class]])) {
                _actionSheetView = [[YAActionSheetView alloc] initWithTitle:title message:message cancelTitle:cancelTitle btnTitlesArray:btnTitlesArray clickBtnBlock:clickBtnBlock dismissViewBlock:^(UIView *view) {
                    [self dismissAlertView:view animated:YES];
                }];
            }else if ((title == nil || title.length == 0 || [title isKindOfClass:[NSNull class]]) && (message == nil || message.length == 0 || [message isKindOfClass:[NSNull class]])) {
                _actionSheetView = [[YAActionSheetView alloc] initWithAttributedTitle:attributedTitle attributedMessage:attributedMessage cancelTitle:cancelTitle btnTitlesArray:btnTitlesArray clickBtnBlock:clickBtnBlock dismissViewBlock:^(UIView *view) {
                    [self dismissAlertView:view animated:YES];
                }];
            }else {
                _actionSheetView = [[YAActionSheetView alloc] initWithTitle:title message:message cancelTitle:cancelTitle btnTitlesArray:btnTitlesArray clickBtnBlock:clickBtnBlock dismissViewBlock:^(UIView *view) {
                    [self dismissAlertView:view animated:YES];
                }];
            }
            if (_actionSheetView) {
                [self prepareAlertToDisplay:_actionSheetView];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private method
/**
 查找数组中的下一个视图显示
 */
- (void)checkoutInStackAlertView {
    if (queueArray.count > 0) {
        [queueArray removeObjectAtIndex:0];
        id view = queueArray.firstObject;
        if (view && [view isKindOfClass:[YAAlertBaseView class]]) {
            [self showAnimationWithView:view];
        }
    }else {
        [self removeFromSuperview];
    }
    
}

/**
 显示前的操作
 */
- (void)prepareAlertToDisplay:(UIView*)view {
    if (view) {
        [queueArray addObject:view];
    }
    [self showAnimationWithView:view];
}

#pragma mark - Show
- (void)showAnimationWithView:(UIView *)view {
    if ([YAAlertStyleView shareInstance].isShow) return;
    if ([view isMemberOfClass:[YAAlertView class]]) {
        _alertView = (YAAlertView *)view;
        [YAAlertStyleView shareInstance].isShow = YES;
        [_alertView showAlertViewAnimated:YES completion:nil];
    }else if ([view isMemberOfClass:[YAActionSheetView class]]) {
        _actionSheetView = (YAActionSheetView *)view;
        [YAAlertStyleView shareInstance].isShow = YES;
        [_actionSheetView showAlertViewAnimated:YES completion:nil];
    }
}

#pragma mark - Dismiss
- (void)dismissAlertView:(UIView *)view animated:(BOOL)animated {
    __weak  typeof(self) weakSelf  = self;
    if ([view isMemberOfClass:[YAAlertView class]]) {
        _alertView = (YAAlertView *)view;
        if (animated) {
            [_alertView dismissAlertViewAnimated:YES completion:^{
                weakSelf.alertView = nil;
                [YAAlertStyleView shareInstance].isShow = NO;
                [weakSelf checkoutInStackAlertView];
            }];
        }else {
            weakSelf.alertView = nil;
            [YAAlertStyleView shareInstance].isShow = NO;
            [weakSelf checkoutInStackAlertView];
        }
    }else if ([view isMemberOfClass:[YAActionSheetView class]]){
        _actionSheetView = (YAActionSheetView *)view;
        if (animated) {
            [_actionSheetView dismissAlertViewAnimated:YES completion:^{
                weakSelf.actionSheetView = nil;
                [YAAlertStyleView shareInstance].isShow = NO;
                [weakSelf checkoutInStackAlertView];
            }];
        }else {
            weakSelf.actionSheetView = nil;
            [YAAlertStyleView shareInstance].isShow = NO;
            [weakSelf checkoutInStackAlertView];
        }
    }
}

#pragma mark - Set
- (void)setTitleColor:(UIColor *)titleColor {
    if (_alertView) {
        [_alertView.titleLabel setTextColor:titleColor];
    }
    
    if (_actionSheetView) {
        [_actionSheetView.titleLabel setTextColor:titleColor];
    }
}

- (void)setMsgColor:(UIColor *)msgColor {
    if (_alertView) {
        [_alertView.messageLabel setTextColor:msgColor];
    }
    
    if (_actionSheetView) {
        [_actionSheetView.messageLabel setTextColor:msgColor];
    }
}

- (void)setCancelBtnTitleColor:(UIColor *)cancelBtnTitleColor {
    if (_alertView) {
        [_alertView.cancelBtn setTitleColor:cancelBtnTitleColor forState:UIControlStateNormal];
    }
    
    if (_actionSheetView) {
        [_actionSheetView.cancelBtn setTitleColor:cancelBtnTitleColor forState:UIControlStateNormal];
    }
}

- (void)setCancelBtnTitleFont:(UIFont *)cancelBtnTitleFont {
    if (_alertView) {
        _alertView.cancelBtn.titleLabel.font = cancelBtnTitleFont;
    }
    
    if (_actionSheetView) {
        _actionSheetView.cancelBtn.titleLabel.font = cancelBtnTitleFont;
    }
}
- (void)setCancelBtnBgColor:(UIColor *)cancelBtnBgColor {
    if (_alertView) {
        [_alertView.cancelBtn setBackgroundColor:cancelBtnBgColor];
    }
    
    if (_actionSheetView) {
        [_actionSheetView.cancelBtn setBackgroundColor:cancelBtnBgColor];
    }
}

- (void)setButtonTitleColor:(UIColor *)titleColor forState:(UIControlState)state atIndex:(NSInteger)index{
    if (_alertView) {
        [_alertView setButtonTitleColor:titleColor forState:state atIndex:index];
    }
    if (_actionSheetView) {
        [_actionSheetView setButtonTitleColor:titleColor forState:state atIndex:index];
    }
}

- (void)setButtonBgColor:(UIColor *)color atIndex:(NSInteger)index {
    if (_alertView) {
        [_alertView setButtonBgColor:color atIndex:index];
    }
    if (_actionSheetView) {
        [_actionSheetView setButtonBgColor:color atIndex:index];
    }
}

- (void)setNeedClickBlankDismiss:(BOOL)needClickBlankDismiss {
    if (_alertView) {
        [_alertView setNeedClickBlankDismiss:needClickBlankDismiss];
    }
    if (_actionSheetView) {
        [_actionSheetView setNeedClickBlankDismiss:needClickBlankDismiss];
    }
}

@end
