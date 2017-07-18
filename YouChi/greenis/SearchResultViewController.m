//
//  SearchResultViewController.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/9/18.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "SearchResultViewController.h"
#import "AppConstants.h"
#import "Masonry.h"

#import "IntroduceContainer.h"
#import "IntroduceDetailViewController.h"

#import "BTConstants.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#import "SegmentedControl.h"
#import "UIViewController+Action.h"
@interface SearchResultViewController () <IntroduceContainerDelegate, SegmentedControlDelegate>
{
    
}

@property (strong, nonatomic) NSString                          *searchKeyword;

@property (strong, nonatomic) SegmentedControl                *segmentedControl;
@property (strong, nonatomic) IntroduceContainer                *searchResultList;

@property (strong, nonatomic) UIScrollView                      *verticalScrollView;
@property (strong, nonatomic) UIView                            *verticalScrollViewContainer;

@property (strong, nonatomic) IntroduceDetailViewController     *introduceDetailVC;

@property (strong, nonatomic) NSArray                           *datas;

@end

@implementation SearchResultViewController

- (instancetype)initWithSearchKeyword:(NSString*)keyword andDatas:(NSArray*)datas {
    self = [super init];
    if (self) {
        self.searchKeyword = keyword;
        _datas = datas;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@", _searchKeyword];
    
    [self initSegmentedControl];
    [self initVerticalScrollView];
    [self initSearchResultList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([AppConstants downloadButtonPress2Pop]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)initSegmentedControl {
    NSArray *segmentedData = @[NSLocalizedString(@"bestofall", @""),
                               NSLocalizedString(@"likedmost", @""),
                               NSLocalizedString(@"usedmost", @"")];
    
    _segmentedControl = [[SegmentedControl alloc] initWithOriginY:20 Titles:segmentedData delegate:self] ;
    [self.view addSubview:_segmentedControl];
    
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}

- (void)segmentedControlSelectAtIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
}

- (void)initVerticalScrollView {
    _verticalScrollView = [UIScrollView new];
    _verticalScrollView.backgroundColor = [UIColor whiteColor];
    _verticalScrollView.scrollsToTop = YES;
    [self.view addSubview:_verticalScrollView];
    [_verticalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segmentedControl.mas_bottom);//.with.offset(5);
        make.left.right.and.bottom.equalTo(self.view);
    }];
    
    _verticalScrollViewContainer = [UIView new];
    _verticalScrollViewContainer.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:234.0/255.0 blue:232.0/255.0 alpha:1.0];
    [_verticalScrollView addSubview:_verticalScrollViewContainer];
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_verticalScrollView);
        make.width.equalTo(_verticalScrollView);
    }];
}

- (void)initSearchResultList
{
    _searchResultList = [[IntroduceContainer alloc] initWithDatas:_datas andStyle:StyleRecipe];
//    _searchResultList = [[IntroduceContainer alloc] initWithImages:_imageArray andFormulaNames:_formulaNameArray andIntroductions:_introductionArray andSavedImages:nil withStyle:StyleRecipe];
    
    _searchResultList.delegate = self;
    
    [_verticalScrollViewContainer addSubview:_searchResultList];
    
    [_searchResultList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_verticalScrollViewContainer);
    }];
    
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_searchResultList.mas_bottom);
    }];
}
    
- (void)introduceContainerClickAtData:(NSObject *)data {
    
    [AppConstants addHistoryBrowseWithData:(IntroduceDataModel *)data];
    
    _introduceDetailVC = [[IntroduceDetailViewController alloc] initWithData:(IntroduceDataModel *)data];
    
    _introduceDetailVC.navigationItem.title = ((IntroduceDataModel *)data).formulaName;
    [_introduceDetailVC onSetupBackButton];
    
    [self.navigationController pushViewController:_introduceDetailVC animated:YES];
    
    _introduceDetailVC = nil;
}

@end












