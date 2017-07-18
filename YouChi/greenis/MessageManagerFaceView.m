
#import "MessageManagerFaceView.h"
#import "ExpressionSectionBar.h"
#import "Masonry.h"
#import "AppConstants.h"

#define FaceSectionBarHeight  36   // 表情下面控件
#define FacePageControlHeight 30  // 表情pagecontrol

#define Pages 3

@implementation MessageManagerFaceView
{
    UIPageControl *pageControl;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
//    self.backgroundColor = [UIColor colorWithRed:248.0f/255 green:248.0f/255 blue:255.0f/255 alpha:1.0];
    self.backgroundColor = [UIColor clearColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];//WithFrame:CGRectMake(0.0f,0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)-FacePageControlHeight-FaceSectionBarHeight)];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    [scrollView setPagingEnabled:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.userInteractionEnabled = YES;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self);
        make.height.equalTo(self.mas_height).with.offset(-FacePageControlHeight-FaceSectionBarHeight);
    }];
    
    UIView *scrollViewContainer = [[UIView alloc] init];
    scrollViewContainer.userInteractionEnabled = YES;
    [scrollView addSubview:scrollViewContainer];
    
    [scrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];
    
    FaceView *lastView = nil;
    for (int i= 0;i<Pages;i++) {
        FaceView *faceView = [[FaceView alloc]initWithIndex:i]; //WithFrame:CGRectMake(i*CGRectGetWidth(self.bounds),0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(scrollView.bounds)) forIndexPath:i];
        faceView.userInteractionEnabled = YES;
//        faceView.backgroundColor = [UIColor blackColor];
        [scrollViewContainer addSubview:faceView];
        faceView.delegate = self;
        
        [faceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(scrollViewContainer);
            make.width.mas_equalTo([AppConstants uiScreenWidth]);
            if (lastView == nil) {
                make.left.equalTo(scrollViewContainer);
            }
            else {
                make.left.equalTo(lastView.mas_right);
            }
        }];
        
        lastView = faceView;
    }
    
    [scrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView);
    }];
    
    pageControl = [[UIPageControl alloc]init];
//    [pageControl setFrame:CGRectMake(0,CGRectGetMaxY(scrollView.frame),CGRectGetWidth(self.bounds),FacePageControlHeight)];
    [self addSubview:pageControl];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    pageControl.numberOfPages = Pages;
    pageControl.currentPage   = 0;
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_bottom);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(FacePageControlHeight);
    }];
    
    ExpressionSectionBar *sectionBar = [[ExpressionSectionBar alloc]init];//WithFrame:CGRectMake(0.0f,CGRectGetMaxY(pageControl.frame),CGRectGetWidth(self.bounds), FaceSectionBarHeight)];
    [self addSubview:sectionBar];
    
    [sectionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pageControl.mas_bottom);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(FaceSectionBarHeight);
    }];
}

#pragma mark  scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/320;
    pageControl.currentPage = page;
}

#pragma mark ZBFaceView Delegate
- (void)didSelecteFace:(NSString *)faceName andIsSelecteDelete:(BOOL)del{
    if ([self.delegate respondsToSelector:@selector(SendTheFaceStr:isDelete:) ]) {
        [self.delegate SendTheFaceStr:faceName isDelete:del];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
