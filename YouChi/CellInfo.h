//
//  CellData.h
//  funvive
//
//  Created by DengZhiMin on 16/3/4.
//  Copyright © 2016年 jiquke. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef CGFloat (^CellHeightBlock)(NSIndexPath *indexPath);
typedef NSInteger (^CellNumberBlock)(NSInteger section);
typedef _Nullable id (^CellModelBlock)(NSIndexPath *indexPath);
typedef CGSize (^CellSizeBlock)(NSIndexPath *indexPath);
typedef UIEdgeInsets (^CellEdgeBlock)(NSIndexPath *indexPath);

@interface CellInfo : NSObject
@property (nonatomic,strong,readonly) NSString *Id;
@property (nonatomic,assign,readonly) UITableViewCellStyle style;
@property (nonatomic,strong,readonly) CellHeightBlock heightBlock;
@property (nonatomic,strong,readonly) CellNumberBlock numberBlock;
@property (nonatomic,strong,readonly) CellModelBlock modelBlock;
@property (nonatomic,strong,readonly) CellSizeBlock sizeBlock;
@property (nonatomic,strong,readonly) CellEdgeBlock edgeBlock;
@property (nonatomic,strong,readonly) CellInfo *headInfo;
@property (nonatomic,strong,readonly) CellInfo *footInfo;

///tableview
+ (instancetype)cellInfoWithId:(NSString *)Id height:(CellHeightBlock )heightBlock  number:(CellNumberBlock _Nullable)numberBlock model:(CellModelBlock _Nullable)modelBlock  edge:(CellEdgeBlock _Nullable)edgeBlock headInfo:(CellInfo * _Nullable)headInfo footInfo:(CellInfo * _Nullable)footInfo style:(UITableViewCellStyle )style;

+ (instancetype)cellInfoWithId:(NSString *)Id height:(CellHeightBlock )heightBlock  number:(CellNumberBlock _Nullable)numberBlock model:(CellModelBlock _Nullable)modelBlock  edge:(CellEdgeBlock _Nullable)edgeBlock headInfo:(CellInfo * _Nullable)headInfo footInfo:(CellInfo * _Nullable)footInfo;

+ (instancetype)cellInfoWithId:(NSString *)Id height:(nonnull CellHeightBlock)heightBlock number:(CellNumberBlock _Nullable)numberBlock model:(CellModelBlock _Nullable)modelBlock edge:(CellEdgeBlock _Nullable)edgeBlock;

+ (instancetype)cellInfoWithId:(NSString *)Id height:(CellHeightBlock )heightBlock number:(CellNumberBlock )numberBlock model:(CellModelBlock _Nullable)modelBlock headInfo:( CellInfo * _Nullable )headInfo footInfo:( CellInfo * _Nullable )footInfo;

+ (instancetype)cellInfoWithId:(NSString *)Id height:(CellHeightBlock )heightBlock number:(CellNumberBlock )numberBlock model:(_Nullable CellModelBlock)modelBlock;

+ (instancetype)cellInfoWithId:(NSString *)Id height:(CellHeightBlock )heightBlock number:(CellNumberBlock )numberBlock;

///collectionview
+ (instancetype)cellInfoWithId:(NSString *)Id  number:(CellNumberBlock _Nullable)numberBlock model:(CellModelBlock _Nullable)modelBlock edge:(CellEdgeBlock _Nullable)edgeBlock size:(CellSizeBlock _Nullable)sizeBlock  headInfo:(CellInfo * _Nullable)headInfo footInfo:(CellInfo * _Nullable)footInfo;

///header or footer
+ (instancetype)subInfoWithHeight:(CellHeightBlock )heightBlock model:(_Nullable CellModelBlock)modelBlock;

+ (CellHeightBlock)height:(CellHeightBlock )heightBlock;
+ (CellNumberBlock)number:(CellNumberBlock )numberBlock;
+ (CellModelBlock)model:(CellModelBlock)modelBlock;
+ (CellSizeBlock)size:(CellSizeBlock)sizeBlock;
+ (CellEdgeBlock)edge:(CellEdgeBlock)edgeBlock;
@end

#define CellInfo_number(_number_) [CellInfo number:^NSInteger(NSInteger section) { return _number_;}]
#define CellInfo_number_1 [CellInfo number:^NSInteger(NSInteger section) { return 1;}]
#define CellInfo_height(_height_) [CellInfo height:^CGFloat(NSIndexPath * _Nonnull indexPath) {return _height_;}]

@interface NSMutableArray (CellInfo)
- (void)setArray:(NSArray *)otherArray count:(NSUInteger)count;
@end
NS_ASSUME_NONNULL_END