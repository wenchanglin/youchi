//
//  PlistEditor.h
//  
//
//  Created by LICAN LONG on 15/7/20.
//
//

#import <Foundation/Foundation.h>

@interface PlistEditor : NSObject

+ (void)createPlistWithName:(NSString*)name withValue:(NSString*)value forKey:(NSString*)key;
+ (void)alterPlist:(NSString*)name addValue:(NSString*)value forKey:(NSString*)key;
+ (void)alterPlist:(NSString*)name deleteKey:(NSString*)key;
+ (void)alterPlist:(NSString*)name alertValue:(NSString*)value forKey:(NSString*)key;
+ (NSString*)queryPlist:(NSString*)name withKey:(NSString*)key;
@end
