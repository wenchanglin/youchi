//
//  IntroduceDetailDataModel.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/13.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "IntroduceDetailDataModel.h"
#import "AppConstants.h"
#import "FileOperator.h"
#import "PlistEditor.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES


@implementation IntroduceDetailDataModel

- (instancetype)initWithFormulaId:(NSString*)formulaId
{
    self = [super init];
    if (self)
    {
        _originalImageUrlArray = [NSMutableArray arrayWithCapacity:100];
        _remarkArray = [NSMutableArray arrayWithCapacity:100];
        _idArray = [NSMutableArray arrayWithCapacity:100];
        _thumbImageUrlArray = [NSMutableArray arrayWithCapacity:100];
        
        
       
        
        NSString *urlString = [NSString stringWithFormat:@"%@resource/formula/steps/list/index.ashx", [AppConstants httpHeader]];
        
        NSDictionary *parameters = @{@"FormulaID":formulaId, @"page":@"1", @"pageSize":@"10"};
        
        [HTTP_CLIENT POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        
         
//                  NSLog(@"success urlString = %@", urlString);
//                  NSLog(@"Success: %@", responseObject);
                  
                  
                  if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                      NSArray *steps = [responseObject objectForKey:@"steps"];
                      NSUInteger stepsCount = [steps count];
                      
                      for (NSUInteger i = 0; i < stepsCount; i++) {
                          NSDictionary *step = [steps objectAtIndex:i];
                          
                          [_remarkArray addObject:[step objectForKey:@"remark"]];
                          [_idArray addObject:[step objectForKey:@"sort_id"]];
                          /*
                          NSString *originalImageUrl = [step objectForKey:@"original_path"];
                          
                          NSString *originalImageFileName = [AppConstants imageUrl2String:originalImageUrl];
                          
                          
                          UIImage *originalImage;
                          UIImage *thumbImage;
                          
                          if ([AppConstants fileExist:originalImageFileName]) {
                              originalImage = [FileOperator getImageWithName:originalImageFileName];
                          }
                          else {
                              [PlistEditor alterPlist:@"AppInfo" alertValue:originalImageFileName forKey:[NSString stringWithFormat:@"stepsOriginalImage%lu", (unsigned long)i]];
                              
                              originalImage = [FileOperator saveImageWithUrl:originalImageUrl toName:originalImageFileName];
                          }
                          
                          [_originalImageArray addObject:originalImage];*/
                          
                          [_originalImageUrlArray addObject:[step objectForKey:@"original_path"]];
                          
                          /*
                          NSString *thumbImageUrl = [step objectForKey:@"thumb_path"];
                          
                          NSString *thumbImageFileName = [AppConstants imageUrl2String:thumbImageUrl];
                          
                          if ([AppConstants fileExist:thumbImageFileName]) {
                              thumbImage = [FileOperator getImageWithName:thumbImageFileName];
                          }
                          else {
                              [PlistEditor alterPlist:@"AppInfo" alertValue:thumbImageFileName forKey:[NSString stringWithFormat:@"stepsThumbImage%lu", (unsigned long)i]];
                              
                              thumbImage = [FileOperator saveImageWithUrl:thumbImageUrl toName:thumbImageFileName];
                          }
                          
                          [_thumbImageArray addObject:thumbImage];*/
                          
                          [_thumbImageUrlArray addObject:[step objectForKey:@"thumb_path"]];
                          
                          NSLog(@"%lu", (unsigned long)i);
                      }
                      
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"IntroduceDetailRequestDone" object:nil];
                  }
                  else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                      NSLog(@"获取列表失败 %@", urlString);
                      
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"IntroduceDetailRequestFail" object:nil];
                  }
                  
                  
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  NSLog(@"false urlString = %@", urlString);
                  NSLog(@"Error: %@", error);
                  
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"IntroduceDetailRequestFail" object:nil];
              }];
    }
    return self;
}

@end
