//
//  AdScrollView.h
//
//
//  Created by LICAN LONG on 15/7/16.
//
//

#import <UIKit/UIKit.h>

@protocol AdScrollViewDelegate <NSObject>

- (void)AdScrollViewClicked;

@end

@interface AdScrollView : UIScrollView<UIScrollViewDelegate>

@property (strong,nonatomic,readwrite) id <AdScrollViewDelegate> adDelegate;
@property (retain,nonatomic,readonly) UIPageControl *pageControl;
@property (strong,nonatomic,readonly) UIView        *titleView;
@property (strong,nonatomic) NSArray                *dataArray;
/*
@property (retain,nonatomic,readwrite) NSArray * imageArray;
@property (retain,nonatomic,readwrite) NSArray * savedImageArray;
@property (retain,nonatomic,readwrite) NSArray * titleArray;*/
@end

