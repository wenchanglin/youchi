//
//  YCChihuoyingTwoCell.h
//  YouChi
//
//  Created by 李李善 on 15/5/29.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCImageSelectControl.h"
#import "YCPhotosView.h"
#import "YCChihuoyingCell.h"
#import "YCCollectionPhotoCell.h"
///随手拍
@interface YCChihuoNubmerCell : YCChihuoyingCell

@property (weak, nonatomic)IBOutlet YCAvatarControl *avatarControl;
@property (weak, nonatomic) IBOutlet YCImageSelectControl *imageSelectControl;

@property (weak, nonatomic) IBOutlet YCPhotosView *photosView;
@property (weak, nonatomic) IBOutlet YCImageSelectControl *relativeView;
@property (weak, nonatomic) IBOutlet UILabel *locationDesc;
@property (weak, nonatomic) IBOutlet UILabel *lRelativeTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (weak, nonatomic) IBOutlet UIView *recommandView;

- (void)update:(id)model atIndexPath:(NSIndexPath *)indexPath;
@end

