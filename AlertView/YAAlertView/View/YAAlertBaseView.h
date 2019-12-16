//
//  YAAlertBaseView.h
//  YAAlertView
//
//  Created by 辰远 on 2018/4/20.
//  Copyright © 2018年 chenyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMAIN_SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height  //!< 屏幕的Height
#define kMAIN_SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width   //!< 屏幕的Width
#define MARGIN 10
#define BUTTON_HEIGHT 50
#define LINE_HEIGHT 0.5
@interface YAAlertBaseView : UIView
// 取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
// 标题label
@property (nonatomic, strong) UILabel *titleLabel;
// 信息label
@property (nonatomic, strong) UILabel *messageLabel;
// 标题
@property (nonatomic, copy) NSString *title;
// 信息
@property (nonatomic, copy) NSString *message;
// 标题
@property (nonatomic, copy) NSAttributedString *attributedTitle;
// 信息
@property (nonatomic, copy) NSAttributedString *attributedMessage;
// 取消按钮的标题
@property (nonatomic, copy) NSString *cancelTitle;
// 按钮标题数组
@property (nonatomic, strong) NSArray<NSString *> *btnTitlesArray;
// 按钮数组
@property (nonatomic, strong) NSMutableArray<UIButton *> *btnsArray;
// 点击回调
@property (nonatomic, copy) void (^clickBtnBlock) (NSInteger tag);
// 消失回调
@property (nonatomic, copy) void (^dismissViewBlock) (UIView *view);
// 是否需要点击空白处消失
@property (nonatomic, assign) BOOL needClickBlankDismiss;

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
             dismissViewBlock:(void (^) (UIView *view))dismissViewBlock;

/**
 显示富文本AlertView
 
 @param attributedTitle 标题
 @param attributedMessage 信息
 @param btnTitlesArray 按钮标题数组
 @param clickBtnBlock 点击按钮的回调
 */
- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle
                      attributedMessage:(NSAttributedString *)attributedMessage
                            cancelTitle:(NSString *)cancelTitle
                         btnTitlesArray:(NSArray<NSString *> *)btnTitlesArray
                          clickBtnBlock:(void (^) (NSInteger tag))clickBtnBlock
                       dismissViewBlock:(void (^) (UIView *view))dismissViewBlock;


/**
 显示alertView

 @param animated 是否动画显示
 @param completion 完成回调
 */
- (void)showAlertViewAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 移除alertView

 @param animated 是否动画移除
 @param completion 完成回调
 */
- (void)dismissAlertViewAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 设置按钮的标题颜色
 
 @param titleColor 标题颜色
 @param state 状态
  @param index 数组下标
 */
- (void)setButtonTitleColor:(UIColor *)titleColor forState:(UIControlState)state atIndex:(NSInteger)index;

/**
 设置按钮的背景颜色
 
 @param bgColor 背景颜色
  @param index 数组下标
 */
- (void)setButtonBgColor:(UIColor *)bgColor atIndex:(NSInteger)index;

- (void)setBgViewClickBlankNeedDissmiss:(BOOL)needClickBlankDismiss;

@end
