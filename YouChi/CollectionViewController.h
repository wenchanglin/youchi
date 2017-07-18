//
//  CollectionViewController.h
//  YouChi
//
//  Created by sam on 16/8/5.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"
#import "CellInfo.h"
@interface CollectionViewController : UICollectionViewController
{
    NSString *_headerKind,*_footerKind;
}

- (void)registerCellInfos:(NSArray<CellInfo *> *)cellInfos count:(NSUInteger)count;
- (void)registerCellInfos:(NSArray<CellInfo*> *)cellInfos;

@property(nonatomic,strong,readonly) NSArray<CellInfo*> *cellInfos;
@property(nonatomic,weak) id<CellConfigureDelegate> configureDelegate;

@end
