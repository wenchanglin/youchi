//
//  AdScrollView.m
//
//
//  Created by LICAN LONG on 15/7/16.
//
//

#import "AdScrollView.h"

#import "Masonry.h"
#import "AppConstants.h"
#import "PlistEditor.h"
#import "FileOperator.h"

#import "UIImageView+YYWebImage.h"

#import "AdDataModel.h"
#import "ChatAdDataModel.h"

static CGFloat const chageImageTime = 5.0;

@interface AdScrollView ()
{
    NSTimer * _moveTime;
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    BOOL _isTimeUp;
}

@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) UIView         *container;
@property (strong, nonatomic) UILabel        *titleLabel;

@end

@implementation AdScrollView

#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.bounces = NO;
        self.scrollsToTop = NO;
        
        _container = [UIView new];
        _container.backgroundColor = [UIColor whiteColor];
        [self addSubview:_container];
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.height.equalTo(self);
        }];
        
        _imageViews = [NSMutableArray arrayWithCapacity:100];
        
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _pageControl.pageIndicatorTintColor = [AppConstants themeGrayColor];
        _pageControl.currentPageIndicatorTintColor = [AppConstants themeColor];
        
        _pageControl.currentPage = 0;
        _pageControl.enabled = NO;
        

        
        //        _moveTime = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
        
        /************** 用上面的方法如果当前线程不是主线程，会导致函数不执行的bug ****************/

        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [_moveTime invalidate];
            
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:chageImageTime
                                                          target:self
                                                        selector:@selector(animalMoveImage)
                                                        userInfo:nil
                                                         repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
            
            _moveTime = timer;
        });*/
        
        _isTimeUp = NO;
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    for (UIView *view in _container.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger count = [_dataArray count];
    
    UIView *lastView = nil;
    for (int i = 0; i < count; ++i)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], ((AdDataModel*)[_dataArray objectAtIndex:i]).imageUrl];
        
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        imageView.tag = i;
        
//        imageView.image = [_imageArray objectAtIndex:i];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todetail)];
        tapGesture.numberOfTapsRequired = 1;
        
        [imageView addGestureRecognizer:tapGesture];
        [_container addSubview:imageView];
        [_imageViews addObject:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.and.bottom.equalTo(_container);
            make.width.mas_equalTo([AppConstants uiScreenWidth]);
            
            if ( lastView )
            {
                make.left.mas_equalTo(lastView.mas_right);
            }
            else
            {
                make.left.mas_equalTo(_container.mas_left);
            }
        }];
        
        lastView = imageView;

    }
    
    if (lastView != nil) {
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.mas_right);
        }];
    }
    
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_titleLabel removeFromSuperview];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor = [UIColor whiteColor];
    if ([_dataArray count] > 0) {
        NSObject *object = [_dataArray objectAtIndex:0];
        
        if ([object isKindOfClass:[AdDataModel class]]) {
            _titleLabel.text = ((AdDataModel*)object).title;
        }
        else if ([object isKindOfClass:[ChatAdDataModel class]]) {
            _titleLabel.text = ((ChatAdDataModel*)object).name;
        }
        
    }
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_titleView addSubview:_titleLabel];
    [self addSubview:_titleView];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(self);
        make.bottom.equalTo(_pageControl.mas_top);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_titleView);
        make.width.equalTo(_titleView);
        make.bottom.equalTo(_titleView);
        make.centerX.equalTo(_pageControl.mas_centerX);
    }];
}

- (void)todetail {
    [_adDelegate AdScrollViewClicked];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"adClicked" object:nil];
}

#pragma mark - 设置广告所使用的图片(名字)
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    _pageControl.numberOfPages = [_dataArray count];
}

#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{    
    if (_pageControl.currentPage == _pageControl.numberOfPages - 1) {
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [self setContentOffset:CGPointMake([AppConstants uiScreenWidth] * (_pageControl.currentPage + 1), 0) animated:YES];
    }
    
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

#pragma mark - 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = self.contentOffset.x/[AppConstants uiScreenWidth];
    
    //根据scrollView 的位置对page 的当前页赋值
    _pageControl.currentPage = current;
    
    NSObject *object = [_dataArray objectAtIndex:current];
    
    if ([object isKindOfClass:[AdDataModel class]]) {
        _titleLabel.text = ((AdDataModel*)object).title;
    }
    else if ([object isKindOfClass:[ChatAdDataModel class]]) {
        _titleLabel.text = ((ChatAdDataModel*)object).name;
    }
    
    if (!_isTimeUp) {
        [_moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:chageImageTime]];
    }
    _isTimeUp = NO;
}

- (void)dealloc {
    NSLog(@"adscrollview dealloc");
}

@end
