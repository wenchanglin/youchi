//
//  CommentCell.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/24.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "CommentCell.h"
#import "Masonry.h"
#import "AppConstants.h"
#import "UIImageView+YYWebImage.h"

@interface CommentCell ()
{
    
}

@property (strong,nonatomic) UIImageView    *imageView;
@property (strong,nonatomic) UILabel        *nameLabel;
@property (strong,nonatomic) UILabel        *timeLabel;
@property (strong,nonatomic) UILabel        *contentLabel;

@end

@implementation CommentCell

- (instancetype)initWithImageName:(NSString*)imageName andName:(NSString*)name andTime:(NSString*)time andContent:(NSString*)content;
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] init];
        
        NSString *imageUrl;
        if ([imageName hasPrefix:@"http:"]) {
            imageUrl = imageName;
        }
        else {
            imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], imageName];
        }
        
        [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
        
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 25;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = name;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = time;
        
        _contentLabel = [[UILabel alloc] init];

//        NSLog(@"content start");
        
        _contentLabel.attributedText = [self emojiString:content];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.preferredMaxLayoutWidth = [AppConstants uiScreenWidth] - 76;
        
//        NSLog(@"_contentLabel.attributedText = %@", _contentLabel.attributedText);
        
//        NSLog(@"content end");
        
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
        [self addSubview:_timeLabel];
        [self addSubview:_contentLabel];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(8);
            make.left.equalTo(self.mas_left).with.offset(8);
            make.width.and.height.equalTo(@50);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_top).with.offset(4);
            make.left.equalTo(_imageView.mas_right).with.offset(8);
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_imageView.mas_bottom).with.offset(-4);
            make.left.equalTo(_imageView.mas_right).with.offset(8);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeLabel);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.top.equalTo(_timeLabel.mas_bottom).with.offset(8);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_contentLabel.mas_bottom).with.offset(8);
        }];
    }
    return self;
}

- (NSMutableAttributedString*)emojiString:(NSString*)content {
    //1、创建一个可变的属性字符串
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:content];
    
    //2、通过正则表达式来匹配字符串
    
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";//匹配表情
    
    NSError *error = nil;
    
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    
    if(!re) {
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //根据匹配范围来用图片进行相应的替换
    
    for(NSTextCheckingResult *match in resultArray) {
        
        //获取数组元素中得到range
        
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        
        NSString *subStr = [content substringWithRange:range];
        
        NSArray *keyArray = [AppConstants expressionNameArray];
        NSDictionary *expressionDic = [AppConstants expressionDic];
        
//        NSLog(@"------%@-----", expressionDic);
        
        for(int i =0; i < keyArray.count; i ++) {
            
            if([keyArray[i] isEqualToString:subStr]) {
                
                //face[i][@"png"]就是我们要加载的图片
                
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                
                //给附件添加图片
                
                textAttachment.image= [UIImage imageNamed:[expressionDic valueForKey:keyArray[i]]];
                
//                NSLog(@"imagename = %@ key = %@ dic = %@", [expressionDic valueForKey:keyArray[i]], keyArray[i], expressionDic);
                
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                    textAttachment.bounds=CGRectMake(0, -5, textAttachment.image.size.width, textAttachment.image.size.height);
                }
                else {
                    textAttachment.bounds=CGRectMake(0, -5, textAttachment.image.size.width / 2, textAttachment.image.size.height / 2);
                }
                
                
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                //把图片和图片对应的位置存入字典中
                
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                
                [imageDic setObject:imageStr forKey:@"image"];
                
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                //把字典存入数组中
                
                [imageArray addObject:imageDic];
            }
        }
    }
    
    //4、从后往前替换，否则会引起位置问题
    
    for(int i = (int)imageArray.count-1; i >=0; i--) {
        
        NSRange range;
        
        [imageArray[i][@"range"] getValue:&range];
        
        //进行替换
        
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    
    return attributeString;
}

@end
