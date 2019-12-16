//
//  YAAlertStyleView.h
//  YAAlertView
//
//  Created by 辰远 on 2018/1/2.
//  Copyright © 2018年 chenyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, YAAlertViewStyle) {
    YAAlertViewStyleAlert = 0,
    YAAlertViewStyleActionSheet,
};
@interface YAAlertStyleView : UIView
// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
// 信息颜色
@property (nonatomic, strong) UIColor *msgColor;
// 取消按钮标题颜色
@property (nonatomic, strong) UIColor *cancelBtnTitleColor;
// 取消按钮标题字体
@property (nonatomic, strong) UIFont *cancelBtnTitleFont;
// 取消按钮背景颜色
@property (nonatomic, strong) UIColor *cancelBtnBgColor;
// 是否需要点击空白处消失
@property (nonatomic, assign) BOOL needClickBlankDismiss;
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
                          clickBlock:(void (^) (NSInteger buttonIndex))clickBlock;


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
                               clickBlock:(void (^) (NSInteger buttonIndex))clickBlock;

/**
 *  显示菜单栏
 *
 *  @param cancelTitle 取消按钮标题
 *  @param otherTitles 其它按钮标题
 *  @param clickBlock  点击回调
 */
+ (YAAlertStyleView *)showAcionSheetWithCancelTitle:(NSString *)cancelTitle
                                     otherTitles:(NSArray *)otherTitles
                                      clickBlock:(void(^)(NSInteger buttonIndex))clickBlock;

/**
 移除所有alertView
 */
+ (void)ya_dismissAllAlertViewWithAnimate:(BOOL)animate;

/**
 设置数组中按钮的标题颜色

 @param titleColor 标题颜色
 @param state 状态
 @param index 数组下标
 */
- (void)setButtonTitleColor:(UIColor *)titleColor forState:(UIControlState)state atIndex:(NSInteger)index;

/**
 设置数组中按钮的背景颜色

 @param color 背景颜色
 @param index 数组下标
 */
- (void)setButtonBgColor:(UIColor *)color atIndex:(NSInteger)index;
@end
