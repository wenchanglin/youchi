//
//  YCMyInitiateGroupM.m
//  YouChi
//
//  Created by ant on 16/5/21.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCMyInitiateGroupM.h"

@implementation YCMyInitiateGroupM

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"shopGroupBuySubs" : [YCshopGroupBuySubsM class],
             };
}


- (void)setupModel
{
    CGFloat w = SCREEN_WIDTH-16;
    CGFloat h = 0;
    
    YCShopProductM *m = self.shopProduct;
    if (m.height && m.width) {
        
        h = w / (m.width / m.height ) ;
    }
    
    // 如果没，在图片里取
    else {
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",m.imagePath];
        
        if ([strUrl rangeOfString:@"$"].location !=NSNotFound) {
            
            NSString *width = nil;
            NSString *height = nil;
            
            NSArray *arr = [strUrl componentsSeparatedByString:@"$"];
            
            width = arr[1];
            height = arr[2];
            
            h = w / (width.floatValue / height.floatValue );
        }
    }
    if (h == 0) {
        // 图片取不到，用默认值
        h = DAMAI_RATIO_2(w, 750, 340);
    }
    
    m.productName = [@" " stringByAppendingString:m.productName];
    
    NSString *nowDiscountStr = [NSString stringWithFormat:@"%.1f折",(self.nowProductStrategy.discount.floatValue * 10)];
    NSString *nextStr = [NSString stringWithFormat:@"%@/%@ ",nowDiscountStr,self.nowProductStrategy.strategyName];
    
    NSMAString *nowDiscountAtt = [self titleStr:nextStr titleStrColor:KBGCColor(@"#a81f24") titleFont:KFont(11) attText:nowDiscountStr attColor:KBGCColor(@"c4191f") attFont:[UIFont fontWithName:@"HiraKakuProN-W6" size:22]];
    _priceAttr = nowDiscountAtt;
    
    NSString *joingCountStr = [NSString stringWithFormat:@"已有%@人参团",self.joinCount];
    NSMAString *jointCountAttr =[self titleStr:joingCountStr titleStrColor:KBGCColor(@"#ffffff") titleFont:KFont(13) attText:self.joinCount.stringValue attColor:KBGCColor(@"#c40000") attFont:KFontb(13)];
    jointCountAttr.alignment = NSTextAlignmentCenter;
    _groupCountAttr = jointCountAttr;
    
    NSString *nextDiscountStr;
    
    NSMAString *brief = [NSMAString new];
    
    UIImage *img = IMAGE(@"打折ICON");
    [brief appendAttributedString:
     [NSMAString attachmentStringWithContent:img contentMode:UIViewContentModeCenter attachmentSize:img.size alignToFont:KFont(12) alignment:YYTextVerticalAlignmentCenter]
     ];
    NSMAString *nextDiscountAtt ;
    if (!self.nextProductStrategy) {
        nextDiscountStr = @" 已经达到最高折扣啦~ "; // 用于修正字体不一致时，label字体位置
        nextDiscountAtt = [self titleStr:nextDiscountStr titleStrColor:KBGCColor(@"#65656D") titleFont:KFont(12) attText:@" " attColor:KBGCColor(@"e84c3d") attFont:KFont(18)];
    }else{
        
        nextDiscountStr = [NSString stringWithFormat:@" 距离商品可以%.1f折还差%d人",(self.nextProductStrategy.discount.floatValue * 10),self.gapCount.intValue];
        nextDiscountAtt = [self titleStr:nextDiscountStr titleStrColor:KBGCColor(@"#65656D") titleFont:KFont(12) attText:self.gapCount.stringValue attColor:KBGCColor(@"e84c3d") attFont:KFont(18)];
    }
    
    UIImage *img2 = IMAGE(@"团字");
    NSMAString *brief_ = [NSMAString attachmentStringWithContent:img2 contentMode:UIViewContentModeCenter attachmentSize:img2.size alignToFont:KFont(12) alignment:YYTextVerticalAlignmentCenter];
    [brief_ appendString:@" "];
    NSMAString *text = NSMAString_initWithString( self.shopProduct.brief);
    text.font = [UIFont systemFontOfSize:12];
    text.color = [UIColor colorWithHexString:@"#65656D"];
    [brief_ appendAttributedString:text];
    
    
    [brief appendAttributedString:nextDiscountAtt];
    [brief appendString:@"\n"];
    [brief appendAttributedString:brief_];
    brief.lineSpacing = 4;
    
    YYTextContainer *tc = [YYTextContainer containerWithSize:CGSizeMake(w, HUGE) insets:UIEdgeInsetsMake(0, 8, 8, 8)];
    YYTextLayout *tl = [YYTextLayout layoutWithContainer:tc text:brief];
    _briefLayout = tl;
    
    
    YCLinearInfo *photo = [[YCLinearInfoStatic alloc]linearInfoWidth:w height:h];
    YCLinearInfo *name_price = [[YCLinearInfoStatic alloc]linearInfoWidth:w height:40];
    YCLinearInfo *brief_li = [[YCLinearInfoText alloc]linearInfoWidth:w textLayout:tl];
    YCLinearInfo *btn = [[YCLinearInfoStatic alloc]linearInfoWidth:w height:40];
    _infoMgr = [[YCLinearInfoManager alloc]initLinearInfoWithLinearInfos:@[
                                                                           photo,
                                                                           name_price,
                                                                           brief_li,
                                                                           btn,
                                                                           btn,
                                                                           ]];
    self.height = _infoMgr.height  + 8;

}

/*
 * str      整条字符
 * strColor 整条字符颜色
 * strFont  整条字符font
 * changStr 要改变的字符
 * color    要改变的字符颜色
 * font     要改变的字符font
 */

- (NSMutableAttributedString *)titleStr:(NSString *)str titleStrColor:(UIColor *)strColor titleFont:(UIFont *)strFont attText:(NSString *)changStr attColor:(UIColor *)color attFont:(UIFont *)font{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    text.color = strColor;
    text.font = strFont;
    [text setColor:color range:[str rangeOfString:changStr]];
    [text setFont:font range:[str rangeOfString:changStr]];
    
    return text;
}
@end

@implementation YCMyParticipationGroupM

- (void)setupModel
{
    [super setupModel];
    YCLinearInfo *info = [[YCLinearInfoStatic alloc]linearInfoWidth:kScreenWidth-16 height:70];
    [self.infoMgr addLinearInfo:info];
    self.height += info.height;
}

@end
@implementation YCNowProductStrategyM


@end

@implementation YCshopGroupBuySubsM


@end