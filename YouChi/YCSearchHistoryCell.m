//
//  YCSearchHistoryCell.m
//  YouChi
//
//  Created by 李李善 on 15/12/29.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSearchHistoryCell.h"
#import "YCCatolog.h"
@implementation YCSearchHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)update:(id)model atIndexPath:(NSIndexPath *)indexPath{
    self.searchTitle.text = model;
}

@end


@implementation YCSearchOneHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)update:(id)model atIndexPath:(NSIndexPath *)indexPath{
    [super update:model atIndexPath:indexPath];
}

@end


@implementation YCSearchTwoHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)update:(id)model atIndexPath:(NSIndexPath *)indexPath{
    [super update:model atIndexPath:indexPath];
}



@end



@implementation YCSearchThreeHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)update:(id)model atIndexPath:(NSIndexPath *)indexPath{
    [super update:model atIndexPath:indexPath];
}



@end



