//
//  YCNewsCell.m
//  YouChi
//
//  Created by 朱国林 on 15/8/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNewsCell.h"
#import "YCView.h"
#import "YCNewsM.h"
#import "NSString+MJ.h"

@implementation YCNewsCell
- (void)dealloc{
    //    OK
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    
    [_bFavorite setNormalBgColor:KBGCColor(@"dab96a") selectedBgColor:KBGCColor(@"#535353")];
    
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.clipsToBounds = YES;
}


- (void)update:(YCNewsList *)model atIndexPath:(NSIndexPath *)indexPath{

//    if (indexPath.row == 0) {
//       
//        NSMutableArray *array=[NSMutableArray arrayWithCapacity:0];
//        NSString *str;
//        for(int i=1;i<61;i++)
//        {
//            str=[NSString stringWithFormat:@"A_%d.JGP",i];
//            UIImage *image=[UIImage imageNamed:str];
//            [array addObject:image];
//            NSLog(@"%@",str);
//        }
//        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//        imageView.animationImages=array;
//        imageView.animationDuration=1.5;//duration :持续 持续时间
//        imageView.animationRepeatCount=10000;//重复次数
//        [self addSubview:imageView];
//        [imageView startAnimating];
//       
//    }
    
    [self.imgView ycNotShop_setImageWithURL:IMAGE_MEDIUM(model.imagePath) placeholder:PLACE_HOLDER];
    self.lTitle.text = model.title;


    self.lAuthor.text = model.author;
    
    BOOL isFavorite =  !model.isFavorite.boolValue;
    
    self.bFavorite.selected = !isFavorite;
    
    //  当收藏数是 0 时 显示 收藏， 当收藏数>0时显示 已收藏（999）；
    NSString *btnTitle;
    
    btnTitle = isFavorite?@"收藏":@"已收藏";
    btnTitle = (![model.favoriteCount intValue])?@"收藏":[NSString stringWithFormat:@"%@(%@)",btnTitle,model.moreFavoriteCount];

    [self.bFavorite setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
