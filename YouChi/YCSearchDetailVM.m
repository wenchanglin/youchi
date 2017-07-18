//
//  YCSearchDetailVM.m
//  YouChi
//
//  Created by 李李善 on 15/8/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSearchDetailVM.h"
#import <NSAttributedString-DDHTML/NSAttributedString+DDHTML.h>
#import "YCNewsM.h"
#import "YCVideoM.h"
@implementation YCSearchDetailVM
@synthesize viewModel,model;
- (void)dealloc
{
    //    OK
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"搜索";
    }
    return self;
}
-(NSInteger)numberOfSections
{
    return (self.model.userList.count>0 || self.model.youchiList.count>0 || self.model.videoList.count>0 ||self.model.newsList.count>0)?4:0;
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if (self.model.userList.count >1) {
                return self.model.userList.count+1;
            }
            return self.model.userList.count;
            
        }
            break;
        case 1:
        {
            if (self.model.youchiList.count >1) {
                return self.model.youchiList.count+1;
            }
            return self.model.youchiList.count;
            
        }
            break;
        case 2:
        {
            if (self.model.videoList.count >1) {
                return self.model.videoList.count+1;
            }
            return self.model.videoList.count;
            
        }
            break;
            
        default:
        {
            if (self.model.newsList.count >1) {
                return self.model.newsList.count+1;
            }
            return self.model.newsList.count;
            
        }
            break;
    }
}


-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==self.model.userList.count){
                return 31.f;
            }
            return 68.f;
            
        }
            break;
        case 1:
        {
            if (indexPath.row==self.model.youchiList.count) {
                return 31.f;
            }
            return 68.f;
            
        }
            break;
        case 2:
        {
            if (indexPath.row==self.model.videoList.count) {
                return 31.f;
            }
            return 68.f;
            
        }
            break;
            
        default:
        {
            if (indexPath.row==self.model.newsList.count) {
                return 31.f;
            }
            return 68.f;
            
        }
            break;
    }
    
}

-(NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        if (indexPath.row==self.model.userList.count) {
            return cell2;
        }
        return cell0;
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==self.model.youchiList.count) {
            return cell2;
        }
        
        return cell1;
    }
    else if (indexPath.section==2)
    {
        if (indexPath.row==self.model.videoList.count) {
            return cell2;
        }
        return cell1;
    }
    else
    {
        if (indexPath.row==self.model.newsList.count) {
            return cell2;
        }
        return cell1;
        
        
    }
}



- (RACSignal  *)searchText:(NSString *)Text{
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    if (Text.length>0) {
        [para addEntriesFromDictionary:@{@"searchParam":Text}] ;
    }
    [para addEntriesFromDictionary:@{@"pageSize":@100}];
    WSELF;
    return [[ENGINE POST_shop_object:apiCGetSearchParam parameters:para parseClass:[YCChihuoyingM_1_2 class] parseKey:nil]doNext:^(id x) {
        SSELF;
        self.model = x;
        
        if (self.model.youchiList.count != 0) {
            for (YCChihuoyingM_1_2 * m  in self.model.youchiList) {
                if ([m.materialName isEqualToString:@""]||m.materialName ==nil) {
                    m.materialName = @"";
                }
                if ([m.desc isEqualToString:@""]||m.desc ==nil) {
                    m.desc = @"";
                }
               m.ui_desc = [NSAttributedString attributedStringFromHTML:[[NSString alloc] initWithFormat:@"<font size='15'>%@\n</font><font size='13'>%@</font>",m.materialName,m.desc]];
                
            }
        }
        if (self.model.videoList.count != 0) {
            for (YCVideoM * m  in self.model.videoList) {
                if ([m.title isEqualToString:@""]||m.title ==nil) {
                    m.title = @"";
                }
                if ([m.desc isEqualToString:@""]||m.desc ==nil) {
                    m.desc = @"";
                }
                m.ui_desc = [NSAttributedString attributedStringFromHTML:[[NSString alloc] initWithFormat:@"<font size='15'>%@\n</font><font size='13'>%@</font>",m.title,m.desc]];
            }
        }
         if (self.model.newsList.count != 0) {
           for (YCNewsList * m  in self.model.newsList) {

               if ([m.title isEqualToString:@""]||m.title ==nil) {
                   m.title = @"";
               }
               if ([m.summary isEqualToString:@""]||m.summary ==nil) {
                   m.summary = @"";
               }
               m.ui_desc = [NSAttributedString attributedStringFromHTML:[[NSString alloc] initWithFormat:@"<font size='15'>%@\n</font><font size='13'>%@</font>",m.title,m.summary]];
               
           }
       }
        
        
        
        
    }];
}



-(id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        if (self.model.userList.count ==indexPath.row) {
            return nil;
        }
        return self.model.userList[indexPath.row];
    }
    else if(indexPath.section==1)
    {
        if (self.model.youchiList.count ==indexPath.row) {
            return nil;
        }
        return  self.model.youchiList[indexPath.row];
        
    }
    else if(indexPath.section==2)
    {
        if (self.model.videoList.count ==indexPath.row) {
            return nil;
        }
        return self.model.videoList[indexPath.row];
    }
    else
    {
        if (self.model.newsList.count ==indexPath.row) {
            return nil;
        }
        return self.model.newsList[indexPath.row];
        
    }
}


@end


@implementation YCSearchYouchiVM
@synthesize viewModel;
-(void)dealloc{
    //    ok
    
}
- (RACSignal *)mainSignal
{
    WSELF;
    NSString *url ,*parseKey;
    Class parseClass;
    NSMutableDictionary *para = @{kToken:[YCUserDefault currentToken]}.mutableCopy;
    if (self.viewModel.searchText.length>0) {
        [para addEntriesFromDictionary:@{@"searchParam":self.viewModel.searchText}] ;
    }
    
    
    
    url = apiCGetSearchYouchiList;
    parseKey = @"content";
    parseClass = [YCChihuoyingM_1_2 class];
    
    return [[ENGINE POST_shop_array:url parameters:para parseClass:parseClass parseKey:parseKey pageInfo:self.pageInfo]doNext:^(NSArray *x) {
        SSELF;
        for (YCChihuoyingM_1_2 *m in x) {
            m.youchiType = @(YCCheatsTypeYouChi);
        }
        [self onSetupHeights:x width:kScreenWidth];
        if (self.nextBlock) {
            self.nextBlock(x);
        }
        
    }];
}

- (NSString *)title
{
    return @"更多搜索结果";//[NSString stringWithFormat:@"所有%@的搜索结果",self.viewModel.searchText];
}
#pragma mark--获取吃货营列表，随手拍则有youchiPhotoList,分享果单和跟做果单则有recipe对象。
@end
