//
//  ADDetailViewController.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/20.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdDataModel.h"
@interface ADDetailViewController : UIViewController
@property (nonatomic,strong,readonly) AdDataModel *adDataModel;

- (instancetype)initWithArticleId:(NSString*)articleId andTitle:(NSString*)title andZhaiyao:(NSString*)zhaiyao andImageUrl:(NSString*)imageUrl;

- (instancetype)initWithAdDataModel:(AdDataModel *)m;
@end
