//
//  ZBMessageInputView.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-10.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageTextView.h"

typedef enum
{
  MessageInputViewStyleDefault, // ios7 样式
  MessageInputViewStyleQuasiphysical
} MessageInputViewStyle;

@protocol MessageInputViewDelegate <NSObject>

@required

/**
 *  输入框刚好开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(MessageTextView *)messageInputTextView;

/**
 *  输入框将要开始编辑
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(MessageTextView *)messageInputTextView;

/**
 *  输入框输入时候
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)inputTextViewDidChange:(MessageTextView *)messageInputTextView;

@optional

/**
 *  发送文本消息，包括系统的表情
 *
 *  @param messageInputTextView 输入框对象
 */
- (void)didSendTextAction:(MessageTextView *)messageInputTextView;

/**
 *  发送第三方表情
 */
- (void)didSendFaceAction:(BOOL)sendFace;

@end

@interface MessageInputView : UIView

@property (nonatomic,strong) id<MessageInputViewDelegate> delegate;

/**
 *  用于输入文本消息的输入框
 */
@property (nonatomic,strong,readonly) MessageTextView *messageInputTextView;

/**
 *  当前输入工具条的样式
 */
@property (nonatomic, assign) MessageInputViewStyle messageInputViewStyle;

/**
 *  第三方表情按钮
 */
@property (nonatomic, strong, readonly) UIButton *faceSendButton;

@property (nonatomic) BOOL faceButtonSelected;

#pragma mark methods

//- (instancetype)init;

/**
 *  动态改变高度
 *
 *  @param changeInHeight 目标变化的高度
 */
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

/**
 *  获取输入框内容字体行高
 *
 *  @return 返回行高
 */
+ (CGFloat)textViewLineHeight;

/**
 *  获取最大行数
 *
 *  @return 返回最大行数
 */
+ (CGFloat)maxLines;

/**
 *  获取根据最大行数和每行高度计算出来的最大显示高度
 *
 *  @return 返回最大显示高度
 */
+ (CGFloat)maxHeight;

#pragma end

@end
