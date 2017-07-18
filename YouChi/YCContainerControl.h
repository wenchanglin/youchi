//
//  YCContainerControl.h
//  YouChi
//
//  Created by sam on 16/1/4.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YCContainerControlType) {
    YCContainerControlTypeHorizion,
    YCContainerControlTypeVertical,
};

@interface YCContainerControl<elementType:UIView *> : UIControl
@property (nonatomic,copy) NSArray<elementType> *elements;
@property (nonatomic,assign) UIEdgeInsets edge;
@property (nonatomic,assign) CGFloat gap;
@property (nonatomic,assign) YCContainerControlType containerControlType;
- (instancetype )initWithElementCount:(NSInteger )count block:(elementType (^)(NSInteger idx))block;
- (void )setElementCount:(NSInteger )count block:(elementType (^)(NSInteger idx))block;
- (void )setButtonImages:(NSArray<NSString*> *)images;
@end

@interface NSArray (container)
- (void)layoutByType:(YCContainerControlType )type edge:(UIEdgeInsets )edge gap:(CGFloat )gap inFrame:(CGRect )frame;
@end