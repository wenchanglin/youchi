//
//  YCSuishoupaiVM.m
//  YouChi
//
//  Created by sam on 15/6/9.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCRandomPicturesVM.h"

#import "YCViewModel+Logic.h"
@import AssetsLibrary;

@implementation YCRandomPicturesVM
{
    NSMutableArray *_modelsProxy;
}

- (void)dealloc
{
    //ok
}


- (NSMutableArray *)modelsProxy
{
    if (!_modelsProxy) {
        _modelsProxy = [[NSMutableArray alloc]initWithCapacity:6];
    }
    return _modelsProxy;
}

- (void)setModelsProxy:(NSMutableArray *)modelsProxy
{
    _modelsProxy = modelsProxy;
}

#pragma mark -
- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.desc forKey:KP(self.desc)];
    [aCoder encodeObject:self.materialName forKey:KP(self.materialName)];
    [aCoder encodeObject:self.modelsProxy forKey:KP(self.modelsProxy)];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.desc = [aDecoder decodeObjectForKey:KP(self.desc)];
        self.materialName = [aDecoder decodeObjectForKey:KP(self.materialName)];
        self.modelsProxy = [aDecoder decodeObjectForKey:KP(self.modelsProxy)];
    }
    return self;
}


- (RACSignal *)signalUploadWith:(RACSubject *)msg
{
    CHECK_SIGNAL(self.desc.length==0, @"描述不能为空");
    CHECK_SIGNAL(self.materialName.length==0, @"食材名称不能为空");
    CHECK_SIGNAL(self.modelsProxy.count<=0, @"请添加至少一张图片");
    
    WSELF;
    
    
    RACSignal *signal = [self uploadToAliyunWithImages:self.modelsProxy messageSignal:msg isShop:NO];
    return [signal.collect flattenMap:^RACStream *(NSArray<NSDictionary *> *imageParams) {
        SSELF;
        
        NSMutableDictionary *param = @{
                                       kToken:[YCUserDefault currentToken],
                                       @"description":[self.desc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                       @"materialName":[self.materialName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                       @"city":self.city,
                                       @"fileSize":@(imageParams.count),
                                       
                                       }.mutableCopy;
        [imageParams enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [param addEntriesFromDictionary:obj];
        }];
        
        return [ENGINE POST_shop_object:@"app/upload/youchi/uploadYouchiForOss.json" parameters:param parseClass:nil parseKey:nil];
    }];
}





/**
 materialName	Y	1.2	String		食材名
 city	Y	1.2	String		城市
 description	Y	1.2	string		随手拍描述
 longitude		1.2	double		经度
 latitude		1.2	double		纬度
 locationDesc		1.2	string		位置描述
 country		1.2	string		国家
 province		1.2	string		省份
 area		1.2	string		区域
 
 */

@end







