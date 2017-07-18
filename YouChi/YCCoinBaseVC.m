//
//  YCCoinBaseVC.m
//  YouChi
//
//  Created by sam on 15/6/9.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCoinBaseVC.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "YCCatolog.h"
#import "YCOthersInfoVC.h"
#import "YCViewModel+Logic.h"
#import <MUKPullToRevealControl/MUKCirclePullToRefreshControl.h>
#import "YCLoginVC.h"
#import "WXApi.h"
@interface YCCoinBaseVC () <UIWebViewDelegate>
@property(nonatomic,strong) MUKCirclePullToRefreshControl *refresh;
@property(nonatomic,strong) WebViewJavascriptBridge* bridge;
@end

@implementation YCCoinBaseVC

#pragma mark -
- (void)dealloc
{
//    ok
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)onSetupRefreshControl
{
    UIWebView *web = (id)self.webView;
    
    MUKCirclePullToRefreshControl *refreshControl = [[MUKCirclePullToRefreshControl alloc]init];
    UIView *circle = [refreshControl valueForKey:@"circleView"];
    CAShapeLayer *layer = (CAShapeLayer *)circle.layer;
    layer.strokeColor = color_yellow.CGColor;
    
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    [web.scrollView addSubview:refreshControl];
    
    self.refresh = refreshControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIWebView *web = (id)self.webView;
    web.delegate = self;
    web.dataDetectorTypes = UIDataDetectorTypeAll;
    web.allowsInlineMediaPlayback = YES;
    web.mediaPlaybackRequiresUserAction = YES;
    web.mediaPlaybackAllowsAirPlay = YES;
    web.scalesPageToFit = YES;
    web.keyboardDisplayRequiresUserAction = YES;
    web.scrollView.bounces = YES;
    web.scrollView.decelerationRate = 1.0f;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onGoBackToHome) name:YCUserDefaultUpdate object:nil];
    
//    [self onSetupRefreshControl];
    [self onGoBackToHome];
    

    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback) {
            responseCallback(data);
        }
    }];

    WSELF;
    [self.bridge registerHandler:@"share" handler:^(NSDictionary *dict, WVJBResponseCallback responseCallback) {
        YCShareM *m = [MTLJSONAdapter modelOfClass:[YCShareM class] fromJSONDictionary:dict error:NULL];
        if ([m.targetURL hasSuffix:@"html"]) {
            m.targetURL = [NSString stringWithFormat:@"%@?share=1",m.targetURL];
        }
        
        else {
            m.targetURL = [NSString stringWithFormat:@"%@&share=1",m.targetURL];
        }
        
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:m.shareImageUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            SSELF;
            [[self.viewModel shareInView:self title:m.shareTitle text:m.shareContent image:image?:APP_ICON url:m.targetURL shareId:nil type:YCShareTypeNone]subscribeError:^(NSError *error) {
                [self performSelector:@selector(showMessage:) withObject:error.localizedDescription afterDelay:1];
            }];
        }];
        
    }];

    
    [self.bridge registerHandler:@"openOtherUserActivty" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        SSELF;
        NSNumber *userId = data[@"userId"];
        YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:userId];
        YCOthersInfoVC *vc = [YCOthersInfoVC vcClass:[YCOthersInfoVC class]];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.navigationItem.leftBarButtonItem.action = @selector(onDismissReturn);
        vc.viewModel = vm;
        [self presentViewController:nc animated:YES completion:nil];
    }];
    
    [self.bridge registerHandler:@"openLogin" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        SSELF;
        UIViewController *vc = [UIViewController vcClass:[YCLoginVC class]];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    [self.bridge registerHandler:@"showOrHideTabbar" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        SSELF;
        NSNumber *showOrHide = data[@"showOrHide"];
        if (showOrHide.boolValue) {
            [self showTabbar];
        } else {
            [self hideTabbar];
        }
    }];
    
    [self.bridge registerHandler:@"sendWXPay" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        NSLog(@"wxpay =%@\n",data);
        
        
        [[ENGINE wxOrderParamters:data]subscribeNext:^(id x) {
            responseCallback(x);
        } error:^(NSError *error) {
            SSELF;
            responseCallback(nil);
            [self showMessage:error.localizedDescription];
        }];
    }];
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status > AFNetworkReachabilityStatusNotReachable) {
            SSELF;
            [self onRefresh:nil];
        }
    }];
}

#pragma mark -
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.executingBlock(YES);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.executingBlock(NO);
    [self onReload:nil];
    [self.refresh coverAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.executingBlock(NO);
    [self showMessage:error.localizedDescription];
    [self.refresh coverAnimated:YES];
}

#pragma mark -
- (void)onReturn
{
    [self.webView goBack];
}

- (IBAction)onRefresh:(UIBarButtonItem *)sender
{
    [self.webView reload];
}

- (void)onReload:(UIRefreshControl *)sender
{
    NSDictionary *param = @{
                            kToken:[YCUserDefault currentToken],
                            @"loginId":[YCUserDefault currentLoginId],
                            @"clientId":ENGINE.clientId,
                            @"headerNavBar":@"0",
                            };
  
    NSString *str = [param mgm_JSONString];
    [self.bridge callHandler:@"setLoginInfo" data:str];
    
}

- (void)onGoBackToHome
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:html5] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
