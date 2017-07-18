//
//  YCApis.h
//  YouChi
//
//  Created by sam on 15/5/24.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef YouChi_YCApis_h
#define YouChi_YCApis_h

#pragma mark--------登陆
///登陆1.2
static NSString *apiLogin = @"app/access/login.json";
///退出登陆1.2
static NSString *apiLoginOut = @"app/access/logout.json";
///第三方登录1.2
static NSString *apiOtherLogin = @"app/access/otherPlatformLogin.json";
///获取验证码1.2
static NSString *apiGetSmsCode = @"app/access/sms/getSmsCode.json";
///注册1.2
static NSString *apiRegister = @"app/access/register.json";
///修改密码1.2
static NSString *apiModifyPassword = @"app/setting/modifyPassword.json";

///校验验证码
static NSString *apiCheckSmsCode = @"app/setting/checkSmsCode.json";
///验证旧密码1.2
static NSString *apiCheckPassword = @"app/setting/checkPassword.json";
///找回密码1.2
static NSString *apiFindPassword = @"app/setting/findPassword.json";


///《友吃服务使用协议》1.2
static NSString *apiRuleRegister =@"http://h5.youchi365.com/shop/kuaiyi/rule/register.html";

///《隐私条款》1.2
static NSString *apiConcealRegister =@"http://h5.youchi365.com/shop/kuaiyi/rule/register2.html";


/////校验验证码
//static NSString *apiCheckSmsCode = @"app/setting/getSmsCodeByEmailAndPhone.json";


#pragma mark--------欢迎页
///保存用户状态
static NSString *apiSaveUser = @"app/state/saveUserState.json";
///获取用户状态
static NSString *apiGetUser = @"app/state/getUserState.json";
///获取所有
static NSString *apiGetAll = @"app/state/getAllState.json";


#pragma mark--------发秘籍

///新建秘籍1.2
static NSString *apiRNewRecipe = @"app/upload/recipe/saveRecipe.json";
///编辑秘籍1.2
static NSString *apiREditRecipe = @"app/upload/recipe/editRecipe.json";



#pragma mark--------随手拍
///发随手拍1.2
static NSString *apiUploadYouchi =@"app/upload/youchi.json";

///获取随手拍城市列表1.2
static NSString *apiGetCityList =@"app/upload/youchi/getCityList.json";

#pragma mark--------私人定制

///删除  果单  的下面的评论内容，和果单下面的评论的回复内容1.2
static NSString *apiRDelComment = @"app/recipe/delComment.json";
///保存果单的下面的评论内容，和果单下面的评论的回复内容1.2
static NSString *apiRSaveComment = @"app/recipe/saveComment.json";
///根据，获取分类果单的列表1.2
static NSString *apiRGetRecommend = @"app/recipe/getRecommendRecipeList.json";

///私人订制 -- 获取私人订制背景图片和推荐水果接口1.2
static NSString *apiRPersonalHeader = @"app/category/getPersonalHeader.json";


///私人订制 -- 获取果单列表1.2
static NSString *apiRPGetMaterial =@"app/material/getMaterialDetails";




#pragma mark--------吃货营

///推荐列表(带分页)1.2
static NSString *apiCGetRecommendPageList = @"app/eater/recommend/getRecommendPageList.json";
///当前用户关注的人的随手拍列表1.2
static NSString *apiCGetFollowUserYouchi = @"app/eater/follow/getFollowUserYouchi.json";
///获取随手拍明细信息1.2
static NSString *apiCGetYouchiDetail =@"app/eater/details/getYouchiDetails.json";
///获取果单秘籍明细信息1.2
static NSString *apiCGetRecipeDetail =@"app/eater/details/getRecipeDetails.json";



#pragma mark--------搜索
///随手拍搜索列表接口1.2
static NSString *apiCGetSearchYouchiList =@"app/search/youchi/getYouchiListBySearchParam.json";


///所有集合搜索列表接口1.2
static NSString *apiCGetSearchParam =@"app/search/collection/getCollectionBySearchParam.json";
///用户搜索列表接口1.2
static NSString *apiCGetSearchUserList = @"app/search/user/getUserListBySearchParam.json";
///视频搜索列表接口1.2
static NSString *apiCGetSearchVideoList = @"app/search/video/getVideoListBySearchParam.json";
///资讯搜索列表接口1.2
static NSString *apiCGetSearchNewsList = @"app/search/news/getNewsListBySearchParam.json";

#pragma mark--------消息

///通知列表接口1.2
static NSString *apiCGetNoticeList =@"app/message/notice/getNoticeList.json";

///评论列表接口1.2
static NSString *apiCGetCommentNoticeList =@"app/message/comment/getCommentNoticeList.json";

///根据cheatsId，获取随手拍明细、果单秘籍明细信息  1.2
static NSString *apiCgetDetails = @"app/eater/cheats/getDetails.json";

///随机用户列表1.2
static NSString *apiCGetRandom = @"app/eater/recommend/getRandomUserList.json";

///秘籍评论和回复秘籍评论接口.note   1.2
static NSString *apiCCheatsComment = @"app/common/comment/saveCheatsComment.json";

///根据cheatsId获取秘籍评论列表  1.2
static NSString *apiCCommentList = @"app/common/comment/getCheatsCommentList.json";


///当前用户可以删除自己留下的秘籍评论和回复，秘籍用户可以删除自己秘籍下的评论   1.2
static NSString *apiCDelCheatsComment = @"app/common/comment/delCheatsComment.json";

///给秘籍点赞或取消点赞   1.2
static NSString *apiCCheatsLike = @"app/common/like/cheatsLikeAction.json";

///随手拍id获取果单秘籍列1.2
static NSString *apiCRecipeList =@"app/eater/recipe/getRecipeListByYouchiId.json";

///上传随手拍接口 1.2
static NSString *apiCUpload = @"app/upload/youchi.json";

///删除  吃货营   的下面的评论内容，和吃货营下面的评论的回复内容1.2
static NSString *apiCDelComment = @"app/youchi/delComment.json";

///保存吃货营的下面的评论内容，和吃货营下面的评论的回复内容1.2
static NSString *apiCSaveComment = @"app/youchi/saveComment.json";


///吃货营点赞或取消点赞    1.2
static NSString *apiCLike = @"app/common/like/youchiLikeAction.json";




#pragma mark -------1.2-赞---------

/// 视频详情--更多点赞 1.2
static NSString *apiGetVideoMoreLikeList = @"app/common/like/videoMoreLikeList.json";
/// 随手拍详情--更多点赞1.2
static NSString *apiGetyouchiMoreLikeList = @"app/common/like/youchiMoreLikeList.json";
/// 秘籍详情--更多点赞1.2
static NSString *apiGetrecipeMoreLikeList =@"app/common/like/recipeMoreLikeList.json";

#pragma mark -------1.2-发现---------

/// 资讯--推荐列表1.2
static NSString *apiGetRecommendNewsList = @"app/find/news/getRecommendNewsList.json";
///// 资讯--最新列表1.2
static NSString *apiGetLatestNewsList = @"app/find/news/getLatestNewsList.json";
///// 视频--推荐视频1.2
static NSString *apiGetRecommendList = @"app/find/video/getRecommendVideoList.json"; 
///// 视频--最新视频1.2
static NSString *apiGetLatestVideoList = @"app/find/video/getLatestVideoList.json";
///// 视频--Banner（广告）1.2
static NSString *apiGetVideoBannerList = @"app/find/video/getVideoBannerList.json";  

///获取视频明细信息1.2
static NSString *apiVideoDetail = @"app/find/video/getDetails.json";

///获取视频评论1.2
static NSString *apiVideoComment = @"app/common/comment/getVideoCommentList.json";

///获取最新资讯列表1.2
static NSString *apiLatestNew = @"app/find/news/getLatestNewsList.json";

///获取推荐资讯列表1.2
static NSString *apiRecommendNews = @"app/find/news/getRecommendNewsList.json";







#pragma mark-----收藏--分享---

#pragma mark--视频收藏_1.2   apiGetMyYouchiFavoriteList
static NSString *apiGetMyVideoFavoriteList =  @"app/my/favorite/getMyVideoFavoriteList.json";
#pragma mark--随手拍收藏_1.2   app/my/favorite/getMyNewsFavoriteList.json
static NSString *apiGetMyYouchiFavoriteList =  @"app/my/favorite/getMyYouchiFavoriteList.json";
#pragma mark--咨询收藏_1.2  /app/my/favorite/getMyVideoFavoriteList.json
static NSString *apiGetMyNewsFavoriteList =  @"app/my/favorite/getMyNewsFavoriteList.json";
#pragma mark--秘籍（果单）收藏_1.2
static NSString *apiGetMyRecipeFavoriteList =  @"app/my/favorite/getMyRecipeFavoriteList.json";

#pragma mark--------个人主页
///获取当前用户信息接口1.2
static NSString *apiGCurrentUserInfo = @"app/my/info/getCurrentUserInfo.json";
///签到1.2
static NSString *apiGSignup = @"app/my/info/signup.json";

///添加关注/取消关注1.2
static NSString *apiGFollow = @"app/common/follow/userFollowAction.json";

///个人头像设置接口1.2
static NSString *apiGSavePersonal = @"app/my/info/saveUserPhoto.json";



///根据token获取我的随手拍列表--1.2
static NSString *apiGetMyYouchiShareList = @"app/my/share/getMyYouchiShareList.json";
///根据token获取我的秘籍列表--1.2
static NSString *apiGetMyRecipeShareList = @"app/my/share/getMyRecipeShareList.json";

///个人资料设置1.2
static NSString *apiSavePersonalInfo = @"app/my/info/saveUserInfo.json";

///关注列表接口  1.2
static NSString *apiGetFollow = @"app/my/follow/getMyFollowUserList.json";

///粉丝列表接口  1.2
static NSString *apiGetFans = @"app/my/follow/getMyFansUserList.json";

///新建意见反馈接口
static NSString *apiNewFeed = @"app/feedback/newFeedback.json";
///删除随手拍
static NSString *apiDelSui = @"app/youchi/delReadilyBeat.json";
///绑定手机号，获取验证码1.2
static NSString *apiAccessGetSmsCode = @"app/access/sms/getSmsCodeByEmailAndPhone.json";


///绑定手机号，获取验证码1.2
static NSString *apiValidatePhone = @"app/my/info/saveUserPhone.json";




#pragma mark--------公共接口
///资讯收藏和取消收藏1.2
static NSString *apiFavoriteNews = @"app/common/favorite/newsFavoriteAction.json";
///秘籍收藏和取消收藏1.2
static NSString *apiFavoriteCheats = @"app/common/favorite/cheatsFavoriteAction.json";

///根据userId获取用户信息接口1.2        
static NSString *apiGetOtherDetailes = @"app/common/userinfo/getDetailesByUserId.json";
///当前用户关注的人的秘籍列表,根据cheatsType来区分 随手拍和果单秘籍1.2
static NSString *apiGetFollowUserCheats = @"app/eater/follow/getFollowUserCheats.json";

///用户随手拍列表1.2
static NSString *apiGetYouchiList =@"app/common/userinfo/getYouchiListByUserId.json";
///用户单秘籍列表1.2
static NSString *apiGetRecipeList =@"app/common/userinfo/getRecipeListByUserId.json";


///生成邀请链接接口
//static NSString *apiGGInviteUrl = @"app/invite/createInviteUrl.json";

///新建意见反馈接口1.2
static NSString *apiGGFeedback = @"app/feedback/newFeedback.json";

///提交投诉/举报的接口  1.2
static NSString *apiGGSaveComplaint = @"app/complaint/saveComplaint.json";


#endif
