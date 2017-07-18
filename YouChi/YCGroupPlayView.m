//
//  YCGroupPlayView.m
//  YouChi
//
//  Created by 李李善 on 16/5/19.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGroupPlayView.h"
#import "YCView.h"
#import "Masonry.h"
#define NSMASAttStr NSMutableAttributedString
@interface YCGroupPlayView (){
    NSArray *_titleS;
}
@end

@implementation YCGroupPlayView
-(instancetype)init{
    if (self==[super init]) {
        
        NSMASAttStr *textLayout = [self creatTextLayoutAntTitleS:@[@"团拼发起人",@"选择商品"]];
        NSMASAttStr *textLayout2 = [self creatTextLayoutAntTitleS:@[@"选择统一",@"收货地址"]];
        NSMASAttStr *textLayout3 = [self creatTextLayoutAntTitleS:@[@"玩命要求",@"小伙伴",@"参与团拼"]];
        NSMASAttStr *textLayout4 = [self creatTextLayoutAntTitleS:@[@"团拼结束",@"与小伙伴",@"一同结账",@"享受低价"]];
        
        _titleS = [NSArray arrayWithObjects:textLayout,@"",textLayout2,@"",textLayout3,@"",textLayout4, nil];
        [self _init];
    
    }
    return self;
}

//1类型2括名3参数4block名

//(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
-(void)_init{
    
    
    for (int i = 0; i<7; i++) {
        if (i%2) {
            UIImageView *imageV =[UIImageView newInSuperView:self];
//            [imageV backColor:[UIColor redColor]];
//            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.image = IMAGE(@"箭一头");
         
        }else{
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.numberOfLines = 0.f;
            button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            NSString *imageName =[NSString stringWithFormat:@"团%d",i];
            UIImage *image = [UIImage imageNamed:imageName];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3);
            button.titleEdgeInsets = UIEdgeInsetsMake(15,0, 0, 0);
            [button setNormalImage:image];
            [button setNormalsetAttTitle:_titleS[i]];
            [button setNormalTitleColor:[UIColor blackColor]];
            [button setTitleFont:12];
            button.enabled = NO;
            [self addSubview:button];
        }
       }
}
//((SCREEN_WIDTH-16.f)-3*17)/4
-(NSMutableAttributedString *)creatTextLayoutAntTitleS:(NSArray *)titles
{
//    YYTextContainer *tc = [YYTextContainer containerWithSize:CGSizeMake(45, HUGE) insets:UIEdgeInsetsMake(0 ,5,0,5)];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:titles.firstObject];
    [title appendString:@"\n"];
    title.font = KFont(9);
    title.color = UIColorHex(#535353);
    title.lineSpacing = 8;
    for (int i =0; i <titles.count; i++) {
        if (i!=0) {
            NSMutableAttributedString *desc = [[NSMutableAttributedString alloc]initWithString:titles[i]];
            [desc appendString:@"\n"];
             desc.lineSpacing = 8;
            desc.font = KFont(9);
            desc.color = UIColorHex(#535353);
            [title appendAttributedString:desc];
        }
    }
    
//    return [YYTextLayout layoutWithContainer:tc text:title];
    return title;
}

-(void)layoutSubviews
{ [super layoutSubviews];
    float W = self.bounds.size.width;
    float H = self.bounds.size.height;
    float jW = 17.f;
    float BW = (W-jW*3)/4;
   __block float x;
    __block CGRect Frame;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if (idx%2) {
            
            Frame =CGRectMake(x, H/2, jW, 6);
            x = jW+x;
        }else{
            Frame = CGRectMake(x, 0, BW, H);
            x = BW+x;
        }
        obj.frame =Frame;
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
