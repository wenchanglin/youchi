//
//  YCCellInfo.h
//  YouChi
//
//  Created by sam on 16/1/23.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef CGFloat (^YCCellHeightBlock)(NSIndexPath *indexPath);
typedef NSInteger (^YCCellNumberBlock)(NSInteger section);
typedef NSInteger (^YCCellSectionBlock)();
typedef NSInteger (^YCCellRowBlock)(NSInteger section);
typedef id (^YCCellModelBlock)(NSIndexPath *indexPath);
@interface YCCellInfo : NSObject
@property (nonatomic,strong,readonly) NSString *Id;
@property (nonatomic,strong,readonly) YCCellHeightBlock heightBlock;
@property (nonatomic,strong,readonly) YCCellNumberBlock numberBlock;
@property (nonatomic,strong,readonly) YCCellModelBlock modelBlock;
+ (instancetype)cellInfoWithId:(NSString *)Id height:(YCCellHeightBlock )heightBlock number:(YCCellNumberBlock )numberBlock model:(YCCellModelBlock)modelBlock;
+ (instancetype)cellInfoWithId:(NSString *)Id height:(YCCellHeightBlock )heightBlock number:(YCCellNumberBlock )numberBlock;
+ (YCCellHeightBlock)height:(YCCellHeightBlock )heightBlock;
+ (YCCellNumberBlock)number:(YCCellNumberBlock )numberBlock;
+ (YCCellModelBlock)model:(YCCellModelBlock)modelBlock;
@end
