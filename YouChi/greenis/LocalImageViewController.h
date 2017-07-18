//
//  LocalImageViewController.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/24.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocalImageViewControllerDelegate <NSObject>

- (void)getSelectImage:(NSArray *)imageArr;

@end

@interface LocalImageViewController : UIViewController

@property (assign, nonatomic) id <LocalImageViewControllerDelegate>         delegate;
@property (nonatomic) NSInteger                                             maxPhotoNumber;

@end
