//
//  PostContainer.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/16.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "PostContainer.h"
#import "Masonry.h"
#import "AppConstants.h"
#import "PlistEditor.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#import "ProgressHUD.h"

@interface PostContainer() <PostDetailCellDelegate>

@property (strong, nonatomic) UIView                    *lastView;
@property (strong, nonatomic) NSMutableArray            *cellArray;

@property (nonatomic, strong) MASConstraint             *bottomConstraint;
@property (nonatomic) PostType                          postType;

@property (strong, nonatomic) NSArray                   *datas;

@property (strong, nonatomic) NSMutableArray                    *ChatLiaoLiaoDataDics;
@property (strong, nonatomic) NSMutableArray                    *ChatLiaoLiaoDatas;

@property (nonatomic) NSInteger                 lastIndex;

@end

@implementation PostContainer

- (instancetype)initWithDatas:(NSArray*)datas andPostType:(PostType)postType{
    self = [super init];
    if (self) {

        _lastView = nil;
        _postType = postType;
        _datas = datas;
        _cellArray = [[NSMutableArray alloc] init];
        
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        
        NSUInteger count = [_datas count];

        _lastView = nil;
        for (int i = 0; i < count; ++i)
        {
            UIView *sepView;
            
            if (_lastView != nil) {
                sepView = [[UIView alloc] init];
                sepView.backgroundColor = [UIColor lightGrayColor];
                sepView.alpha = 0.3;
                
                [self addSubview:sepView];
                [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_lastView.mas_bottom);
                    make.left.and.right.equalTo(self);
                    make.height.mas_equalTo(1);
                }];
            }
            
            PostDetailCell *subv;
            
            subv = [[PostDetailCell alloc] initWithData:[datas objectAtIndex:i] andIsLikeable:NO andIndex:i];
            subv.tag = [((ChatLiaoLiaoPostDataModel*)[datas objectAtIndex:i]).Id intValue];
            [_cellArray addObject:subv];
            
            subv.delegate = self;
            [self addSubview:subv];
            
            [subv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self);
                //            make.height.mas_equalTo(@75);
                
                if ( _lastView )
                {
                    make.top.mas_equalTo(sepView.mas_bottom);
                }
                else
                {
                    make.top.mas_equalTo(self.mas_top);
                }
            }];
            
            _lastView = subv;
        }
        
        _lastIndex = count;
        
        if (_lastView != nil) {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                _bottomConstraint = make.bottom.equalTo(_lastView.mas_bottom);
            }];
        }

    }
    
    NSLog(@"PostContainer done");
    
    return self;
}

- (PostDetailCell*)cellAtIndex:(NSInteger)index {
    return [_cellArray objectAtIndex:index];
}

- (void)loadMoreWithPage:(NSInteger)page andID:(NSString *)Id{
    
    NSString *urlString;
    NSDictionary *parameters;
    
    if (_postType == PostAdDetail || _postType == PostActivityDetail || _postType == PostTopicDetail) {
        urlString = [NSString stringWithFormat:@"%@interaction/forum/post/list/bytopicid/index.ashx", [AppConstants httpHeader]];
        parameters = @{@"AccessToken":[AppConstants userInfo].accessToken, @"TopicId":Id, @"page":[NSString stringWithFormat:@"%ld", (long)page], @"pageSize":@"10"};
    }
    else if (_postType == PostQueryByUserid) {
        urlString = [NSString stringWithFormat:@"%@interaction/forum/post/list/byuserid/index.ashx", [AppConstants httpHeader]];
        parameters = @{@"AccessToken":[AppConstants userInfo].accessToken, @"UserId":Id, @"page":[NSString stringWithFormat:@"%ld", (long)page], @"pageSize":@"10"};
    }
    else if (_postType == PostMine) {
        urlString = [NSString stringWithFormat:@"%@interaction/forum/post/myself/list/index.ashx", [AppConstants httpHeader]];
        
        parameters = @{@"AccessToken":[AppConstants userInfo].accessToken, @"page":[NSString stringWithFormat:@"%ld", (long)page], @"pageSize":@"10"};
    }
    else if (_postType == PostNormal) {
        urlString = [NSString stringWithFormat:@"%@interaction/forum/post/list/index.ashx", [AppConstants httpHeader]];
        
        parameters = @{@"AccessToken":[AppConstants userInfo].accessToken, @"page":[NSString stringWithFormat:@"%ld", (long)page], @"pageSize":@"10"};
    }
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
            NSLog(@"success urlString = %@", urlString);
            NSLog(@"Success: %@", responseObject);
              
              NSLog(@"page = %ld", (long)page);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSArray *posts = [responseObject objectForKey:@"posts"];
                  
                  if ([posts count] == 0) {
                      [ProgressHUD showSuccess:NSLocalizedString(@"nomorepost", @"")];
                      
                      return;
                  }
                  
                  _ChatLiaoLiaoDataDics = [[NSMutableArray alloc] init];
                  [_ChatLiaoLiaoDataDics addObjectsFromArray:posts];
                  
                  _ChatLiaoLiaoDatas = [[NSMutableArray alloc] init];
                  
                  for (int i = 0; i < _ChatLiaoLiaoDataDics.count; i++) {
                      ChatLiaoLiaoPostDataModel *dataModel = [[ChatLiaoLiaoPostDataModel alloc] init];
                      dataModel.addtime = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"add_time"];
                      dataModel.clickDegree = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"click_degree"];
                      dataModel.commentDegree = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"comment_degree"];
                      dataModel.content = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"content"];
                      dataModel.hotDegree = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"hot_degree"];
                      dataModel.Id = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"id"];
                      dataModel.avatar = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"avatar"];
                      dataModel.thumbsupDegree = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumbsup_degree"];
                      dataModel.userId = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"userId"];
                      dataModel.userName = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"nickName"];
                      dataModel.image1URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image1URL"];
                      dataModel.image2URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image2URL"];
                      dataModel.image3URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image3URL"];
                      dataModel.image4URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image4URL"];
                      dataModel.image5URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image5URL"];
                      dataModel.image6URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image6URL"];
                      dataModel.image7URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image7URL"];
                      dataModel.image8URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image8URL"];
                      dataModel.image9URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"image9URL"];
                      dataModel.thumbImage1URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image1URL"];
                      dataModel.thumbImage2URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image2URL"];
                      dataModel.thumbImage3URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image3URL"];
                      dataModel.thumbImage4URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image4URL"];
                      dataModel.thumbImage5URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image5URL"];
                      dataModel.thumbImage6URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image6URL"];
                      dataModel.thumbImage7URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image7URL"];
                      dataModel.thumbImage8URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image8URL"];
                      dataModel.thumbImage9URL = [[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"thumb_image9URL"];
                      dataModel.liked = [[[_ChatLiaoLiaoDataDics objectAtIndex:i] objectForKey:@"isThumbsup"] intValue] == 1 ? @"1" : @"0";
                      
                      [_ChatLiaoLiaoDatas addObject:dataModel];
                  }
                  
                  [self loadMoreDone];
              }
              else if ([[responseObject objectForKey:@"errno"] isEqualToString:@"4401"]) {
                  [AppConstants relogin:^(BOOL success){
                      if (success) {
                          [self loadMoreWithPage:page andID:Id];
                      }
                      else {
                          [AppConstants notice2ManualRelogin];
                      }
                  }];
              }
              else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                  NSLog(@"获取列表失败 %@", urlString);
                  
                  [self loadMoreFail];
              }
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              NSLog(@"false urlString = %@", urlString);
              NSLog(@"Error: %@", error);
              
              [self loadMoreFail];
          }];*/
}

- (void)loadMoreDone {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        
        [self LoadMoreWithDatas:_ChatLiaoLiaoDatas];
    });
}

- (void)loadMoreFail {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMoreDone" object:nil];
}

- (void)LoadMoreWithDatas:(NSArray*)datas {
    
    NSLog(@"postContainer loadMore");
    
    NSUInteger count = [datas count];
    
    for (int i = 0; i < count; ++i)
    {
        UIView *sepView;
        
        if (_lastView != nil) {
            sepView = [[UIView alloc] init];
            sepView.backgroundColor = [UIColor lightGrayColor];
            sepView.alpha = 0.3;
            
            [self addSubview:sepView];
            [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lastView.mas_bottom);
                make.left.and.right.equalTo(self);
                make.height.mas_equalTo(1);
            }];
        }
        
        PostDetailCell *subv;
        
        subv = [[PostDetailCell alloc] initWithData:[datas objectAtIndex:i] andIsLikeable:NO andIndex:_lastIndex + i];
        subv.tag = [((ChatLiaoLiaoPostDataModel*)[datas objectAtIndex:i]).Id intValue];
        [_cellArray addObject:subv];
        
        subv.delegate = self;
        [self addSubview:subv];
        
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            //            make.height.mas_equalTo(@75);
            
            if ( _lastView )
            {
                make.top.mas_equalTo(sepView.mas_bottom);
            }
            else
            {
                make.top.mas_equalTo(self.mas_top);
            }
        }];
        
        _lastView = subv;
    }
    
    _lastIndex = _lastIndex + count;
    
    [_bottomConstraint uninstall];
    
    if (_lastView != nil) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            _bottomConstraint = make.bottom.equalTo(_lastView.mas_bottom);
        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMoreDone" object:nil];
}

- (void)changeWithData:(ChatLiaoLiaoPostDataModel*)data atIndex:(NSInteger)index {
    [[_cellArray objectAtIndex:index] changeWithData:data];
}
/*
- (void)removeWithPostID:(NSString*)postID {
    NSArray *views = [self subviews];
    for(UIView *view in views)
    {
        NSLog(@"view.tag = %ld, postID = %@", (long)view.tag, postID);
        if (view.tag == [postID intValue]) {
            [view removeFromSuperview];
            break;
        }
    }
}
*/
- (void)postDetailCellClickAtData:(ChatLiaoLiaoPostDataModel *)data andIndex:(NSInteger)index {
    [_delegate postContainerClickAtData:data andIndex:index];
}

- (void)postDetailCellHeadImageViewClickByUserid:(NSString*)userid andUsername:(NSString*)username andUserAvatar:(NSString*)Avatar {
    [_delegate postContainerHeadImageViewClickByUserid:userid andUsername:username andUserAvatar:Avatar];
}

- (void)postDetailCellContentImageViewClickAtIndex:(NSInteger)index andImages:(NSArray*)images {
    [_delegate postContainerContentImageViewClickAtIndex:index andImages:images];
}

- (void)postDetailCellLongPressAtData:(ChatLiaoLiaoPostDataModel *)data {
    [_delegate postContainerLongPressAtData:data];
}

- (void)postDetailCellChangeWithData:(ChatLiaoLiaoPostDataModel *)data andIndex:(NSInteger)index {
    
}

@end
