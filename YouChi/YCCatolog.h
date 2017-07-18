//
//  OFCatolog.h
//  OrderingFood
//
//  Created by Mallgo on 15-3-20.
//  Copyright (c) 2015年 mall-go. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreText/CoreText.h>

typedef void (^YCNextBlock)(id next);
typedef void(^YCErrorBlock)(NSError *error);
typedef void (^YCCompleteBlock)(void);
typedef void (^YCExecutingBlock)(BOOL isExecuting);

typedef NSString *(^YCPhotoCellIdBlock)(NSIndexPath *indexPath);
typedef void(^YCPhotoUpdateBlock)(id cell,id model);
typedef void(^YCPhotoPageBlock)(NSIndexPath *indexPath,id model);
typedef CGSize (^YCPhotoSizeBlock)(CGSize size);
typedef CGFloat (^YCPhotoHeightBlock)(NSIndexPath *indexPath);
typedef void(^YCPhotoSelectBlock)(NSIndexPath *indexPath,id model);

typedef void(^TableViewCellUpdateBlock)(UITableViewCell * cell,NSIndexPath *indexPath);

static NSString *NSJSONKitErrorDomain = @"NSJSONKitErrorDomain";
@interface YCCatolog : NSObject

@end

@interface UITableViewCell (OF)
@property (nonatomic,weak) UIViewController *pushedViewController;
- (void)update:(id)model atIndexPath:(NSIndexPath *)indexPath controller:(UIViewController *)vc;
- (void)update:(id)model atIndexPath:(NSIndexPath *)indexPath;

@end

@interface UICollectionViewCell (OF)
- (void)update:(id)model atIndexPath:(NSIndexPath *)indexPath;
@end


@interface RACSignal (OF)
+ (RACSignal *)errorString:(NSString *)e;

@end

@interface NSObject (JSONKit)

- (NSString *)mgm_JSONString;
- (NSString *)mgm_JSONStringWithOptions:(NSJSONWritingOptions)opt error:(NSError **)error;
- (NSData *)mgm_JSONData;
- (NSData *)mgm_JSONDataWithOptions:(NSJSONWritingOptions)opt error:(NSError **)error;

@end

@interface NSAttributedString (YC)
- (CGFloat)heightWithFixedWidth:(CGFloat)width;
@end

@interface NSString (YC)
- (CGFloat) heightForFontSize:(CGFloat)fontSize andWidth:(CGFloat)width;
- (NSString *) yc_md5;
+ (NSString *)yc_md5Sign:(NSDictionary *)dict;
+ (NSString *)genPackage:(NSMutableDictionary*)packageParams;
@end

