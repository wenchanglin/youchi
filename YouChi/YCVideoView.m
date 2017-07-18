//
//  YCVideoView.m
//  YouChi
//
//  Created by 李李善 on 15/10/22.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCVideoView.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"
#import "YCMarcros.h"
#import "YCView.h"
@interface YCVideoView ()
{
    int _lfont;
}
@end
@implementation YCVideoView

- (void)dealloc{
    //ok
}
//- (void)prepareForInterfaceBuilder
//{
//    [self awakeFromNib];
//}


- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    [self _init];
    
}
-(void)_init{
    
    _lfont = 14;
    
    [self.imagvBj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.equalTo(self.mas_height).offset(-30);
    }];
    
    [self.imagvContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imagvBj);
    }];
    
    [self.lTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagvBj.mas_bottom).offset(6);
        make.right.left.equalTo(self.imagvBj);
        make.height.equalTo(@16);
    }];
    

}
-(UILabel *)lTitle{
    
    
    if (!_lTitle) {
        _lTitle = [UILabel new];
        [_lTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:_lfont]];
        [self addSubview:_lTitle];
    }
    return _lTitle;
}

-(UIImageView *)imagvBj
{
    if (!_imagvBj) {
    _imagvBj =  [UIImageView new];
    _imagvBj.contentMode =UIViewContentModeScaleAspectFill;
    _imagvBj.clipsToBounds = YES;
    [self addSubview:_imagvBj];
}
    return _imagvBj;
    
}
-(UIImageView *)imagvContent
{
    if (!_imagvContent) {
    _imagvContent = [UIImageView new];
    _imagvContent.bounds= CGRectMake(0, 0, 50, 50);
    _imagvContent.image = [UIImage imageNamed:@"视频按钮_default"];
    _imagvContent.image = [UIImage imageNamed:@"视频按钮_click"];
    
    _imagvContent.contentMode =UIViewContentModeScaleAspectFill;
    [self addSubview:_imagvContent];
}
    return _imagvContent;
    
}


-(void)onUpdataBtnImage:(NSURL *)image content:(NSString *)centent
{
    [_imagvBj sd_setImageWithURL:image placeholderImage:AVATAR];
    _lTitle.text = [NSString stringWithFormat:@" %@",centent];
    
}


@end
