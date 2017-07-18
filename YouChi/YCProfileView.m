//
//  YCProfileView.m
//  YouChi
//
//  Created by sam on 15/8/19.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCProfileView.h"
#import "YCMarcros.h"
#import "Masonry.h"
@implementation YCProfileView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (NSMutableArray *)segments{
//
//    if (!_segments) {
//        _segments = [NSMutableArray array];
//    }
//    return _segments;
//}

-(void)dealloc{
    //    ok
    
}

- (void)awakeFromNib
{
    _infoAvatar = VIEW(1);
    _rank = VIEW(2);
    _attention = VIEW(3);
    _fans = VIEW(4);
    _share = VIEW(5);
    _edit = VIEW(6);
    _profileButtonsView = VIEW(8);
    
    self.infoAvatar.isClipAvatar = YES;
    self.infoAvatar.isSexHidden = NO;
}




@end
