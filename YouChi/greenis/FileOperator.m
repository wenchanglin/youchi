//
//  FileOperator.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/12.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "FileOperator.h"


@implementation FileOperator

+(void)saveImage:(UIImage*)image fromUrl:(NSString*)url toName:(NSString*)name {

    @autoreleasepool {
        NSData *imageData;
        NSString *savedImagePath;

        /*
        UIImageJPEGRepresentation(image,0.1);
        
        image = nil;*/

        if ([url hasSuffix:@"jpg"]) {
            imageData = UIImageJPEGRepresentation(image,0.5);
            savedImagePath = [[AppConstants httpSavePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", name]];
        }
        else if ([url hasSuffix:@"png"]) {
            imageData = UIImagePNGRepresentation(image);
            savedImagePath = [[AppConstants httpSavePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", name]];
        }
        else {
            imageData = UIImageJPEGRepresentation(image,0.5);
            savedImagePath = [[AppConstants httpSavePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", name]];
        }

//        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).memeryCount += imageData.length / 1000;
//        NSLog(@"memery: %ld", (long)((AppDelegate*)[[UIApplication sharedApplication] delegate]).memeryCount);
        
        [imageData writeToFile:savedImagePath atomically:NO];
    }
}

+(NSString*)getImageName:(NSString*)name {
    NSString *savedImagePath = [[AppConstants httpSavePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", name]];
    
    return savedImagePath;
}

+(UIImage*)getImageWithName:(NSString*)name {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:name]];
    
    if (image == nil) {
        NSLog(@"nil image %@", name);
        image = [UIImage imageNamed:@"defaultImage"];
    }
    
    return image;
}

+(BOOL)fileExist:(NSString*)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:path]];
}

@end



