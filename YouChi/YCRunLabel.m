//
//  YCRunLabel.m
//  YouChi
//
//  Created by 李李善 on 15/10/26.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRunLabel.h"
#import <Masonry/Masonry.h>
#import "YCCatolog.h"
#import "YCView.h"
@interface YCRunLabel ()
{
    CGFloat _font;
    CGRect _meFrame;
    BOOL _isCenter;
}
@end
@implementation YCRunLabel
- (void)dealloc{
    //ok
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
    
}
- (void)_init
{
    self.clipsToBounds = YES;
    _font = 18;
    float offset = 0;
    if ([UIDevice currentDevice].systemVersion.floatValue < 8) {
        //offset = -8*2;
    }
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(offset);
    }];

    
//    self.label.borderWidth = self.borderWidth = 1;
//    self.label.borderColor = self.borderColor = [UIColor whiteColor];
    
}


-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectZero];
        _label.font = [UIFont systemFontOfSize:_font];
        _label.numberOfLines = 1;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.text = @"";
        [self addSubview:_label];
    }
    
    return _label;
}

-(void)setTitle:(NSString *)title
{
    self.label.text = title;
    [self.label sizeToFit];
    //[self setNeedsLayout];
    
    
    //*
    CGRect frame = self.frame;
    CGRect lableFrame = self.label.frame;
    // 计算尺寸
    
    
    if (lableFrame.size.width > frame.size.width) {
        
        CGAffineTransform t1 = self.label.transform;
        
        CGFloat offset = lableFrame.size.width - frame.size.width;
        const float speed = 10;
        NSTimeInterval duration = offset/speed;
        //offset += 1;
        CGAffineTransform t2 = CGAffineTransformMakeTranslation(-offset, 0);

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:duration
                                  delay:0
                                options:UIViewAnimationOptionRepeat //动画重复的主开关
             |UIViewAnimationOptionAutoreverse //动画重复自动反向，需要和上面这个一起用
             |UIViewAnimationOptionCurveLinear //动画的时间曲线，滚动字幕线性比较合理
                             animations:^{
                                 self.label.transform = t2;
                             }
                             completion:^(BOOL finished) {
                                 if (finished) {
                                     self.label.transform = t1;
                                 }
                             }
             ];

        });

    } else {
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(self);
        }];
    }
     //*/
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
