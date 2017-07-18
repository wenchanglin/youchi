//
//  UIButton+MJ.m
//  YouChi
//
//  Created by 李李善 on 15/5/21.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "UIButton+MJ.h"
#import "YCMarcros.h"
#define KBtnWH 60
#define YCQianMingFont 10
@implementation UIButton (MJ)
- (void)dealloc{
    //ok
}

+(UIButton *)oncrearbuttonSuperFrame:(CGRect)frame Count:(int)Count Row:(int)row Column:(int)column
{

    
    CGPoint point = [self  onPointbuttonSuperFrame:frame Count:Count Row:row Column:column];
   
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = (CGRect ){point,CGSizeMake( KBtnWH, KBtnWH)};
        button.backgroundColor = [UIColor redColor];
        button.tag = Count + 1;//1~12
    return button;
    
}
+(CGPoint)onPointbuttonSuperFrame:(CGRect)frame Count:(int)Count Row:(int)row Column:(int)column{
  
    
    int rowLength = row;//行与行之间的距离(行间距)
    int columnLength = column;//列与列之间的间距(列间距)
    //用i表示行   用j表示列
    int i = Count / 4; // 行
    int j = Count % 4; // 列
    
    //x = j 个组合+ 一个列间距
    int x = j * (KBtnWH + columnLength) + columnLength;
    
    //y = i 个组合 + 一个行间距
    int y = i * (KBtnWH + rowLength) + rowLength+95;
    
    return CGPointMake(x,y);
}


+(UIButton *)onCreatebuttonTarget:(id)target action:(SEL)action Image:(NSString *)image Frame:(CGRect)frame
{
    UIButton *button = [self onCearchButtonWithImage:image SelImage:nil Title:nil Target:target action:action];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.frame =frame;

    return button;
}


+(instancetype)onCearchButtonWithBackgroundImage:(NSString *)Image Title:(NSString *)title Target:(id)target action:(SEL)action
{
    UIButton *button = [self onCearchButtonWithImage:nil SelImage:nil Title:title Target:target action:action];
    [button setBackgroundImage:[UIImage imageNamed:Image] forState:UIControlStateNormal];
  
    return button;
}

+(instancetype)onCearchButtonWithImage:(NSString *)Image SelImage:(NSString *)SelImage Title:(NSString *)title Target:(id)target action:(SEL)action
{
    UIButton *btton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (Image != nil&&![Image isEqualToString:@""]){
        [btton setImage:[UIImage imageNamed:Image] forState:UIControlStateNormal];
    }
    if (SelImage != nil&&![SelImage isEqualToString:@""]){
        [btton setImage:[UIImage imageNamed:SelImage] forState:UIControlStateSelected];
        [btton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,2.5)];
    }
    if (title != nil&&![title isEqualToString:@""]){
        btton.titleLabel.font =[UIFont systemFontOfSize:YCQianMingFont];
        [btton setTitle:title forState:UIControlStateNormal];
        [btton setTitleColor:KBGCColor(@"#272636") forState:UIControlStateNormal];
        [btton setTitleEdgeInsets:UIEdgeInsetsMake(0,2.5, 0,0)];
    }
    if (target!=nil &&action != nil) {
        [btton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    btton.userInteractionEnabled = YES;
    return btton;
}
@end
