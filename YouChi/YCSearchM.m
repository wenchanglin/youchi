//
//  YCSearchM.m
//  YouChi
//
//  Created by 李李善 on 15/6/2.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSearchM.h"




@implementation YCSearchM
- (void)dealloc
{
    //    OK
}
//
//+ (NSDictionary *)JSONKeyPathsByPropertyKey
//{
//    NSMutableDictionary *dict = [super JSONKeyPathsByPropertyKey].mutableCopy;
//    [dict addEntriesFromDictionary:@{
//                                     //              键
//                                     @"appUserPage":@"appUserPage",
//                                     @"recipePage":@"recipePage",
//                                     }];
//    
//    return dict;
//}
//
//+ (NSValueTransformer *)recipePageJSONTransformer
//{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        NSArray *arr = value[@"content"];
//   
//        if (!arr) {
//            return nil;
//        }
//        return [MTLJSONAdapter modelsOfClass:[YCChihuoyingRecipeM class]
//                               fromJSONArray:arr error:error];
//    }];
//}
//
//+ (NSValueTransformer *)appUserPageJSONTransformer
//{
//    return [self recipePageJSONTransformer];
//}
//+ (NSValueTransformer *)resultJSONTransformer
//{
//    return [self recipePageJSONTransformer];
//}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"appUserPage" : @"content.appUserPage",
             @"recipePage" : @"content.recipePage"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"appUserPage" : YCChihuoyingRecipeM.class,
             @"recipePage" : YCChihuoyingRecipeM.class,
             };
}
@end
