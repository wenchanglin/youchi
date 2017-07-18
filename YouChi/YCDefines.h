//
//  YCDefines.h
//  YouChi
//
//  Created by sam on 15/5/24.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef YouChi_YCDefines_h
#define YouChi_YCDefines_h

///推送类型

typedef NS_ENUM(NSUInteger, YCMessageType) {
    YCMessageTypeURL = 0,//链接
    YCMessageTypeYONGHU ,//用户
    YCMessageTypeMIJI ,//果单
    YCMessageTypeSUISHOUPAI ,//食材
    YCMessageTypeSHIPIN ,//商品
    YCMessageTypeSHANGPIN ,//吃货营
    YCMessageTypeZIXUN ,//资讯
    YCMessageTypeDINGDAN ,//视频
    YCMessageTypeCOUPON ,//优惠券
    YCMessageTypeCUIKUAN ,//催款
};

typedef NS_ENUM(NSUInteger, YCOriginalType) {
    YCOriginalTypeUrl = 0,//链接
    YCOriginalTypeUser ,//用户
    YCOriginalTypeRecipe ,//果单
    YCOriginalTypeMaterial ,//食材
    YCOriginalTypeItem ,//商品
    YCOriginalTypeYouChi ,//吃货营
    YCOriginalTypeNews ,//资讯
    YCOriginalTypeVideo ,//视频
    YCOriginalTypeGroup = 9,// 团拼
};

typedef NS_ENUM(NSUInteger, YCCheatsType) {
    YCCheatsTypeYouChi = 1,///随手拍
    YCCheatsTypeRecipe = 2,///秘籍
    YCCheatsTypeAd = 3,///广告
    YCCheatsTypeUserList = 4,///推荐
    YCCheatsTypeVideo = 5,///视频
    YCCheatsTypeNews = 6,///资讯
    YCCheatsTypeGoods = 7, /// 商品
    YCCheatsTypeAddress = 8, /// 地址
};

typedef NS_ENUM(NSUInteger, YCMoreLikeType) {
    YCMoreLikeTypeYouChi = 1,///随手拍
    YCMoreLikeTypeRecipe = 2,///秘籍
    YCMoreLikeTypeVideo = 3,///视频
};

typedef NS_ENUM(NSUInteger, YCShareType) {
    YCShareTypeNone = 0 ,
    YCShareTypeRecipe = 1,///秘籍
    YCShareTypeNews = 2,///资讯
    YCShareTypeVideo = 3,///视频
    YCYCShareTypeItem = 4,//商品
    YCShareTypeYouChi = 5,///随手拍

};


/// 订单状态
typedef NS_ENUM(NSUInteger, YCGroupPayState) {
    YCGroupPayStateNotPay = 0,/// 他人未付款
    YCGroupPayStateHadPay,    /// 已付款
    YCGroupPayStateSelfNotPay,    /// 自己未付款 isQtyExist
    YCGroupPayStateCancel,    /// 订单已取消
    YCGroupPayStateisQtyExist, /// 已下架
};



    

static NSString  *const header = @"h";
static NSString  *const headerC = @"h1";
static NSString  *const headerC2 = @"h2";
static NSString  *const headerC3 = @"h3";
static NSString  *const headerC4 = @"h4";
static NSString  *const headerC5 = @"h5";
static NSString  *const footerC = @"f";


static NSString  *const cell0 = @"c0";
static NSString  *const cell00 = @"c00";

static NSString  *const cell1 = @"c1";
static NSString  *const cell1_0 = @"c1_0";
static NSString  *const cell1_1 = @"c1_1";
static NSString  *const cell1_2 = @"c1_2";
static NSString  *const cell1_3 = @"c1_3";

static NSString  *const cell2 = @"c2";
static NSString  *const cell2_1 = @"c2_1";

static NSString  *const cell3 = @"c3";
static NSString  *const cell3_1 = @"c3_1";
static NSString  *const cell3_0 = @"c3_0";

static NSString  *const cell4 = @"c4";
static NSString  *const cell4_1 = @"c4_1";

static NSString  *const cell5 = @"c5";
static NSString  *const cell6 = @"c6";
static NSString  *const cell7 = @"c7";
static NSString  *const cell8 = @"c8";
static NSString  *const cell8_0 = @"c8_0";
static NSString  *const cell9 = @"c9";
static NSString  *const cell9_0 = @"c9_0";


static NSString  *const cellInset = @"cinset";
static NSString  *const cellInset0 = @"cinset0";
static NSString  *const cellInset1 = @"cinset1";

static NSString  *const cell10 = @"c10";
static NSString  *const cell11 = @"c11";
static NSString  *const cell12 = @"c12";
static NSString  *const cell12_0 = @"c12_0";
static NSString  *const cell13 = @"c13";
static NSString  *const cell14 = @"c14";
static NSString  *const cell15 = @"c15";
static NSString  *const cell16 = @"c16";
static NSString  *const cell17 = @"c17";
static NSString  *const cell18 = @"c18";

static NSString *const kApiVersion = @"apiVersion";
static NSString *const loginId = @"loginId";
static NSString *const kClientId = @"clientId";
static NSString *const kSign = @"sign";
static NSString *const kTimeStamp = @"timestamp";
static NSString *const kClientType = @"clientType";
static NSString *const kClientVersion = @"clientVersion";
static NSString *const kClientOsVersion = @"clientOsVersion";

static NSString *const error_domain_weixin = @"error_domain_weixin";
static NSString *const error_domain_aliplay = @"error_domain_aliplay";

#define share_click @"share_click"

#define shopHome_banner_click @"shopHome_banner_click"
#define shopHome_action_click @"shopHome_action_click"
#define shopHome_item_click @"shopHome_item_click"

#define shopItem_favorite_click @"shopItem_favorite_click"
#define shopItem_viewCart_click @"shopItem_viewCart_click"
#define shopItem_buy_click @"shopItem_buy_click"
#define shopItem_addCart_click @"shopItem_addCart_click"


//0 内网
//1 外网
//2 测试

//appstore打包前注意：1，切换外网运行一遍，检查滤镜能否用。2，将build版本末尾号加1，3，检查infoPlist的CFBundleDisplayName是否为“友吃”，4，检查bundleId是否为“com.QuicklyANT.YouChi” 5，注释#define NSLog(...)
/*
 友吃2.0的外网请求地址
	吃货营、发现、我的这几个模块的地址:
 http://api1-2.youchi365.com/
	吃货营、发现、我的这几个模块的图片地址:
 http://img.youchi365.com/
	新商城模块的API地址(下面的是测试而已，上线之后不是用这个地址了):
 http://121.40.179.44:8080
	新商场模块的图片地址:
 http://shopimage.youchi365.com/
 06cd078ab4f6eb7d0d4f9feb061390b7817639c4
 
 static NSString * host = @"http://192.168.31.195:8080/youchi_refactor/";
 */
#ifndef SETTING
#define SETTING 1
#endif

#undef SETTING
#define SETTING 1

#if DEBUG == 0
#define NSLog(...)
#endif

#if SETTING == 0


//内网
//static NSString * youchi_shop = @"http://192.168.0.239:8088/shop/";
static NSString * youchi_shop = @"http://192.168.0.239:8088/shop/";
//static NSString * host = @"http://192.168.31.195:8080/youchi_refactor/";
static NSString * host = @"http://192.168.31.195:8084/youchi/";

//static NSString * host = @"http://192.168.31.195:8080/shop/";

static NSString * hostImage = @"http://shopimage.youchi365.com/";

static NSString * html5 = @"http://192.168.0.60:8080/youchi/shop/youmi/index.html";
static NSString * html_share = @"http://192.168.0.60:8080/youchi/shop/youmi/";


#elif SETTING == 1

//外网，正式上线地址

//#define NSLog(...)

//static NSString * youchi_shop = @"http://121.41.35.184/";// 测试外网

static NSString * youchi_shop = @"http://dyysshop.youchi365.com/";// 德意云商版本的商城 支付宝和微信支付都是德意云商的
static NSString * host = @"http://api1-2.youchi365.com/"; // 友吃1.2版本的API接口地址  发现、吃货营、消息通知等接口
static NSString * hostImage = @"http://img.youchi365.com/"; // 友吃1.2版本的图片请求地址
static NSString * html5 = @"http://api1-2.youchi365.com/shop/youmi/index.html"; // 友吃1.2版本的商城首页 已废弃
static NSString * html_share = @"http://api1-2.youchi365.com/shop/youmi/"; // 友吃1.2版本的商城分享地址


#elif SETTING == 2
//测试
static NSString * host = @"http://shop2.youchi365.com/";
static NSString * hostImage = //@"http://img.youchi365.com/";
@"http://shopimage.youchi365.com/";
static NSString * html5 = @"http://121.40.32.58/shop/youmi/index.html";
static NSString * html_share = @"http://121.40.32.58/shop/youmi/";

#endif

static NSString *const html_home = @"http://www.youchi365.com/mobileOfficial/index.html?share=1";
//static NSString *url_tuanpin = @"http://api1-2.youchi365.com/shop/youmi/团拼.html";
static NSString *url_tuanpin = @"https://mp.weixin.qq.com/s?__biz=MzAwMDE4MjkzNA==&mid=502880423&idx=1&sn=31c56e9152bc24713de3cb6bd4c11084&scene=1&srcid=0621wiAVhaVsE2Q0lTnlYlof&pass_ticket=2kEnw4LEX4u4iiOjAAWqyHIjlV6AJsjzFyFsp33pZOrUt5IQPyD0pImbtCX2Jd7S#rd";
static NSString *url_buy_baozhang = @"http://api1-2.youchi365.com/shop/youmi/购买协议.html";
static NSString *url_jiesuan = @"http://api1-2.youchi365.com/shop/youmi/结算规则.html";

static NSString *const domain = @"domain";
static NSString *const kCode = @"code";
static NSString *const kResult = @"result";
//TODO:开发

static NSString *const kMsg = @"msg";
static NSString *const kLoginId = @"loginId";
static NSString *const kPassword = @"password";
static NSString *const kOldPassword = @"oldPassword";
static NSString *const kSmsCode = @"smsCode";
static NSString *const kToken = @"token";
static NSString *const kPageNo = @"pageNo";
static NSString *const kPageSize = @"pageSize";
static NSString *const kPageInfo = @"pageInfo";
static NSString *const kFirstId = @"firstId";
static NSString *const kActionType = @"actionType";
static NSString *const kEmail = @"email";
static NSString *const kSex = @"sex";
static NSString *const kNickName = @"nickName";
static NSString *const kBirthDay = @"birthDay";
static NSString *const kSignature = @"signature";
static NSString *const kTitle = @"title";
static NSString *const kDescription = @"description";
static NSString *const kFollowUserId = @"followUserId";
static NSString *const kOriginalType = @"originalType";
static NSString *const kActionId = @"actionId";
static NSString *const kRecipeId = @"recipeId";
static NSString *const kContent = @"content";

static NSString *const YCClickNotification = @"YCClickNotification";
static NSString *const YCPhotoNotification = @"YCPhotoNotification";
static NSString *const YCReceivePushNotification = @"YCPushNotification";
static NSString *const YCUpdataMyCarList = @"YCUpdataMyCarList";
static NSString *const YCPayOrderSucessNotification = @"YCPayOrderSucessNotification";
static NSString *const YCAddCartItemNotification = @"YCAddCartItemNotification";
static NSString *YCYouChiShopNewsTapNotification = @"YCYouChiShopNewsTapNotification";

static NSString *const YCLastCouponCreatDate = @"YCLastCouponCreatDate";
static NSString *const YCLastOrderDate = @"YCLastOrderDate";
static NSString *const YCCouponStatueSave = @"YCCouponStatusSave";
static NSString *const YCOrderStatueSave = @"YCOrderStatusSave";
static NSString *const YCBecomeActive = @"YCBecomeActive";

static NSString *YCPayGroupPurchaseVCNotification = @"YCPayGroupPurchaseVCNotification";


#define UMAppKey @"5551a06367e58e106b006cf7"
/**分析测试key*/
#define UManalyseAppKey @"559244b467e58e5ad8002f70"

#define UMWeiboKey @"wb3690945947"
#define UMWeiboUmKey @"sina.5551a06367e58e106b006cf7"

#define UMWeixinKey WX_APP_ID
#define UMWeixinSecret @"e96fe03fa988ab6f5fbf11f9449ac2ff"

#define UMQQKey @"1104602141"
#define UMQQSecret @"02rGpxqwZkox0C5T"

#define UMQZoneKey @"tencent1104602141"

#define GTAppId @"K9QKJJOBNj56AgUgzz8XV"
#define GTAppKey @"bGbEh1FHLOALBKbf23l5F3"
#define GTAppSecret @"i1k6PLxFlT73d3LogqWWR7"

#define PGYAppId @"c9efcd69bfd1bda79a0f8f1e094ccc3e"

#define APP_ID @"1011075754"  

///客服电话
#define CustomerService @"4008862683"
#define AboutYouChi @"020-81245266 "

/// 360相机key
//CESHI
#if SETTING != 1
//*
#define Camera360Key @"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"
//*/

#else
//FABU
#define Camera360Key @"hk5qVtkovqMu/jiSM+pHuVCwOkiDn5PppbAr7hb05Of9Jcd4+SXVsDetWTQUE9P1gtGmTkjzaWuj9fBGNd+kkUn7Jxedrrdetu3j+WsY8nJGaltWSCu4OZH/7zeX6wxw6iziyleupBAHVjfXbnPg/ijMik3SKP2X8OzbpU0CvSWVUY4zj8kToc5lEk/N2yUNmHZgjsWiKjkDGcH57gySJufDET24MFp1+6UxKAgYHP/EP6M86/Y1vJn382r4bq8kY0kXhqCLnopJigVl+KAmvHiYo6GRLei5ZgrsA3255dGuWem6INe+6b2INlX/OOQD0MRqOmGLxH7mgXlVe6+409eyOUqXIhrZdnxhPK8B9f0FSJg+9XYNDuGnAXRsMYfDe8Dte8AePZslBFrd9kMRgnydP8pAefL/QmPly+XDm2qtox10K9c4Q7ekbWb59+xnOhGglHBNedEDp6DxMdQoKw49GWzx2BKr/dcwvkpGEvuM3iEZ4xnaCVxTh66SGqrjTNC9NnHjO7QNwBDK6hoPCrxVI2S68696lyL+uHbrbfJbgyLugk6RskJ11KwuoPlX8S5BS6caZ2p5Jd2XgI3Wk6Pdh3YM6/48q5Khab4rTo6R4wveRnVA6ppb5DULEm3SIvsEyxdXL/+ee5Bk7VI4Rf0SYtJaGAOG22EgKBuD1LoVgZRwIsXbK2ropowVEEq0Fdi7s+U+LY/amPBUPukEeVITbR6znI2gT3eIcWL27Zt7h3pqHE2PoxpKiMk5Ps+GQWxC3EgTsYgjoAhODzKOi3yg063JGOHKgiMlGVG17Gy1n3ThoFyR1jQXAWjcaxcNxhiPwq5OEJ7KaOXiAjIeey6XpgNtoU+O7bS1hJIkfWPV5A9K2rdHhcKPIf5rAtib+8Jta1/Jpg+ElDjJlVmQjDuR+W5z44NVSy8nb6LJR8//0YmAk3eWwQJG6fAiYHT+1M5NQRrqvzUbEZzKDbHUu2uyKwUntpdQmXlwDqKYzJeAE5jYT7p5h+vXCsjjnCDvvgZkSX/B61GpqWfKva/md6rXdnlmPpg8l0U2Tcv2sSDKlsbR8NIrSZpwbzSPQj3tFIvNqWi2hrAgS4x6ElQa34MsbDwaFUcxC10QTBaW9OtvDhD4vHd8FF6CSlj+oG90SY2BwT8zh5gQgHAcJyWgwNp8xJAfnFigC7QHCHWHncj02mgsrhwKFRAjBZo7NIO/zTUqzkJzuSP9IdpiWI1ix/W2bLO+BxOxr5Eu5Cx1KQx/JnBWsbfRaYS3ZXAGGWSde7qTVnBPEdoAd5ETg2uOItf/LIBsS76NTXobxa67Qt59Xkst0JX279DHtw4IgH48eaas8JpxXEfV1NDhH+ecFFgU90F5DVh6Kd1Jm/T9vREKJND9BxbCqhfVjAlPEX4pP/HenoYwgrRQ6W3yw3v+RcTK2YLazpPcT5+i4D3nYLw1BlJUiRdVkTtgdvzu810Wjzgi4wPghOgalGBTXM0/ggK1R/qG5WOX+qvzDX2Fyq6rjQWVQL8iJ5NKhsCpTjq+S/g7eoA7r3FqBYXVZ218gHtm40gUgfJsiybspSCxqf9jaLsJP0kpj1oPgsCJuCyYiSZiCBY872x+0h2ugq6j1aJd5hL0XCkFjwMf2kb5zqyBiRaaoxYRAzE77isFxbJu4h4XZxKrPTj0/ixqx4oU3yp24JE2WPH9N/CkeHsfGXr/yTcQ/Av+aBeF/ub+kLYo0vhQXlT0VPGanUfeqLuMoA/FZU+RpqddAYsy4kcVHYDBrQast/1scsQd7/fMEzQ7lF3ZLAcA2XH0jZTpmdlrg7i2JUyCl8+BFFeYGcA3ghEJitaRiIgJONTyD1icgNxE4ofWv22Iahj+K48FoSY6sohFW5bt1We3f29Jwt11zcfJLow4hzYeZecQhQB/Oxq3lE36kf67vvElx6Df3XqcnjFwYydx5iG5pBX2ClyitbPy6ZbrlZhC2KwKpeBpdsjwx6HNNyjTwkIiW/hRI4xroqqefRNB7yAUBQud63pNEjKNQ394SWT5Lark5MHNhzD56SoNc8wqA6ukSYG0lz+VMATNqcNyg4FrxNdLn7opxznO8hCL7vhEZv6J1fr04ntzyE2VPbWBj3RCoabsyKGjcddPveoIVm7YmIByFzoFqcbHtk4Q3v/crZwCFlADNazMqRDql2Sr7ucDgNr6tL7ziiqH7ikYJQNHxzqLd9d7EHd5eYgFnmRPJzs5izHnAEatCZNm1osG5RGE+Sq9A0bueEck+eqqw/3KtXdaP4X/rybXyO0yPwQJz1QiJCumwwaLPOP7Ff6rvY+HjDEVjicmJM8Vleob6zqALz4u92PksMN8nZpGGUt1xZuTgFep1t/672dI5Kddm89LcKtrXsuavLBcKSYHUQDr7ObYPgqa0JVZbf9t9j/VbsQ8aCmIr8ih3xFD00JcIWJdlMH2JLi5DB2KF9YXKsRKr17YxQ96NSFyNMvYbSOXz8wx7KgGeabzngmgEjIRsPe2b1htkRw5ua0AjtmcGcJepvHxXl3TeiWJdGqaB2zrBEm6IE7CjYEDOtbFjFL+cqpMi59q5ItV59f18QoFqlxo9zL8eJQvhzgxQxeevrcTuD24ssdYpp34/qRX0aAsXcTofeunGdSnSFK4JvtFbgl9NYA33kOGY3U55AFeRJl6aAzBBA2wk2AGf5TTZktV0Er4QlVIZceCinCMoMQbL+LL7uAybQOu8e1pxzUH6/86w3m2WJ0b05oJzTU/U6hcVpqp6xaANsTgw4KONUAycoQNA2s90Z4lNPmonylKNGGRyV6/cBNhSIPqJsuQtHOxUbggJvc6UoWmIyG9igkowgiwEBZUCkRtpWUBBGt4mrQzNay3N+113dsvuspHTMiEE590sKGxV7uWaLFXFqoaKfwMTsJcEBap+kmq4KI7DgugLhQSN2dLVkoaZuwfBrvzRj/m/FvXvoAiafc4+5fMMeRDotq8n/wqmTNOAGGE9ACjNkrrYlvt/7aViv1C169BDug4mLuzWwHM2lWwQATM6LYoFjwJttGXWdCK3qFTkwDNzIhLAozQGghQOY8/ooz0GQ1QEgXtPWJ2phBXQ7X2Oy43gzKbTF2WMLtv1zN4Dp+28VAJbTTvv6/Ra3tfygiVZEJ/0Am+nq2wwKeSbkh+Dt87BlZzlz6sH7f1SFmWmdmSterD7OHEMUcEeZhiREYAKIQy7elrfAOSVLuS4mWg+0fKYN4++GlTtNXl+Dy5K9wj/mqA0EMrDxlsM51ok5g5o1OuRwl5T4yW2aT/xg1vhEc8dBriNzJvbIod12CZ2QtEu2NYafFcQr+/mwdhVtHv+rMWf1Q6jdVJPRBH4MUksJY+fx7ZasTTp4T8z4vaVHMp8N3VAZYgGvbq33SRR4cwRXEGjmNTuccMjm0yS9u8gchDwxyty6w8aqVqxQnxK/GmemtPqgpphpb4WSEB1jEH76b9gYmJkvT5b2jTyHjY3hl6gW/ckDb/k4nNLLs8iDVA6kIL29LCcHNVQ3WGl4U2YU9oZ/a0YjD+00CNhZCWPw2OmOLlgO7EgbfTWR+Jti7Q7tURDoq59MM4VM2IZNsUdapn31wirUpnree6Y5hDj3ahnYENVgl1XLDUVfR4XR1vBlCrw6GdNJnwKTMh4FW1+FxAXQQ22nXESg6tz1UPIIozGSJUHVvhlk0Q5PsQm/EhlyNm+DuuDvfovbnpG6X8k1sf0L48kVFjPlJBcXHGZHDDSqmkKhyCOl7sy4Pv7d80XVGY+BmK7c1I6L/4w5dgGCn6L2kegt0LDQcgp5fnhCp41QFh5u5+qLkiD/ODsTPGR7bJb/VCyC0yLdJEcFyRgjACKZfDZ2iJ65XWRgIg2fLywkQynmCx/EFooYdJXjCpGoj02C5182zsb8BaFG3XUJKsGSq1E5/DwiOuQYQSknG699KPSFPBELlfYXaMAq3uItOpGebZMtZYqbTNyg8SlSS9Nw3lsZC3G2QQaLs2I0Tp+L3ni66l/3PuqKf1AM6TRRMzTNx395nGgkRqEiaBbyEoLmAtI7xvMdb4uEX0GQOvWVW5MYVfUwLiJoujrNO68xDLRSijH52s5ssk9HdoLNBkPZsvDbzzfCEspXfyWIUXPu2vsjV/i418FsPCQ9z1lfNuqtvOle/BeJ+dUmqVQPI/VXjafVBIVXTsFtGVIZPFZXTl/6EDpzB/iyxN8e2+0C8l9r465NkHc2L2gzAX43nFH/3d/GWMUnCjHAS4izs7JCXTTxK9QiCydXAVUo5z7En3dQ75Sq8IfPHMF61J9L0A0PKs9IakueLG9NU8qMhTFuJGX+s3ESdxcQtfDJ4wClADSw9FvePM50DUQeW3KGPXq7s3XoWn1R6D17hse5ARwQlkEO1Lf7graILHKoLeYwWXwW6VwUn1D9pptVo41u6a2PUuB+hC3rlSHOvA+B6tKNUqMVJSPF8cLnTdzhkjKVMx2SavSRNRPhcnYQfVpFggD/sIRvn1Ki/HrRQE5ryR7BybsywEd6mtCnjjh4EWKmmnl/rzzq60uUfMW4Ksso48k0Zfu7GOG3OpRppQwjJK7Reu85J/Kn8HftxcGHJ0ut1V8ER/VYqdi46V329TrRWPGFftKr9PI0yV32yBy+ROV9s7PG/J2w7RgEIAMPDKpUTxIR2O2jAsMbCpfkMpZ5+hIJ4vepLn8I2m9GvjHtFbDBBehS6hGSC0qL0j1GQiavFDmCXzgmidPJEDggZm8omOj/qmCTSshb6b59pQwnBt5JX1dgE1+/mp8FZpjq46aGGhQ8cW3pBrBvhmO5RI3uE8PBZJPGf5EaeYwuZAPxUFdSKNUZ5oXu6blDK9XCzsEHbJM8GkVifuL/rc9Jn2YSZFAfHjm4sEMtgla51IHE2WfI7WaswbO35OIlk5fzIzcSoxnMzMT5fvDc3izwUX9sZQq4S4/3UqsgcfATLkdgYGIL+3xJmJjvjFgzLD1fwFVraL/KCpfPpIAf3L1dz7Tga6vJbqOZ1fw860vEMdbqMeV65eMLHFLK2PHQpsVb2ca2B1gIyjTRN+Ag0dWacjrHsPT63Rik6oBRRhBGfNq1Sef/94WYEltTo/xS8Bymasjo8+f8za9ES50tCpBwo+O02+UCjP8DQQXoEPHLcdGKf7TudXX/BmL0vkg/6CIIwUx72zDtW8gdaq1s98AzivK3JujGemkUO7+yOIEYlCpi9X7l1Nw/UVlmBcN8GAXEu0dRTrN4rdkTun+ay+xoR7hns3IsXDtqVT7BrjGw9q5wfqSxaOtHM06WDODH5Tkd2f+eOlF1DsBnGcSHlrISgnpOcm0wfkXYkeK3GvRLRJJfV1kK6Ku8i2bUY4uqPrNLIijPwng4ddmxfO9MkrniYdM+KbhhbI+Xr8vnAKX0a1qN/Db/PAcIi4x1Rt1e5wOACMGnheyxZc2e1Z9ZPN4vY2j5208J9KeEDl44jtScN9AIKQj+rPHfSUdnRmKn6eIJdMVRTZkblOG+FCBCnbIBy7JIgD3ah1AW0zAKplwXb3pqgsYCJtCa7RoRGVJbESf40sI2uagABBCedCBCBHSFPEIEVy4gKg0w/brqWYj08XzvbB0z+qN0YEFLk="
#endif

#define TCCloudKey @"AKIDCd3zdFCQz1RUSZndPdOYXaLsW3LCdm0q"

///appid需要在info.url上设置一下
#define WX_APP_ID @"wxd9879eef88e8760d"
#define WX_MCH_ID @"1335074501"

///暂时不需要
///支付结果回调页面
#define WX_NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
///获取服务器端支付数据地址（商户自定义）
#define WX_SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

#define WX_API_KEY @"e3245d7804ba4d185470bdf225b6aede"

///阿里支付
/*
将私钥转成PKCS8替换一下原私钥即可
1、生成私钥pem,  执行命令openssl genrsa -out rsa_private_key.pem 1024
2、生成公钥,执行命令openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
 */
#define ALIPAY_PARTNER @"2088221618671060"
#define ALIPAY_PRIVATE @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMutwnTpsJGsSIYegLH5yyJZyr+MM+A9kH+ndqYMNpeGG3JKKf9wgxDKB/FjUN/KQ9X8AoEg6DO4YwrwaKnRoQcoZINfDFyVhObvrooVFcfYz2DcL14ZXAQGMXQCZorNs21KAVDNvY9fomw1njwwxa4KZcYRStLmDq+OcIXHljy/AgMBAAECgYEAri6k87K963Y4d2oyiQGkNHYxq2nNG2HK50BheVNMhHyNkEnYbLjdfUgpTseubBPfu2nPAnsP2NtA6CP8fe3mFF6KakioD+DBUjNH+e5m9TcJgLgDW1/iSyq7MFSauMFnS9WnPNyBDvBF4U9jXMJHPfFt4QZKYUsZSywEbuKgDHECQQD70dDoT2/JZP5uGVE1Be3dHDzuEDlDrvDrccMqVkY0QXyqSEx2WcjljjbU2ljqNSrvw/39mjwAIDPP82xCFSyTAkEAzw9auRYjbqMYv0qZXHHgJktthIRBu7cEqnuZpCImFjTT8Za/dkSB7aDXDLeEkjIynlZP9JPXpuUb+OI2/MC2pQJAeDOwJ6P7dUPLG1zkYY4B+8CF6RE/dGpmP8ze3y+tdTYpPtMiBIBZIBJhY/sR5EIay7ZfYBWmPF0ivkmwzF51FwJBAIdTMafloCKe1X2v86tHgYeFpH4HMi7M3m/NeAydhObef+ZU760L+R6lD+dvyWUDCbISFw9x0G9zLWTr86QdD0ECQGi76VZms45Gtyy8n4h5m07I+dTyMQoG/xicotOMktoImy/hXJwDw7RgzrqSmw5TUcs2PENoC1remetUoSbYW3Y="

///上传图片到阿里去的令牌
#define  ALI_endpoint @"oss-cn-hangzhou.aliyuncs.com"
#define  ALI_accessKeyId  @"mVDpDinK3GgzkF4b"
#define  ALI_accessKeySecret  @"GEPQ4Tm5u7QW6VddexNQfrANsLcAie"
#define  ALI_bucket  @"youchishop"
#define  ALI_bucket_suishoupai  @"youchi"

///友盟推送
#define UM_push_app_key @"559244b467e58e5ad8002f70"
#define UM_push_app_secret @"kwhzyh1vgeysgeegteapitxr79weggoo"
#endif
