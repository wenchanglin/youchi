//
//  YCModel.h
//  YouChi
//
//  Created by sam on 15/5/6.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <WTATagStringBuilder/WTATagStringBuilder.h>
#import <YYKit/YYKit.h>
#import "YCMarcros.h"
#import "YCDefines.h"

NS_INLINE BOOL isOldOSS(NSString *imagePath){
    return [imagePath hasPrefix:@"/upload"];
}

@interface YCBaseModel : NSObject<NSCoding>
@property (nonatomic,strong) NSNumber *Id;
@property (nonatomic,strong) NSString *desc,*createdDate;

PROPERTY_STRONG_READONLY NSString *shortCreateDate;

+ (NSDictionary *)modelCustomPropertyMapper;
+ (NSDictionary *)modelContainerPropertyGenericClass;

- (void)setupModel;
@end

@interface YCBaseImageModel : YCBaseModel
@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,assign) CGFloat imageWidth,imageHeight,width,height;

@end

@interface YCBaseUserImageModel : YCBaseImageModel
@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSString *userImage,*userImagePath,*userName;
@end