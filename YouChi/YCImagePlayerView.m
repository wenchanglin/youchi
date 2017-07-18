//
//  YCImagePlayerView.m
//  YouChi
//
//  Created by sam on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCImagePlayerView.h"
#import <YYKit/YYKit.h>
#import "YCMarcros.h"
#import "YCView.h"
@implementation YCImagePlayerView

-(void)yc_initView{
    [self _setup];
}

- (void)_setup
{
    self.imagePlayerViewDelegate = self;
    self.pageControlPosition = ICPageControlPosition_BottomCenter;
    [self setShopUpdateBlock];
    
}

- (void)reloadImageData
{
    @try {
        BOOL b = self.dataSource.count>1;
        self.endlessScroll = b;
        self.hidePageControl = !b;
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (NSInteger)numberOfItems
{
    return self.dataSource.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    
    if (_updateBlock) {
        id model = self.dataSource[index];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _updateBlock(model,imageView);
    }
 
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    if (_didTapBlock) {
        _didTapBlock(@(index));
    }
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didScorllIndex:(NSInteger)index
{
    if (self.shouldAutoScrollWhenScroll == NO) {
        self.autoScroll = self.shouldAutoScrollWhenScroll;
    }
    
}

- (void)setShopUpdateBlock
{
    [self setUpdateBlock:^(__kindof YCBaseImageModel *model, UIImageView *imageView) {
        [imageView yc_setImageWithURL:IMAGE_HOST_SHOP(model.imagePath) placeholder:PLACE_HOLDER];
    }];
}
@end


@implementation YCADView
{
    NSArray *_imageDatas;
    NSInteger _count;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imagePlayerViewDelegate = self;
        self.pageControlPosition = ICPageControlPosition_BottomCenter;
    }
    return self;
}

- (void)reloadImageData:(NSArray *)imageDatas
{
    _count = imageDatas.count;
    
    self.shouldAutoScrollWhenScroll = YES;
    
    @try {
        BOOL b = imageDatas.count>1;
        self.endlessScroll = b;
        self.hidePageControl = !b;
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (NSInteger)numberOfItems
{
    return _count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    
    if (_updateBlock) {
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _updateBlock(index,imageView);
    }
    
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    if (_selectBlock) {
        _selectBlock(index,nil);
    }
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didScorllIndex:(NSInteger)index
{
    if (self.shouldAutoScrollWhenScroll == NO) {
        self.autoScroll = self.shouldAutoScrollWhenScroll;
    }
    
}

@end