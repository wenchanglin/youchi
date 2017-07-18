//
//  YCShopSearchCell.m
//  YouChi
//
//  Created by 李李善 on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCShopSearchCell.h"
#import "YCCatolog.h"
#import "YCShopCategoryM.h"
#import "YCView.h"
@implementation YCShopSearchCell

- (void)awakeFromNib {
    // Initialization code
    self.lName.font = KFontBold(15);
    self.lMuch.textColor = KBGCColor(@"#65656c");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(YCShopCategoryM *)model atIndexPath:(NSIndexPath *)indexPath
{
    [_imgInfo ycShop_setImageWithURL:model.imagePath placeholder:PLACE_HOLDER];
//    self.lTitle.text = model.shopKeyword.keyword;
    self.lKeyWord.text = model.shopKeyword.keyword;
    self.lName.text = model.productName;
    self.lPrice.text = [NSString stringWithFormat:@"%.2f",model.shopPrice.floatValue];
    self.lLodPrice.text = [NSString stringWithFormat:@"%.2f",model.marketPrice.floatValue];
    self.lMuch.text = model.brief;
    
}

-(void)setIsShopSearch:(BOOL)isShopSearch
{
    if (_isShopSearch != isShopSearch) {
        _isShopSearch = isShopSearch;
       self.lTitle.hidden =self.imgTitle.hidden = _isShopSearch;
    }
}

@end
