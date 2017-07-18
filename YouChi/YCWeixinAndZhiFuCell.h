//
//  YCWeixinAndZhiFuCell.h
//  YouChi
//
//  Created by 李李善 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCTableVIewCell.h"
@interface YCWeixinAndZhiFuCell : YCTableVIewCell
@property(nonatomic,strong)IBOutlet UIImageView *selsctImage;
- (void)onTick:(BOOL)b;
@end



