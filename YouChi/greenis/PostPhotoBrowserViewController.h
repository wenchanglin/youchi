//
//  PostPhotoBrowserViewController.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/19.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostPhotoBrowserViewController : UIViewController

-(instancetype)initWithImages:(NSArray*)images isUrl:(BOOL)isUrl andIndex:(NSInteger)index;

@end
