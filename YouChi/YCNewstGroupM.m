//
//  YCNewstGroupM.m
//  YouChi
//
//  Created by ant on 16/5/21.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCNewstGroupM.h"


@implementation YCNewstGroupM

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shopSpecs" : [YCShopSpecs class],
             };
}

- (void)setupModel
{
    self.productName = [@" " stringByAppendingString:self.productName];
    
    NSString *groupStr = [NSString stringWithFormat:@"共有%d人开团",self.sponsorCount.intValue];
    NSMAString *groupPurchaseNumtext = NSMAString_initWithString(groupStr);
    groupPurchaseNumtext.font = [UIFont systemFontOfSize:13];
    groupPurchaseNumtext.color = [UIColor whiteColor];
    groupPurchaseNumtext.alignment = NSTextAlignmentCenter;
    
    NSMAString *count = NSMAString_initWithString(self.sponsorCount.stringValue);
    count.color = [UIColor colorWithHexString:@"#c40000"];
    count.font = [UIFont boldSystemFontOfSize:13];
    [groupPurchaseNumtext replaceCharactersInRange:[groupStr rangeOfString:count.string] withAttributedString:count];
    _groupCountAttr = groupPurchaseNumtext;
    
    
    NSMAString *allPrice = [NSMAString new];
    NSString *sp = [NSString stringWithFormat:@"%.2f",self.shopPrice.floatValue];
    NSMAString *shopPrice = NSMAString_initWithString(sp);
    [shopPrice setAttributes:@{NSKernAttributeName : @(-1.3f)}];
    shopPrice.color = [UIColor colorWithHexString:@"#c41914"];
    shopPrice.font = [UIFont fontWithName:@"Verdana-Bold" size:22];
    
    NSMAString *yuan = NSMAString_initWithString(@"元 ");
    yuan.color = shopPrice.color;
    [shopPrice appendAttributedString:yuan];
    
    NSString *mp = [NSString stringWithFormat:@"%.2f元 ",self.marketPrice.floatValue];
    NSMAString *marketPrice = NSMAString_initWithString(mp);
    marketPrice.font = KFont(12);
    marketPrice.strikethroughStyle = NSUnderlinePatternSolid | NSUnderlineStyleSingle;
    marketPrice.strikethroughColor = [UIColor blackColor];
    
    [allPrice appendAttributedString:shopPrice];
    [allPrice appendAttributedString:marketPrice];
    
    _priceAttr = allPrice;
    
    UIImage *img = IMAGE(@"团字");
    NSMAString *brief = [NSMAString attachmentStringWithContent:img contentMode:UIViewContentModeCenter attachmentSize:img.size alignToFont:KFont(12) alignment:YYTextVerticalAlignmentCenter];
    [brief appendString:@" "];
    NSMAString *text = NSMAString_initWithString( self.brief);
    text.font = [UIFont systemFontOfSize:12];
    text.color = [UIColor colorWithHexString:@"#65656D"];
    [text setColor:[UIColor colorWithHexString:@"#e84c3d"] range:NSMakeRange(0,1)];
    [text setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 1)];
    [brief appendAttributedString:text];
    brief.lineSpacing = 2;

    CGFloat w = SCREEN_WIDTH-16;
    CGFloat h = 0;
    
    YCNewstGroupM *m = self;
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
    YYTextContainer *tc = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH-16, HUGE) insets:UIEdgeInsetsMake(0, 8, 8, 8)];
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
                                                                            btn
                                                                            ]];
    self.height = _infoMgr.height + 8;
}





@end
