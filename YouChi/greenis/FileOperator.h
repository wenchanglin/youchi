//
//  FileOperator.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/12.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstants.h"
@interface FileOperator : NSObject

+(void)saveImage:(UIImage*)image fromUrl:(NSString*)url toName:(NSString*)name;
+(NSString*)getImageName:(NSString*)name;
+(UIImage*)getImageWithName:(NSString*)name;
+(BOOL)fileExist:(NSString*)path;
@end
