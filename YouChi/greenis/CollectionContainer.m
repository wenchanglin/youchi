//
//  CollectionView.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/9/17.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "CollectionContainer.h"
#import "CollectionViewCell.h"
#import "Masonry.h"
#import "AppConstants.h"

@interface CollectionContainer() <CollectionViewCellDelegate> {
    
}

@property (strong,nonatomic) NSArray                *tags;

@end


@implementation CollectionContainer

- (instancetype)initWithTags:(NSArray*)tags
{
    self = [super init];
    if (self) {
        _tags = tags;
    }
    return self;
}
//自定义视图设置约束自己应该通过重写这个方法
- (void)updateConstraints {
    [super updateConstraints];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    //数组个数5
    NSUInteger tagsCount = [_tags count];
    NSLog(@"(unsigned long)tagsCount4444444444 %ld",(unsigned long)tagsCount);
//    collection个数6
    NSUInteger count = ((tagsCount / 3) + 1) * 3;
    NSLog(@"(unsigned long)count33333333333333  %ld",(unsigned long)count);
    UIView *lastView = nil;
    UIView *rightView = nil;
    for (int i = 0; i < count; ++i)
    {
        CollectionViewCell *subv;
        if (i == 0) {
            subv = [[CollectionViewCell alloc] initWithTitle:NSLocalizedString(@"topSearches", @"") andIndex:9999 andColor:[UIColor redColor] andIsTouchEnabled:NO];
        }
        else if (i > tagsCount) {
            subv = [[CollectionViewCell alloc] initWithTitle:@"" andIndex:9999 andColor:nil andIsTouchEnabled:NO];
        }
        else {
            subv = [[CollectionViewCell alloc] initWithTitle:[[_tags objectAtIndex:i - 1] valueForKey:@"tagName"]  andIndex:[[[_tags objectAtIndex:i - 1] valueForKey:@"tagId"] intValue] andColor:nil andIsTouchEnabled:YES];
        }
        
        if (i == 2) {
            rightView = subv;
        }
        
        subv.delegate = self;
        subv.layer.cornerRadius = 3;
        [self addSubview:subv];
        
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i % 3 == 0) {
                make.left.equalTo(self).with.offset(1);
            }
            else {
                make.left.equalTo(lastView.mas_right).with.offset(1);
            }
            
            int row = i / 3;
            int subvHeight = [AppConstants uiScreenHeight] / 15;
            make.top.equalTo(self.mas_top).with.offset((row * subvHeight) + (1 * row) + 1);
            make.width.mas_equalTo(([AppConstants uiScreenWidth] - 24) / 3);
            make.height.mas_equalTo(subvHeight);
        }];
        
        lastView = subv;
    }
    
    if (lastView != nil) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightView.mas_right).with.offset(1);
            make.bottom.equalTo(lastView.mas_bottom).with.offset(1);
        }];
    }
}

- (void)collectionViewCellClickAtKeyword:(NSString*)keyword {
    [_delegate collectionContainerClickAtKeyword:keyword];
}


@end
