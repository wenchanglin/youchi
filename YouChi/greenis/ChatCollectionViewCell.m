//
//  ChatCollectionViewCell.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/10/27.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "ChatCollectionViewCell.h"
#import "Masonry.h"
#import "AppConstants.h"
#import "UIImageView+YYWebImage.h"
#import "FileOperator.h"

@interface ChatCollectionViewCell ()
{
    
}

@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) UILabel       *nameLabel;
@property (nonatomic) NSInteger             index;
@property (nonatomic) BOOL                  isTouchEnabled;
@property (strong, nonatomic) NSString      *userid;
@property (strong, nonatomic) NSString      *username;
@property (strong, nonatomic) NSString      *imageurl;

@end

@implementation ChatCollectionViewCell

- (instancetype)initWithImageUrl:(NSString*)ImageUrl andUserName:(NSString*)UserName andUserID:(NSString*)UserID andIsTouchEnabled:(BOOL)isTouch {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _isTouchEnabled = isTouch;
        _userid = UserID;
        _username = UserName;
        _imageurl = ImageUrl;
        
        _imageView = [[UIImageView alloc] init];

        NSString *imageUrl;
        if ([ImageUrl hasPrefix:@"http:"]) {
            imageUrl = ImageUrl;
        }
        else {
            imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], ImageUrl];
        }
        
        [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
        
//        [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"icon.png"] options:YYWebImageOptionShowNetworkActivity|YYWebImageOptionSetImageWithFadeAnimation completion:nil];

        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = ([AppConstants uiScreenWidth] / 5 - 10) / 2;
    
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [UIColor lightGrayColor];
        _nameLabel.text = UserName;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            make.left.equalTo(self).with.offset(5);
            make.right.equalTo(self).with.offset(-5);
            make.height.equalTo(_imageView.mas_width);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_imageView);
            make.top.equalTo(_imageView.mas_bottom).with.offset(10);
            make.width.equalTo(self);
        }];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_isTouchEnabled) return;
    
    [self setBackgroundColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0]];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_isTouchEnabled) return;
    
    [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touchPoint.x > 0 && touchPoint.x < self.frame.size.width && touchPoint.y > 0 && touchPoint.y < self.frame.size.height)
    {
        NSString *imageUrl;
        if ([_imageurl hasPrefix:@"http:"]) {
            imageUrl = _imageurl;
        }
        else {
            imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], _imageurl];
        }
        
        [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
        
        [_delegate chatCollectionViewCellClickByUserID:_userid andUserAvatar:_imageurl andUsername:_username];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_isTouchEnabled) return;
    
    [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [super touchesCancelled:touches withEvent:event];
    
    //    NSLog(@"touchesCancelled");
}
@end
