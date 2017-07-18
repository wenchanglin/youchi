//
//  PlistEditor.m
//  
//
//  Created by LICAN LONG on 15/7/20.
//
//

#import "PlistEditor.h"
#import "AppConstants.h"

@implementation PlistEditor

+ (void)createPlistWithName:(NSString*)name withValue:(NSString*)value forKey:(NSString*)key {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *plistName = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
    
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).AppInfoPlistName = plistName;
    
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:[AppConstants AppInfoPlistName] contents:nil attributes:nil];
    
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).AppInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:value, key, nil];
//    [dic writeToFile:plistName atomically:YES];
}

+ (void)alterPlist:(NSString*)name addValue:(NSString*)value forKey:(NSString*)key {
    
    if (value == nil) {
//        NSLog(@"add nil %@", key);
        [[AppConstants AppInfoDic] setObject:@"" forKey:key];
    }
    else {
//        NSLog(@"add not nil %@", key);
        [[AppConstants AppInfoDic] setObject:value forKey:key];
    }
    /*
    if (![[AppConstants AppInfoDic] writeToFile:plistName atomically:YES]) {
        NSLog(@"写入数据失败, plistName = %@, value = %@, key = %@", plistName, value, key);
    }
    else {
//        NSLog(@"写入数据成功, value = %@, key = %@", value, key);
    }
    */
//    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:plistName];
//    NSLog(@"dic is:%@",dic2);
}

+ (void)alterPlist:(NSString*)name deleteKey:(NSString*)key {

    [[AppConstants AppInfoDic] removeObjectForKey:key];
    
//    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:plistName];
//    NSLog(@"dic is:%@",dic2);
}

+ (void)alterPlist:(NSString*)name alertValue:(NSString*)value forKey:(NSString*)key {
    [PlistEditor alterPlist:name deleteKey:key];
    [PlistEditor alterPlist:name addValue:value forKey:key];
}

+ (NSString*)queryPlist:(NSString*)name withKey:(NSString*)key {
    if ([[AppConstants AppInfoDic] objectForKey:key] == nil) {
        NSLog(@"nil %@", key);
        
        return @"";
    }
    else {
        return [[AppConstants AppInfoDic] objectForKey:key];
    }
}

@end
