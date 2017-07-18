//
//  YCCellManager.h
//  YouChi
//
//  Created by water on 16/6/15.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCCellManagerFrame,YCViewInfo;

@interface YCCellManager : UIView

@property (strong,nonatomic) YCCellManagerFrame *managerFrame;

-(void)updateWithViewInfo:(YCViewInfo *)info;

@end

