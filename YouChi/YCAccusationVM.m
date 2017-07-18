//
//  YCJuBaoVM.m
//  YouChi
//
//  Created by 李李善 on 15/6/8.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCChihuoyingM.h"
#import "YCAccusationVM.h"
#import "AppDelegate.h"
#import <NSAttributedString-DDHTML/NSAttributedString+DDHTML.h>
@implementation YCAccusationVM

- (void)dealloc{
    //ok
}

- (instancetype)initWithModel:(YCChihuoyingM_1_2 *)aModel
{
    self = [self init];
    if (self) {
        
        self.model = aModel;
        self.Id = self.model.Id;

        if ([aModel isKindOfClass:[YCChihuoyingM_1_2 class]]) {
            YCChihuoyingM_1_2 *m = aModel;
            NSString *str = m.youchiType.intValue ==YCCheatsTypeYouChi ?@"随手拍":@"秘籍";
            NSString *name =[NSString stringWithFormat:@"@%@",m.userName];
            self.name = [NSAttributedString attributedStringFromHTML:[[NSString alloc] initWithFormat:@"举报<font size='15' color='#eaa93b'>%@</font>的%@",name,str]];

            self.info = [NSAttributedString attributedStringFromHTML:[[NSString alloc] initWithFormat:@"<font size='15' color='#eaa93b'>%@:</font><font size='13'>%@</font>",name,m.desc]];
        }

    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reports = [NSMutableArray new];
        [self.modelsProxy setArray:@[ @"垃圾营销", @"色情",@"不实信息", @"敏感信息",@"抄袭内容", @"搔扰信息",
                                     @"虚假中奖",@"其他"]];

    }
    return self;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    if (self.modelsProxy.count/2 != 0)
        return self.modelsProxy.count/2+1;
    else
        return self.modelsProxy.count/2;
}


- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath width:(CGFloat)width
{
    if (indexPath.section==1) {
        return[self.info.string heightForFontSize:13 andWidth:kScreenWidth-8*2]+15*2.f;
    }
    else if (indexPath.section==2)
    {
        if (self.modelsProxy.count/2 != 0)
            return (self.modelsProxy.count/2+1)*35.f;
        else
            return (self.modelsProxy.count/2)*35.f;
   
    }
    return 35.f;
}

-(NSString *)cellIDAtIndexPath:(NSIndexPath *)indexPath
{
    return cell3;
}

- (id)modelForItemAtIndexPath:(NSIndexPath *)indexPath
{
        NSUInteger loc = 2*indexPath.row;
        NSUInteger end = MIN(self.modelsProxy.count, loc+2);
        return  [self.modelsProxy subarrayWithRange:NSMakeRange(loc, end-loc)];

    
}




#pragma mark-- 提交投诉/举报的接口

- (RACSignal *)onJuBaoSignal:(NSArray *)reports
{
    NSString *str = [reports componentsJoinedByString:@","];
    NSInteger type = self.model.youchiType.intValue;
    return [ENGINE POSTBool:apiGGSaveComplaint parameters:@{kToken:[YCUserDefault currentToken],
                                                            kOriginalType:@(type),//---举报的类型
                                                            
                                                            kActionId:self.Id ,//---当前举报对象的id
                                                            
                                                            kDescription:str//---内容
                                                            
                                                            }];


}

/**
 
 
 
 kOriginalType:举报的类型
 
 1 - 随手拍
 
 2 - 果单
 
 
 actionId:当前举报对象的id
 
 根据originalType参数提供
 
 例如: 果单id、随手拍id
 
 */

@end
