//
//  YCCellManagerFrame.m
//  YouChi
//
//  Created by water on 16/6/17.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCellManagerFrame.h"
#import "YCChihuoyingM.h"

@implementation YCCellManagerFrame

-(void)setModel:(YCChihuoyingM_1_2 *)model{
    _model = model;
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    if (model.materialName == nil) {
        model.materialName = @"";
    }
    
    NSMutableAttributedString *materialName = [[NSMutableAttributedString alloc]initWithString:model.materialName];
    [materialName appendString:@"\n"];
    materialName.font = KFont(kFontYouChiTitle);
    materialName.lineSpacing = 10;
    if (model.desc == nil) {
        model.desc = @"";
    }
    NSMutableAttributedString *desc = [[NSMutableAttributedString alloc]initWithString:model.desc];
    desc.font = KFont(kFontYouChiContent);
    desc.color = [UIColor colorWithHex:0x000000];
    desc.lineSpacing = 4;
    
    [text appendAttributedString:materialName];
    [text appendAttributedString:desc];
    
    YYTextContainer *tc = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH, HUGE) insets:UIEdgeInsetsMake(8, 15, 8, 15)];
    tc.maximumNumberOfRows = 5;
    tc.truncationType = YYTextTruncationTypeEnd;
    
    
    model.textLayout = [YYTextLayout layoutWithContainer:tc text:text];
    
    CGFloat h = 50+SCREEN_WIDTH*3/4+SCREEN_WIDTH*5/32+20+model.textLayout.textBoundingSize.height+42;
    if (model.recipeList.count>0) {
        h += 80;
    }
    h += 10;

    
    _cellH = h;
}

@end
