//
//  UIView+Layout.h
//  YouChi
//
//  Created by sam on 15/12/30.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,LayoutType) {
    LayoutTypeVertical,
    LayoutTypeHorizen,
};

@interface UIView (Layout)
@property(nonatomic,assign) UIEdgeInsets linearLayoutEdge;
@property(nonatomic,assign) CGSize linearLayoutSize;
@end

@interface NSArray (Layout)
- (void)linearLayoutByType:(LayoutType )type inFrame:(CGRect )frame;
@end