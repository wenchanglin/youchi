//
//  YCVideoCell.h
//  YouChi
//
//  Created by 朱国林 on 15/8/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCVideoView.h"
@interface YCVideoCell : UITableViewCell

/// 图片
@property (weak, nonatomic) IBOutlet YCVideoView *videRightView;
@property (weak, nonatomic) IBOutlet YCVideoView *videLeftView;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *plays;

@end
