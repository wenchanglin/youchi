//
//  ChatCollectionContainer.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/10/27.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "ChatCollectionContainer.h"
#import "ChatCollectionViewCell.h"
#import "Masonry.h"
#import "AppConstants.h"
#import "ChatUserDataModel.h"

@interface ChatCollectionContainer() <ChatCollectionViewCellDelegate> {
    
}
/*
@property (strong, nonatomic) NSArray                   *avatars;
@property (strong, nonatomic) NSArray                   *nicknames;
@property (strong, nonatomic) NSArray                   *userIDs;
@property (strong, nonatomic) NSArray                   *savedImages;*/

@property (strong, nonatomic) NSArray                   *datas;

@end


@implementation ChatCollectionContainer
/*
- (instancetype)initWithAvatars:(NSArray*)avatars andSavedImage:(NSArray*)savedImages andNickname:(NSArray*)nicknames andUserID:(NSArray*)userIDs;
{
    self = [super init];
    if (self) {
        _avatars = avatars;
        _nicknames = nicknames;
        _userIDs = userIDs;
        _savedImages = savedImages;
    }
    return self;
}*/

- (instancetype)initWithDatas:(NSArray*)datas {
    self = [super init];
    if (self) {
        _datas = datas;
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.tintColor = [UIColor blackColor];
    titleLabel.text = NSLocalizedString(@"liaoliaodaren", @"");
    
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(5);
        make.left.equalTo(self).with.offset(10);
    }];
    
//    NSUInteger tagsCount = [_tags count];
    NSUInteger tagsCount = 10;
    NSUInteger count = (tagsCount / 5) * 5;
    
    UIView *lastView = nil;
    UIView *rightView = nil;
    for (int i = 0; i < count; ++i)
    {
        ChatCollectionViewCell *subv;

        if (i >= tagsCount) {
            subv = [[ChatCollectionViewCell alloc] initWithImageUrl:@"" andUserName:@"" andUserID:@"" andIsTouchEnabled:NO];
        }
        else {
            subv = [[ChatCollectionViewCell alloc] initWithImageUrl:((ChatUserDataModel*)[_datas objectAtIndex:i]).avatar andUserName:((ChatUserDataModel*)[_datas objectAtIndex:i]).username andUserID:((ChatUserDataModel*)[_datas objectAtIndex:i]).Id andIsTouchEnabled:YES];
        }
        
        if (i == 4) {
            rightView = subv;
        }
        
        subv.delegate = self;
//        subv.layer.cornerRadius = 3;
        [self addSubview:subv];
        
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i % 5 == 0) {
                make.left.equalTo(self);
            }
            else {
                make.left.equalTo(lastView.mas_right);
            }
            
            int row = i / 5;
            make.top.equalTo(titleLabel.mas_bottom).with.offset((row * ([AppConstants uiScreenWidth] / 5 + 30)) + 10);
            make.width.mas_equalTo([AppConstants uiScreenWidth] / 5);
            make.height.mas_equalTo([AppConstants uiScreenWidth] / 5 + 30);
        }];
        
        lastView = subv;
    }
    
    if (lastView != nil) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightView.mas_right);
            make.bottom.equalTo(lastView.mas_bottom);
        }];
    }
}

- (void)chatCollectionViewCellClickByUserID:(NSString*)userid andUserAvatar:(NSString*)Avatar andUsername:(NSString*)username{
    [_delegate chatCollectionContainerClickByUserID:userid andUserAvatar:Avatar andUsername:username];
}

@end
