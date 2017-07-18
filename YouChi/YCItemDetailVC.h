//
//  YCItemDetailVC.h
//  YouChi
//
//  Created by sam on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCItemDetailVM.h"
#import "YCView.h"
#import "YCGoodsCommentVC.h"
#import "YCFixOrderVC.h"
#import "YCMyCartVC.h"
#import "YCPlayerVC.h"
#import "YCYouChiShopVC.h"
#import "YCAddShopCar.h"

#import "YCFixOrderVC.h"

#import "YCWebVC.h"
#import "YCYouMiExchangePayVC.h"
#import "YCImagePlayerView.h"

#import "YCContainerControl.h"
#import "YCDistributionAreaVC.h"
#import "YCCenterButton.h"
@interface YCItemDetailVCP: YCViewController
@end

@interface YCItemDetailVC: YCBTableViewController<UIWebViewDelegate>
PROPERTY_STRONG_VM(YCItemDetailVM);
PROPERTY_STRONG UIWebView *webView;
@end

@interface YCItemDetailRecommendView : YCView

PROPERTY_STRONG UIView *item;
PROPERTY_STRONG YYLabel *detail;

PROPERTY_STRONG YYLabel *price;
PROPERTY_STRONG UIButton *more;
- (void)updateItemDetailRecommendViewWith:(ShopProductRecommend *)m;
@end