//
//  PostDetailCell.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/16.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "PostDetailCell.h"
#import "Masonry.h"
#import "AppConstants.h"
#import "FileOperator.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#import "ProgressHUD.h"
#import "UIImageView+YYWebImage.h"

@interface PostDetailCell () 
{
    
}

@property (strong,nonatomic) UIImageView            *headImageView;
@property (strong,nonatomic) UILabel                *usernameLabel;
@property (strong,nonatomic) UILabel                *addtimeLabel;
@property (strong,nonatomic) UILabel                *contentLabel;
@property (nonatomic) NSInteger                     index;

@property (nonatomic) NSInteger                     imageCount;
@property (strong, nonatomic) NSMutableArray        *thumbImageUrlArray;
@property (strong, nonatomic) NSMutableArray        *imageUrlArray;
@property (strong, nonatomic) NSMutableArray        *imageViewArray;

@property (strong, nonatomic) UIImageView           *lastView;

@property (strong, nonatomic) UIView                *commentView;
@property (strong, nonatomic) UIImageView           *commentImageView;
@property (strong, nonatomic) UILabel               *commentLabel;
@property (strong, nonatomic) UIView                *likeView;
@property (strong, nonatomic) UIImageView           *likeImageView;
@property (strong, nonatomic) UILabel               *likeLabel;

@property (strong, nonatomic) ChatLiaoLiaoPostDataModel *data;

@end

@implementation PostDetailCell

- (instancetype)initWithData:(ChatLiaoLiaoPostDataModel*)data andIsLikeable:(BOOL)isLikeable andIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _data = data;
        
        _isLikeable = isLikeable;
        _index = index;

        _imageUrlArray = [[NSMutableArray alloc] initWithCapacity:10];
        _thumbImageUrlArray = [[NSMutableArray alloc] initWithCapacity:10];
        _imageViewArray = [[NSMutableArray alloc] initWithCapacity:10];
        [_imageUrlArray addObject:_data.avatar];
        [_thumbImageUrlArray addObject:_data.avatar];
        
        if (![_data.image1URL isEqualToString:@""]) {
            [_imageUrlArray addObject:_data.image1URL];
        }
        if (![_data.image2URL isEqualToString:@""]) {
            [_imageUrlArray addObject:_data.image2URL];
        }
        if (![_data.image3URL isEqualToString:@""]) {
            [_imageUrlArray addObject:_data.image3URL];
        }
        if (![_data.image4URL isEqualToString:@""]) {
            [_imageUrlArray addObject:_data.image4URL];
        }
        if (![_data.image5URL isEqualToString:@""]) {
            [_imageUrlArray addObject:_data.image5URL];
        }
        if (![_data.image6URL isEqualToString:@""]) {
            [_imageUrlArray addObject:_data.image6URL];
        }
        if (![_data.image7URL isEqualToString:@""]) {
            [_imageUrlArray addObject:_data.image7URL];
        }
        if (![_data.image8URL isEqualToString:@""]) {
            [_imageUrlArray addObject:_data.image8URL];
        }
        if (![_data.image9URL isEqualToString:@""]) {
            [_imageUrlArray addObject:_data.image9URL];
        }
        
        if (![_data.thumbImage1URL isEqualToString:@""]) {
            [_thumbImageUrlArray addObject:_data.thumbImage1URL];
        }
        if (![_data.thumbImage2URL isEqualToString:@""]) {
            [_thumbImageUrlArray addObject:_data.thumbImage2URL];
        }
        if (![_data.thumbImage3URL isEqualToString:@""]) {
            [_thumbImageUrlArray addObject:_data.thumbImage3URL];
        }
        if (![_data.thumbImage4URL isEqualToString:@""]) {
            [_thumbImageUrlArray addObject:_data.thumbImage4URL];
        }
        if (![_data.thumbImage5URL isEqualToString:@""]) {
            [_thumbImageUrlArray addObject:_data.thumbImage5URL];
        }
        if (![_data.thumbImage6URL isEqualToString:@""]) {
            [_thumbImageUrlArray addObject:_data.thumbImage6URL];
        }
        if (![_data.thumbImage7URL isEqualToString:@""]) {
            [_thumbImageUrlArray addObject:_data.thumbImage7URL];
        }
        if (![_data.thumbImage8URL isEqualToString:@""]) {
            [_thumbImageUrlArray addObject:_data.thumbImage8URL];
        }
        if (![_data.thumbImage9URL isEqualToString:@""]) {
            [_thumbImageUrlArray addObject:_data.thumbImage9URL];
        }

        _headImageView = [[UIImageView alloc] init];
        
        _imageCount = [_thumbImageUrlArray count];
        
        if (_imageCount > 0) {
            NSString *imageUrl = [_thumbImageUrlArray objectAtIndex:0];

            if ([imageUrl hasPrefix:@"http:"]) {
                [_headImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
            }
            else {
                [_headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], imageUrl]] placeholder:[UIImage imageNamed:@"placeholder.png"]];
            }
        }
        
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = ([AppConstants uiScreenWidth] / 5 - 10) / 2;
        
        [self addSubview:_headImageView];
        
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            make.left.equalTo(self).with.offset(5);
            make.width.and.height.mas_equalTo([AppConstants uiScreenWidth] / 5 - 10);
        }];
        
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *headImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTaped)];
        [_headImageView addGestureRecognizer:headImageTap];
        
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.font = [UIFont systemFontOfSize:15];
        _usernameLabel.tintColor = [UIColor blackColor];
        _usernameLabel.text = _data.userName;
        
        [self addSubview:_usernameLabel];
        
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImageView).with.offset(5);
            make.left.equalTo(_headImageView.mas_right).with.offset(5);
        }];
        
        _addtimeLabel = [[UILabel alloc] init];
        _addtimeLabel.font = [UIFont systemFontOfSize:14];
        _addtimeLabel.textColor = [UIColor lightGrayColor];
        _addtimeLabel.text = _data.addtime;
        
        [self addSubview:_addtimeLabel];
        
        [_addtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImageView.mas_bottom).with.offset(-25);
            make.left.equalTo(_usernameLabel);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.tintColor = [UIColor blackColor];
        _contentLabel.text = _data.content;
        _contentLabel.numberOfLines = 0;
        
        [self addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImageView.mas_bottom).with.offset(5);
            make.left.equalTo(_headImageView.mas_right).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-20);
        }];

        if (_imageCount == 1) {
            
            [self initCommentAndLikeView];
        }
        else if (_imageCount == 2) {
            
            _lastView = [[UIImageView alloc] init];
            _lastView.tag = 1;
            NSString *imageName = [_thumbImageUrlArray objectAtIndex:1];
            
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], imageName];
            
            [_lastView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
            
            [self addSubview:_lastView];
            
            [_lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_contentLabel.mas_bottom).with.offset(10);
                make.left.equalTo(_headImageView.mas_right).with.offset(5);
                make.width.mas_equalTo([AppConstants uiScreenWidth] / 3 * 2);
                make.height.mas_equalTo([AppConstants uiScreenWidth] / 3 * 2 - 50);
            }];
            
            [self initCommentAndLikeView];
            
            _lastView.userInteractionEnabled = YES;
            UITapGestureRecognizer *contentImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImageTaped:)];
            [_lastView addGestureRecognizer:contentImageTap];
            
            [_imageViewArray addObject:_lastView];
            
            _lastView.contentMode = UIViewContentModeScaleAspectFill;
            _lastView.clipsToBounds = YES;
        }
        else if (_imageCount > 2) {

            _lastView = nil;
            UIView *rightView = nil;
            for (int i = 1; i < _imageCount; ++i)
            {
                UIImageView *subv = [[UIImageView alloc] init];
                subv.tag = i;
                
                NSString *imageName = [_thumbImageUrlArray objectAtIndex:i];
                
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], imageName];
                
                [subv setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
                
                if (i == 4) {
                    rightView = subv;
                }
                
//                subv.delegate = self;
                //        subv.layer.cornerRadius = 3;
                [self addSubview:subv];
                
                [subv mas_makeConstraints:^(MASConstraintMaker *make) {
                    if ((i - 1) % 3 == 0) {
                        make.left.equalTo(_headImageView.mas_right).with.offset(5);
                    }
                    else {
                        make.left.equalTo(_lastView.mas_right).with.offset(5);
                    }
                    
                    int row = (i - 1) / 3;
                    make.top.equalTo(_contentLabel.mas_bottom).with.offset(row * (([AppConstants uiScreenWidth] / 4 - 5) + 5) + 10);
                    make.width.mas_equalTo([AppConstants uiScreenWidth] / 4 - 5);
                    make.height.mas_equalTo([AppConstants uiScreenWidth] / 4 - 5);
                }];
                
                _lastView = subv;
                
                subv.userInteractionEnabled = YES;
                UITapGestureRecognizer *contentImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImageTaped:)];
                [subv addGestureRecognizer:contentImageTap];
                
                [_imageViewArray addObject:subv];
                subv.contentMode = UIViewContentModeScaleAspectFill;
                subv.clipsToBounds = YES;
            }
            
            [self initCommentAndLikeView];
            
            
            
        }
        
        UILongPressGestureRecognizer *LongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressFrom:)];
        UITapGestureRecognizer *singleTagRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapFrom:)];
        singleTagRecognizer.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:LongPressRecognizer];
        [self addGestureRecognizer:singleTagRecognizer];
    }
    
    return self;
}


- (void)LongPressFrom:(UILongPressGestureRecognizer*)LongPressRecognizer
{
    if (LongPressRecognizer.state == UIGestureRecognizerStateEnded) {
        return;
    }
    else if (LongPressRecognizer.state == UIGestureRecognizerStateBegan) {
        [_delegate postDetailCellLongPressAtData:_data];
    }
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否退出本次编辑" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
     */
}

- (void)singleTapFrom:(UITapGestureRecognizer*)singleTagRecognizer
{
    [_delegate postDetailCellClickAtData:_data andIndex:_index];
}

- (void)initCommentAndLikeView {
    _commentView = [[UIView alloc] init];
    
    _commentImageView = [[UIImageView alloc] init];
    _commentImageView.image = [UIImage imageNamed:@"littleComment"];
    
    _commentLabel = [[UILabel alloc] init];
    _commentLabel.font = [UIFont systemFontOfSize:15];
    _commentLabel.textColor = [UIColor lightGrayColor];
    _commentLabel.text = _data.commentDegree;
    
    [_commentView addSubview:_commentImageView];
    [_commentView addSubview:_commentLabel];
    [self addSubview:_commentView];
    
    _likeView = [[UIView alloc] init];
    
    _likeImageView = [[UIImageView alloc] init];
    if ([_data.liked isEqualToString:@"1"]) {
        _likeImageView.image = [UIImage imageNamed:@"littleLiked"];
    }
    else {
        _likeImageView.image = [UIImage imageNamed:@"littleUnliked"];
    }
    
    _likeLabel = [[UILabel alloc] init];
    _likeLabel.font = [UIFont systemFontOfSize:15];
    _likeLabel.textColor = [UIColor lightGrayColor];
    _likeLabel.text = _data.thumbsupDegree;
    
    [_likeView addSubview:_likeImageView];
    [_likeView addSubview:_likeLabel];
    [self addSubview:_likeView];
    
    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_likeView).with.offset(5);
        make.right.equalTo(_likeView.mas_right);
    }];
    
    [_likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(@15);
        make.centerY.equalTo(_likeLabel);
        make.right.equalTo(_likeLabel.mas_left).with.offset(-10);
    }];
    
    [_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([_thumbImageUrlArray count] < 2) {
            make.top.equalTo(_contentLabel.mas_bottom).with.offset(10);
        }
        else {
            make.top.equalTo(_lastView.mas_bottom).with.offset(10);
        }
        make.height.equalTo(@15);
        make.left.equalTo(_likeImageView);
        make.right.equalTo(self).with.offset(-10);
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commentView).with.offset(5);
        make.right.equalTo(_commentView.mas_right);
    }];
    
    [_commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(@15);
        make.centerY.equalTo(_commentLabel);
        make.right.equalTo(_commentLabel.mas_left).with.offset(-10);
    }];
    
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.equalTo(_likeView);
        make.left.equalTo(_commentImageView);
        make.right.equalTo(_likeView.mas_left).with.offset(-10);
    }];
    
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
    tapGesture1.numberOfTapsRequired = 1;
    
    [_likeView addGestureRecognizer:tapGesture1];

    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_commentView.mas_bottom).with.offset(20);
    }];
}

- (void)like {/*
    if (!_isLikeable) {
        return;
    }
    
    if ([[AppConstants userInfo].accessToken isEqualToString:@""]) {
        
        [ProgressHUD showError:NSLocalizedString(@"dengluzaidianzan", @"")];
        
        return;
    }
    
    NSString *urlString;
    
    if ([_data.liked isEqualToString:@"1"]) {
        urlString = [NSString stringWithFormat:@"%@interaction/forum/post/unthumbsup/index.ashx", [AppConstants httpHeader]];
    }
    else {
        urlString = [NSString stringWithFormat:@"%@interaction/forum/post/thumbsup/index.ashx", [AppConstants httpHeader]];
    }
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
//    NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/post/thumbsup/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"AccessToken":[AppConstants userInfo].accessToken, @"PostId":_data.Id};
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              NSLog(@"success urlString = %@", urlString);
              NSLog(@"Success: %@", responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  if ([_data.liked isEqualToString:@"1"]) {
                      _data.thumbsupDegree = [NSString stringWithFormat:@"%d", [_data.thumbsupDegree intValue] - 1];
                      _likeLabel.text = [NSString stringWithFormat:@"%@", _data.thumbsupDegree];
                      _likeLabel.textColor = [UIColor lightGrayColor];
                      _likeImageView.image = [UIImage imageNamed:@"littleUnliked"];
                      _data.liked = @"0";
                  }
                  else {
                      _data.thumbsupDegree = [NSString stringWithFormat:@"%d", [_data.thumbsupDegree intValue] + 1];
                      _likeLabel.text = [NSString stringWithFormat:@"%@", _data.thumbsupDegree];
                      _likeLabel.textColor = [AppConstants themeColor];
                      _likeImageView.image = [UIImage imageNamed:@"littleLiked"];
                      _data.liked = @"1";
                  }
                  
                  [_delegate postDetailCellChangeWithData:_data andIndex:_index];
//                  [ProgressHUD showSuccess:NSLocalizedString(@"dianzanchenggong", @"")];
              }
              else if ([[responseObject objectForKey:@"errno"] isEqualToString:@"4401"]) {
                  [AppConstants relogin:^(BOOL success){
                      if (success) {
                          [self like];
                      }
                      else {
                          [AppConstants notice2ManualRelogin];
                      }
                  }];
              }
              else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
//                  [ProgressHUD showError:NSLocalizedString(@"dianzanshibai", @"")];
                  
                  if ([_data.liked isEqualToString:@"1"]) {
                      _data.thumbsupDegree = [NSString stringWithFormat:@"%d", [_data.thumbsupDegree intValue] - 1];
                      _likeLabel.text = [NSString stringWithFormat:@"%@", _data.thumbsupDegree];
                      _likeLabel.textColor = [UIColor lightGrayColor];
                      _likeImageView.image = [UIImage imageNamed:@"littleUnliked"];
                      _data.liked = @"0";
                  }
                  else {
                      _data.thumbsupDegree = [NSString stringWithFormat:@"%d", [_data.thumbsupDegree intValue] + 1];
                      _likeLabel.text = [NSString stringWithFormat:@"%@", _data.thumbsupDegree];
                      _likeLabel.textColor = [AppConstants themeColor];
                      _likeImageView.image = [UIImage imageNamed:@"littleLiked"];
                      _data.liked = @"1";
                  }
                  
                  [_delegate postDetailCellChangeWithData:_data andIndex:_index];
              }
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              NSLog(@"false urlString = %@", urlString);
              NSLog(@"Error: %@", error);
              
              [ProgressHUD showError:NSLocalizedString(@"badNetwork", @"")];
          }];
*/}

- (void)contentImageTaped:(UITapGestureRecognizer *)recognizer
{
    for (int i = 0; i < [_imageViewArray count]; i++) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], [_thumbImageUrlArray objectAtIndex:i + 1]];
        [[_imageViewArray objectAtIndex:i] setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
    }

    UIView *viewT = [recognizer view];
    [_delegate postDetailCellContentImageViewClickAtIndex:viewT.tag andImages:_imageUrlArray];
}

- (void)headImageTaped {
    [_delegate postDetailCellHeadImageViewClickByUserid:_data.userId andUsername:_data.userName andUserAvatar:_data.avatar];
}

- (void)changeWithData:(ChatLiaoLiaoPostDataModel*)data {
    _data = data;
    
    _likeLabel.text = [NSString stringWithFormat:@"%@", _data.thumbsupDegree];
    
    if ([_data.liked isEqualToString:@"1"]) {
        _likeLabel.textColor = [AppConstants themeColor];
        _likeImageView.image = [UIImage imageNamed:@"littleLiked"];
    }
    else {
        _likeLabel.textColor = [UIColor lightGrayColor];
        _likeImageView.image = [UIImage imageNamed:@"littleUnliked"];
    }
}
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0]];
 
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touchPoint.x > 0 && touchPoint.x < self.frame.size.width && touchPoint.y > 0 && touchPoint.y < self.frame.size.height)
    {
        [_delegate postDetailCellClickAtIndex:_index];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    
    [super touchesCancelled:touches withEvent:event];
}*/

@end
