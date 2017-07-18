//
//  YCChihuoyingCommentM.m
//  YouChi
//
//  Created by sam on 15/6/4.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCCatolog.h"
#import "YCCommentM.h"
#import <WTATagStringBuilder/WTATagStringBuilder.h>
#import <NSAttributedString-DDHTML/NSAttributedString+DDHTML.h>

@implementation YCCommentM
@synthesize ui_comment = _ui_comment;
- (void)dealloc{
    //ok
}
//
//+ (NSDictionary *)JSONKeyPathsByPropertyKey
//{
//    NSMutableDictionary *dict = [super JSONKeyPathsByPropertyKey].mutableCopy;
//    
//   
//    [dict addEntriesFromDictionary:@{
//                                     @"comment":@"comment",
//                                     @"levelName":@"levelName",
//                                     
//                                     @"replyCommentId":@"replyCommentId",
//                                     @"replyUserId":@"replyUserId",
//                                     @"replyUserName":@"replyUserName",
//                                     
//                                     @"youchiId":@"youchiId",
//                                     }];
//  
//    
//    return dict;
//}
//
//
//
//+ (NSValueTransformer *)html5PathJSONTransformer
//{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        if (!value) {
//            return nil;
//        }
//        NSString *img = [NSString stringWithFormat:@"%@%@",html_share,value];
//        //NSLog(@">> %@\n",img);
//        return [NSURL URLWithString:img];
//    }];
//}
//
//
//+ (NSValueTransformer *)userImageJSONTransformer
//{
//    return [self imagePathJSONTransformer];
//}
//
//
//
//+ (NSValueTransformer *)pushUserJSONTransformer
//{
//    return [self recipeJSONTransformer];
//}
//
//+ (NSValueTransformer *)recipeJSONTransformer
//{
//   return [self JSONTransformerFromDictonary:[YCMeM class]];
//}
//
//
//+ (NSValueTransformer *)youchiLikeListJSONTransformer
//{
//    return [self JSONTransformerFromArray:[YCPageModel class]];
//}
//
//+ (NSValueTransformer *)youchiPhotoListJSONTransformer
//{
//    return [self JSONTransformerFromArray:[YCPageModel class]];
//}
//
- (NSAttributedString *)ui_comment
{
    if (!_ui_comment) {
        static WTATagStringBuilder *b = nil;
        if (!b) {
            b = [WTATagStringBuilder new];
            [b addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] tag:@"color"];
            [b addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kFontComment] tag:@"font"];
        }
        b.string = [[NSString alloc]initWithFormat:@"<font>回复 <color>%@</color> %@</font>",self.replyUserName,_comment];
        if (self.replyUserName) {
            _ui_comment = b.attributedString;
        } else {
            _ui_comment = [[NSAttributedString alloc]initWithString:_comment];
        }
    }
    return _ui_comment;
}

- (void)onSetupHeightWithWidth:(float)width
{
    float height = 15.f+15.f+[self.ui_comment.string heightForFontSize:kFontComment andWidth:width-11.f-40.f-6.f-11.f]+15.f;
    self.cellHeight = MAX(height, 70);
}
@end
