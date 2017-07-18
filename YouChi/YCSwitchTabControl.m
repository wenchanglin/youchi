//
//  YCSwitchTabControl.m
//  YouChi
//
//  Created by 李李善 on 15/8/5.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSwitchTabControl.h"
#import "YCView.h"
#pragma mark -
@implementation YCSwitchTabControl
{
    NSMutableArray *_segments;
    UIButton *_lastSegment;
    UIView *_segmentLine;
}
-(void)dealloc{
    //    ok
    
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    self.backgroundColor =[UIColor clearColor];
    self.opaque = YES;
    
    _segments = [NSMutableArray new];
    
    UIView *view = [[UIView alloc]init];
    [self addSubview:view];
    _segmentLine = view;
    _segmentLine.backgroundColor = KBGCColor(@"#d09356");
    
//    [self setSelectedSegmentIndex:0];
    _selectedSegmentIndex = 0;
    _segmentFont = [UIFont systemFontOfSize:18];
    _segmentLineHeight = 2.f;
}

- (void)insertSegmentWithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    }
    if (image) {
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    }
    [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
    [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
    
    btn.titleLabel.font = self.segmentFont;
    
    [self addSubview:btn];
    
    
    if (_segments.count ==0) {
        btn.selected = YES;
        _lastSegment = btn;
    }
   
    
    [_segments addObject:btn];
   
    
    [self setNeedsLayout];
    
}



- (void)setIsSegmentLineHidden:(BOOL)isSegmentLineHidden
{
    if (_isSegmentLineHidden != isSegmentLineHidden)
    {
        _isSegmentLineHidden = isSegmentLineHidden;
        _segmentLine.hidden = isSegmentLineHidden;
    }
}

- (void)insertSegmentWithTitle:(NSString *)title image:(NSString *)image
{
    [self insertSegmentWithTitle:title image:image selectedImage:nil];
}


- (void)onClick:(UIButton *)sender
{
    NSUInteger idx = [_segments indexOfObject:sender];
    if (idx == _selectedSegmentIndex) {
        return;
    }
    _lastSegment.selected = NO;
    sender.selected = YES;
    _selectedSegmentIndex = idx;
    _lastSegment = sender;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
  
}



#pragma mark --setSelectedSegmentIndex:
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (_selectedSegmentIndex != selectedSegmentIndex) {
        UIButton *sender = _segments[selectedSegmentIndex];
        _lastSegment.selected = NO;
        sender.selected = YES;
        _selectedSegmentIndex = selectedSegmentIndex;
//        [self sendActionsForControlEvents:UIControlEventValueChanged];
//        _segmentLine.center = CGPointMake(sender.center.x, _segmentLine.center.y);
        _lastSegment = sender;
    }
   
}
- (void)setAllButtonSelected:(BOOL)selected
{
    for (UIButton *btn in _segments) {
        btn.selected = selected;
    }
}

- (void)setButtonSelected:(BOOL)selected at:(NSInteger)index
{
    [_segments[index] setSelected:selected];
    
}

- (void)segmentLineScrollToIndex:(NSInteger )index animate:(BOOL)animate
{
    UIButton *sender = _segments[index];
    if (animate) {
       
        POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        anSpring.toValue = @(sender.center.x);
        anSpring.beginTime = CACurrentMediaTime();
        anSpring.springBounciness = 10.0f;
        [_segmentLine pop_addAnimation:anSpring forKey:@"position"];
        
    } else {
        
        [UIView animateWithDuration:0.2f animations:^{
            _segmentLine.center = CGPointMake(sender.center.x, _segmentLine.center.y);
            
        } completion:^(BOOL finished) {
        }];
        
    }

}

#pragma mark-------
- (void)onCreachSpecialWithSelColor:(UIColor *)selColor  normalColor:(UIColor *)normalColor font:(CGFloat)font{
    
    if (selColor ==nil) {
        selColor = KBGCColor(@"#d09356");
    }
    if (normalColor ==nil) {
        normalColor= KBGCColor(@"#535353");
    }
    if (font ==0) {
        font = 14;
    }
    self.selectedColor =selColor;
    self.normalColor =normalColor;
    [self setSegmentFont:[UIFont fontWithName:@"Helvetica-Bold" size:font]]; //加粗
//    [self setSegmentFont:[UIFont systemFontOfSize:font]];

}



- (void)setSegmentLineColor:(UIColor *)segmentLineColor
{
    self.segmentLine.backgroundColor = segmentLineColor;
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float ww = CGRectGetWidth(self.bounds);
    float hh = CGRectGetHeight(self.bounds);
    
    float w = ww/_segments.count;
    float h = hh;
    
    if (_segments.count>0) {
        for (int n = 0; n<_segments.count; n++) {
            UIButton *btn = _segments[n];
            btn.frame = CGRectMake(n*w, 0, w, h);
         
        }
        UIButton *selectedSegment = _segments[_selectedSegmentIndex];
        CGRect rect = selectedSegment.frame;
        rect.origin.y = hh - _segmentLineHeight;
        rect.size.height = _segmentLineHeight;
        _segmentLine.frame = rect;
        selectedSegment.selected = YES;
    }
    
 
}


#pragma mark - interface
- (NSUInteger)numberOfSegments{
    return _segments.count;
}

#pragma mark --字体
- (void)setSegmentFont:(UIFont *)segmentFont{
    _segmentFont = segmentFont;
    [_segments enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btn.titleLabel.font = segmentFont;
    }];
}

- (void)setLoginsSegmentIndex:(NSInteger)loginsSegmentIndex{

    UIButton *selectedSegment = _segments[0];
    [self onClick:selectedSegment];
}

#pragma mark --选中图片
- (void)insertselectedImage:(NSArray *)images{
    for (int n = 0; n<_segments.count; n++) {
        UIButton *btn = _segments[n];
        [btn setImage:[UIImage imageNamed:images[n]] forState:UIControlStateSelected];
    }
    
}

#pragma mark --按钮不同状态背景颜色
- (void)setNormalBGColor:(UIColor*)normalColor selectedBGColor:(UIColor *)selectedColor{
    
    
    [self layoutIfNeeded];
    
    for (int n = 0; n<_segments.count; n++) {
        
        UIButton *btn = _segments[n];
        
        [btn setNormalBgColor:normalColor selectedBgColor:selectedColor];
        
    }
}



#pragma mark --按钮选中颜色
- (void)setSelectedColor:(UIColor *)selectedColor{
    
    if (_selectedColor == nil) {
        
        selectedColor = KBGCColor(@"#d09356");
    }
    
    _selectedColor = selectedColor;
    [_segments enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    }];
}

#pragma mark --按钮 普通状态 字体颜色
- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    [_segments enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
    }];
}

#pragma mark --按钮 cornerRadius
- (void)buttonCornerRadius:(CGFloat)cornerRadius{
    
    [_segments enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        
        btn.cornerRadius = cornerRadius;
        
    }];
}

@end
