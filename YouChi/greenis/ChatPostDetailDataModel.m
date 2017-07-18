//
//  ChatPostDetailDataModel.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/23.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "ChatPostDetailDataModel.h"
#import "AppConstants.h"
#import "PlistEditor.h"
#import "FileOperator.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

@implementation ChatPostDetailDataModel

- (instancetype)initWithID:(NSInteger)ID forUpdate:(BOOL)isUpdate
{
    self = [super init];
    if (self)
    {
//
//        _addTimeArray = [NSMutableArray arrayWithCapacity:100];
//        _contentArray = [NSMutableArray arrayWithCapacity:100];
//        _userIdArray = [NSMutableArray arrayWithCapacity:100];
//        _avatarArray = [NSMutableArray arrayWithCapacity:100];
//        _usernameArray = [NSMutableArray arrayWithCapacity:100];
//        _nickNameArray = [NSMutableArray arrayWithCapacity:100];
//
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        manager.securityPolicy = securityPolicy;
//        
//        //        NSString *urlString = [NSString stringWithFormat:@"%@resource/article/frontpage/slide/list/index.ashx", [AppConstants httpHeader]];
//        
//        //        NSDictionary *parameters = @{@"page":@"1", @"pageSize":@"10"};
//        
//        NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/post/comment/list/index.ashx", [AppConstants httpHeader]];
//        
//        NSDictionary *parameters = @{@"page":@"1", @"pageSize":@"10", @"PostId":[NSString stringWithFormat:@"%ld", (long)ID]};
//        
//        [manager POST:urlString parameters:parameters
//              success:^(AFHTTPRequestOperation *operation,id responseObject) {
//                  NSLog(@"success urlString = %@", urlString);
//                  NSLog(@"Success: %@", responseObject);
//                  
//                  if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
//                      NSArray *comments = [responseObject objectForKey:@"comments"];
//                      NSUInteger commentsCount = [comments count];
//                      //                      NSLog(@"articles count = %lu", (unsigned long)[articles count]);
//                      /*
//                       [[AppConstants UpdatingPlistLock] lock];
//                       
//                       [PlistEditor alterPlist:@"AppInfo" alertValue:[NSString stringWithFormat:@"%lu", (unsigned long)articlesCount] forKey:@"adImageCount"];
//                       
//                       [AppConstants writeDic2File];
//                       
//                       [[AppConstants UpdatingPlistLock] unlock];
//                       */
//                      
//                      for (NSUInteger i = 0; i < commentsCount;i++) {
//                          NSDictionary *comment = [comments objectAtIndex:i];
//                          
//                          [_addTimeArray addObject:[comment objectForKey:@"addtime"]];
//                          [_userIdArray addObject:[comment objectForKey:@"userId"]];
//                          [_contentArray addObject:[comment objectForKey:@"content"]];
//                          [_avatarArray addObject:[comment objectForKey:@"avatar"]];
//                          [_usernameArray addObject:[comment objectForKey:@"userName"]];
//                          [_nickNameArray addObject:[comment objectForKey:@"nickName"]];
//                      }
//                      
//                      if (isUpdate) {
//                          [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatPostDetailRequestForUpdateDone" object:nil];
//                      }
//                      else {
//                          [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatPostDetailRequestDone" object:nil];
//                      }
//                      
//                      /*
//                       dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                       [self updatePlist:articles];
//                       });*/
//                  }
//                  else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
//                      NSLog(@"获取列表失败 %@", urlString);
//                      
//                      if (isUpdate) {
//                          [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatPostDetailRequestForUpdateFail" object:nil];
//                      }
//                      else {
//                          [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatPostDetailRequestFail" object:nil];
//                      }
//                  }
//              }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
//                  NSLog(@"false urlString = %@", urlString);
//                  NSLog(@"Error: %@", error);
//                  
//                  if (isUpdate) {
//                      [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatPostDetailRequestForUpdateFail" object:nil];
//                  }
//                  else {
//                      [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatPostDetailRequestFail" object:nil];
//                  }
//              }];
    }
    return self;
}
/*
 - (void)updatePlist:(NSArray*)array {
 
 [[AppConstants UpdatingPlistLock] lock];
 
 int count = (int)[array count];
 
 for (int i = 0; i < count; ++i) {
 NSDictionary *dic = [array objectAtIndex:i];
 
 NSString *imageFileName = [AppConstants imageUrl2String:[dic objectForKey:@"ImgUrl"]];
 [PlistEditor alterPlist:@"AppInfo" alertValue:imageFileName forKey:[NSString stringWithFormat:@"adImage%d", i]];
 
 [PlistEditor alterPlist:@"AppInfo" alertValue:[dic objectForKey:@"UserName"] forKey:[NSString stringWithFormat:@"adUserName%d", i]];
 
 [PlistEditor alterPlist:@"AppInfo" alertValue:[dic objectForKey:@"addtime"] forKey:[NSString stringWithFormat:@"adAddtime%d", i]];
 [PlistEditor alterPlist:@"AppInfo" alertValue:[dic objectForKey:@"articleid"] forKey:[NSString stringWithFormat:@"adArticleid%d", i]];
 [PlistEditor alterPlist:@"AppInfo" alertValue:[dic objectForKey:@"click"] forKey:[NSString stringWithFormat:@"adClick%d", i]];
 [PlistEditor alterPlist:@"AppInfo" alertValue:[dic objectForKey:@"comment_total"] forKey:[NSString stringWithFormat:@"adCommentTotal%d", i]];
 [PlistEditor alterPlist:@"AppInfo" alertValue:[dic objectForKey:@"formulas_total"] forKey:[NSString stringWithFormat:@"adFormulasTotal%d", i]];
 [PlistEditor alterPlist:@"AppInfo" alertValue:[dic objectForKey:@"title"] forKey:[NSString stringWithFormat:@"adTitle%d", i]];
 NSLog(@"%@ %@", [NSString stringWithFormat:@"adTitle%d", i], [dic objectForKey:@"title"]);
 [PlistEditor alterPlist:@"AppInfo" alertValue:[dic objectForKey:@"zhaiyao"] forKey:[NSString stringWithFormat:@"adZhaiyao%d", i]];
 }
 
 
 [AppConstants writeDic2File];
 [[AppConstants UpdatingPlistLock] unlock];
 NSLog(@"ad updatePlist done");
 }*/

- (instancetype)initFromLocal {
    self = [super init];
    if (self)
    {
        /*
         _adTypeArray = [NSMutableArray arrayWithCapacity:100];
         _addtimeArray = [NSMutableArray arrayWithCapacity:100];
         _contentArray = [NSMutableArray arrayWithCapacity:100];
         _idArray = [NSMutableArray arrayWithCapacity:100];
         _savedImageArray = [NSMutableArray arrayWithCapacity:100];
         _imageArray = [NSMutableArray arrayWithCapacity:100];
         _nameArray = [NSMutableArray arrayWithCapacity:100];
         _shareUrlArray = [NSMutableArray arrayWithCapacity:100];
         _topicIdFkArray = [NSMutableArray arrayWithCapacity:100];
         
         [NSThread detachNewThreadSelector:@selector(loadDatas) toTarget:self withObject:nil];*/
    }
    
    return self;
}
/*
 - (void)loadDatas {
 
 NSLog(@"ad loaddatas");
 
 int adImageCount = [PlistEditor queryPlist:@"AppInfo" withKey:@"adImageCount"].intValue;
 //    NSLog(@"adImageCount = %d", adImageCount);
 for (int i = 0; i < adImageCount; ++i) {
 NSString *imagePath = [PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"%@%d", [AppConstants adImageName], i]];
 [_savedImageArray addObject:[FileOperator getImageName:imagePath]];
 
 if ([imagePath isEqualToString:@""]) {
 NSLog(@"key = %@, imagePath = %@, imageName = %@",[NSString stringWithFormat:@"%@%d", [AppConstants adImageName], i], imagePath, [FileOperator getImageName:imagePath]);
 }
 
 [_imageArray addObject:imagePath];
 
 [_userNameArray addObject:[PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"adUserName%d", i]]];
 [_addtimeArray addObject:[PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"adAddtime%d", i]]];
 [_articleidArray addObject:[PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"adArticleid%d", i]]];
 [_clickArray addObject:[PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"adClick%d", i]]];
 [_commentTotalArray addObject:[PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"adCommentTotal%d", i]]];
 [_formulasTotalArray addObject:[PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"adFormulasTotal%d", i]]];
 [_titleArray addObject:[PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"adTitle%d", i]]];
 
 NSLog(@"%@ %@", [NSString stringWithFormat:@"adTitle%d", i], [PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"adTitle%d", i]]);
 [_zhaiyaoArray addObject:[PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"adZhaiyao%d", i]]];
 }
 
 //    NSLog(@"ad %lu %lu %lu %lu %lu %lu %lu %lu %lu" ,(unsigned long)[_imageArray count], (unsigned long)[_userNameArray count], (unsigned long)[_addtimeArray count], (unsigned long)[_articleidArray count], (unsigned long)[_clickArray count], (unsigned long)[_commentTotalArray count], (unsigned long)[_formulasTotalArray count], (unsigned long)[_titleArray count], (unsigned long)[_zhaiyaoArray count]);
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatADRequestDone" object:nil];
 }*/

@end


