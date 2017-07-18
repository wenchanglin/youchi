//
//  LocalImageCollectionViewCell.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/24.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalImageCollectionViewCell : UICollectionViewCell
{
    BOOL selectFlag;
}

@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) UIImageView *selectImageView;

- (void)sendValue:(id)dic;
- (void)setSelectFlag:(BOOL)flag;

@end
