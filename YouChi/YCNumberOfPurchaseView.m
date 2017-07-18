//
//  YCNumBerOfPurchaseView.m
//  YouChi
//
//  Created by 朱国林 on 16/5/16.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNumberOfPurchaseView.h"
#import "YCCollectionPhotoCell.h"
#import "YCView.h"
#import "YCItemDetailM.h"

@implementation YCNumberOfPurchaseView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        WSELF;
        UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 8;
        layout.sectionInset = UIEdgeInsetsZero;
        //设置方向
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _photosView = [[YCPhotosView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photosView.showsHorizontalScrollIndicator = NO;
        [_photosView registerClass:[YCCollectionPhotoCell class] forCellWithReuseIdentifier:cell0];
        
        [self addSubview:_photosView];
        
        _lTitle = [YYLabel newInSuperView:self];
        
        
        CGFloat titleHeight = 30;
        [self setLayoutBlock:^(YCView *__weak view, CGRect frame) {
            SSELF;
            self.lTitle.frame = frame;
            self.lTitle.height = titleHeight;
            
            self.photosView.frame = frame;
            self.photosView.height = frame.size.height - titleHeight;
            
            self.photosView.top = titleHeight;
        }];
    }
    return self;
}

-(void)yc_initView
{
    self.backgroundColor = _photosView.backgroundColor = [UIColor whiteColor];
    _lTitle.font = [UIFont systemFontOfSize:10];
    _lTitle.textColor = [UIColor colorWithHexString:@"#232313"];
    _lTitle.text = @"  已参与团拼人数";
    
    self.photosView.updateBlock = ^(YCCollectionPhotoCell *cell,YCShopGroupBuySubM *subM) {
        //TODO:显示图片方法改变
        
        YCLoginUserM *m = subM.appUser;
        [cell.avatar yc_setImageWithURL:IMAGE_HOST_NOT_SHOP(m.imagePath) placeholder:AVATAR];
    };
    
    
    self.photosView.sizeBlock = ^(CGSize size) {
        return CGSizeMake(30, 30);
//        CGFloat h = size.height-10;
//        return CGSizeMake(h, h);
    };
}



- (void)onUpdataAvatar:(NSArray *)avatarList
{
    
    if (self.photosView.photos != avatarList ) {
        self.photosView.photos = avatarList;
        
        [self.photosView performBatchUpdates:^{
            
            NSIndexSet *idp = [NSIndexSet indexSetWithIndex:0];
            [self.photosView deleteSections:idp];
            [self.photosView insertSections:idp];
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}


+ (CGFloat)preferHeight:(CGFloat)h
{
    return 70.f;
}
@end
