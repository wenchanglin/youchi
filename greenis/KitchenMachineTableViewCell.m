//
//  KitchenMachineTableViewCell.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/6.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "KitchenMachineTableViewCell.h"
#import "Masonry.h"
#import "AppConstants.h"

@interface KitchenMachineTableViewCell() {
    
}

@property (strong, nonatomic) UILabel           *nameLabel;
@property (strong, nonatomic) UIButton          *connectButton;

@end

@implementation KitchenMachineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
        
        [self setttingViewAutoLayout];
    }
    
    return self;
}

- (void)createView {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = _data.name;
    _nameLabel.textColor = [UIColor lightGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
    }];
    
    _connectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_connectButton setTitle:@"连     接" forState:UIControlStateNormal];
    _connectButton.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [_connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_connectButton addTarget:self action:@selector(connectButtonPress) forControlEvents:UIControlEventTouchUpInside];
    _connectButton.backgroundColor = [AppConstants themeColor];
    [self.contentView addSubview:_connectButton];
    [_connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel);
        make.width.equalTo(@100);
        make.height.equalTo(_nameLabel);
        make.right.equalTo(self).with.offset(-10);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_nameLabel).with.offset(10);
    }];
}

- (void)connectButtonPress {
    NSLog(@"connect");
}

- (void)setttingViewAutoLayout {
    
}

- (void)setData:(BLEPort *)data {
    _data = data;
    _nameLabel.text = _data.name;
}

- (void)setIsConnected:(BOOL)isConnected {
    if (isConnected) {
        [_connectButton setTitle:NSLocalizedString(@"yilianjie", @"") forState:UIControlStateNormal];
    }
    else {
        [_connectButton setTitle:NSLocalizedString(@"lianjie", @"") forState:UIControlStateNormal];
    }
}

@end
