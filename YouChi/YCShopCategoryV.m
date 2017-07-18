//
//  YCShopCategoryV.m
//  YouChi
//
//  Created by 李李善 on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCShopCategoryV.h"
#import "UIButton+MJ.h"
#import "YCView.h"


#import "YCMarcros.h"

@interface YCShopCategoryV ()
{   UIButton *_selsctBtn;
    NSMutableArray *_btns;
    UIView *_line;
}
@end
@implementation YCShopCategoryV

//-(instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self==[super initWithCoder:aDecoder]) {
//        [self _init];
//    }
//    return self;
//}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self _init];
}


-(void)_init{
    
    _btns = [NSMutableArray arrayWithCapacity:0];
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = KBGCColor(@"d09356");
    [self addSubview:view];
    _line = view;
    _line.frame = CGRectMake(3, 33, 60, 2);
}

-(void)setTitles:(NSMutableArray *)titles{
    if (_titles != titles) {
        _titles = titles;
        
        [_btns makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_btns removeAllObjects];
        
        for (int i = 0; i<titles.count; i++) {
            NSString *title = titles[i];
            ///按钮
            UIButton *button = [UIButton onCearchButtonWithImage:nil SelImage:nil Title:title Target:self  action:@selector(onClickBtn:)];
            button.titleLabel.font = KFont(16);
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:KBGCColor(@"#272636") forState:UIControlStateNormal];
            [button setTitleColor:KBGCColor(@"d09356") forState:UIControlStateSelected];
            button.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
            button.tag = i+1;
            [_btns addObject:button];
             [self addSubview:button];
           
           
        }
        
    }
    [self setNeedsLayout];
}

#pragma mark - runtime objects

-(void)onClickButton:(onClickButton)click{
    [self setOnClickButton:click];
}

- (void)setOnClickButton:(onClickButton)onClickButton {
    objc_setAssociatedObject(self, @selector(onClickButton),onClickButton, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (onClickButton)onClickButton {
    return objc_getAssociatedObject(self, _cmd);
}

-(void)onClickBtn:(UIButton *)btn
{
    onClickButton clickButton = [self onClickButton];
    if (clickButton) {
        clickButton(btn,btn.tag);
    }
    
    int idx = (int)[_btns indexOfObject:btn];
    _selsectBtnInteger = idx;
    
    _selsctBtn.selected = NO;
    btn.selected = YES;
    btn.titleLabel.font = KFontBold(15);
    _selsctBtn = btn;
    
    for (UIButton *btn in _btns) {
        
        if (!btn.selected) {
            btn.titleLabel.font = KFont(14);
        }
    }

    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    
    float toValue = btn.center.x;
    
    if (toValue == 0.) {
        toValue = 35.;
    }
    
    anSpring.toValue = @(toValue + 1);
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.springBounciness = 10.0f;
    [_line pop_addAnimation:anSpring forKey:@"position"];
    
    
}


-(void)setSelsectBtnInteger:(int)selsectBtnInteger{
    
    if (selsectBtnInteger== 0 ||selsectBtnInteger > self.titles.count) {
        
        return;
    }
    _selsectBtnInteger = selsectBtnInteger;
    if (_btns.count !=0 ) {
        UIButton *button = _btns[selsectBtnInteger -1];
        
        [self onClickBtn:button];
        
    }
}



-(void)setImgs:(NSMutableArray *)imgs{
    if (_imgs != imgs) {
        _imgs = imgs;
        if (_btns.count==0) return;
        for (int i =0; i <imgs.count; i++) {
            NSString *imag = imgs[i];
            UIButton *button = _btns[i];
            [button setImage:[UIImage imageNamed:imag] forState:UIControlStateNormal];
        }
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    CGFloat ww= self.bounds.size.width;
    CGFloat width = 75;
    for (int i = 0;i<_btns.count;i++){
         CGFloat x = width*i;
        UIButton *button = _btns[i];
        
        button.frame = CGRectMake(x, 0, width, 38);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
