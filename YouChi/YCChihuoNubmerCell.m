//
//  YCChihuoyingTwoCell.m
//  YouChi
//
//  Created by 李李善 on 15/5/29.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCChihuoNubmerCell.h"
#import "YCChihuoyingM.h"

@implementation YCChihuoNubmerCell
- (void)dealloc{
    //ok
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self _setup];
}


- (void)_setup
{
    //*
    self.avatarControl.clipsToBounds = YES;
    self.avatarControl.sign.numberOfLines = 1;
    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
    
    [_photosView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cell0];
    _photosView.scrollsToTop = NO;
    
    
    [_imageSelectControl addTarget:self action:@selector(onImageSelect:) forControlEvents:UIControlEventValueChanged];
    _imageSelectControl.imageCount = 6;
    _imageSelectControl.showSelected = YES;
    _imageSelectControl.edge = UIEdgeInsetsMake(2, 4, 2, 4);
    _imageSelectControl.gap = 4;
    _imageSelectControl.containerControlType = YCContainerControlTypeHorizion;
    _relativeView.imageCount = 5;
    _relativeView.gap = 4;
    self.lContent.displaysAsynchronously = YES;
    self.lContent.ignoreCommonProperties = YES;
    
    _photosView.backgroundColor = [UIColor whiteColor];
    _photosView.updateBlock = ^(UICollectionViewCell *cell,YCBaseImageModel *m) {
        if (isOldOSS(m.imagePath)) {
            [cell.contentView ycNotShop_setImageWithURL:IMAGE_MEDIUM(m.imagePath) placeholder:PLACE_HOLDER];
        } else {
            [cell.contentView yc_setImageWithURL:IMAGE_HOST_1_2_get(m.imagePath) placeholder:PLACE_HOLDER];
        }
        
    };
    
    WSELF;
    
    _photosView.pageBlock = ^(NSIndexPath *indexPath,YCBaseImageModel *model) {
        SSELF;
        @try {
            self.imageSelectControl.selectedIndex = indexPath.row;
            self.model.selectedIndex = indexPath.row;
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            ;
        }
    };
    
    _photosView.sizeBlock = ^(CGSize size) {
        return size;
    };
    

     //*/
}

- (void)onImageSelect:(YCImageSelectControl *)sender{
    NSUInteger idx = sender.selectedIndex;
    
    @try {
        [_photosView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        self.model.selectedIndex = idx;
    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }

    
}

- (void)prepareForReuse{
    [super prepareForReuse];
        
    
}



- (void)update:(YCChihuoyingM_1_2 *)model atIndexPath:(NSIndexPath *)indexPath{

    //*
    [super update:model atIndexPath:indexPath];
    
    //*
    [self.avatarControl updateAvatarControlWith:model.userImage name:model.userName sign:model.signature];
    
    [self.likeCount updateLikeCount:model.likeCount.intValue];
    
    
    [_photosView performBatchUpdates:^{
        _photosView.photos = model.youchiPhotoList;
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
        [_photosView deleteSections:set];
        [_photosView insertSections:set];
        
        
    } completion:nil];
    
    [_imageSelectControl updateImagesWithPageModels:model.youchiPhotoList];
    
    [_relativeView updateImagesWithPageModels:model.recipeList];
    _relativeView.showDefault = (model.recipeList.count == 0);
    //*
//    @try {
        //
        NSUInteger selectedIndex = model.selectedIndex;
        if (_imageSelectControl.selectedIndex != selectedIndex) {
            _imageSelectControl.selectedIndex = selectedIndex;
            [_photosView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        
        
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",exception);
//    }
//    @finally {
//        ;
//    }
    
    
 
    

    if (_locationDesc) {
        _locationDesc.text = model.city;
    }
    
    self.lContent.textLayout = model.textLayout;
    self.lContent.attributedText = model.textLayout.text;;
    self.contentHeight.constant = model.textLayout.textBoundingSize.height;
    
    BOOL relative = model.recipeList.count > 0;
    self.relativeHeight.constant = relative ? 80 : 0;
    self.recommandView.hidden = !relative;
    
    if (_lRelativeTitle) {
        _lRelativeTitle.text = [[NSString alloc] initWithFormat:@"%d个相关食材的秘籍",(int)model.recipeCount.intValue];
    }
    //*/

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end

