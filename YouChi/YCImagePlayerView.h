//
//  YCImagePlayerView.h
//  YouChi
//
//  Created by sam on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <ImagePlayerView/ImagePlayerView.h>
#import "YCCatolog.h"
#import "YCModel.h"

typedef void(^YCImagePlayerViewUpdateBlock)(__kindof NSObject *model,UIImageView *imageView);
@interface YCImagePlayerView : ImagePlayerView <ImagePlayerViewDelegate>
@property (nonatomic,copy) YCNextBlock didTapBlock;
@property (nonatomic,copy) YCImagePlayerViewUpdateBlock updateBlock;

@property (nonatomic,copy) NSArray *dataSource;
@property (nonatomic,assign) BOOL shouldAutoScrollWhenScroll;
- (void)reloadImageData;
- (void)setDidTapBlock:(YCNextBlock)didTapBlock;
- (void)setUpdateBlock:(YCImagePlayerViewUpdateBlock)updateBlock;
- (void)setShopUpdateBlock;
@end

typedef void(^YCADViewBlock)(NSInteger index,UIImageView *imageView);
@interface YCADView : ImagePlayerView <ImagePlayerViewDelegate>
@property (nonatomic,assign) BOOL shouldAutoScrollWhenScroll;
@property (nonatomic,strong) YCADViewBlock updateBlock;
@property (nonatomic,strong) YCADViewBlock selectBlock;
- (void)reloadImageData:(NSArray *)imageDatas;
- (void)setUpdateBlock:(YCADViewBlock)updateBlock;
- (void)setSelectBlock:(YCADViewBlock)selectBlock;
@end

