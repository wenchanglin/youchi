//
//  PostPhotoBrowserViewController.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/19.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "PostPhotoBrowserViewController.h"
#import "Masonry.h"
#import "FileOperator.h"
#import "AppConstants.h"

#import "UIImageView+YYWebImage.h"

@interface PostPhotoBrowserViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView                      *scrollView;
@property (strong, nonatomic) UIView                            *scrollViewContainer;
@property (strong, nonatomic) UIPageControl                     *pageControl;

@property (strong, nonatomic) NSArray                           *images;
@property (strong, nonatomic) NSMutableArray                    *imageViews;
@property (nonatomic) NSInteger                                 index;
@property (nonatomic) BOOL                                      isUrl;

@end

@implementation PostPhotoBrowserViewController

-(instancetype)initWithImages:(NSArray*)images isUrl:(BOOL)isUrl andIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _images = images;
        _index = index;
        _isUrl = isUrl;
        
        _imageViews = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    self.navigationItem.title = NSLocalizedString(@"tupianliulan", @"");
    
    // Do any additional setup after loading the view.
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.bounces = NO;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 0.5;
    
    [self.view addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _scrollViewContainer = [UIView new];
    _scrollViewContainer.backgroundColor = [UIColor blackColor];
    [_scrollView addSubview:_scrollViewContainer];
    [_scrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.numberOfPages = [_images count];
    _pageControl.currentPage = _index;
    if (_isUrl) {
        _pageControl.numberOfPages = [_images count] - 1;
        _pageControl.currentPage = _index - 1;
    }
    
    _pageControl.enabled = NO;
    
    
    NSUInteger count = [_images count];
    UIView *lastView = nil;
    
    int initCount;
    
    if (_isUrl) {
        initCount = 1;
    }
    else {
        initCount = 0;
    }
    
    for (int i = initCount; i <= count - 1; ++i)
    {
        UIScrollView *subScrollView = [[UIScrollView alloc] init];
        subScrollView.backgroundColor = [UIColor clearColor];
//        subScrollView.contentSize = CGSizeMake(360, 460);
        subScrollView.showsHorizontalScrollIndicator = NO;
        subScrollView.showsVerticalScrollIndicator = NO;
        subScrollView.delegate = self;
        subScrollView.minimumZoomScale = 1.0;
        subScrollView.maximumZoomScale = 3.0;
        subScrollView.tag = i;
        [subScrollView setZoomScale:1.0];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        if (_isUrl) {
            NSString *imageUrl;
            if ([[_images objectAtIndex:i] hasPrefix:@"http:"]) {
                imageUrl = [_images objectAtIndex:i];
            }
            else {
                imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], [_images objectAtIndex:i]];
            }
            
            [imageView setImageWithURL:[NSURL URLWithString:imageUrl] options:YYWebImageOptionShowNetworkActivity | YYWebImageOptionProgressive];
            
//            [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:nil];
        }
        else {
            [imageView setImage:[_images objectAtIndex:i]];
        }

        [imageView setTranslatesAutoresizingMaskIntoConstraints:YES];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tapGesture.numberOfTapsRequired = 1;
        
        [imageView addGestureRecognizer:tapGesture];
        
        [subScrollView addSubview:imageView];
        [_scrollViewContainer addSubview:subScrollView];
        
        
        [subScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.and.bottom.equalTo(_scrollViewContainer);
            make.width.mas_equalTo([AppConstants uiScreenWidth]);
            
            if ( lastView )
            {
                make.left.mas_equalTo(lastView.mas_right);
            }
            else
            {
                make.left.mas_equalTo(_scrollViewContainer.mas_left);
            }
        }];
        
        imageView.frame = CGRectMake(0, 0, [AppConstants uiScreenWidth], [AppConstants uiScreenHeight]);
        
        /*
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(subScrollView);
            
            make.edges.equalTo(subScrollView);
//            make.centerX.and.centerY.equalTo(subScrollView);
            if (imageView.image.size.width / imageView.image.size.height > [AppConstants uiScreenWidth] / [AppConstants uiScreenHeight]) {
                make.width.mas_equalTo([AppConstants uiScreenWidth]);
                make.height.mas_equalTo([AppConstants uiScreenWidth] * (imageView.image.size.width / imageView.image.size.height));
            }
            else {
                make.height.mas_equalTo([AppConstants uiScreenHeight]);
                make.width.mas_equalTo([AppConstants uiScreenHeight] * (imageView.image.size.width / imageView.image.size.height));
            }
        }];*/
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = NO;
        
        lastView = subScrollView;
        
//        [_imageViews addObject:subScrollView];
        
//        [self.imageScrollView addSubview:s];
    }
    
    if (lastView != nil) {
        [_scrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.mas_right);
        }];
    }
    
    [self.view addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
}

- (void)viewDidLayoutSubviews {
    [_scrollView setContentOffset:CGPointMake([AppConstants uiScreenWidth] * (_pageControl.currentPage), 0) animated:NO];
}

- (void)dismiss {
    NSLog(@"dismiss");
    
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = self.scrollView.contentOffset.x/[AppConstants uiScreenWidth];
    
    //根据scrollView 的位置对page 的当前页赋值
    _pageControl.currentPage = current;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
//    return [_imageViews objectAtIndex:_pageControl.currentPage];
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
