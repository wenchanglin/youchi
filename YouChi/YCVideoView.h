//
//  YCVideoView.h
//  YouChi
//
//  Created by 李李善 on 15/10/22.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE@interface YCVideoView : UIControl

@property(nonatomic,strong) UILabel *lTitle;

@property(nonatomic,strong) UIImageView *imagvBj;

@property(nonatomic,strong) UIImageView *imagvContent;
-(void)onUpdataBtnImage:(NSURL *)image content:(NSString *)centent;
@end
