//
//  TableViewController.h
//  YouChi
//
//  Created by sam on 16/8/8.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NSArray<CellInfo*> *(^CellInfosBlock)(__kindof NSArray *datas);
@interface TableViewController : UITableViewController <CellConfigureDelegate>
@property(nonatomic,strong,readonly) NSMutableArray *datas;
@property(nonatomic,strong,readonly) NSArray<CellInfo*> *cellInfos;
@property(nonatomic,weak) id<CellConfigureDelegate> configureDelegate;
@property(nonatomic,weak) id<UIScrollViewDelegate> scrollViewDelegate;
@property (nonatomic,strong) CellInfosBlock cellInfosBlock;
- (void )setCellInfosBlock:(CellInfosBlock)cellInfosBlock;
- (id )modelForIndexPath:(NSIndexPath *)indexPath;
@end
NS_ASSUME_NONNULL_END