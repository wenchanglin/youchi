//
//  YCWebVC.m
//  YouChi
//
//  Created by sam on 15/6/17.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCWebVC.h"
#import "YCViewModel+Logic.h"
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "YCLoginVC.h"
#import <JDFNavigationBarActivityIndicator/JDFNavigationBarActivityIndicator.h>
#import "YCRandomPicturesVC.h"
#import "YCMaterialVC.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "YCItemDetailVC.h"
#import "YCCache.h"
@interface YCWebVC ()
PROPERTY_STRONG_VM(YCWebVM);
@property (nonatomic,strong) WebViewJavascriptBridge *bridge;
@property (nonatomic,strong) JDFNavigationBarActivityIndicator *indicator;
@property (nonatomic,strong) UIBarButtonItem *bClose;
@property (nonatomic,strong) UIWebView *web;
@end

@implementation YCWebVC
SYNTHESIZE_VM;
- (void)dealloc
{
    //ok
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithUrlString:(NSString *)urlString
{
    _urlString = urlString;
    return [self init];
}

- (void)loadView
{
    self.view = _web = [UIWebView new];
    self.title = @"正在加载中...";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hideTabbar];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.indicator stopAnimating];
}

- (void)onSetupActivityIndicatorView
{
    JDFNavigationBarActivityIndicator *indicator = [[JDFNavigationBarActivityIndicator alloc]init];
    indicator.color = color_yellow;
    indicator.highlightColor = [UIColor whiteColor];
    UINavigationBar *bar = self.navigationController.navigationBar;
    
    [indicator addToNavigationBar:bar startAnimating:YES];
    self.indicator = indicator;
}

- (UIBarButtonItem *)bClose
{
    if (!_bClose) {
        _bClose = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(onClose)];
    }
    return _bClose;
}

- (void)onReturn
{
    UIWebView *web = self.web;
    if ([web canGoBack]) {
        [web goBack];
    }
    
    else {
        [super onReturn];
    }
}

- (void)onClose
{
    [super onReturn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WSELF;
    UIWebView *web = self.web;
    web.delegate = self;
    web.dataDetectorTypes = UIDataDetectorTypeAll;
    web.allowsInlineMediaPlayback = YES;
    web.mediaPlaybackRequiresUserAction = YES;
    web.mediaPlaybackAllowsAirPlay = YES;
    web.scalesPageToFit = YES;
    web.keyboardDisplayRequiresUserAction = YES;
    web.scrollView.bounces = YES;
    web.scrollView.decelerationRate = 1.0f;
    web.scrollView.alwaysBounceHorizontal = NO;
    web.scrollView.alwaysBounceVertical = NO;
    
    [self onSetupActivityIndicatorView];

    self.bridge = [WebViewJavascriptBridge bridgeForWebView:web webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(data);
    }];
    
    ///MARK:share
    [self.bridge registerHandler:@"share" handler:^(NSDictionary *dict, WVJBResponseCallback responseCallback) {
        YCShareM *m = [YCShareM modelWithDictionary:dict];
        if ([m.targetURL hasSuffix:@"html"]) {
            m.targetURL = [NSString stringWithFormat:@"%@?share=1",m.targetURL];
        }
        
        else {
            m.targetURL = [NSString stringWithFormat:@"%@&share=1",m.targetURL];
        }
        if (!self.viewModel) {
            self.viewModel = [YCWebVM new];
        }
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:m.shareImageUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            SSELF;
            dispatch_async_on_main_queue(^{
                [[self.viewModel shareInView:self title:m.shareTitle text:m.shareContent image:image?:APP_ICON url:m.targetURL shareId:nil type:YCShareTypeNone]subscribeNext:^(id x) {
                    [self performSelector:@selector(showMessage:) withObject:x afterDelay:1];
                } error:^(NSError *error) {
                    SSELF;
                    [self performSelector:@selector(showMessage:) withObject:error.localizedDescription afterDelay:1];
                }];

            });
        }];
        
    }];
    
    ///MARK:login
    [self.bridge registerHandler:@"openLogin" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        SSELF;
        UIViewController *vc = [UIViewController vcClass:[YCLoginVC class]];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    ///MARK:openController
    [self.bridge registerHandler:@"openController" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        SSELF;
        @try {
            Class vmc = NSClassFromString(data[@"vmClass"]);
            Class vcc = NSClassFromString(data[@"vcClass"]);
            NSNumber *itemId = data[@"vmId"];
           

            YCPageViewModel *vm = [[vmc alloc]initWithId:itemId];
            
            YCTableViewController *vc = [YCTableViewController vcClass:vcc];
            vc.viewModel = vm;
            
            NSDictionary *arg = data[@"vmParamters"];
            if (arg) {
                [vm setValuesForKeysWithDictionary:arg];
            }

            [self.navigationController pushViewController:vc animated:YES];
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            ;
        }
    }];
    
    ///MARK:openRandomPhoto
    [self.bridge registerHandler:@"openRandomPhoto" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        SSELF;
        YCRandomPicturesVC *vc = [YCRandomPicturesVC vcClass:[YCRandomPicturesVC class]];
        NSDictionary *arg = data[@"vmParamters"];
        if (arg) {
            [vc.viewModel setValuesForKeysWithDictionary:arg];
        }
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    ///MARK:openCheats
    [self.bridge registerHandler:@"openCheats" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        SSELF;
        @try {
            NSNumber *itemId = data[@"vmId"];
            YCMaterialVM *vm = [YCMaterialVM new];
            vm.Id = itemId;
            
            NSDictionary *arg = data[@"vmParamters"];
            if (arg) {
                [vm setValuesForKeysWithDictionary:arg];
            }
            
            [self pushTo:[YCMaterialVC class] viewModel:vm];
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            ;
        }
    }];
    
    ///MARK:登录getLoginInfo
    [self.bridge registerHandler:@"getLoginInfo" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        NSDictionary *param = @{
                                kToken:[YCUserDefault currentToken],
                                @"loginId":[YCUserDefault currentLoginId],
                                @"clientId":ENGINE.clientId,
                                @"headerNavBar":@"1",
                                };
        NSString *str = [param jsonStringEncoded];
        responseCallback(str);
    }];
    
    ///MARK:网页微信支付
    [self.bridge registerHandler:@"sendWXPay" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        NSLog(@"wxpay =%@\n",data);
        //responseCallback(data);
        [[ENGINE wxOrderParamters:data]subscribeNext:^(id x) {
            responseCallback(x);
        } error:^(NSError *error) {
            SSELF;
            responseCallback(nil);
            [self showMessage:error.localizedDescription];
        }];
    }];
    
    ///MARK:跳到商品详情
    [self.bridge registerHandler:@"jumpToItemDetail" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback) {
        SSELF;
        @try {
            NSNumber *itemId = data[@"itemId"];
            YCItemDetailVM *vm = [YCItemDetailVM new];
            vm.Id = itemId;
           
            [self pushTo:[YCItemDetailVC class] viewModel:vm];
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            ;
        }
    }];

    
    [[NSNotificationCenter defaultCenter] addObserverForName:YCPhotoNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * note) {
        [web reload];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_refreshData) name:YCUserDefaultUpdate object:nil];
}
  
- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    NSURL *url = nil;
    if (self.viewModel.url) {
        url = NSURL_URLWithString([self.viewModel.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    }  else if (self.urlString) {
        url = NSURL_URLWithString([self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    }
    
    if (url) {
        NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        [self.web loadRequest:req];
        NSLog(@"url = %@",url.absoluteString);
    }
    else {
        NSLog(@"木有url");
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicator stopAnimating];
    
    [self _setLoginInfo];
    
    self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if ([webView canGoBack]) {
        [self.navigationItem setLeftBarButtonItems:@[self.navigationItem.leftBarButtonItem,self.bClose] animated:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.errorBlock(error);
    [self.indicator stopAnimating];
    
    
}

- (void)_setLoginInfo
{
    NSDictionary *param = @{
                            kToken:[YCUserDefault currentToken],
                            @"loginId":[YCUserDefault currentLoginId],
                            @"clientId":ENGINE.clientId,
                            @"headerNavBar":@"1",
                            };
    NSString *str = [param mgm_JSONString];
    [self.bridge callHandler:@"setLoginInfo" data:str];
    
}

- (void)_refreshData
{
    [self _setLoginInfo];
    [self.web loadRequest:self.web.request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@implementation YCShareM


@end