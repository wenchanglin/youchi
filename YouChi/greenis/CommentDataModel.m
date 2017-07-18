//
//  CommentDataModel.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/23.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "CommentDataModel.h"
#import "AppConstants.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

@interface CommentDataModel () {
    
}

@property (strong, nonatomic) NSString          *formulaId;

@end

@implementation CommentDataModel

- (instancetype)initWithFormulaId:(NSString*)formulaId AndCommentCount:(int)count forUpdate:(BOOL)isUpdate
{
    self = [super init];
    if (self)
    {
        _imageNameArray = [NSMutableArray arrayWithCapacity:100];
        _nameArray = [NSMutableArray arrayWithCapacity:100];
        _timeArray = [NSMutableArray arrayWithCapacity:100];
        _contentArray = [NSMutableArray arrayWithCapacity:100];
        
        _formulaId = formulaId;
        
        // 获取最新数据
    
        
        NSString *urlString = [NSString stringWithFormat:@"%@interaction/formula/comment/list/index.ashx", [AppConstants httpHeader]];
        
        NSDictionary *parameters = @{@"formulaId":_formulaId, @"page":@"1", @"pageSize":[NSString stringWithFormat:@"%d", count]};
        
        [HTTP_CLIENT POST:urlString parameters:parameters
              progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  NSLog(@"%@ Success:success:^(AFHTTPRequestOperation *operation,id responseObject) {   %@", urlString, responseObject);
                  
                  if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                      NSArray *comments = [responseObject objectForKey:@"comments"];
                      NSUInteger commentsCount = [comments count];
                      
                      for (NSUInteger i = 0; i < commentsCount; i++) {
                          NSDictionary *comment = [comments objectAtIndex:i];
                          
                          [_imageNameArray addObject:[comment objectForKey:@"avatar"]];
                          [_nameArray addObject:[comment objectForKey:@"user_nick_name"]];
                          [_timeArray addObject:[comment objectForKey:@"add_time"]];
                          [_contentArray addObject:[comment objectForKey:@"content"]];
                      }
                      
                      if (!isUpdate) {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"commentRequestDone" object:nil];
                      }
                      else {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"commentRequestUpdateDone" object:nil];
                      }
                  }
                  else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                      NSLog(@"获取列表失败 %@", urlString);
                      
                      if (!isUpdate) {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"commentRequestFail" object:nil];
                      }
                      else {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"commentRequestUpdateFail" object:nil];
                      }
                  }
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"Error: %@", error);
                  
                  if (!isUpdate) {
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"commentRequestFail" object:nil];
                  }
                  else {
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"commentRequestUpdateFail" object:nil];
                  }
              }];
    }
    return self;
}

@end
