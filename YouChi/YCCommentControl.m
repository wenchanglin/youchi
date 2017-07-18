//
//  YCZanShuVC.m
//  YouChi
//
//  Created by 李李善 on 15/8/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCommentControl.h"
#import <Masonry/Masonry.h>
#import "YCView.h"
#import "UIButton+MJ.h"

#define YCQianMingFont 10
#define YCButtonLeft 10
#define YCTop 5
#define YCLeft 5

#define YCDotR 4


@implementation YCDotButton
{
    UILabel *_numberView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _numberView = [UILabel new];
        [self addSubview:_numberView];
        
        _numberView.clipsToBounds = YES;
        _numberView.font = [UIFont systemFontOfSize:12];
        //_numberView.backgroundColor = [UIColor redColor];
        _numberView.textColor = [UIColor blackColor];
        _numberView.hidden = YES;
    }
    return self;
}

- (void)setNumber:(int)number
{
    if (0 == number) {
        _numberView.hidden = YES;
    } else {
        _numberView.hidden = NO;
        _numberView.text = @(number).stringValue;
        [_numberView sizeToFit];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect f = self.titleLabel.frame;
    f.origin.x += f.size.width;
    f.origin.y -= f.size.height-2;
 
    f.size = _numberView.frame.size;
    _numberView.frame = f;
    //_numberView.cornerRadius = f.size.height/4;
}

@end

@interface YCCommentControl()
{
    NSMutableArray *_buttons;
}

@end
@implementation YCCommentControl

- (void)dealloc{
    //ok
}
- (void)prepareForInterfaceBuilder{
    [self _init];
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
        [self _init2];
    }
    return self;
}


- (void)_init{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
    self.exclusiveTouch = YES;
    
#pragma mark---赞
    [self.like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(self).dividedBy(3);
    }];
    
#pragma mark---评论
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.like.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(self.like);
    }];
    
#pragma mark---收藏
    
    [self.favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(self.like);
    }];
    
    
}


- (UIButton *)like{
    if (!_like) {
        _like =[UIButton onCearchButtonWithImage:@"点赞-_click" SelImage:@"已赞_default" Title:@"赞" Target:self action:@selector(onClick:)];
        [_like setTitle:@"已赞" forState:UIControlStateSelected];
        _like.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [_like setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, 6)];
        [_like setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0,0)];
        _like.tag = 1;
        [self addSubview:_like];
    }
    return _like;
}
- (UIButton *)comment{
    if (!_comment) {
        _comment = [UIButton onCearchButtonWithImage:@"评论" SelImage:@"评论" Title:@"评论" Target:self action:@selector(onClick:)];
        _comment.titleLabel.font = [UIFont systemFontOfSize:12];
        _comment.tag = 2;
        [_comment setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, 6)];
        [_comment setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0,0)];
        [self addSubview:_comment];
    }
    return _comment;
}

- (UIButton *)favorite{
    
    if (!_favorite) {
        
        
        _favorite = [UIButton onCearchButtonWithImage:@"收藏_default" SelImage:@"收藏_click" Title:@"收藏" Target:self action:@selector(onClick:)];
        [_favorite setTitle:@"已收藏" forState:UIControlStateSelected];
        _favorite.titleLabel.font = [UIFont systemFontOfSize:12];
        [_favorite setImageEdgeInsets:UIEdgeInsetsMake(0,0,1, 6)];
        [_favorite setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0,0)];
        _favorite.tag = 3;
        [self addSubview:_favorite];
    }
    return _favorite;
}

-(void)setButtonType:(YCButtonType)ButtonType
{
    if (_ButtonType != ButtonType) {
        
        _ButtonType = ButtonType;
        UIImage *normalImage;
        UIImage *selImage;
        NSString *normalText;
        NSString *selText;
        if (ButtonType==YCButtonTypeCollect) {
            normalImage = [UIImage imageNamed:@"收藏_default"];
            selImage   = [UIImage imageNamed:@"收藏_click"];
            normalText = @"收藏";
            selText = @"已收藏";
            
        }
        else if(ButtonType==YCButtonTypeDelete)
        {
            normalImage = [UIImage imageNamed:@"垃圾桶"];
            selImage   = [UIImage imageNamed:@"垃圾桶"];
            normalText = @"删除";
            selText    = @"删除";
            [self.favorite setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [self.favorite setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else if(ButtonType==YCButtonTypeMore)
        {
            normalImage = [UIImage imageNamed:@"更多"];
            selImage   = [UIImage imageNamed:@"更多"];
            normalText = @"更多";
            selText    = @"更多";
    
            
        }

        else if (ButtonType==YCButtonTypeYouChi)
        {
            normalImage = [UIImage imageNamed:@"收藏_click"];
            selImage   = [UIImage imageNamed:@"收藏_click"];
            normalText = @"取消收藏";
            selText    = @"取消收藏";
        }
        [self.favorite  setTitle:normalText forState:UIControlStateNormal];
        [self.favorite  setTitle:selText forState:UIControlStateSelected];
        [self.favorite  setImage:normalImage forState:UIControlStateNormal];
        [self.favorite  setImage:selImage forState:UIControlStateSelected];
        
    }
    
}


- (void)_init2
{
    UIColor *sc = color_yellow;
    [self.like setTitleColor:sc forState:UIControlStateSelected];
    [self.favorite setTitleColor:sc forState:UIControlStateSelected];
}

-(void)onClick:(UIButton *)button{
    _selectedIndex = button.tag-1;

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setselectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)updateWithIsLike:(BOOL)like isFavorite:(BOOL)favorite
{
    _like.selected = like;
    _favorite.selected = favorite;
    
}

- (void)updateWithIsLike:(BOOL)like isFavorite:(BOOL)favorite likeCount:(int)likeCount commentCount:(int)commentCount
{
    [self updateWithIsLike:like isFavorite:favorite];
    [_like setTitle:[[NSString alloc]initWithFormat:@"赞 %d",likeCount] forState:UIControlStateNormal];
    [_like setTitle:[[NSString alloc]initWithFormat:@"已赞 %d",likeCount] forState:UIControlStateSelected];
    [_comment setTitle:[[NSString alloc]initWithFormat:@"评论 %d",commentCount] forState:UIControlStateNormal];
   
}

- (void)updateWithModel:(YCChihuoyingM_1_2 *)m
{
    [self updateWithIsLike:m.isLike.boolValue isFavorite:m.isFavorite.boolValue likeCount:m.likeCount.intValue commentCount:m.commentCount.intValue];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

@interface YCLeftCommentControl ()
{
    NSMutableArray *_labels;
}
@end

@implementation YCLeftCommentControl

- (void)dealloc{
    //ok
}
- (void)prepareForInterfaceBuilder{
    [self _init];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    
    
}

- (void)_init{
    
    float h = 5;
    self.opaque = YES;
    self.exclusiveTouch = NO;
    self.userInteractionEnabled = YES;
    self.enabled = YES;
    
    self.share.layer.cornerRadius  =self.frame.size.height/2-15;
    self.share.layer.masksToBounds = YES;
    [self.comment setTitle:@"分享" forState:UIControlStateNormal];
    [self.comment setImage:[UIImage imageNamed:@"转发"] forState:UIControlStateNormal];
    
#pragma mark---赞
    [self.like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(YCButtonLeft+1);
        make.centerY.equalTo(self);
        make.height.equalTo(self.mas_height).offset(-h*2);
        make.width.mas_equalTo(60);
    }];
    
    UILabel *lb =[self onCreach];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.like.mas_right).offset(1);
        make.centerY.equalTo(self.like);
        make.height.equalTo(self.like.mas_height).offset(-4*YCLeft);
        make.width.mas_equalTo(@1);
    }];
    
    
#pragma mark---评论
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.like.mas_right).offset(YCLeft);
        make.centerY.equalTo(self.like);
        make.height.equalTo(self.like.mas_height);
        make.width.equalTo(self.like.mas_width);
    }];
    
    UILabel *lb1 =[self onCreach];
    
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.comment.mas_right).offset(1);
        make.centerY.equalTo(self.comment);
        make.height.equalTo(self.comment.mas_height).offset(-4*YCLeft);
        make.width.mas_equalTo(@1);
    }];
    
    
#pragma mark---收藏
    
    [self.favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.comment.mas_right).offset(YCLeft);
        make.centerY.equalTo(self.comment);
        make.height.equalTo(self.comment.mas_height);
        make.width.equalTo(self.comment.mas_width).offset(8);
    }];
    
    [self.share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-YCLeft);
        make.centerY.equalTo(self.comment);
        make.height.equalTo(self.comment.mas_height).offset(-10);
        
        
        make.width.mas_equalTo(69);
    }];
    
    [self.inputControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
}


-(UILabel *)onCreach
{
    UILabel *label = [[UILabel alloc]init];
//    label.backgroundColor = KBGCColor(@"#b6b6b6");
    label.hasLeftLine = YES;
    [self addSubview:label];
    return label;
    
}

- (UIButton *)share{
    if (!_share) {
        _share = [UIButton onCearchButtonWithImage:@"评论2" SelImage:nil Title:@"评论" Target:self action:@selector(onClick:)];
        _share.backgroundColor = KBGCColor(@"#dab96a");
        [_share setTitleColor:KBGCColor(@"#ffffff") forState:UIControlStateNormal];
        _share.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0,5);
        _share.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0,0);
        _share.tag = 4;
        [self addSubview:_share];
    }
    return _share;
}

- (YCInputControl *)inputControl
{
    if (!_inputControl) {
        _inputControl = [YCInputControl new];
        
        [self addSubview:_inputControl];
        
        
        _inputControl.hidden = YES;
        
        _inputControl.send.backgroundColor = KBGCColor(@"#dab96a");
        _inputControl.send.titleLabel.font = [UIFont systemFontOfSize:12];
        _inputControl.send.clipsToBounds = YES;
        _inputControl.send.cornerRadius = 4;
        
        _inputControl.content.borderColor = [UIColor colorWithHex:0xd8d8dc];
        _inputControl.content.borderWidth = 1;
        _inputControl.content.cornerRadius = 5;
    }
    return _inputControl;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    self.inputControl.hidden = NO;
    [self bringSubviewToFront:self.inputControl];
    return [self.inputControl.content becomeFirstResponder];
}


- (BOOL)resignFirstResponder
{
    self.inputControl.hidden = YES;
    [self sendSubviewToBack:self.inputControl];
    return [self.inputControl.content resignFirstResponder];
}

- (void)updatePlaceholder:(NSString *)placeholder
{
    _inputControl.content.placeholder = placeholder;
}
@end
