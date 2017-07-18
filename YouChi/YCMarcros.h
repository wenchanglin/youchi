//
//  OFMarcros.h
//  OrderingFood
//
//  Created by Mallgo on 15-3-27.
//  Copyright (c) 2015年 mall-go. All rights reserved.
//


#ifndef OrderingFood_OFMarcros_h
#define OrderingFood_OFMarcros_h
#import <EDColor/EDColor.h>



/**
 * GCD线程
 * BackgroundThreadPerformBlock 子线程运行block
 * MainThreadPerformBlock 主线程运行block
 * DelayMainThreadPerformBlock 主线程中延时secs秒后运行block
 */
#define BackgroundThreadPerformBlock(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define MainThreadPerformBlock(block) dispatch_async(dispatch_get_main_queue(),block)

#define DelayMainThreadPerformBlock(block,secs) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), block)


/*
 屏幕宽度
 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/*
 KSize            屏幕的size
 KRect            屏幕的bounds
 KSectionHeight   区头的高度
 */
#define KSize [UIScreen mainScreen].bounds.size
#define KRect [UIScreen mainScreen].bounds
#define KSectionHeight 32.f



#define PROPERTY_STRONG @property (nonatomic, strong)
#define PROPERTY_ASSIGN @property (nonatomic, assign)
#define PROPERTY_STRONG_READONLY @property (nonatomic, strong,readonly)
#define PROPERTY_ASSIGN_REAODNLY @property (nonatomic, assign,readonly)

#define DAMAI_RATIO(_width_,_height_) (_width_/750*_height_)
#define DAMAI_RATIO_2(_width0_,_width1_,_height1_) (_width0_/_width1_*_height1_)
#define DAMAI_RATIO_3(_width0_,_width_height_ratio_) (_width0_*_width_height_ratio_)

/*
 <##>
 <##>
 */
#define KP(_keyPath_) @keypath(_keyPath_)
#define CK(_keyPath_) @collectionKeypath(_keyPath_)

/*
 弱引用，强引用
 */
#define WSELF @weakify(self)
#define SSELF @strongify(self)

#define PROPERTY_STRONG_VM(_cls_) @property (nonatomic,strong) _cls_ *viewModel
#define PROPERTY_STRONG_M(_cls_) @property (nonatomic,strong) _cls_ *model
#define SYNTHESIZE_VM @synthesize viewModel
#define SYNTHESIZE_M @synthesize model
/*
 将方法名转换字符串
 */
#define SEL(_str_) NSStringFromSelector(@selector(_str_))

#define VAR_STR(_str_) @#_str_
/*
 <##>
 <##>
 */
#define error(e) [NSError errorWithDomain:@"domain" code:0 userInfo:@{NSLocalizedDescriptionKey:e?:@""}]
//#define error_weixin(e) [NSError errorWithDomain:@"domain" code:0 userInfo:@{NSLocalizedDescriptionKey:e?:@""}]
/// 友吃2.0版本图片加载地址
#define IMAGE_SHOP(_url_) ([NSURL URLWithString:[_url_.absoluteString stringByReplacingOccurrencesOfString:_url_.host withString:@"shopimage.youchi365.com"]])

#define IMAGE_HOST_SHOP(s) (id)[NSString stringWithFormat:@"http://shopimage.youchi365.com/%@",s]
#define IMAGE_HOST_SHOP_(s) (id)[NSString stringWithFormat:@"http://shopimage.youchi365.com%@",s]
#define IMAGE_HOST_NOT_SHOP(s) (id)[NSString stringWithFormat:@"http://img.youchi365.com/%@",s]
#define IMAGE_HOST_NOT_SHOP_(s) (id)[NSString stringWithFormat:@"http://img.youchi365.com%@",s]
#define IMAGE_HOST_(s,h,w) (id)[NSString stringWithFormat:@"http://shopimage.youchi365.com/%@%@%dh_%dw_1e",s,@"@",(int)h,(int)w]
#define IMAGE_HOST_size(s,size) IMAGE_HOST_(s,size.height,size.width)

#define IMAGE_HOST_1_2(s) (id)[NSString stringWithFormat:@"http://img1-2.youchi365.com/%@",s]
#define IMAGE_HOST_1_2_WW(s) (id)[NSString stringWithFormat:@"http://img1-2.youchi365.com/%@%@%.fw",s,@"@",kScreenWidth]
#define IMAGE_HOST_1_2_H_W(s,h,w) (id)[NSString stringWithFormat:@"http://img1-2.youchi365.com/%@%@%dh_%dw_1e",s,@"@",(int)h,(int)w]

#define IMAGE_HOST_1_2_get(s) (id)[NSString stringWithFormat:@"http://img1-2get.youchi365.com/%@@0o_0l_400w_90q.src",s]

#define IMAGE_MEDIUM(s) [s stringByReplacingCharactersInRange:[s rangeOfString:@"small"] withString:@"medium"]
#define IMAGE_LARGE(s) [s stringByReplacingCharactersInRange:[s rangeOfString:@"small"] withString:@"large"]

#define NSURL_URLWithString(_url_) [NSURL URLWithString:_url_]

#define completeUrlWithString(_url_) [NSURL URLWithString:[NSString stringWithFormat:@"http://shopimage.youchi365.com/%@",_url_]]

#define NSMAString NSMutableAttributedString
#define NSMAString_initWithString(_title_) [[NSMutableAttributedString alloc]initWithString:_title_];
#define NSMAString_initWithAString(_title_) [[NSMutableAttributedString alloc]initWithAttributedString:_title_];







/*
 1:PLACE_HOLDER  默认背景图片
 2:AVATAR        默认头像
 3:AVATAR_LITTLE 默认加载图
 4:APP_ICON      appIcon图标
 */
#define PLACE_HOLDER [UIImage imageNamed:@"loading"]
#define AVATAR [UIImage imageNamed:@"默认头像"]
#define AVATAR_LITTLE [UIImage imageNamed:@"加载图"]
#define APP_ICON [UIImage imageNamed:@"appIcon"]
/*
 图片加载
 */
#define IMAGE(_name_) [UIImage imageNamed:_name_]
/*
 判断是加载男的还是女的图片
 */
#define SEX_IMAGE(_sex_) _sex_?IMAGE(@"iconfont-nan"):IMAGE(@"iconfont-nv")
/*
 判断是选择哪个颜色
 */
#define KSelected(_SEL_) _SEL_?KBGCColor(@"535353"):KBGCColor(@"dab96a")
/*
 color_yellow        黄色
 KBtnSelecotColor    按钮选中的颜色
 KSelfBJColor        self的背景颜色
 color_Line          线条颜色
 color_d09356        新版字体颜色  showmMidMessage
 */
#define color_yellow KBGCColor(@"#be8f59")
#define KBtnSelecotColor KBGCColor(@"#be8f59")
#define KSelfBJColor KBGCColor(@"#404040")
#define KBGCColor(color) [UIColor colorWithHexString:color]
#define color_Line KBGCColor(@"#c8c7cc")

#define color_d09356 KBGCColor(@"#d09356")
#define color_btnBakColor KBGCColor(@"#dad96a")
#define color_btnGold KBGCColor(@"#DEC079")
#define color_title KBGCColor(@"#d09356")

#define color_light_text KBGCColor(@"#333333")
/*
 KFont        字体大小
 KFontBold    粗体大小  [UIFont boldSystemFontOfSize:13]
 */
#define KFont(font) [UIFont systemFontOfSize:font]
#define KFontb(font) [UIFont boldSystemFontOfSize:font]
#define KFontBold(font) [UIFont fontWithName:@"Helvetica-Bold" size:font]

/*
 判断是否关注
 */
#define KSELTile(_SEL_) _SEL_?@"已关注":@"关注"
/*
 条件提示框
 */
#define CHECK(_condition_,_error_) if (_condition_) {\
    [self showmMidMessage:_error_];\
    return;\
}\

#define CHECK_IF_YES(_condition_,_error_) if (!_condition_) {\
[self showmMidMessage:_error_];\
return;\
}\

#define CHECKMidMessage(_condition_,_error_) if (_condition_) {\
     [self showmMidMessage:_error_];\
     return;\
}\

#define UIVIEW_DEBUG(_VIEW_) _VIEW_.borderColor = [UIColor blackColor];\
_VIEW_.borderWidth = 1;





/*
<##>
<##>
*/
#define CHECK_SIGNAL(_condition_,_error_)if (_condition_) {\
    return [RACSignal errorString:_error_];\
}\

/*
 <##>
 <##>
 */
#define QUALITY 1.0

#define kGolderRatio 0.6180339887


/*
 根据tag值获取控件
 */
#define VIEW(_n_)  (id)[self viewWithTag:_n_]


/*
 kFontYouChiTitle
 kFontYouChiContent
 kHeightYouChiMiniContent
 */
#define kFontYouChiTitle 16
#define kFontYouChiContent 14
#define kHeightYouChiMiniContent 75
/*
 图片比例
 */
#define kRatioImage 0.75f
/*
 内容大小
 */
#define kFontComment 11.f


/*
 SDWebimage        SDWebImageOptions枚举
 */
#define kImageOption (SDWebImageRetryFailed|SDWebImageLowPriority)
/*
 <##>
 <##>
 */
#define AVATAR_VIEW [[UIImageView alloc]initWithImage:IMAGE(@"yuan")]
/*
 TICK       获取本地时间
 TOCK
 */
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])
#endif
