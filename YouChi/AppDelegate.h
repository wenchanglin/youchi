//
//  AppDelegate.h
//  YouChi
//
//  Created by sam on 15/4/28.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WTATagStringBuilder/WTATagStringBuilder.h>
#import "YCIntroductionVC.h"
#import "BTConstants.h"

#define APP ((AppDelegate *)[UIApplication sharedApplication].delegate)

@class BLEPort,UserInfoDataModel;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WTATagStringBuilder *builder;
@property (strong, nonatomic) YCIntroductionVC *introductionVC;
@property (strong, nonatomic) RACSubject *weixinSignal;
@property (strong, nonatomic) RACSubject *alipaySignal;
- (void)shouldRegisterRemoteNotification:(BOOL)b;


@property (strong, nonatomic) NSString *WXCode;
@property (strong, nonatomic) NSString *WXAccessToken;
@property (strong, nonatomic) NSString *WXOpenid;
@property (strong, nonatomic) NSString *WXRefreshToken;
@property (strong, nonatomic) NSString *WXScope;
@property (strong, nonatomic) NSString *WXUnionid;
@property (strong, nonatomic) NSString *WXCity;
@property (strong, nonatomic) NSString *WXCountry;
@property (strong, nonatomic) NSString *WXHeadimgurl;
@property (strong, nonatomic) NSString *WXLanguage;
@property (strong, nonatomic) NSString *WXNickname;
@property (strong, nonatomic) NSString *WXProvince;
@property (strong, nonatomic) NSString *WXSex;

@property (strong, nonatomic) NSString *QQAccessToken;
@property (strong, nonatomic) NSString *QQOpenId;
@property (strong, nonatomic) NSString *QQNickname;
@property (strong, nonatomic) NSString *QQImageUrl1;
@property (strong, nonatomic) NSString *QQImageUrl2;
@property (strong, nonatomic) NSString *QQCity;
@property (strong, nonatomic) NSString *QQGender;
@property (strong, nonatomic) NSString *QQProvince;

@property (strong, nonatomic) NSString *WeiboAccessToken;
@property (strong, nonatomic) NSString *WeiboRefreshToken;
@property (strong, nonatomic) NSString *WeiboUsername;
@property (strong, nonatomic) NSString *WeiboImageUrlHD;
@property (strong, nonatomic) NSString *WeiboImageUrlLarge;
@property (strong, nonatomic) NSString *WeiboCity;
@property (strong, nonatomic) NSString *WeiboDescription;
@property (strong, nonatomic) NSString *WeiboGender;
@property (strong, nonatomic) NSString *WeiboId;
@property (strong, nonatomic) NSString *WeiboLocation;

@property (strong, nonatomic) NSString *originUsername;
@property (strong, nonatomic) NSString *originAccessToken;
@property (strong, nonatomic) NSString *currentOName;
@property (strong, nonatomic) NSString *currentOImageUrl;
@property (strong, nonatomic) NSString *currentOGender;
@property (strong, nonatomic) NSString *currentOLocation;

@property (strong, nonatomic) BLEPort  *currentBTPort;

@property (nonatomic) BOOL              WXLogin;
@property (nonatomic) BOOL              QQLogin;
@property (nonatomic) BOOL              WeiboLogin;

@property (nonatomic) BOOL              BTConnectStatus;
@property (nonatomic) BOOL              BTAvailable;
@property (nonatomic) NSString          *BTRequestType;
@property (nonatomic) unsigned long     stepTotalTime;
@property (nonatomic) NSString          *BTConnectedMachineName;
@property (nonatomic) NSString          *BTConnectedMachineMac;
@property (strong, nonatomic) NSString  *BTCurrentRecipeImageName;
@property (strong, nonatomic) NSString  *BTCurrentRecipeName;
@property (assign, nonatomic) BTMachineStatus  BTStatus;
@property (nonatomic) BOOL              BTDownloadingSteps;
@property (strong, nonatomic) NSDictionary      *expressionDic;
@property (strong, nonatomic) NSMutableArray    *expressionNameArray;

/*
 @property (strong, nonatomic) NSMutableArray    *historyBrowseFormulaID;
 @property (strong, nonatomic) NSMutableArray    *historyBrowseIntroduction;
 @property (strong, nonatomic) NSMutableArray    *historyBrowseIngredients;
 @property (strong, nonatomic) NSMutableArray    *historyBrowseVideoUrl;
 @property (strong, nonatomic) NSMutableArray    *historyBrowseStepStr;
 @property (strong, nonatomic) NSMutableArray    *historyBrowseFormulaName;
 @property (strong, nonatomic) NSMutableArray    *historyBrowseImageName;
 @property (strong, nonatomic) NSMutableArray    *historyBrowseShareUrl;
 
 @property (strong, nonatomic) NSMutableArray    *favFormulaID;
 @property (strong, nonatomic) NSMutableArray    *favIntroduction;
 @property (strong, nonatomic) NSMutableArray    *favIngredients;
 @property (strong, nonatomic) NSMutableArray    *favVideoUrl;
 @property (strong, nonatomic) NSMutableArray    *favStepStr;
 @property (strong, nonatomic) NSMutableArray    *favFormulaName;
 @property (strong, nonatomic) NSMutableArray    *favImageName;
 @property (strong, nonatomic) NSMutableArray    *favShareUrl;*/

@property (strong, nonatomic) NSMutableArray                    *HistoryIntroduceDataDics;
@property (strong, nonatomic) NSMutableArray                    *HistoryIntroduceDatas;
@property (strong, nonatomic) NSMutableArray                    *FavIntroduceDataDics;
@property (strong, nonatomic) NSMutableArray                    *FavIntroduceDatas;

@property (nonatomic) BOOL                      downloadButtonPress2Pop;
//@property (nonatomic) BOOL                      BTLocked;
//@property (strong, nonatomic) MainTabBarController *mainTabBarController;

@property (nonatomic, assign) int WXErrCode;

@property (strong, nonatomic) NSString *httpAccessToken;
//@property (nonatomic) sqlite3  *db;

@property (strong, nonatomic) NSRecursiveLock            *updatingPlistLock;
@property (strong, nonatomic) NSMutableDictionary      *AppInfoDic;
@property (strong, nonatomic) NSString          *AppInfoPlistName;

@property (strong, nonatomic) NSArray           *shareSheetMenu;

@property (nonatomic) NSInteger         memeryCount;

@property (nonatomic) BOOL              justPostANewPost;

@property (strong, nonatomic) UserInfoDataModel *userInfo;

@property (nonatomic) BOOL              isPlayingVideo;

@property (nonatomic) BOOL              isRecipeCacheCleared;
@property (nonatomic) BOOL              isChatCacheCleared;

@end

