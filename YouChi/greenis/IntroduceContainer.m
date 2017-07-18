//
//  IntroduceContainer.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/20.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "IntroduceContainer.h"
#import "Masonry.h"
#import "AppConstants.h"
#import "PlistEditor.h"

#import "ChatTopicDataModel.h"
#import "ChatActivityDataModel.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

@interface IntroduceContainer() <IntroduceDetailCellDelegate> {
    
}

@property (strong,nonatomic) NSArray                *introduceDetailViews;
@property (retain,nonatomic) NSArray                *savedImageArray;
@property (retain,nonatomic) NSArray                *imageArray;
@property (retain,nonatomic) NSArray                *formulaNameArray;
@property (retain,nonatomic) NSArray                *introductionArray;
@property (nonatomic)        IntroduceStyle         style;

@property (strong,nonatomic) ChatTopicDataModel     *chatTopicDataModel;
@property (strong,nonatomic) ChatActivityDataModel  *chatActivityDataModel;
@property (strong,nonatomic) UIView                 *lastView;

@property (nonatomic, strong) MASConstraint             *bottomConstraint;

@property (strong, nonatomic) NSMutableArray                    *IntroduceDataDics;
@property (strong, nonatomic) NSMutableArray                    *IntroduceDatas;
@property (strong, nonatomic) NSMutableArray                    *ChatTopicDataDics;
@property (strong, nonatomic) NSMutableArray                    *ChatTopicDatas;
@property (strong, nonatomic) NSMutableArray                    *ChatActivityDataDics;
@property (strong, nonatomic) NSMutableArray                    *ChatActivityDatas;

@end

@implementation IntroduceContainer

- (instancetype)initWithDatas:(NSArray*)datas andStyle:(IntroduceStyle)style {
    self = [super init];
    if (self) {
        
        _style = style;
        
        _totalCount = 0;
        
        NSUInteger count = [datas count];
        
        _lastView = nil;
        for (int i = 0; i < count; ++i)
        {
            IntroduceDetailCell *subv;
            
            NSDictionary *data = [datas objectAtIndex:i];

            subv = [[IntroduceDetailCell alloc] initWithData:data andStyle:_style];

            subv.delegate = self;
            [self addSubview:subv];
            
            [subv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self);
                make.height.mas_equalTo(@75);
                
                if ( _lastView )
                {
                    make.top.mas_equalTo(_lastView.mas_bottom);
                }
                else
                {
                    make.top.mas_equalTo(self.mas_top);
                }
            }];
            
            _totalCount++;
            
            _lastView = subv;
        }
        
        if (_lastView != nil) {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                _bottomConstraint = make.bottom.equalTo(_lastView.mas_bottom);
            }];
        }
    }
    return self;
}

- (void)loadMoreWithPage:(NSInteger)page andID:(NSString*)ID{
    
    if (_style == StyleRecipe) {
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@resource/article/detail/index.ashx", [AppConstants httpHeader]];
        
        NSDictionary *parameters = @{@"ArticleId":ID, @"page":[NSString stringWithFormat:@"%ld", (long)page], @"pageSize":@"10"};
        
        NSLog(@"page = %@ ID = %@", [NSString stringWithFormat:@"%ld", (long)page], ID);
        
        [HTTP_CLIENT POST:urlString parameters:parameters
              progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                  NSLog(@"success urlString = %@", urlString);
                  NSLog(@"Success: %@", responseObject);
                  
                  if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                      NSArray *articles = [responseObject objectForKey:@"formulas"];
                      
                      _IntroduceDataDics = [[NSMutableArray alloc] init];
                      [_IntroduceDataDics addObjectsFromArray:articles];
                      
                      _IntroduceDatas = [[NSMutableArray alloc] init];
                      
                      for (int i = 0; i < _IntroduceDataDics.count; i++) {
                          IntroduceDataModel *dataModel = [[IntroduceDataModel alloc] init];
                          dataModel.effect = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Effect"];
                          dataModel.formulaID = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"FormulaID"];
                          dataModel.formulaName = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"FormulaName"];
                          dataModel.imageUrl = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"ImgUrl"];
                          dataModel.ingredients = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Ingredients"];
                          dataModel.introduction = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Introduction"];
                          dataModel.steps = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Steps"];
                          dataModel.userNickName = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"UserNickName"];
                          dataModel.videoUrl = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"VideoUrl"];
                          dataModel.albumsTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"albums_total"];
                          dataModel.commentTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"comment_total"];
                          dataModel.friendsTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"friends_total"];
                          dataModel.stepTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"step_total"];
                          dataModel.tagsTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"tags_total"];
                          dataModel.shareUrl = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"share_url"];
                          
                          [_IntroduceDatas addObject:dataModel];
                      }
                      
                      [self loadMoreDone];
                      
                  }
                  else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                      NSLog(@"获取列表失败 %@", urlString);
                      
                      [self loadMoreFail];
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"false urlString = %@", urlString);
                  NSLog(@"Error: %@", error);
                  
                  [self loadMoreFail];
              }];
    }
    else if (_style == StyleTopic) {
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/query/topic/org/list/hot/top10/index.ashx", [AppConstants httpHeader]];
        
        NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld", (long)page], @"pageSize":@"10"};
        
        [HTTP_CLIENT POST:urlString parameters:parameters
              progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  ;
                  //                  NSLog(@"success urlString = %@", urlString);
                  //                  NSLog(@"Success: %@", responseObject);
                  
                  if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                      NSArray *topics = [responseObject objectForKey:@"Topics"];
                      
                      _ChatTopicDataDics = [[NSMutableArray alloc] init];
                      [_ChatTopicDataDics addObjectsFromArray:topics];
                      
                      for (int i = 0; i < _ChatTopicDataDics.count; i++) {
                          ChatTopicDataModel *dataModel = [[ChatTopicDataModel alloc] init];
                          dataModel.addTime = [[_ChatTopicDataDics objectAtIndex:i] objectForKey:@"add_time"];
                          dataModel.content = [[_ChatTopicDataDics objectAtIndex:i] objectForKey:@"content"];
                          dataModel.Id = [[_ChatTopicDataDics objectAtIndex:i] objectForKey:@"id"];
                          dataModel.forumPostTotal = [[_ChatTopicDataDics objectAtIndex:i] objectForKey:@"forum_post_total"];
                          dataModel.hotDegree = [[_ChatTopicDataDics objectAtIndex:i] objectForKey:@"hot_degree"];
                          dataModel.imageUrl = [[_ChatTopicDataDics objectAtIndex:i] objectForKey:@"img_url"];
                          dataModel.name = [[_ChatTopicDataDics objectAtIndex:i] objectForKey:@"name"];
                          dataModel.shareUrl = [[_ChatTopicDataDics objectAtIndex:i] objectForKey:@"share_url"];
                          
                          [_ChatTopicDatas addObject:dataModel];
                      }
                      
                      [self loadMoreDone];
                  }
                  else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                      NSLog(@"获取列表失败 %@", urlString);
                      
                      [self loadMoreFail];
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"false urlString = %@", urlString);
                  NSLog(@"Error: %@", error);
                  
                  [self loadMoreFail];
              }];
    }
    else if (_style == StyleActivity) {
        
        
        NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/query/topic/list/activity/list/index.ashx", [AppConstants httpHeader]];
        
        NSDictionary *parameters = @{@"page" :[NSString stringWithFormat:@"%ld", (long)page], @"pageSize" : @"10"};
        
        [HTTP_CLIENT POST:urlString parameters:parameters
              progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  ;
                  //                    NSLog(@"success urlString = %@", urlString);
                  //                    NSLog(@"Success: %@", responseObject);
                  
                  if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                      NSArray *topics = [responseObject objectForKey:@"Topics"];
                      
                      _ChatActivityDataDics = [[NSMutableArray alloc] init];
                      [_ChatActivityDataDics addObjectsFromArray:topics];
                      
                      _ChatActivityDatas = [[NSMutableArray alloc] init];
                      
                      for (int i = 0; i < _ChatActivityDataDics.count; i++) {
                          ChatActivityDataModel *dataModel = [[ChatActivityDataModel alloc] init];
                          dataModel.addTime = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"add_time"];
                          dataModel.content = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"content"];
                          dataModel.forumPostTotal = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"forum_post_total"];
                          dataModel.hotDegree = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"hot_degree"];
                          dataModel.Id = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"id"];
                          dataModel.imageUrl = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"img_url"];
                          dataModel.name = [[_ChatActivityDataDics objectAtIndex:i] objectForKey:@"name"];
                          
                          [_ChatActivityDatas addObject:dataModel];
                      }
                      
                      [self loadMoreDone];
                  }
                  else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                      NSLog(@"获取列表失败 %@", urlString);
                      
                      [self loadMoreFail];
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"false urlString = %@", urlString);
                  NSLog(@"Error: %@", error);
                  
                  [self loadMoreFail];
              }];
    }
}

- (void)loadMoreDone {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        
        if (_style == StyleRecipe) {
            
            NSLog(@"StyleRecipe");
            
            [self LoadMoreWithDatas:_IntroduceDatas];
        }
        
        else if (_style == StyleTopic) {
            
            NSLog(@"StyleTopic");
            
            [self LoadMoreWithDatas:_ChatTopicDatas];
        }
        
        else if (_style == StyleActivity) {
            
            NSLog(@"StyleActivity");
            
            [self LoadMoreWithDatas:_ChatActivityDatas];

        }
    });
         
}

- (void)loadMoreFail {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMoreDone" object:nil];
}

- (void)LoadMoreWithDatas:(NSArray*)datas {
    NSUInteger count = [datas count];
    
    for (int i = 0; i < count; ++i)
    {
        IntroduceDetailCell *subv;
        
        NSDictionary *data = [datas objectAtIndex:i];
        
        subv = [[IntroduceDetailCell alloc] initWithData:data andStyle:StyleRecipe];
        
        subv.delegate = self;
        [self addSubview:subv];
        
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.height.mas_equalTo(@75);
            
            if ( _lastView )
            {
                make.top.mas_equalTo(_lastView.mas_bottom);
            }
            else
            {
                make.top.mas_equalTo(self.mas_top);
            }
        }];
        
        _totalCount++;
        
        _lastView = subv;
    }
    
    [_bottomConstraint uninstall];
    
    if (_lastView != nil) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            _bottomConstraint = make.bottom.equalTo(_lastView.mas_bottom);
        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMoreDone" object:nil];
}

- (void)introduceDetailCellClickAtData:(NSObject *)data {
    [_delegate introduceContainerClickAtData:data];
}

- (void)dealloc {
    NSLog(@"introduce dealloc");
}

@end
