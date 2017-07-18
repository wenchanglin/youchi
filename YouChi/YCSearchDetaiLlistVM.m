//
//  YCSearchDetaiLlistVM.m
//  YouChi
//
//  Created by 李李善 on 15/9/11.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSearchDetaiLlistVM.h"
#import "YCVideoM.h"
#import "YCNewsM.h"
@implementation YCSearchDetaiLlistVM
@synthesize model;

-(void)dealloc{
    //    ok
}
-(instancetype)initWithCellId:(NSString *)cellId HeightRow:(CGFloat)heightRow SearchlistType:(YCSearchlistType)listType
{
    if (self==[super init]) {
        self.CellId = cellId;
        self.listType = listType;
        self.height = heightRow;
        
    }
    return self;
    
}


- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.modelsProxy[indexPath.row];
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.modelsProxy.count;
    
}

-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    if (self.listType == YCSearchlistTypeUser || self.listType == YCSearchlistTypePhoto) {
        return 68.f;
        
    }
    if (self.listType == YCSearchlistTypeVideo) {
        return 120.0f;
    }
    return self.height;
}
-(NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.listType == YCSearchlistTypeUser ) {
        return cell0;
    }
    
    else if (self.listType == YCSearchlistTypePhoto) {
        return cell1_1;
    }
    
    else if (self.listType == YCSearchlistTypeVideo) {
        return cell2;
    }
    
    else if (self.listType == YCSearchlistTypeRecommend) {
        return cell3;
    }
    return cell1_1;
    
}


- (RACSignal  *)mainSignal
{
    NSString *url ,*parseKey;
    Class parseClass;
    
    if (self.listType ==YCSearchlistTypeUser) {
        url = apiCGetSearchUserList;
        parseKey = @"userList";
        parseClass = [YCLoginUserM class];
    }
    else if (self.listType ==YCSearchlistTypePhoto) {
        
        url = apiCGetSearchYouchiList;
        parseKey = @"content";
        parseClass = [YCChihuoyingM_1_2 class];
    }
    
    else if (self.listType ==YCSearchlistTypeVideo) {
        
        url = apiCGetSearchVideoList;
        parseKey = @"videoList";
        parseClass = [YCVideoM class];
    }
    
    else {
        url = apiCGetSearchNewsList;
        parseKey = @"newsList";
        parseClass = [YCNewsList class];
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    if (self.searchText.length>0) {
        [para addEntriesFromDictionary:@{@"searchParam":self.searchText}] ;
    }
    
    [para addEntriesFromDictionary:@{kToken:[YCUserDefault currentToken]}];
    
    
    
    WSELF;
    return [[ENGINE POST_shop_array:url parameters:para parseClass:parseClass parseKey:parseKey pageInfo:self.pageInfo ]doNext:^(NSArray *x) {
        SSELF;
        
        if (self.listType ==YCSearchlistTypeVideo) {
            for(YCVideoM *m in x)
            {
                m.playTime = [NSString stringWithFormat:@"时间 %@",m.playTime];
            }
        }
        else if (self.listType ==YCSearchlistTypeRecommend) {
            for (YCNewsList *m in x) {
                
                [m onSetupData];
                
            }
        }
        
        if (self.nextBlock) {
            self.nextBlock(x);
        }
    }];
}

@end
