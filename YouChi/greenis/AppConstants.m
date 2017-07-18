//
//  AppConstantsa.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/20.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "AppConstants.h"
#import "PlistEditor.h"
#import <ImageIO/ImageIO.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>


@implementation BaseModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"imageUrl" : @"ImgUrl",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return nil;
}

- (void)setupModel
{
    
}

@end

@implementation AppConstants

+(int)messageInputViewHeight {
    return 45;
}

+(int)messageInputViewButtonHeight {
    return 35;
}

+(int)uiNavigationBarHeight {
    return 64;
}

+(int)uiTabBarHeight {
    return 49;
}

+(int)uiScreenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+(int)uiScreenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+(int)searchBarX {
    return 50;
}

+(int)searchBarY {
    return 22;
}

+(int)searchBarWidth {
    return [AppConstants uiScreenWidth] - 110;
}

+(UIColor*)themeColor {
    return [AppConstants initUIColorWithInt:0x5E8A41];
}

+(UIColor*)themeGrayColor {
    return [AppConstants initUIColorWithInt:0x898989];
}

+(UIColor*)backgroundColor {
    return [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0];
}

+(NSString*)DBName {
    return @"APPTempData";
}
//
//+(sqlite3*)DBInstance {
//    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).db;
//}
//
//+(void)execSql:(NSString *)sql {
//    char *err;
//    if (sqlite3_exec([AppConstants DBInstance], [sql UTF8String], NULL, NULL, &err) != SQLITE_OK){
//        sqlite3_close([AppConstants DBInstance]);
//        NSLog(@"数据库操作数据失败!");
//        NSLog(@"%s", err);
//    }
//    else {
//        NSLog(@"操作成功？");
//    }
//}

+(NSString*)WXAppID {
    return @"wx70520944ed61dd54";
}

+(NSString*)WXAppSecret {
    return @"29741bf5475bc4f885977bb5e3ab48b4";
}

+(NSString*)QQAppID {
    return @"222222";
}

+(NSString*)SINAAppKey {
    return @"1436472074";
}

+(AppDelegate*)AppDelegate {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

+(NSString*)WXCode {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXCode;
}

+(NSString*)WXAccessToken {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXAccessToken;
}

+(NSString*)WXOpenid {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXOpenid;
}

+(NSString*)WXRefreshToken {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXRefreshToken;
}

+(NSString*)WXScope {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXScope;
}

+(NSString*)WXUnionid {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXUnionid;
}

+(int)WXErrCode {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXErrCode;
}

+(NSString*)WXCity {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXCity;
}

+(NSString*)WXCountry {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXCountry;
}

+(NSString*)WXHeadimgurl {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXHeadimgurl;
}

+(NSString*)WXLanguage {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXLanguage;
}

+(NSString*)WXNickname {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXNickname;
}

+(NSString*)WXProvince {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXProvince;
}

+(NSString*)WXSex {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXSex;
}

+(NSString*)WXMobile {
    return @"";
}

+(NSString*)WXEmail {
    return @"";
}

+(NSString*)WXBirthday {
    return @"";
}

+(NSString*)WXAddress {
    return @"";
}

+(void)setWXCode:(NSString*)code {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXCode = code;
}

+(void)setWXAccessToken:(NSString*)accessToken {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXAccessToken = accessToken;
}

+(void)setWXOpenid:(NSString*)openid {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXOpenid = openid;
}

+(void)setWXRefreshToken:(NSString*)RefreshToken {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXRefreshToken = RefreshToken;
}

+(void)setWXScope:(NSString*)Scope {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXScope = Scope;
}

+(void)setWXUnionid:(NSString*)Unionid {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXUnionid = Unionid;
}

+(void)setWXCity:(NSString*)City {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXCity = City;
}

+(void)setWXCountry:(NSString*)Country {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXCountry = Country;
}

+(void)setWXHeadimgurl:(NSString*)Headimgurl {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXHeadimgurl = Headimgurl;
}

+(void)setWXLanguage:(NSString*)Language {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXLanguage = Language;
}

+(void)setWXNickname:(NSString*)Nickname {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXNickname = Nickname;
}

+(void)setWXProvince:(NSString*)Province {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXProvince = Province;
}

+(void)setWXSex:(NSString*)Sex {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXSex = Sex;
}

+(void)setIsShowIntroView {
    [PlistEditor alterPlist:@"AppInfo" alertValue:@"YES" forKey:@"isShowIntroView"];
    [AppConstants writeDic2File];
}

+(BOOL)isShowIntroView {
    return [[PlistEditor queryPlist:@"AppInfo" withKey:@"isShowIntroView"] isEqualToString:@"YES"];
}

+(int)introStartButtonHeight {
    return 40;
}

+(UIColor*)introCard1Color {
    return [AppConstants initUIColorWithInt:0xFFC81E];
}

+(UIColor*)introCard2Color {
    return [AppConstants initUIColorWithInt:0x41B450];
}

+(UIColor*)introCard3Color {
    return [AppConstants initUIColorWithInt:0x0096DD];
}

+(UIColor*)introStartButtonColor {
//    return [AppConstants initUIColorWithInt:0x363B40];
    return [UIColor colorWithRed:41.0/255.0 green:45.0/255.0 blue:49.0/255.0 alpha:1.0];
}

+(UIColor*)initUIColorWithInt:(int)RGB {
    return [UIColor colorWithRed:((RGB & 0xFF0000) >> 16) / 255.0 green:((RGB & 0x00FF00) >> 8) / 255.0 blue:(RGB & 0x0000FF) / 255.0 alpha:1.0];
}

+(int)pagerCenterOffsetFromScrollViewBottom {
    return 5;
}

+(int)introCardTextLineHeight {
    return 6;
}

+(UIFont*)introCardTextFont
{
    return [UIFont systemFontOfSize:16];
}

+(UIFont*)introCardTitleFont {
    return [UIFont systemFontOfSize:18];// weight:UIFontWeightBold];
}

+(NSString*)introCard1Title {
    return @"title1";
}

+(NSString*)introCard2Title {
    return @"title2";
}

+(NSString*)introCard1Text {
    return @"text1";
}

+(NSString*)introCard2Text {
    return @"text2";
}

+(NSString*)introCard3Text {
    return @"text3";
}

+(NSString*)adImageName {
    return @"adImage";
}

+(NSString*)introduceImageName {
    return @"introduceImage";
}

+(NSString*)httpImageHeader {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
//        return @"http://120.26.37.253/";
        return @"http://app-cn.greenis-service.com.cn/";
    }
    else {
//        return @"http://120.26.203.184/";
        return @"http://app-en.greenis-service.com.cn/";
    }
}

+(NSString*)shareHeader {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        //        return @"http://120.26.37.253/";
        return @"http://app-cn.greenis-service.com.cn/";
    }
    else {
        //        return @"http://120.26.203.184/";
        return @"http://app-en.greenis-service.com.cn/";
    }
}

+(NSString*)httpVideoHeader {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        //        return @"http://120.26.37.253/";
        return @"http://app-cn.greenis-service.com.cn/";
    }
    else {
        //        return @"http://120.26.203.184/";
        return @"http://app-en.greenis-service.com.cn/";
    }
}

+(NSString*)httpHeader {
    return [NSString stringWithFormat:@"%@%@:%@/smartkitchenappswebapi/v1/", [AppConstants httpType], [AppConstants httpServerIP], [AppConstants httpServerPort]];
}

+(NSString*)httpType {
    return @"https://";
}

+(NSString*)httpServerIP {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"app-cn.greenis-service.com.cn";
    }
    else {
        return @"app-en.greenis-service.com.cn";
    }
}

+(NSString*)httpServerPort {
    return @"1900";
}

+(NSString*)httpAccessToken {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).httpAccessToken;
}

+(void)setHttpAccessToken:(NSString*)newAccessToken {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).httpAccessToken = newAccessToken;
}

+(NSString*)httpSavePath {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    
    return documentsDirectory;
}

+(NSString*)imageUrl2String:(NSString*)url {
    return [url stringByReplacingOccurrencesOfString:@"/"withString:@"-_-"];
}

+(NSString*)string2ImageUrl:(NSString*)url {
    return [url stringByReplacingOccurrencesOfString:@"-_-"withString:@"/"];
}

+(BOOL)isWXLogin {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXLogin;
}

+(BOOL)isQQLogin {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQLogin;
}

+(BOOL)isWeiboLogin {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboLogin;
}

+(void)setWXLogin {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXLogin = TRUE;
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQLogin = FALSE;
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboLogin = FALSE;
}

+(void)setQQLogin {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXLogin = FALSE;
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQLogin = TRUE;
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboLogin = FALSE;
}

+(void)setWeiboLogin {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXLogin = FALSE;
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQLogin = FALSE;
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboLogin = TRUE;
}

+(int)LoginType {
    int loginType = 0;
    
    if (((AppDelegate*)[[UIApplication sharedApplication] delegate]).WXLogin == TRUE) {
        loginType = 1;
    }
    else if (((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQLogin == TRUE) {
        loginType = 2;
    }
    else if (((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboLogin == TRUE) {
        loginType = 3;
    }
    
    return loginType;
}

+(void)setOriginAccessToken:(NSString*)accessToken {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).originAccessToken = accessToken;
}

+(NSString*)OriginAccessToken {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).originAccessToken;
}

+(void)setOriginUsername:(NSString*)username {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).originUsername = username;
}

+(NSString*)OriginUsername {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).originUsername;
}

+(void)setCurrentOName:(NSString*)username {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).currentOName = username;
}

+(NSString*)CurrentOName {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).currentOName;
}

+(void)setCurrentOImageUrl:(NSString*)imageUrl {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).currentOImageUrl = imageUrl;
}

+(NSString*)CurrentOImageUrl {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).currentOImageUrl;
}

+(void)setCurrentOGender:(NSString*)gender {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).currentOGender = gender;
}

+(NSString*)CurrentOGender {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).currentOGender;
}

+(void)setCurrentOLocation:(NSString*)location {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).currentOLocation = location;
}

+(NSString*)CurrentOLocation {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).currentOLocation;
}


+(void)setQQAccessToken:(NSString*)accessToken {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQAccessToken = accessToken;
}

+(void)setQQOpenId:(NSString*)openId {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQOpenId = openId;
}

+(void)setQQNickname:(NSString*)nickname {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQNickname = nickname;
}

+(void)setQQImageUrl1:(NSString*)imageurl {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQImageUrl1 = imageurl;
}

+(void)setQQImageUrl2:(NSString*)imageurl {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQImageUrl2 = imageurl;
}

+(void)setQQCity:(NSString*)city {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQCity = city;
}

+(void)setQQGender:(NSString*)gender {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQGender = gender;
}

+(void)setQQProvince:(NSString*)province {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQProvince = province;
}

+(NSString*)QQAccessToken {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQAccessToken;
}

+(NSString*)QQOpenId {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQOpenId;
}

+(NSString*)QQNickname {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQNickname;
}

+(NSString*)QQImageUrl1 {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQImageUrl1;
}

+(NSString*)QQImageUrl2 {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQImageUrl2;
}

+(NSString*)QQCity {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQCity;
}

+(NSString*)QQGender {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQGender;
}

+(NSString*)QQProvince {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).QQProvince;
}

+(void)setWeiboAccessToken:(NSString*)accessToken {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboAccessToken = accessToken;
}

+(void)setWeiboId:(NSString*)id {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboId = id;
}

+(void)setWeiboRefreshToken:(NSString*)RefreshToken {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboRefreshToken = RefreshToken;
}

+(void)setWeiboUsername:(NSString*)username {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboUsername = username;
}

+(void)setWeiboImageUrlHD:(NSString*)ImageUrl {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboImageUrlHD = ImageUrl;
}

+(void)setWeiboImageUrlLarge:(NSString*)ImageUrl {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboImageUrlLarge = ImageUrl;
}

+(void)setWeiboCity:(NSString*)city {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboCity = city;
}

+(void)setWeiboDescription:(NSString*)description {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboDescription = description;
}

+(void)setWeiboGender:(NSString*)gender {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboGender = gender;
}

+(void)setWeiboLocation:(NSString*)location {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboLocation = location;
}

+(NSString*)WeiboAccessToken {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboAccessToken;
}

+(NSString*)WeiboId {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboId;
}

+(NSString*)WeiboRefreshToken {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboRefreshToken;
}

+(NSString*)WeiboUsername {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboUsername;
}

+(NSString*)WeiboImageUrlHD {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboImageUrlHD;
}

+(NSString*)WeiboImageUrlLarge {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboImageUrlLarge;
}

+(NSString*)WeiboCity {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboCity;
}

+(NSString*)WeiboDescription {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboDescription;
}

+(NSString*)WeiboGender {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboGender;
}

+(NSString*)WeiboLocation {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).WeiboLocation;
}

+(NSDictionary*)expressionDic {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).expressionDic;
}

+(NSMutableArray*)expressionNameArray {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).expressionNameArray;
}

/*
+(NSArray*)historyBrowseFormulaID {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).historyBrowseFormulaID;
}

+(NSArray*)historyBrowseIntroduction {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).historyBrowseIntroduction;
}

+(NSArray*)historyBrowseIngredients {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).historyBrowseIngredients;
}

+(NSArray*)historyBrowseVideoUrl {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).historyBrowseVideoUrl;
}

+(NSArray*)historyBrowseStepStr {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).historyBrowseStepStr;
}

+(NSArray*)historyBrowseFormulaName {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).historyBrowseFormulaName;
}

+(NSArray*)historyBrowseImageName {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).historyBrowseImageName;
}

+(NSArray*)historyBrowseShareUrl {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).historyBrowseShareUrl;
}

+(NSArray*)favFormulaID {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).favFormulaID;
}

+(NSArray*)favIntroduction {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).favIntroduction;
}

+(NSArray*)favIngredients {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).favIngredients;
}

+(NSArray*)favVideoUrl {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).favVideoUrl;
}

+(NSArray*)favStepStr {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).favStepStr;
}

+(NSArray*)favFormulaName {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).favFormulaName;
}

+(NSArray*)favImageName {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).favImageName;
}

+(NSArray*)favShareUrl {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).favShareUrl;
}*/

+(NSMutableArray*)historyData {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).HistoryIntroduceDatas;
}

+(NSMutableArray*)favData {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).FavIntroduceDatas;
}

+(void)setDownloadButtonPress2Pop:(BOOL)isPress {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).downloadButtonPress2Pop = isPress;
}

+(BOOL)downloadButtonPress2Pop {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).downloadButtonPress2Pop;
}

+(NSString*)AppInfoPlistName {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).AppInfoPlistName;
}

+(NSMutableDictionary*)AppInfoDic {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).AppInfoDic;
}

+(NSRecursiveLock*)UpdatingPlistLock {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).updatingPlistLock;
}

+(void)writeDic2File {
    BOOL writeResult = [[AppConstants AppInfoDic] writeToFile:[AppConstants AppInfoPlistName] atomically:YES];
    
    NSLog(@"writeResult = %@", writeResult ? @"YES" : @"NO");
    
    if (!writeResult) {
        NSLog(@"AppInfoDic = %@", [AppConstants AppInfoDic]);
    }
}

+(void)addHistoryBrowseWithData:(IntroduceDataModel*)data {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{

        int index = -1;
        
        for (int i = 0; i < [[AppConstants historyData] count]; ++i) {
            if ([data.formulaID isEqualToString:((IntroduceDataModel*)[[AppConstants historyData] objectAtIndex:i]).formulaID]) {
                index = i;
                break;
            }
        }
        
        if (index == -1) {

            [[AppConstants historyData] insertObject:data atIndex:0];
            
            if ([[AppConstants historyData] count] > 10) {
                [[AppConstants historyData] removeLastObject];
            }
        }
        else if (index == 0) {
            return;
        }
        else {
            [[AppConstants historyData] removeObjectAtIndex:index];
            [[AppConstants historyData] insertObject:data atIndex:0];
        }

        [AppConstants saveModelWithKey:[AppConstants localFileHistory] andArray:[AppConstants historyData]];
    });
}

+(void)addFavWithData:(IntroduceDataModel*)data {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        
        [[AppConstants favData] addObject:data];
        
        [AppConstants saveModelWithKey:[AppConstants localFileFav] andArray:[AppConstants favData]];
    });
}

+(void)deleteFavWithData:(IntroduceDataModel*)data {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        
        int index = -1;
        
        for (int i = 0; i < [[AppConstants favData] count]; ++i) {
            if ([data.formulaID isEqualToString:((IntroduceDataModel*)[[AppConstants favData] objectAtIndex:i]).formulaID]) {
                index = i;
                break;
            }
        }
        
        if (index == -1) {
            return;
        }
        else {
//            把数组里面的数据删掉
            [[AppConstants favData] removeObjectAtIndex:index];
        }
        
        [AppConstants saveModelWithKey:[AppConstants localFileFav] andArray:[AppConstants favData]];
    });
}

+(NSArray*)shareSheetMenu {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).shareSheetMenu;
}

+(CGSize)getImageSizeWithURL:(NSString*)urlStr;
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0.0f, height = 0.0f;
    
    if (imageSource)
    {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        
        if (imageProperties != NULL)
        {
            CFNumberRef widthNum  = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNum != NULL) {
                CFNumberGetValue(widthNum, kCFNumberFloatType, &width);
            }
            
            CFNumberRef heightNum = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNum != NULL) {
                CFNumberGetValue(heightNum, kCFNumberFloatType, &height);
            }
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSource);
//        NSLog(@"Image dimensions: %.0f x %.0f px", width, height);
    }
    return CGSizeMake(width, height);
}

+(BOOL)isJustPostANewPost {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).justPostANewPost;
}

+(void)setJustPostANewPost:(BOOL)post {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).justPostANewPost = post;
}

+(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(void)saveModelWithKey:(NSString*)key andArray:(NSArray*)array {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:key];
    
    NSMutableString *jsonString = [[NSMutableString alloc] initWithFormat:@"{\"datas\":["];
    
    for(int i = 0; i < [array count]; i++){
        [jsonString appendString:[[array objectAtIndex:i] modelToJSONString]];
        [jsonString appendString:@","];
    }
    
    NSUInteger location = [jsonString length]-1;
    NSRange range       = NSMakeRange(location, 1);
    [jsonString replaceCharactersInRange:range withString:@"]}"];
    
//    NSLog(@"jsonString = %@", jsonString);

    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"writeToFile %@", [data writeToFile:fileName atomically:YES] == YES ? @"success" : @"fail");
}

+(void)saveDicWithKey:(NSString*)key andArray:(NSArray*)array {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:key];
    
    NSMutableString *jsonString = [[NSMutableString alloc] initWithFormat:@"{\"datas\":["];
    
    for(int i = 0; i < [array count]; i++){
        [jsonString appendString:[AppConstants dictionaryToJson:(NSDictionary*)[array objectAtIndex:i]]];
        [jsonString appendString:@","];
    }
    
    NSUInteger location = [jsonString length]-1;
    NSRange range       = NSMakeRange(location, 1);
    [jsonString replaceCharactersInRange:range withString:@"]}"];

    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    [data writeToFile:fileName atomically:YES];
}

+(NSData*)loadDataWithKey:(NSString*)key{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:key];
    
    return [NSData dataWithContentsOfFile:fileName];
}

+(UserInfoDataModel*)userInfo {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo;
}

+(void)saveUserInfo {
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setObject:[AppConstants userInfo].accessToken forKey:@"accessToken"];
    [userInfoDic setObject:[AppConstants userInfo].userId forKey:@"userId"];
    [userInfoDic setObject:[AppConstants userInfo].nickname forKey:@"nickname"];
    [userInfoDic setObject:[AppConstants userInfo].sex forKey:@"sex"];
    [userInfoDic setObject:[AppConstants userInfo].mobile forKey:@"mobile"];
    [userInfoDic setObject:[AppConstants userInfo].avatarURL forKey:@"avatarURL"];
    [userInfoDic setObject:[AppConstants userInfo].account forKey:@"account"];
    [userInfoDic setObject:[AppConstants userInfo].password forKey:@"password"];
    [userInfoDic setObject:[AppConstants userInfo].OAuthName forKey:@"OAuthName"];
    [userInfoDic setObject:[AppConstants userInfo].openid forKey:@"openid"];
    
    NSArray *userInfoDatas = [[NSArray alloc] initWithObjects:userInfoDic, nil];
    
    [AppConstants saveDicWithKey:[AppConstants localFileUserInfo] andArray:userInfoDatas];
    
    [AppConstants getUserInfoFromLocal];
}

+(UserInfoDataModel*)getUserInfoFromLocal {
    NSMutableArray *userInfoDataDics;
    
    NSData *data = [AppConstants loadDataWithKey:[AppConstants localFileUserInfo]];
    UserInfoDatas *info = [UserInfoDatas modelWithJSON:data];
    
    [userInfoDataDics addObjectsFromArray:info.datas];
    
    for (int i = 0; i < info.datas.count; i++) {
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo = [[UserInfoDataModel alloc] init];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo.accessToken = [[info.datas objectAtIndex:i] objectForKey:@"accessToken"];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo.userId = [[info.datas objectAtIndex:i] objectForKey:@"userId"];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo.nickname = [[info.datas objectAtIndex:i] objectForKey:@"nickname"];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo.sex = [[info.datas objectAtIndex:i] objectForKey:@"sex"];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo.mobile = [[info.datas objectAtIndex:i] objectForKey:@"mobile"];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo.avatarURL = [[info.datas objectAtIndex:i] objectForKey:@"avatarURL"];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo.account = [[info.datas objectAtIndex:i] objectForKey:@"account"];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo.password = [[info.datas objectAtIndex:i] objectForKey:@"password"];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo.OAuthName = [[info.datas objectAtIndex:i] objectForKey:@"OAuthName"];
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo.openid = [[info.datas objectAtIndex:i] objectForKey:@"openid"];
    }
    
    NSLog(@"getUserInfoFromLocal %@", [info.datas objectAtIndex:0]);
    
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo;
}

+(void)clearCacheFile:(NSString*)cacheFile {
    if ([cacheFile isEqualToString:[AppConstants localFileUserInfo]]) {
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).userInfo = [[UserInfoDataModel alloc] init];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:cacheFile];
    
    NSError *error;
    
    if ([[NSFileManager defaultManager] removeItemAtPath:fileName error:&error] != YES) {
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }
}

+(NSString*)AppID {
    return @"1067728404";
}

+(NSString*)localFileUserInfo {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"UserInfoCN";
    }
    else {
        return @"UserInfoEN";
    }
}

+(NSString*)localFileHistory {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"HistoryCN";
    }
    else {
        return @"HistoryEN";
    }
}

+(NSString*)localFileFav {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"FavCN";
    }
    else {
        return @"FavEN";
    }
}

+(NSString*)localFileChatADData {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"ChatADDataCN";
    }
    else {
        return @"ChatADDataEN";
    }
}

+(NSString*)localFileChatTopicData {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"ChatTopicDataCN";
    }
    else {
        return @"ChatTopicDataEN";
    }
}

+(NSString*)localFileChatUserData {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"ChatUserDataCN";
    }
    else {
        return @"ChatUserDataEN";
    }
}

+(NSString*)localFileChatLiaoLiaoData {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"ChatLiaoLiaoDataCN";
    }
    else {
        return @"ChatLiaoLiaoDataEN";
    }
}

+(NSString*)localFileADData {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"ADDataCN";
    }
    else {
        return @"ADDataEN";
    }
}

+(NSString*)localFileIntroduceData {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"IntroduceDataCN";
    }
    else {
        return @"IntroduceDataEN";
    }
}

+(NSString*)localFileArticleData {
    if ([NSLocalizedString(@"test", @"") isEqualToString:@"测试"]) {
        return @"ArticleDataCN";
    }
    else {
        return @"ArticleDataEN";
    }
}

+(void)clearUserInfo {
    [AppConstants clearCacheFile:[AppConstants localFileUserInfo]];
}

+(void)clearLocalFileChatADData {
    [AppConstants clearCacheFile:[AppConstants localFileChatADData]];
}

+(void)clearLocalFileChatTopicData {
    [AppConstants clearCacheFile:[AppConstants localFileChatTopicData]];
}

+(void)clearLocalFileChatUserData {
    [AppConstants clearCacheFile:[AppConstants localFileChatUserData]];
}

+(void)clearLocalFileChatLiaoLiaoData {
    [AppConstants clearCacheFile:[AppConstants localFileChatLiaoLiaoData]];
}

+(void)clearLocalFileADData {
    [AppConstants clearCacheFile:[AppConstants localFileADData]];
}

+(void)clearLocalFileIntroduceData {
    [AppConstants clearCacheFile:[AppConstants localFileIntroduceData]];
}

+(void)clearLocalFileArticleData {
    [AppConstants clearCacheFile:[AppConstants localFileArticleData]];
}

+(void)relogin:(void(^)(BOOL))finishBlock {
    /*
    if ([[AppConstants userInfo].openid isEqualToString:@""]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
        
        NSString *urlString = [NSString stringWithFormat:@"%@authentication/user/login/index.ashx", [AppConstants httpHeader]];
        
        NSDictionary *parameters = @{@"UserId":[AppConstants userInfo].account, @"Password":[AppConstants userInfo].password};
        
        [manager POST:urlString parameters:parameters
              success:^(AFHTTPRequestOperation *operation,id responseObject) {
                  NSLog(@"success urlString = %@", urlString);
                  NSLog(@"Success: %@", responseObject);

                  if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                      NSLog(@"set accessToken");
                      
                      [AppConstants userInfo].accessToken = [responseObject objectForKey:@"AccessToken"];
                      
                      [AppConstants saveUserInfo];

                      dispatch_async(dispatch_get_main_queue(), ^{
                          finishBlock(YES);
                      });
                  }
                  else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                      NSLog(@"登录失败 %@", urlString);
                      dispatch_async(dispatch_get_main_queue(), ^{
                          finishBlock(NO);
                      });
                  }
                  
              }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                  NSLog(@"false urlString = %@", urlString);
                  NSLog(@"Error: %@", error);
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      finishBlock(NO);
                  });
              }];
    }
    else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
        
        NSString *urlString = [NSString stringWithFormat:@"%@authentication/oauth/login/index.ashx", [AppConstants httpHeader]];
        
        NSDictionary *parameters = @{@"OpenID":[AppConstants userInfo].openid, @"OAuthName":[AppConstants userInfo].OAuthName};
        
        NSLog(@"parameters = %@", parameters);
        
        [manager POST:urlString parameters:parameters
              success:^(AFHTTPRequestOperation *operation,id responseObject) {
                  NSLog(@"success urlString = %@", urlString);
                  NSLog(@"Success: %@", responseObject);
                  
                  if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                      NSLog(@"第三方登录成功 %@", urlString);

                      [AppConstants userInfo].accessToken = [responseObject objectForKey:@"AccessToken"];
                      
                      [AppConstants saveUserInfo];
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          finishBlock(YES);
                      });
                  }
                  else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                      NSLog(@"第三方登录失败 %@", urlString);

                      dispatch_async(dispatch_get_main_queue(), ^{
                          finishBlock(NO);
                      });
                  }
              }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                  NSLog(@"false urlString = %@", urlString);
                  NSLog(@"Error: %@", error);
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      finishBlock(NO);
                  });

              }];
    }
     */
}

+(void)notice2ManualRelogin {
    NSLog(@"notice2ManualRelogin");
    
    [ProgressHUD showError:NSLocalizedString(@"notice2ManualRelogin", @"")];
    
    [AppConstants clearUserInfo];
}

/*
 http接口
 
 case 0:
 server += "authentication/user/register";
 break;
 case 1: // 绑定设备
 server += "Devices/Bind/index.ashx";
 break;
 case 2: // 查询绑定的设备
 server += "Devices/query/index.ashx";
 break;
 case 3: // 获取菜谱清单
 server += "resource/formula/list/index.ashx";
 break;
 case 4: // 获取菜谱相册清单
 server += "resource/formula/albums/list/index.ashx";
 break;
 case 5: // 获取菜谱的厨友清单
 server += "resource/formula/friends/list/index.ashx";
 break;
 case 6: // 获取菜谱的烹调步骤清单
 server += "resource/formula/steps/list/index.ashx";
 break;
 case 7: // test
 server += "test/hello/index.ashx";
 break;
 case 8: // 重新获取安全令牌
 server += "authentication/user/RefreshAccessToken/index.ashx";
 break;
 case 9: // 获取首页专题列表
 server += "resource/article/frontpage/list/index.ashx";
 break;
 case 10: // 获取专题分类列表
 server += "resource/article/category/list/index.ashx";
 break;
 case 11: // 根据关键字查询获取专题列表
 server += "resource/article/keyword/list/index.ashx";
 break;
 case 12: // 登录帐号
 server += "authentication/user/login/index.ashx";
 break;
 case 13: // 获取帐户信息
 server += "authentication/user/infomation/index.ashx";
 break;
 case 14:  // 获取专题详细内容
 server += "resource/article/detail/index.ashx";
 break;
 case 15: // 根据关键字查询获取菜谱列表
 server += "resource/formula/keyword/list/index.ashx";
 break;
 case 16: // 获取首页菜谱列表
 server += "resource/formula/frontpage/list/index.ashx";
 break;
 case 17: // 获取热门搜索
 server += "resource/tag/hot/list/index.ashx";
 break;
 case 18: // 获取首页顶部广告专题
 server += "resource/article/frontpage/slide/list/index.ashx";
 break;
 case 19: // 获取菜谱评论
 server += "interaction/formula/comment/list/index.ashx";
 break;
 case 20: // 第三方登录
 server += "authentication/oauth/login/index.ashx";
 break;
 case 21: // 第三方注册
 server += "authentication/oauth/register/index.ashx";
 break;
 case 22: // 发表菜谱评论
 server += "interaction/formula/comment/post/index.ashx";
 break;
 case 23: // 获取收藏最多的菜谱列表
 server += "resource/formula/collecttop/list/index.ashx";
 */

/*
 蓝牙指令
 
 private class AddRecipeThread extends Thread{
 private String steps;
 public AddRecipeThread(String step) {
 steps = step;
 }
 
 @Override
 public void run() {
 // TODO Auto-generated method stub
 Looper.prepare();
 AppLog.i("录入菜谱start");
 HashMap<Integer, String> hmSteps = ModelManager.getRecipeSteps(steps);
 if(hmSteps == null) {
 hmSteps = ModelManager.getRecipeSteps();
 }
 boolean isAddSuccess = true;
 if(isDevOpen) { // 蓝牙连接了
 isAddingSteps = true;
 for(int i=0; i<hmSteps.size(); i++) {
 util.writePort(hmSteps.get(i).getBytes()); // 菜谱指令hashmap
 AppLog.i("录入菜谱 : "+hmSteps.get(i));
 isWaitingStep = true;
 while(isWaitingStep) {
 }
 BlutoothInstructionInfo inst = ModelManager.parseBluetoothInstruction(addStepsReceive); // 解析指令
 if(inst.getInst().equals("BF")) { // BF指令 表示一条指令执行成功
 
 }else {
 String err = "菜谱下载失败！ "+inst.getData();
 if(inst.getInst().equals("BE")) {
 String[] ss = inst.getData().split("%");
 if(ss.length >= 2) {
 if(ss[1].equals("21")) {
 err += "步骤ID不正确";
 }else if(ss[1].equals("22")) {
 err += "动作指令未定义";
 }else if(ss[1].equals("23")) {
 err += "参数超过最大允许值";
 }else if(ss[1].equals("24")) {
 err += "转速超过本机范围";
 }else if(ss[1].equals("25")) {
 err += "档位超过最大值";
 }else if(ss[1].equals("31")) {
 err += "步骤"+ss[0]+" 保存失败";
 }else if(ss[1].equals("32")) {
 err += "指令"+ss[0]+" 保存失败";
 }else if(ss[1].equals("33")) {
 err += "参数DATA保存失败";
 }else if(ss[1].equals("34")) {
 err += "转速参数 保存失败";
 }else if(ss[1].equals("35")) {
 err += "档位参数 保存失败";
 }
 }
 }
 isAddSuccess = false;
 Toast.makeText(context, err, Toast.LENGTH_SHORT).show();
 Message msg2 = new Message();
 msg2.what = 2;
 msg2.obj = 0;
 if(AppApplication.recipeactHandler != null) {
 AppApplication.recipeactHandler.sendMessage(msg2);
 }
 break;
 }
 }
 AppLog.i("录入菜谱end");
 if(isAddSuccess) {
 Toast.makeText(context, "菜谱下载成功！", Toast.LENGTH_SHORT).show();
 AppPrefs.setStrValue("load_recipe_steps", steps);
 Message msg2 = new Message();
 msg2.what = 2;
 msg2.obj = 1;
 if(AppApplication.recipeactHandler != null) {
 AppApplication.recipeactHandler.sendMessage(msg2);
 }
 Message msg3 = new Message();
 msg3.what = 6;
 btHandler.sendMessageDelayed(msg3, 1000);
 
 String com = BlueToothCommandParams.getCommand("C2", "06");
 Message msg = new Message();
 msg.what = 1;
 msg.obj = com;
 btComHandler.sendMessage(msg);
 }
 }else {
 Toast.makeText(context, "蓝牙设备未连接", Toast.LENGTH_SHORT).show();
 Message msg2 = new Message();
 msg2.what = 2;
 msg2.obj = 0;
 if(AppApplication.recipeactHandler != null) {
 AppApplication.recipeactHandler.sendMessage(msg2);
 }
 }
 isAddingSteps = false;
 Looper.loop();
 }
	}
 */
@end


@implementation HttpClient

+ (HttpClient *)sharedClient {
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [self manager];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        _sharedClient.securityPolicy = securityPolicy;
    });
    return _sharedClient;
}

@end











