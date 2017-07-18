//
//  YCTableViewHeaderFooterView.h
//  YouChi
//
//  Created by sam on 16/1/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
#import "YCTableViewHeaderFooterView.h"

@class YCTableViewHeaderFooterView;
@protocol YCTableVIewHeaderFooterViewDelegate <NSObject>
@optional
- (void)onConfigureHeader:(YCTableViewHeaderFooterView *)header reuseIdentifier:(NSString *)reuseIdentifier;
- (void)onConfigureFooter:(YCTableViewHeaderFooterView *)footer reuseIdentifier:(NSString *)reuseIdentifier;
@end
typedef void(^YCHeaderFooterInitBlock)(YCTableViewHeaderFooterView *headerFooter,UIView *view,NSString *reuseIdentifier);
typedef void(^YCHeaderFooterLayoutBlock)(YCTableViewHeaderFooterView *headerFooter,UIView *view,CGRect frame);
typedef void(^YCHeaderFooterUpdateBlock)(YCTableViewHeaderFooterView *headerFooter,UIView *view,NSInteger section);

@interface YCTableViewHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic,weak) UIViewController<YCTableVIewHeaderFooterViewDelegate> *headerDelegate;
@property (nonatomic,weak) UIViewController<YCTableVIewHeaderFooterViewDelegate> *footerDelegate;
@property (nonatomic,weak) id data;
@property (nonatomic,assign) NSInteger section;

@property (nonatomic,strong) YCHeaderFooterLayoutBlock layoutBlock;
@property (nonatomic,strong) YCHeaderFooterUpdateBlock updateBlock;

- (void)setInitBlock:(YCHeaderFooterInitBlock)initBlock;
- (void)setLayoutBlock:(YCHeaderFooterLayoutBlock )layoutBlock;
- (void)setUpdateBlock:(YCHeaderFooterUpdateBlock)updateBlock;

- (BOOL)checkIsHasSetData:(id )data;

@end
