//
//  YAAlertBaseView.m
//  YAAlertView
//
//  Created by 辰远 on 2018/4/20.
//  Copyright © 2018年 chenyuan. All rights reserved.
//

#import "YAAlertBaseView.h"
@implementation YAAlertBaseView

/**
 显示AlertView
 
 @param title 标题
 @param message 信息
 @param btnTitlesArray 按钮标题数组
 @param clickBtnBlock 点击按钮的回调
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
               btnTitlesArray:(NSArray<NSString *> *)btnTitlesArray
                clickBtnBlock:(void (^) (NSInteger tag))clickBtnBlock
             dismissViewBlock:(void (^) (UIView *view))dismissViewBlock {
    if (self = [super init]) {
        _title = title;
        _message = message;
        _cancelTitle = cancelTitle;
        _btnTitlesArray = btnTitlesArray;
        _clickBtnBlock = clickBtnBlock;
        _dismissViewBlock = dismissViewBlock;
    }
    return self;
}


/**
 显示富文本AlertView
 
 @param attributedTitle 标题
 @param attributedMessage 信息
 @param btnTitlesArray 按钮标题数组
 @param clickBtnBlock 点击按钮的回调
 */
- (instancetype)initWithAttributedTitle:(NSMutableAttributedString *)attributedTitle
                      attributedMessage:(NSMutableAttributedString *)attributedMessage
                  cancelTitle:(NSString *)cancelTitle
               btnTitlesArray:(NSArray<NSString *> *)btnTitlesArray
                clickBtnBlock:(void (^) (NSInteger tag))clickBtnBlock
             dismissViewBlock:(void (^) (UIView *view))dismissViewBlock {
    if (self = [super init]) {
        _attributedTitle = attributedTitle;
        _attributedMessage = attributedMessage;
        _cancelTitle = cancelTitle;
        _btnTitlesArray = btnTitlesArray;
        _clickBtnBlock = clickBtnBlock;
        _dismissViewBlock = dismissViewBlock;
    }
    return self;
}


/**
 显示alertView
 
 @param animated 是否动画显示
 @param completion 完成回调
 */
- (void)showAlertViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
    
}


/**
 移除alertView
 
 @param animated 是否动画移除
 @param completion 完成回调
 */
- (void)dismissAlertViewAnimated:(BOOL)animated completion:(void (^)(void))completion {

}

/**
 设置按钮的标题颜色
 
 @param titleColor 标题颜色
 @param state 状态
 @param index 数组下标
 */
- (void)setButtonTitleColor:(UIColor *)titleColor forState:(UIControlState)state atIndex:(NSInteger)index {
    
}

/**
 设置按钮的背景颜色
 
 @param bgColor 背景颜色
 @param index 数组下标
 */
- (void)setButtonBgColor:(UIColor *)bgColor atIndex:(NSInteger)index {
    if (self.btnsArray.count > 0) {
        if (index < 0 || index > self.btnsArray.count) return;
    }
}

- (void)setBgViewClickBlankNeedDissmiss:(BOOL)needClickBlankDismiss  {
    _needClickBlankDismiss = needClickBlankDismiss;
}

#pragma mark - Lazy laod
- (NSMutableArray *)btnsArray {
    if (!_btnsArray) {
        _btnsArray = [[NSMutableArray alloc] init];
    }
    return _btnsArray;
}
@end
