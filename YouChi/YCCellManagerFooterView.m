//
//  YCCellManagerFooterView.m
//  YouChi
//
//  Created by water on 16/6/15.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCellManagerFooterView.h"
#import "YCCellManagerFrame.h"
#import "YCChihuoyingM.h"



@interface YCCellManagerFooterView ()

@property (strong,nonatomic) NSMutableArray *btns;
@property (strong,nonatomic) NSMutableArray *images;

@property (strong,nonatomic) UIButton *collectBtn;
@property (strong,nonatomic) UIButton *commentBtn;
@property (strong,nonatomic) UIButton *attitudeBtn;

@end

@implementation YCCellManagerFooterView

-(NSMutableArray *)btns{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

-(NSMutableArray *)images{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
//        self.image = [UIImage resizeImageWithName:@"timeline_card_bottom_background_os7"];
//        self.highlightedImage = [UIImage resizeImageWithName:@"timeline_card_top_background_highlighted_os7"];
        
//        self.collectBtn = [self addBtnWithTitle:@"转发" image:@"timeline_icon_retweet_os7" bgImage:@"timeline_card_leftbottom_highlighted_os7"];
//        self.commentBtn = [self addBtnWithTitle:@"评论" image:@"timeline_icon_comment_os7" bgImage:@"timeline_card_middlebottom_highlighted_os7"];
//        self.attitudeBtn = [self addBtnWithTitle:@"赞" image:@"timeline_icon_unlike_os7" bgImage:@"timeline_card_rightbottom_highlighted_os7"];
        
//        [self addDivers];
//        [self addDivers];
    }
    return self;
}

-(void)setBtn:(UIButton *)btn title:(NSString *)originalTitle count:(int)count{
    if (count) {
        if (count>10000) {
            float num;
            num = count/10000.0;
            NSString *numTitle = [NSString stringWithFormat:@"%.1f万",num];
            numTitle = [numTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
            [btn setTitle:numTitle forState:UIControlStateNormal];
        }else{
            [btn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
        }
    }else{
        [btn setTitle:originalTitle forState:UIControlStateNormal];
    }
}

-(UIButton *)addBtnWithTitle:(NSString *)title image:(NSString *)img bgImage:(NSString *)bgImg{
    UIButton *btn = [[UIButton alloc] init];
    btn.adjustsImageWhenHighlighted = NO;
//    [btn setImage:[UIImage resizeImageWithName:img] forState:UIControlStateNormal];
    //[btn setImage:[UIImage resizeImageWithName:bgImg] forState:UIControlStateHighlighted];
//    [btn setBackgroundImage:[UIImage resizeImageWithName:bgImg] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    [self.btns addObject:btn];
    return btn;
}

-(void)addDivers{
    UIImageView *iv = [[UIImageView alloc] init];
//    iv.image = [UIImage resizeImageWithName:@"timeline_card_bottom_line_os7"];
    //iv.highlightedImage = [UIImage resizeImageWithName:@"timeline_card_bottom_line_highlighted_os7"];
    [self addSubview:iv];
    [self.images addObject:iv];
}

-(void)setManagerFrame:(YCCellManagerFrame *)managerFrame{
    _managerFrame = managerFrame;
    [self setBtn:self.attitudeBtn title:@"赞" count:managerFrame.model.likeCount.intValue];
    [self setBtn:self.commentBtn title:@"评论" count:managerFrame.model.commentCount.intValue];
    [self setBtn:self.collectBtn title:@"收藏" count:managerFrame.model.favoriteCount.intValue];
    
    self.frame = managerFrame.footerViewF;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    float dividerW = 2;
    float btnw = ([UIScreen mainScreen].bounds.size.width - 20-2*dividerW)/3;
    for (int i = 0; i<self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        btn.frame = CGRectMake(i*(btnw+dividerW), 0, btnw, self.frame.size.height);
    }
    
    for (int j = 0; j<self.images.count; j++) {
        UIImageView *iv = self.images[j];
        iv.frame = CGRectMake(btnw+(dividerW+btnw)*j, 0, 2, self.frame.size.height);
    }
}




@end
