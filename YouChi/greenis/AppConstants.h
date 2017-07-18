//
//  AppConstantsa.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/20.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UserInfoDataModel.h"
#import "IntroduceDataModel.h"

//#define NSLocalizedString(key, comment) \
//(([[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"zh-Hans"])?([[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]):([[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"]] localizedStringForKey:key value:@"" table:nil]))
@interface BaseModel : NSObject
+ (NSDictionary *)modelCustomPropertyMapper;
+ (NSDictionary *)modelContainerPropertyGenericClass;

- (void)setupModel;
@end

@interface AppConstants : NSObject

+(UIColor*)initUIColorWithInt:(int)RGB;

+(int)messageInputViewHeight;
+(int)messageInputViewButtonHeight;
+(int)uiNavigationBarHeight;
+(int)uiTabBarHeight;
+(int)uiScreenWidth;
+(int)uiScreenHeight;
+(int)searchBarX;
+(int)searchBarY;
+(int)searchBarWidth;

+(UIColor*)themeColor;
+(UIColor*)themeGrayColor;
+(UIColor*)backgroundColor;

+(NSString*)DBName;
//+(sqlite3*)DBInstance;
+(void)execSql:(NSString *)sql;

+(NSString*)WXAppID;
+(NSString*)WXAppSecret;
+(NSString*)QQAppID;
+(NSString*)SINAAppKey;

+(AppDelegate*)AppDelegate;
+(NSString*)WXCode;
+(NSString*)WXAccessToken;
+(NSString*)WXOpenid;
+(NSString*)WXRefreshToken;
+(NSString*)WXScope;
+(NSString*)WXUnionid;
+(NSString*)WXCity;
+(NSString*)WXCountry;
+(NSString*)WXHeadimgurl;
+(NSString*)WXLanguage;
+(NSString*)WXNickname;
+(NSString*)WXProvince;
+(NSString*)WXSex;
+(NSString*)WXMobile;
+(NSString*)WXEmail;
+(NSString*)WXBirthday;
+(NSString*)WXAddress;
+(void)setWXCode:(NSString*)code;
+(void)setWXAccessToken:(NSString*)accessToken;
+(void)setWXOpenid:(NSString*)openid;
+(void)setWXRefreshToken:(NSString*)RefreshToken;
+(void)setWXScope:(NSString*)Scope;
+(void)setWXUnionid:(NSString*)Unionid;
+(void)setWXCity:(NSString*)City;
+(void)setWXCountry:(NSString*)Country;
+(void)setWXHeadimgurl:(NSString*)Headimgurl;
+(void)setWXLanguage:(NSString*)Language;
+(void)setWXNickname:(NSString*)Nickname;
+(void)setWXProvince:(NSString*)Province;
+(void)setWXSex:(NSString*)Sex;

+(int)WXErrCode;
+(void)setIsShowIntroView;
+(BOOL)isShowIntroView;

+(int)introStartButtonHeight;
+(UIColor*)introCard1Color;
+(UIColor*)introCard2Color;
+(UIColor*)introCard3Color;
+(UIColor*)introStartButtonColor;

+(int)pagerCenterOffsetFromScrollViewBottom;
+(int)introCardTextLineHeight;

+(UIFont*)introCardTextFont;
+(UIFont*)introCardTitleFont;
+(NSString*)introCard1Title;
+(NSString*)introCard2Title;
+(NSString*)introCard1Text;
+(NSString*)introCard2Text;
+(NSString*)introCard3Text;

+(NSString*)adImageName;
+(NSString*)introduceImageName;

+(NSString*)httpVideoHeader;
+(NSString*)httpImageHeader;
+(NSString*)shareHeader;
+(NSString*)httpHeader;
+(NSString*)httpType;
+(NSString*)httpServerIP;
+(NSString*)httpServerPort;
+(NSString*)httpAccessToken;
+(void)setHttpAccessToken:(NSString*)newAccessToken;

+(NSString*)httpSavePath;

//+(NSString*)imageUrl2String:(NSString*)url;
//+(NSString*)string2ImageUrl:(NSString*)url;
/*
+(BOOL)isWXLogin;
+(BOOL)isQQLogin;
+(BOOL)isWeiboLogin;
+(void)setWXLogin;
+(void)setQQLogin;
+(void)setWeiboLogin;
+(int)LoginType;

+(void)setOriginAccessToken:(NSString*)accessToken;
+(NSString*)OriginAccessToken;
+(void)setOriginUsername:(NSString*)username;
+(NSString*)OriginUsername;
+(void)setCurrentOName:(NSString*)username;
+(NSString*)CurrentOName;
+(void)setCurrentOImageUrl:(NSString*)imageUrl;
+(NSString*)CurrentOImageUrl;
+(void)setCurrentOGender:(NSString*)gender;
+(NSString*)CurrentOGender;
+(void)setCurrentOLocation:(NSString*)location;
+(NSString*)CurrentOLocation;
*/
+(void)setQQAccessToken:(NSString*)accessToken;
+(void)setQQOpenId:(NSString*)openId;
+(void)setQQNickname:(NSString*)nickname;
+(void)setQQImageUrl1:(NSString*)imageurl;
+(void)setQQImageUrl2:(NSString*)imageurl;
+(void)setQQCity:(NSString*)city;
+(void)setQQGender:(NSString*)gender;
+(void)setQQProvince:(NSString*)province;

+(NSString*)QQAccessToken;
+(NSString*)QQOpenId;
+(NSString*)QQNickname;
+(NSString*)QQImageUrl1;
+(NSString*)QQImageUrl2;
+(NSString*)QQCity;
+(NSString*)QQGender;
+(NSString*)QQProvince;

+(void)setWeiboAccessToken:(NSString*)accessToken;
+(void)setWeiboId:(NSString*)id;
+(void)setWeiboRefreshToken:(NSString*)RefreshToken;
+(void)setWeiboUsername:(NSString*)username;
+(void)setWeiboImageUrlHD:(NSString*)ImageUrl;
+(void)setWeiboImageUrlLarge:(NSString*)ImageUrl;
+(void)setWeiboCity:(NSString*)city;
+(void)setWeiboDescription:(NSString*)description;
+(void)setWeiboGender:(NSString*)gender;
+(void)setWeiboLocation:(NSString*)location;

+(NSString*)WeiboAccessToken;
+(NSString*)WeiboId;
+(NSString*)WeiboRefreshToken;
+(NSString*)WeiboUsername;
+(NSString*)WeiboImageUrlHD;
+(NSString*)WeiboImageUrlLarge;
+(NSString*)WeiboCity;
+(NSString*)WeiboDescription;
+(NSString*)WeiboGender;
+(NSString*)WeiboLocation;

+(NSDictionary*)expressionDic;
+(NSMutableArray*)expressionNameArray;

/*
+(NSArray*)historyBrowseFormulaID;
+(NSArray*)historyBrowseIntroduction;
+(NSArray*)historyBrowseIngredients;
+(NSArray*)historyBrowseVideoUrl;
+(NSArray*)historyBrowseStepStr;
+(NSArray*)historyBrowseFormulaName;
+(NSArray*)historyBrowseImageName;
+(NSArray*)historyBrowseShareUrl;

+(NSArray*)favFormulaID;
+(NSArray*)favIntroduction;
+(NSArray*)favIngredients;
+(NSArray*)favVideoUrl;
+(NSArray*)favStepStr;
+(NSArray*)favFormulaName;
+(NSArray*)favImageName;
+(NSArray*)favShareUrl;
*/

+(NSMutableArray*)historyData;
+(NSMutableArray*)favData;

+(void)setDownloadButtonPress2Pop:(BOOL)isPress;
+(BOOL)downloadButtonPress2Pop;

+(NSString*)AppInfoPlistName;
+(NSMutableDictionary*)AppInfoDic;
+(NSRecursiveLock*)UpdatingPlistLock;

+(void)writeDic2File;

+(void)addHistoryBrowseWithData:(IntroduceDataModel*)data;
+(void)addFavWithData:(IntroduceDataModel*)data;
+(void)deleteFavWithData:(IntroduceDataModel*)data;

/*
+(void)addHistoryBrowseWithFormulaID:(NSString*)formulaID andIntroduction:(NSString*)introduction andIngredients:(NSString*)ingredients andVideoUrl:(NSString*)videoUrl andStepStr:(NSString*)stepStr andFormulaName:(NSString*)formulaName andImageName:(NSString*)imageName andShareUrl:(NSString*)shareUrl;

+(void)addFavWithFormulaID:(NSString*)formulaID andIntroduction:(NSString*)introduction andIngredients:(NSString*)ingredients andVideoUrl:(NSString*)videoUrl andStepStr:(NSString*)stepStr andFormulaName:(NSString*)formulaName andImageName:(NSString*)imageName andShareUrl:(NSString*)shareUrl;

+(void)deleteFavWithFormulaID:(NSString*)formulaID andIntroduction:(NSString*)introduction andIngredients:(NSString*)ingredients andVideoUrl:(NSString*)videoUrl andStepStr:(NSString*)stepStr andFormulaName:(NSString*)formulaName andImageName:(NSString*)imageName andShareUrl:(NSString*)shareUrl;
*/
+(NSArray*)shareSheetMenu;

+(CGSize)getImageSizeWithURL:(NSString *)urlStr;

+(BOOL)isJustPostANewPost;
+(void)setJustPostANewPost:(BOOL)post;

+(NSString*)dictionaryToJson:(NSDictionary *)dic;
+(void)saveModelWithKey:(NSString*)key andArray:(NSArray*)array;
+(void)saveDicWithKey:(NSString*)key andArray:(NSArray*)array;
+(NSData*)loadDataWithKey:(NSString*)key;

+(UserInfoDataModel*)userInfo;
+(void)saveUserInfo;
+(UserInfoDataModel*)getUserInfoFromLocal;
+(void)clearUserInfo;

+(NSString*)AppID;

+(NSString*)localFileUserInfo;
+(NSString*)localFileHistory;
+(NSString*)localFileFav;
+(NSString*)localFileChatADData;
+(NSString*)localFileChatTopicData;
+(NSString*)localFileChatUserData;
+(NSString*)localFileChatLiaoLiaoData;
+(NSString*)localFileADData;
+(NSString*)localFileIntroduceData;
+(NSString*)localFileArticleData;

+(void)clearLocalFileChatADData;
+(void)clearLocalFileChatTopicData;
+(void)clearLocalFileChatUserData;
+(void)clearLocalFileChatLiaoLiaoData;
+(void)clearLocalFileADData;
+(void)clearLocalFileIntroduceData;
+(void)clearLocalFileArticleData;

+(void)relogin:(void(^)(BOOL))finishBlock;
+(void)notice2ManualRelogin;

@end

#define HTTP_CLIENT [HttpClient sharedClient]
@interface HttpClient : AFHTTPSessionManager
+ (HttpClient *)sharedClient;
@end

