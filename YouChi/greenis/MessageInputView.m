//
//  ZBMessageInputView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-10.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "MessageInputView.h"
#import "NSString+Message.h"
#import "Masonry.h"
#import "AppConstants.h"

@interface MessageInputView()<UITextViewDelegate>

@property (nonatomic, strong, readwrite) MessageTextView *messageInputTextView;

@property (nonatomic, strong, readwrite) UIButton *faceSendButton;

@property (nonatomic, strong) NSString *inputedText;

//@property (nonatomic) BOOL faceButtonSelected;

@end

@implementation MessageInputView

- (void)dealloc{
    _messageInputTextView.delegate = nil;
    _messageInputTextView = nil;

    _faceSendButton = nil;

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.faceSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceButtonSelected = NO;
//        self.faceSendButton.backgroundColor = [UIColor blackColor];
        //    [self.faceSendButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion_ios7"] forState:UIControlStateNormal];
        UIImage *faceSendButtonImage = [UIImage imageNamed:@"ToolViewEmotion_ios7"];
        
        if (faceSendButtonImage == nil) {
            NSLog(@"faceSendButtonImage = nil");
        }
        
        [self.faceSendButton setImage:faceSendButtonImage forState:UIControlStateNormal];
        
        [self.faceSendButton addTarget:self
                                action:@selector(messageStyleButtonClicked:)
                      forControlEvents:UIControlEventTouchUpInside];
        self.faceSendButton.tag = 1;
        [self addSubview:self.faceSendButton];
        
         [self.faceSendButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.equalTo(self).with.offset(-5);
         make.right.equalTo(self).with.offset(-10);
         make.width.and.height.mas_equalTo(35);
         }];
        
        // 初始化输入框
        
        
        MessageTextView *textView = [[MessageTextView alloc] init];
        textView.returnKeyType = UIReturnKeySend;
        textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        textView.placeHolder = NSLocalizedString(@"shuodianshenme", @"");
        textView.delegate = self;
        [self addSubview:textView];
        _messageInputTextView = textView;
        
        _messageInputTextView.backgroundColor = [UIColor clearColor];
        _messageInputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        _messageInputTextView.layer.borderWidth = 0.65f;
        _messageInputTextView.layer.cornerRadius = 6.0f;
        
        [_messageInputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-5);
            make.height.equalTo(@35);
            make.left.equalTo(self).with.offset(10);
            make.width.mas_equalTo([AppConstants uiScreenWidth] - 65);
            //        make.right.equalTo(_faceSendButton.mas_left).with.offset(-10);
        }];
        /*
        [self.faceSendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_messageInputTextView);
            make.left.equalTo(_messageInputTextView.mas_right).with.offset(10);
            //        make.right.equalTo(self).with.offset(-10);
            make.width.and.height.mas_equalTo(35);
        }];*/

        
//        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
//        self.opaque = YES;
        // 由于继承UIImageView，所以需要这个属性设置
//        self.userInteractionEnabled = YES;
        /*
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7 )
        {
            _messageInputViewStyle = MessageInputViewStyleDefault;
//            self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)
                                                                                resizingMode:UIImageResizingModeStretch];
        }
        else
        {
            _messageInputViewStyle = MessageInputViewStyleQuasiphysical;
//            self.image = [[UIImage imageNamed:@"input-bar-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)
                                                                                      resizingMode:UIImageResizingModeStretch];
            
        }
        [self setupMessageInputViewBarWithStyle:_messageInputViewStyle];*/
    }
    return self;
}

#pragma mark - Action

- (void)messageStyleButtonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {/*
            self.faceSendButton.selected = NO;
            self.multiMediaSendButton.selected = NO;
            sender.selected = !sender.selected;
            
            if (sender.selected){
                NSLog(@"声音被点击的");
                [self.messageInputTextView becomeFirstResponder];
                
            }else{
                NSLog(@"声音被点击结束");
                [self.messageInputTextView resignFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.holdDownButton.hidden = sender.selected;
                self.messageInputTextView.hidden = !sender.selected;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didChangeSendVoiceAction:)]) {
                [self.delegate didChangeSendVoiceAction:sender.selected];
            }*/
        }
            break;
        case 1:
        {
//            sender.selected = !sender.selected;
            _faceButtonSelected = !_faceButtonSelected;
            if (_faceButtonSelected) {
                NSLog(@"表情被点击");
                [self.messageInputTextView resignFirstResponder];
                [self.faceSendButton setImage:[UIImage imageNamed:@"ToolViewKeyboard_ios7"] forState:UIControlStateNormal];
            }else{
                NSLog(@"表情没被点击");
                [self.messageInputTextView becomeFirstResponder];
                [self.faceSendButton setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7"] forState:UIControlStateNormal];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.messageInputTextView.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didSendFaceAction:)]) {
                [self.delegate didSendFaceAction:_faceButtonSelected];
            }
        }
            break;
        case 2:
        {
            /*
            self.voiceChangeButton.selected = YES;
            self.faceSendButton.selected = NO;
            
            sender.selected = !sender.selected;
            if (sender.selected) {
                NSLog(@"分享被点击");
                [self.messageInputTextView resignFirstResponder];
            }else{
                NSLog(@"分享没被点击");
                [self.messageInputTextView becomeFirstResponder];
            }

            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.holdDownButton.hidden = YES;
                self.messageInputTextView.hidden = NO;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didSelectedMultipleMediaAction:)]) {
                [self.delegate didSelectedMultipleMediaAction:sender.selected];
            }*/
        }
            break;
        default:
            break;
    }
}

#pragma mark - 添加控件
- (void)setupMessageInputViewBarWithStyle:(MessageInputViewStyle )style{
/*
    self.faceSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _faceButtonSelected = NO;
    self.faceSendButton.backgroundColor = [UIColor blackColor];
//    [self.faceSendButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion_ios7"] forState:UIControlStateNormal];
    UIImage *faceSendButtonImage = [UIImage imageNamed:@"ToolViewEmotion_ios7"];
    
    if (faceSendButtonImage == nil) {
        NSLog(@"faceSendButtonImage = nil");
    }
    
    [self.faceSendButton setImage:faceSendButtonImage forState:UIControlStateNormal];
    
    [self.faceSendButton addTarget:self
                            action:@selector(messageStyleButtonClicked:)
                  forControlEvents:UIControlEventTouchUpInside];
    self.faceSendButton.tag = 1;
    [self addSubview:self.faceSendButton];
 
    [self.faceSendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-5);
        make.right.equalTo(self).with.offset(-10);
        make.width.and.height.mas_equalTo(35);
    }];
    
    // 初始化输入框
    
    
    MessageTextView *textView = [[MessageTextView alloc] init];
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    textView.placeHolder = @"说点什么...";
    textView.delegate = self;
    [self addSubview:textView];
	_messageInputTextView = textView;
    
    _messageInputTextView.backgroundColor = [UIColor clearColor];
    _messageInputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _messageInputTextView.layer.borderWidth = 0.65f;
    _messageInputTextView.layer.cornerRadius = 6.0f;

    [_messageInputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-5);
        make.height.equalTo(@35);
        make.left.equalTo(self).with.offset(10);
        make.width.mas_equalTo([AppConstants uiScreenWidth] - 65);
//        make.right.equalTo(_faceSendButton.mas_left).with.offset(-10);
    }];
    
    [self.faceSendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_messageInputTextView);
        make.left.equalTo(_messageInputTextView.mas_right).with.offset(10);
//        make.right.equalTo(self).with.offset(-10);
        make.width.and.height.mas_equalTo(35);
    }];
    
    NSLog(@"%f %f %f %f", _faceSendButton.frame.size.height, _faceSendButton.frame.size.width, _faceSendButton.frame.origin.x, _faceSendButton.frame.origin.y);
    NSLog(@"%f %f %f %f", _messageInputTextView.frame.size.height, _messageInputTextView.frame.size.width, _messageInputTextView.frame.origin.x, _messageInputTextView.frame.origin.y);
    
    NSLog(@"setup end");*/
}

#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
    // 动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.messageInputTextView.frame;
    
    NSUInteger numLines = MAX([self.messageInputTextView numberOfLinesOfText],
                              [self.messageInputTextView.text numberOfLines]);
    
    self.messageInputTextView.frame = CGRectMake(prevFrame.origin.x,
                                          prevFrame.origin.y,
                                          prevFrame.size.width,
                                          prevFrame.size.height + changeInHeight);
    
    
    self.messageInputTextView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                       0.0f,
                                                       (numLines >= 6 ? 4.0f : 0.0f),
                                                       0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    self.messageInputTextView.scrollEnabled = YES;
    
    if (numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.messageInputTextView.contentSize.height - self.messageInputTextView.bounds.size.height);
        [self.messageInputTextView setContentOffset:bottomOffset animated:YES];
        [self.messageInputTextView scrollRangeToVisible:NSMakeRange(self.messageInputTextView.text.length - 2, 1)];
    }
}

+ (CGFloat)textViewLineHeight{
    return 36.0f ;// 字体大小为16
}

+ (CGFloat)maxHeight{
    return ([MessageInputView maxLines] + 1.0f) * [MessageInputView textViewLineHeight];
}

+ (CGFloat)maxLines{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}
#pragma end

- (void)setup {
    NSLog(@"inputview setup");
    /*
    // 配置自适应
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    // 由于继承UIImageView，所以需要这个属性设置
    self.userInteractionEnabled = YES;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7 )
    {
        _messageInputViewStyle = MessageInputViewStyleDefault;
        self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)
                                                                            resizingMode:UIImageResizingModeStretch];
    }
    else
    {
        _messageInputViewStyle = MessageInputViewStyleQuasiphysical;
        self.image = [[UIImage imageNamed:@"input-bar-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)
                                                                                  resizingMode:UIImageResizingModeStretch];
        
    }
    [self setupMessageInputViewBarWithStyle:_messageInputViewStyle];*/
}

#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)])
    {
        [self.delegate inputTextViewWillBeginEditing:self.messageInputTextView];
    }
    _faceButtonSelected = NO;
    [self.faceSendButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion_ios7"] forState:UIControlStateNormal];

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidChange:)]) {
        [self.delegate inputTextViewDidChange:self.messageInputTextView];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.messageInputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendTextAction:)]) {
            [self.delegate didSendTextAction:self.messageInputTextView];
        }
        return NO;
    }
    return YES;
}
#pragma end

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
