//
//  YCNotificationM.m
//  YouChi
//
//  Created by 李李善 on 15/6/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNotificationM.h"
#import "YCCatolog.h"
@implementation YCNotificationM
-(void)dealloc{
    //    ok
    
}
//+ (NSDictionary *)JSONKeyPathsByPropertyKey
//{
//    NSMutableDictionary *dict = [super JSONKeyPathsByPropertyKey].mutableCopy;
//
//    [dict addEntriesFromDictionary:@{@"message":@"message",
//                                    @"originalAction":@"originalAction",
//                                     @"originalType":@"originalType",
//                                     @"createdBy":@"createdBy",
//                                    @"lastModifiedBy":@"lastModifiedBy",
//                                     @"lastModifiedDate":@"lastModifiedDate",
//                                     @"status":@"status",
//                                    @"deletedBy":@"deleteBy",
//                                     @"deletedDate":@"deleteDate",
//                                     @"pushUser":@"pushUser",
//                                     @"title":@"title",
//                                     @"user":@"user",
//                                     @"userId":@"userId",
//                                     @"firstPage":@"firstPage",
//                                     @"lastPage":@"lastPage",
//                                    @"numberOfElements":@"numberOfElements",
//                                     @"size":@"size",
//                                     @"totalElements":@"totalElements",
//                                     @"totalPages":@"totalPages",
//                                     @"createdDate":@"createdDate",
//                                    }];
//    return dict;
//}


- (void)onSetupHeightWithWidth:(float)width
{
    
    float height = 15.f+3.f+1.F+12.f+[self.message heightForFontSize:kFontComment andWidth:width-13.f-10.f-10.f]+10.f;
    if (height <= 70.f) {
        height = 70.f;
    }
    
//    NSLog(@"%f---%f",height,[self.message heightForFontSize:kFontComment andWidth:width-13.f-10.f-10.f]);
    
    
    self.cellHeight = height;
}
@end
