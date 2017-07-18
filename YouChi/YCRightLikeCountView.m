//
//  YCZanView.m
//  YouChi
//
//  Created by 李李善 on 15/8/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRightLikeCountView.h"
#import <Masonry/Masonry.h>
#import "YCView.h"
#import "UIButton+MJ.h"

#define YCZanFont 13
#define YCLeft 5
#define YCTop 5


@implementation YCRightLikeCountView
-(void)dealloc{
    //    ok
    
}
- (void)prepareForInterfaceBuilder{
    [self _init];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void) _init{
    
    
    self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
    self.exclusiveTouch = NO;
    self.userInteractionEnabled = YES;
    
    
#pragma mark --赞数
    [self.zanShu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
 #pragma mark --赞图片
    [self.zanImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zanShu.mas_centerY);
        make.right.equalTo(self.zanShu.mas_left).offset(-YCLeft);
        make.height.width.mas_equalTo(@15);
    }];
    
}

- (UILabel *)zanShu
{
    if (!_zanShu) {
        _zanShu = [[UILabel alloc] init];
        _zanShu.textColor = KBGCColor(@"#000000");
        _zanShu.font = [UIFont systemFontOfSize:YCZanFont];
        _zanShu.adjustsFontSizeToFitWidth = YES;
        _zanShu.textAlignment =  NSTextAlignmentLeft;
        
        [self addSubview:_zanShu];
    }
    return _zanShu;
}
- (UIImageView *)zanImage{
    
    if (!_zanImage) {
        _zanImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"赞_显示数量的赞"]];
        _zanImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_zanImage];
        _zanImage.exclusiveTouch = YES;
    }
    return _zanImage;
};

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateLikeCount:(int )likeCount
{
    _zanShu.text = [[NSString alloc]initWithFormat:@"%d个人觉得赞",likeCount];
}
@end




@implementation YCLeftZanView
-(void)dealloc{
    //    ok
    
}
- (void)prepareForInterfaceBuilder{
    [self _init];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self _init];
    
}
- (void) _init{
    
    self.opaque = YES;
    self.exclusiveTouch = NO;
    self.userInteractionEnabled = YES;
    self.zanShu.textColor = KBGCColor(@"#272636");
  
    
#pragma mark --赞图片
    [self.zanImage  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(4);
        make.left.equalTo(self.mas_left).offset(15);
        //make.height.width.equalTo(self.mas_height).offset(-6);
    }];
#pragma mark --赞数
    [self.zanShu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zanImage.mas_centerY);
        make.left.equalTo(self.zanImage.mas_right).offset(10);
        make.height.equalTo(self.zanImage.mas_height);
    }];
};

- (void)updateLikeCount:(int )likeCount
{
    
    self.zanShu.text = [[NSString alloc]initWithFormat:@"%d个赞",likeCount];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

