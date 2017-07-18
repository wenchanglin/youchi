//
//  YCCellManagerMiddleView.m
//  YouChi
//
//  Created by water on 16/6/15.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCellManagerMiddleView.h"
#import "YCCellManagerFrame.h"
#import "YCChihuoyingM.h"



@interface YCCellManagerMiddleView ()

@property (weak,nonatomic) UIImageView *bigPictureView;
@property (weak,nonatomic) UIImageView *smallPictureView;
@property (weak,nonatomic) UIImageView *addressIconView;

@property (weak,nonatomic) UILabel *locationDescLbl;
@property (weak,nonatomic) UILabel *materialNameLbl;
@property (weak,nonatomic) UILabel *materialDescLbl;




@end

@implementation YCCellManagerMiddleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bigPictureView = [[UIImageView alloc] init];
        [self addSubview:bigPictureView];
        self.bigPictureView = bigPictureView;
        
        UIImageView *smallPictureView = [[UIImageView alloc] init];
        [self addSubview:smallPictureView];
        self.smallPictureView = smallPictureView;
        
        UIImageView *addressIconView = [[UIImageView alloc] init];
        [self addSubview:addressIconView];
        self.addressIconView = addressIconView;
        
        UILabel *locationDescLbl = [[UILabel alloc] init];
        [self addSubview:locationDescLbl];
        self.locationDescLbl = locationDescLbl;
        
        UILabel *materialNameLbl = [[UILabel alloc] init];
        [self addSubview:materialNameLbl];
        self.materialNameLbl = materialNameLbl;
        
        UILabel *materialDescLbl = [[UILabel alloc] init];
        [self addSubview:materialDescLbl];
        self.materialDescLbl = materialDescLbl;
    }
    return self;
}

-(void)setManagerFrame:(YCCellManagerFrame *)managerFrame{
    _managerFrame = managerFrame;
    
    self.bigPictureView.frame = managerFrame.bigPictureF;
    self.smallPictureView.frame = managerFrame.smallPictureF;
    self.addressIconView.frame = managerFrame.addressIconF;
    self.locationDescLbl.frame= managerFrame.locationDescF;
    self.materialNameLbl.frame = managerFrame.materialNameF;
    self.materialDescLbl.frame = managerFrame.materialDescF;
    
    self.frame = managerFrame.middleViewF;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}


@end
