//
//  YCOthersInfoVM.m
//  YouChi
//
//  Created by 李李善 on 15/8/21.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCOthersInfoVM.h"
#import "YCChihuoyingM.h"
#import "YCViewModel+Logic.h"
@interface YCOthersInfoVM ()
@property(nonatomic,strong) NSArray *urls;
@property(nonatomic,strong) NSArray *parseKeys;
@property(nonatomic,strong) NSArray *cells;
@end


@implementation YCOthersInfoVM
@synthesize model;
- (void)dealloc{
    //    OK
}
- (instancetype)initWithId:(id)Id{
    self = [super initWithId:Id];
    if (self) {
        
        _urls = @[apiGetYouchiList,apiGetRecipeList];
        _cells = @[cell1,cell2];
        _parseKeys =@[@"content",@"recipeList"];
        self.urlString = _urls .firstObject;
        self.cellId    =_cells.firstObject;
        self.parseKey  =_parseKeys.firstObject;
        
        
        WSELF;
        [[self getUserInfo:Id parseClass:[YCLoginUserM class] parseKey:@"appUser"].deliverOnMainThread subscribeNext:^(YCLoginUserM *x) {
            SSELF;
            self.appUser = x;
            self.title = [[NSString alloc] initWithFormat:@"%@",x.nickName];
        }];
    }
    return self;
}

- (NSInteger)numberOfSections
{
    return [super numberOfSections];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [super numberOfItemsInSection:section];
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return   [super modelForItemAtIndexPath:indexPath];
}

- (NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.cellId isEqualToString:cell1]) {
        return  [super cellIDAtIndexPath:indexPath];
    }
    return self.cellId;
    //return [super cellIDAtIndexPath:indexPath];
}


- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width {
    return [super heightForRowAtIndexPath:indexPath width:width];
    
}

- (NSString *)headerIDInSection:(NSInteger)section
{
    if (section == 0) {
        return headerC;
    }
    return nil;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44;
    }
    return 0;
}

#pragma mark--获取吃货营列表，随手拍则有youchiPhotoList,分享果单和跟做果单则有recipe对象。
- (RACSignal *)mainSignal
{
    NSDictionary *param = @{
                            @"userId":self.Id,
                            kToken:[YCUserDefault currentToken]
                            } ;
    WSELF;
    return [[ENGINE POST_shop_array:self.urlString parameters:param parseClass:[YCChihuoyingM_1_2 class] parseKey:self.parseKey pageInfo:self.pageInfo]doNext:^(NSArray *x) {
        SSELF;
        
        
        
        if (self.nextBlock) {
            
            if ([self.cellId isEqualToString:cell2]) {
                for (YCChihuoyingM_1_2 *m in x) {
                    m.youchiType = @(YCCheatsTypeRecipe);
                }
                
            }else{
                for (YCChihuoyingM_1_2 *m in x) {
                    m.youchiType = @(YCCheatsTypeYouChi);
                }
            }
            
            [super onSetupHeights:x width:kScreenWidth];
            self.nextBlock(x);
        }
        
    }];
}


-(void)onSelectWithInteger:(NSInteger )integer
{
    self.urlString = _urls [integer];
    self.cellId    = _cells[integer];
    self.parseKey  = _parseKeys[integer];
    self.pageInfo = nil;
}
@end
