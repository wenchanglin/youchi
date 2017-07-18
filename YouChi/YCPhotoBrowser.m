//
//  YCPhotoBrowser.m
//  YouChi
//
//  Created by sam on 15/9/22.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import <LTNavigationBar/UINavigationBar+Awesome.h>
#import "YCPhotoBrowser.h"
#import "YCModel.h"
@interface YCPhotoBrowser () <MWPhotoBrowserDelegate>
@property (nonatomic,strong) NSArray *pageModels;
@property (nonatomic,assign) NSUInteger selectedIndex;
@end

@implementation YCPhotoBrowser
- (void)dealloc
{
//    OK
}

- (instancetype)initWithPageModels:(NSArray *)pageModels selectedIndex:(NSUInteger )selectedIndex
{
    self = [super init];
    if (self) {
        self.pageModels = pageModels.copy;
        self.delegate = self;
        self.selectedIndex = selectedIndex;
        [self setCurrentPhotoIndex:selectedIndex];
        [self setUrlBlock:^NSURL *(YCBaseImageModel *model) {
            if ([model isKindOfClass:[NSURL class]]) {
                return (id)model;
            }
            return NSURL_URLWithString(IMAGE_HOST_NOT_SHOP_(IMAGE_LARGE(model.imagePath)));
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    YCBaseImageModel *pm = self.pageModels[index];
    MWPhoto *photo;
    if (self.urlBlock) {
        NSURL *url = self.urlBlock(pm);
        photo = [[MWPhoto alloc]initWithURL:url];
    }
    
    else if ([pm isKindOfClass:[YCBaseImageModel class]]) {
        photo = [[MWPhoto alloc]initWithURL:NSURL_URLWithString(IMAGE_LARGE(pm.imagePath))];
    }
    
    else if ([pm isKindOfClass:[UIImage class]]) {
        photo = [[MWPhoto alloc]initWithImage:(id)pm];
    }
    
    else if ([pm isKindOfClass:[NSURL class]]) {
        
        photo = [[MWPhoto alloc]initWithURL:(id)pm];
    }
    
    return photo;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.pageModels.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setNavBarAppearance:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = color_title;
    navBar.barTintColor = nil;
    navBar.shadowImage = nil;
    navBar.translucent = YES;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsLandscapePhone];
    [navBar lt_setBackgroundColor:KBGCColor(@"#000000")];
}


@end
