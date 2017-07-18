//
//  YCRecommendMsgM.m
//  YouChi
//
//  Created by 朱国林 on 15/8/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNewsM.h"

@implementation YCNewsM
- (void)dealloc{
    //    OK
}
//+ (NSDictionary *)JSONKeyPathsByPropertyKey
//{
//    NSMutableDictionary *dict = [super JSONKeyPathsByPropertyKey].mutableCopy;
//    [dict addEntriesFromDictionary:@{
//                                     @"newsList":@"newsList",
//                            
//                                     }];
//    return dict;
//}
//+ (NSValueTransformer *)newsListJSONTransformer
//{
//    return [self JSONTransformerFromArray:[YCNewsList class]];
//}
@end



@implementation YCNewsList
- (void)dealloc{
    //    OK
}
//+ (NSDictionary *)JSONKeyPathsByPropertyKey
//{
//    NSMutableDictionary *dict = [super JSONKeyPathsByPropertyKey].mutableCopy;
//    [dict addEntriesFromDictionary:@{
//                                     @"title":@"title",
//                                     @"author":@"author",
//                                     @"favoriteCount":@"favoriteCount",
//                                     @"pv":@"pv",
//                                     @"isFavorite":@"isFavorite",
//                                     @"author":@"author",
//                                     @"htmlPath":@"htmlPath",
//                                     @"summary":@"summary",
//                                     }];
//    return dict;
//}


- (void)onSetupData
{
    float pv = self.pv.floatValue;
    NSString *readCount;
    if (pv >= 1000) {
        readCount = [NSString stringWithFormat:@"%.2fk",pv / 1000.0];
    }else{
        readCount = [NSString stringWithFormat:@"%.f",pv];
    }
    if (pv >= 10000) {
        readCount = [NSString stringWithFormat:@"%.2fw",pv / 10000.0];
    }
    
    if (self.author == nil) {
        self.author = @"báby fàce、小小编";
    }
    
    self.author = [NSString stringWithFormat:@"%@    |    阅读量: %@    |   %@",self.author,readCount,[self.createdDate substringToIndex:10]];
    
    
    if (self.favoriteCount.intValue>9999) {
        self.moreFavoriteCount = @"9999+";
    }else {
        self.moreFavoriteCount = [NSString stringWithFormat:@"%@",self.favoriteCount];
    }
    
    
}
@end