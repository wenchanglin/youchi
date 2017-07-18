//
//  UIPlaceHolderTextView.h
//  SmartKitchen
//
//  Created by LICAN LONG on 15/12/1.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
