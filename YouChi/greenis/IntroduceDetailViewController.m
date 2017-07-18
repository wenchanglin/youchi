//
//  IntroduceDetailViewController.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/7/21.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>

#import "IntroduceDetailViewController.h"
#import "IntroduceDetailStepViewCell.h"

#import <MediaPlayer/MediaPlayer.h>
#import "AppConstants.h"
#import "CommentContainer.h"
#import "CommentDataModel.h"
#import "IntroduceDetailDataModel.h"


#import "MessageInputView.h"
#import "MessageManagerFaceView.h"


#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#import "SDRefresh.h"

//#import "ShareSheet.h"
//#import "WXApiRequestHandler.h"
//#import "WXApiManager.h"
//
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/TencentOAuthObject.h>
//#import <TencentOpenAPI/TencentApiInterface.h>
//#import "TencentOpenAPI/QQApiInterface.h"
//#import "SDPhotoBrowser.h"

#import "UIViewController+Action.h"
@interface IntroduceDetailViewController () <IntroduceDetailStepViewCellDelegate, MessageInputViewDelegate, MessageManagerFaceViewDelegate, UIScrollViewDelegate, BLESerialComManagerDelegate, RefreshDelegate
//ShareSheetDelegate, WXApiManagerDelegate, TencentSessionDelegate
/*, UIWebViewDelegate*/>

@property (strong, nonatomic) UIScrollView              *verticalScrollView;
@property (strong, nonatomic) UIView                    *verticalScrollViewContainer;
//@property (strong, nonatomic) MPMoviePlayerController   *player;
@property (strong, nonatomic) UIImageView               *videoPreviewImageView;
//视频播放按钮
@property (strong, nonatomic) UIButton                  *videoStartButton;
@property (strong, nonatomic) UIToolbar                 *customToolBar;
@property (strong, nonatomic) UIView                    *effectView;
@property (strong, nonatomic) UIView                    *materialView;
@property (strong, nonatomic) UIView                    *stepsView;
@property (strong, nonatomic) UIView                    *exampleView;
@property (strong, nonatomic) UIView                    *separatedView;
@property (strong, nonatomic) CommentContainer          *commentView;
//@property (strong, nonatomic) SDRefreshFooterView       *refreshFooterView;

@property (strong, nonatomic) MessageInputView          *messageInputView;
@property (strong, nonatomic) MessageManagerFaceView    *faceView;

@property (strong, nonatomic) UIImageView               *effectTitleImageView;
@property (strong, nonatomic) UIImageView               *materialTitleImageView;
@property (strong, nonatomic) UIImageView               *stepsImageView;
@property (strong, nonatomic) UIImageView               *exampleImageView;

@property (strong, nonatomic) CommentDataModel          *commentDataModel;
@property (strong, nonatomic) CommentDataModel          *commentDataModelTemp;

@property (strong, nonatomic) IntroduceDetailDataModel  *introduceDetailDataModel;

@property (nonatomic) double                            animationDuration;
@property (nonatomic) CGRect                            keyboardRect;

@property (strong, nonatomic) NSMutableArray            *stepArray;
@property (nonatomic) int                               currentStepIndex;

@property (nonatomic) BOOL                              isIntroduceDetailReady;
@property (nonatomic) BOOL                              isCommentReady;

@property (nonatomic) float                             commentViewY;
@property (nonatomic) float                             totalHeight;

@property (nonatomic) BOOL                                      isDataShow;
@property (strong, nonatomic) UIButton                          *getDataFailButton;

@property (nonatomic) int                               commentCount;

//@property (strong, nonatomic) TencentOAuth              *oAuth;
@property (nonatomic) BOOL                              isFav;

@property (strong, nonatomic) UIBarButtonItem           *starButton;

@property (strong, nonatomic) IntroduceDataModel        *data;

@end

@implementation IntroduceDetailViewController

- (instancetype)initWithData:(IntroduceDataModel*)data {

//- (instancetype)initWithFormulaID:(NSString*)formulaID andIntroduction:(NSString*)introduction andIngredients:(NSString*)ingredients andVideoUrl:(NSString*)videoUrl andStepStr:(NSString*)stepStr andFormulaName:(NSString*)formulaName andImageName:(NSString*)imageName andShareUrl:(NSString *)shareUrl{
    self = [super init];
    if (self) {
        _data = data;
        /*
        self.formulaId = data.formulaID;
        self.introduction = data.introduction;
        self.ingredients = data.ingredients;
        self.videoUrl = data.videoUrl;
        self.stepStr = data.steps;
        self.formulaName = data.formulaName;
        self.imageName = data.imageUrl;
        self.shareUrl = data.shareUrl;
        */
        _commentCount = 10;

        NSArray *array = [data.steps componentsSeparatedByString:@"%"];
        
        _stepArray = [[NSMutableArray alloc] initWithCapacity:100];
        
        for (int i = 0; i < [array count]; ++i) {
            if (![[array objectAtIndex:i] isEqualToString:@""]) {
                [_stepArray addObject:[array objectAtIndex:i]];
            }
        }
        
        _isFav = NO;
        NSArray *favData = [AppConstants favData];
        int favCount = (int)[favData count];
        for (int i = 0; i < favCount; ++i) {
            if ([_data.formulaID isEqualToString:((IntroduceDataModel*)[favData objectAtIndex:i]).formulaID]) {
                _isFav = YES;
                break;
            }
        }
    }
    return self;
}

- (void)viewDidLayoutSubviews {
//    NSLog(@"effectView width = %f, height = %f", _effectView.frame.size.width, _effectView.frame.size.height);
//    
    float totalY = _effectView.frame.size.height + _materialView.frame.size.height + _stepsView.frame.size.height + _commentView.frame.size.height;
    
    _commentViewY = _effectView.frame.size.height + _materialView.frame.size.height + _stepsView.frame.size.height;
    
    if (totalY > _totalHeight) {
        _totalHeight = totalY;
    }
    
    NSLog(@"_totalHeight = %f, _commentViewY = %f", _totalHeight, _commentViewY);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onSetupBackButton];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [BLESerialComManager sharedInstance].delegate = self;
    
////    微信
//    [WXApiManager sharedManager].delegate = self;
//
//    NSString *appid = [AppConstants QQAppID];
//    
//    // 只是为了消除warning
//    _oAuth = [[TencentOAuth alloc] initWithAppId:appid andDelegate:self];
    
    _keyboardRect = CGRectZero;
    
    _isIntroduceDetailReady = NO;
    _isCommentReady = YES;
    _isDataShow = NO;
    
    [ProgressHUD show:NSLocalizedString(@"loading", @"")];
    
    [self loadData];
    
    [self initBarButtons];
    
    /*
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_stepsView.mas_bottom);
    }];
     */
}

- (void)loadData {
    [_getDataFailButton removeFromSuperview];
    
    if (_isDataShow == NO) {
        [ProgressHUD show:NSLocalizedString(@"loading", @"")];
    }
//    简介详细内容加载
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIntroduceDetailData) name:@"IntroduceDetailRequestDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail) name:@"IntroduceDetailRequestFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCommentData) name:@"commentRequestDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail) name:@"commentRequestFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendCommentPress) name:@"commentPost" object:nil];
    
    _introduceDetailDataModel = [[IntroduceDetailDataModel alloc] initWithFormulaId:_data.formulaID];
    _commentDataModelTemp = [[CommentDataModel alloc] initWithFormulaId:_data.formulaID AndCommentCount:_commentCount forUpdate:NO];
}

- (void)getDataFail {
    [_getDataFailButton removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IntroduceDetailRequestDone" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IntroduceDetailRequestFail" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentRequestDone" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentRequestFail" object:nil];
    
    [ProgressHUD showError:NSLocalizedString(@"jiazaishibai", @"")];
    
    if (_isDataShow == NO) {
        _getDataFailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getDataFailButton setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
        [_getDataFailButton addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_getDataFailButton];
        
        [_getDataFailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.width.and.height.equalTo(@160);
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
    
    _messageInputView = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"IntroduceDetailRequestDone" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"commentRequestDone" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"commentPost" object:nil];
}

- (void)sendCommentPress {
    NSLog(@"sendCommentPress");
    NSLog(@"messageInputTextView = %@", _messageInputView.messageInputTextView);
    
    [self didSendTextAction:_messageInputView.messageInputTextView];
}

- (void)setIntroduceDetailData {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IntroduceDetailRequestDone" object:nil];
    //数据是否准备显示
    _isIntroduceDetailReady = YES;
    //准备显示数据
    [self prepareToShowData];
}

- (void)setCommentData {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentRequestDone" object:nil];
    
    _isCommentReady = YES;
    
    [self prepareToShowData];
}

- (void)prepareToShowData {
    
    if (_isIntroduceDetailReady &&
        _isCommentReady)
    {
        [self initViews];
        
        [self doAnimation];
    }
}
#pragma mark -initViews
- (void)initViews {
//评论输入框
    //[self initMessageInputView];
//    笑脸第三方
    //[self initFaceView];
//    简介主要内容的ScrollView
    [self initVerticalScrollView];
//    [self initFaceView];
//    播放完成时执行的方法
    [self addObservers];
//    [self initMoviePlayer];
//    菜谱功效
    [self initEffectView];
//    菜谱食材料（播放）
    [self initMaterialView];
//    菜谱步骤
    [self initStepsView];
//    菜谱评论
    //[self initCommentView];
    
    if ([_commentDataModel.nameArray count] > 5) {
        [self setupFooter];
    }
    
    _isDataShow = YES;
    [_getDataFailButton removeFromSuperview];
    [ProgressHUD dismiss];
    
    [self prepareForAnimation];
    
    [self doAnimation];
}

- (void)prepareForAnimation {
    _effectTitleImageView.transform = CGAffineTransformMakeScale(0, 0);
    _materialTitleImageView.transform = CGAffineTransformMakeScale(0, 0);
    _stepsImageView.transform = CGAffineTransformMakeScale(0, 0);
    _exampleImageView.transform = CGAffineTransformMakeScale(0, 0);
}

- (void)doAnimation {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone
                     animations: ^{
                         _effectTitleImageView.transform = CGAffineTransformMakeScale(1, 1);
                     }completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone
                     animations: ^{
                         _materialTitleImageView.transform = CGAffineTransformMakeScale(1, 1);
                     }completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone
                     animations: ^{
                         _stepsImageView.transform = CGAffineTransformMakeScale(1, 1);
                     }completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.3 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone
                     animations: ^{
                         _exampleImageView.transform = CGAffineTransformMakeScale(1, 1);
                     }completion:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardChange:)
                                                name:UIKeyboardDidChangeFrameNotification
                                              object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    NSLog(@"hide");

    _keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSLog(@"keyboardWillHide height = %f", _keyboardRect.size.height);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
     
        [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
        
        [_messageInputView layoutIfNeeded];
        [_verticalScrollView layoutIfNeeded];
    }completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    NSLog(@"show");
    
    _keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _animationDuration= [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSLog(@"keyboardWillShow height = %f", _keyboardRect.size.height);
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-_keyboardRect.size.height);
        }];
        [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(-_keyboardRect.size.height);
        }];
        
        [_messageInputView layoutIfNeeded];
        [_verticalScrollView layoutIfNeeded];
    }completion:nil];
}

- (void)keyboardChange:(NSNotification *)notification{
    
    NSLog(@"keyboardChange");
    /*
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight(self.view.frame)) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).with.offset(-_keyboardRect.size.height);
            }];
            [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(-_keyboardRect.size.height);
            }];
            
            [_messageInputView layoutIfNeeded];
            [_verticalScrollView layoutIfNeeded];
        }completion:nil];
    }*/
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

//    self.tabBarController.tabBar.hidden = YES;
    
    [self doAnimation];
}

- (void)downloadButtonPress {
    NSLog(@"downloadButtonPress");
    
    [_messageInputView.messageInputTextView resignFirstResponder];
//BTDownloadingSteps 是个bool类型的
    if ([BTConstants BTDownloadingSteps]) {
        return;
    }
//    是否连接到蓝牙
    if (![BTConstants BTConnected]) {
        [ProgressHUD showError:NSLocalizedString(@"weilianjielanya", @"")];
        
        [BTConstants BTSetDownloadingSteps:NO];
        
        [AppConstants setDownloadButtonPress2Pop:YES];
        
        [NSThread detachNewThreadSelector:@selector(timedPop) toTarget:self withObject:nil];
        
        return;
    }
//    机器运行中
    if ([BTConstants BTStatus] == BTStatusRunning) {
        [ProgressHUD showError:NSLocalizedString(@"jiqiyunxingzhong", @"")];
        
        return;
    }
    else {
        [BTConstants BTSetRequestType:@"download"];
        [BTConstants sendCommand:[BTConstants A9]];
    }
}

- (void)downloadTimeUp {
    @autoreleasepool
    {
        NSTimeInterval sleep = 5.0;
        
        [NSThread sleepForTimeInterval:sleep];
        
        if ([BTConstants BTDownloadingSteps] == YES) {
            [BTConstants BTSetDownloadingSteps:NO];
            [BTConstants BTSetRequestType:@""];
            [ProgressHUD showError:NSLocalizedString(@"xiafacaipuchaoshi", @"")];
        }
    }
}

- (void)timedPop
{
    @autoreleasepool
    {
        NSTimeInterval sleep = 2.0;
        
        [NSThread sleepForTimeInterval:sleep];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)downloadStepToMachine {

    if (_currentStepIndex == [_stepArray count]) {
        _currentStepIndex = -1;
        
        [BTConstants BTSetRequestType:@"C2"];
        [BTConstants sendCommand:[BTConstants C2_6]];
        
        return;
    }
    
    if (![[_stepArray objectAtIndex:_currentStepIndex] isEqualToString:@""]) {
        [BTConstants BTSetRequestType:@"C7"];
        [BTConstants sendCommand:[BTConstants C7:[_stepArray objectAtIndex:_currentStepIndex]]];
        
        _currentStepIndex++;
    }
}


- (void)shareButtonPress {
    NSLog(@"shareButtonPress");
    
    [_messageInputView.messageInputTextView resignFirstResponder];
    
//    ShareSheet *sheet = [[ShareSheet alloc]initWithlist:[AppConstants shareSheetMenu] height:0];
//    sheet.delegate = self;
//    [sheet showInView:nil];
}
/*
//分享
-(void)didSelectIndex:(NSInteger)index{
    // 0 新浪微博
    // 1 微信好友
    // 2 微信朋友圈
    // 3 QQ好友
    // 4 QQ空间
    // 5 取消
    switch (index) {
        case 0:
        {
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
            authRequest.scope = @"all";
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:[AppConstants WeiboAccessToken]];
            request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            [WeiboSDK sendRequest:request];
        }
            break;
        case 1:
        {
            // ThumbImage 超过10K 会分享失败
            [WXApiRequestHandler sendLinkURL:[NSString stringWithFormat:@"%@%@", [AppConstants shareHeader], _data.shareUrl]
                                     TagName:@"SmartKitchen"
                                       Title:_data.formulaName
                                 Description:_data.introduction
                                  ThumbImage:[UIImage imageNamed:@"icon.png"]
                                     InScene:WXSceneSession];
        }
            break;
        case 2:
        {
            // ThumbImage 超过10K 会分享失败
            [WXApiRequestHandler sendLinkURL:[NSString stringWithFormat:@"%@%@", [AppConstants shareHeader], _data.shareUrl]
                                     TagName:@"SmartKitchen"
                                       Title:_data.formulaName
                                 Description:_data.introduction
                                  ThumbImage:[UIImage imageNamed:@"icon.png"]
                                     InScene:WXSceneTimeline];
        }
            break;
        case 3:
        {
            NSURL *previewURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], [_introduceDetailDataModel.originalImageUrlArray lastObject]]];
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [AppConstants shareHeader], _data.shareUrl]];
            
            QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:_data.formulaName description:_data.introduction previewImageURL:previewURL];
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
            
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleSendResult:sent];
        }
            break;
        case 4:
        {
            NSURL *previewURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], [_introduceDetailDataModel.originalImageUrlArray lastObject]]];
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [AppConstants shareHeader], _data.shareUrl]];
            
            QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:_data.formulaName description:_data.introduction previewImageURL:previewURL];
            
            [img setCflag:kQQAPICtrlFlagQZoneShareOnStart];
            
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
            
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleSendResult:sent];
        }
            break;
        default:
            NSLog(@"index = %ld", (long)index);
            break;
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    NSLog(@"handleSendResult");
    
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            [ProgressHUD showError:@"App未注册 -_-"];
        }
            break;
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            [ProgressHUD showError:@"发送参数错误 -_-"];
        }
            break;
        case EQQAPIQQNOTINSTALLED:
        {
            [ProgressHUD showError:@"未安装手Q -_-"];
        }
            break;
        case EQQAPIQQNOTSUPPORTAPI:
        {
            [ProgressHUD showError:@"API接口不支持 -_-"];
        }
            break;
        case EQQAPISENDFAILD:
        {
            [ProgressHUD showError:@"发送失败-_-"];
        }
            break;
        default:
        {
            break;
        }
    }
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = _data.formulaID;
    webpage.title = _data.formulaName;
    webpage.description = _data.introduction;
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]];
    webpage.webpageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants shareHeader], _data.shareUrl];
    message.mediaObject = webpage;
    
    return message;
}*/
//收藏
- (void)starButtonPress {
    NSLog(@"starButtonPress");
    
    [_messageInputView.messageInputTextView resignFirstResponder];
    
    UIImage *starButtonImage;
    
    if (_isFav) {
//        当已经收藏室，删除收藏
        starButtonImage = [UIImage imageNamed:@"star"];
        
        [AppConstants deleteFavWithData:_data];
        
//        [AppConstants deleteFavWithFormulaID:_formulaId andIntroduction:_introduction andIngredients:_ingredients andVideoUrl:_videoUrl andStepStr:_stepStr andFormulaName:_formulaName andImageName:_imageName andShareUrl:_shareUrl];
    }
    else {
        starButtonImage = [UIImage imageNamed:@"starFull"];
//        写入到沙盒文件夹的document
        [AppConstants addFavWithData:_data];
        
//        [AppConstants addFavWithFormulaID:_formulaId andIntroduction:_introduction andIngredients:_ingredients andVideoUrl:_videoUrl andStepStr:_stepStr andFormulaName:_formulaName andImageName:_imageName andShareUrl:_shareUrl];
    }
    
    starButtonImage = [starButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _starButton.image = starButtonImage;
    
    _isFav = !_isFav;
    
//    [ProgressHUD showError:@"收藏功能暂未开放"];
}

- (void)initBarButtons {
//    分享
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 130, 45)];
    toolBar.backgroundColor = [UIColor clearColor];
//    [toolBar setAlpha:[self.navigationController.navigationBar alpha]];
    
    UIImage *shareButtonImage = [UIImage imageNamed:@"share"];
    shareButtonImage = [shareButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonPress)];
//    下载
    UIImage *downloadButtonImage = [UIImage imageNamed:@"download"];
    downloadButtonImage = [downloadButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *downloadButton = [[UIBarButtonItem alloc] initWithImage:downloadButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(downloadButtonPress)];
    
//    收藏
    UIImage *starButtonImage;
    if (_isFav) {
        starButtonImage = [UIImage imageNamed:@"starFull"];
    }
    else {
        starButtonImage = [UIImage imageNamed:@"star"];
    }
    starButtonImage = [starButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _starButton = [[UIBarButtonItem alloc] initWithImage:starButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(starButtonPress)];
    
    [toolBar setItems:@[shareButton, downloadButton, _starButton]];
    [toolBar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
    toolBar.clipsToBounds = YES;
    
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
    customButton.tintColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = customButton;
}

- (void)initMessageInputView {
//    评论框
    _messageInputView = [[MessageInputView alloc] init];
//    _messageInputView.messageInputViewStyle = MessageInputViewStyleDefault;
    _messageInputView.delegate = self;
    [self.view addSubview:_messageInputView];
    
    [_messageInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.equalTo(_messageInputView.messageInputTextView.mas_height).with.offset(10);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-_keyboardRect.size.height);
    }];
}

- (void)initFaceView {
//    笑脸第三方
    self.faceView = [[MessageManagerFaceView alloc] init];
    self.faceView.delegate = self;
    self.faceView.userInteractionEnabled = YES;
    [self.view addSubview:self.faceView];
    
    [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(196);
    }];
}

- (void)initVerticalScrollView {
//    简介主要内容的ScrollView
    _verticalScrollView = [UIScrollView new];
    _verticalScrollView.backgroundColor = [UIColor whiteColor];
    _verticalScrollView.scrollsToTop = YES;
    _verticalScrollView.userInteractionEnabled = YES;
    _verticalScrollView.delegate = self;
    [self.view addSubview:_verticalScrollView];
    [_verticalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.bottom.right.equalTo(self.view);
        //make.bottom.equalTo(_messageInputView.mas_top);//.with.offset([AppConstants uiTabBarHeight]);
    }];
    
    _verticalScrollViewContainer = [UIView new];
    _verticalScrollViewContainer.backgroundColor = [UIColor grayColor];
    _verticalScrollViewContainer.userInteractionEnabled = YES;
//    把灰色的view放在scrollview上面
    [_verticalScrollView addSubview:_verticalScrollViewContainer];
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_verticalScrollView);
        make.width.equalTo(_verticalScrollView);
    }];

}

- (void)addObservers {
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackstateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification   //播放状态改变，可配合playbakcState属性获取具体状态
                                               object:nil];*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playDidFinish:) //媒体播放完成或用户手动退出，具体完成原因可以通过通知userInfo中的key为MPMoviePlayerPlaybackDidFinishReasonUserInfoKey的对象获取
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerWillEnterFullScreen)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification
                                               object:nil];
}

- (void)initMoviePlayer {
//    NSString *url = [NSString stringWithFormat:@"%@%@", [AppConstants httpVideoHeader], _videoUrl];
    
//    int videoDuration = [self getVideoDuration:url];
    
    
}

- (int)getVideoDuration:(NSString*)videoUrl {
    NSURL *movieURL = [NSURL URLWithString:videoUrl];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    NSLog(@"movie duration : %f", second);

    return second;
}

-(UIImage*)getVideoPreviewImageWithUrl:(NSString *)videoURL// andTimestamp:(int)timestamp
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    NSURL *url = [[NSURL alloc] initWithString:videoURL];
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake([AppConstants uiScreenWidth] - 10, 150);
    
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(1, 1) actualTime:NULL error:&error];
//    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(timestamp / 20, 1) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    
    return image;
}

//功效view
- (void)initEffectView {
    _effectView = [[UIView alloc] init];
    _effectView.backgroundColor = [UIColor whiteColor];
    
    [_verticalScrollViewContainer addSubview:_effectView];
    
    UIImageView *doneImageView = [[UIImageView alloc] init];
    
    NSString *imageUrl = [_introduceDetailDataModel.originalImageUrlArray lastObject];
    
    NSString *imageHttpUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], imageUrl];
    
    [doneImageView setImageWithURL:[NSURL URLWithString:imageHttpUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];
    
    doneImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_effectView addSubview:doneImageView];
    
    [doneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_effectView).with.offset(10);
        make.left.equalTo(_effectView).with.offset(20);
        make.right.equalTo(_effectView).with.offset(-20);
        //            make.width.mas_equalTo([AppConstants uiScreenWidth] - 40);
        make.height.mas_equalTo(([AppConstants uiScreenWidth] - 40) / 3 * 2);
    }];
    
    _effectTitleImageView = [[UIImageView alloc] init];
    UIImage *effectTitleImage = [UIImage imageNamed:@"tips"];
    effectTitleImage = [effectTitleImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _effectTitleImageView.image = effectTitleImage;
    [_effectView addSubview:_effectTitleImageView];
    [_effectTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(doneImageView.mas_bottom).with.offset(10);
        make.left.equalTo(_effectView).with.offset(10);
        make.width.and.height.equalTo(@25);
    }];
    
    UILabel *effectTitleLabel = [[UILabel alloc] init];
    effectTitleLabel.text = NSLocalizedString(@"gongxiao", @"");
    effectTitleLabel.textColor = [AppConstants themeColor];
    [_effectView addSubview:effectTitleLabel];
    [effectTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_effectTitleImageView.mas_centerY);
        make.left.equalTo(_effectTitleImageView.mas_right).with.offset(10);
    }];
    
    UILabel *effectContentLabel = [[UILabel alloc] init];
    effectContentLabel.text = _data.introduction;
    effectContentLabel.textColor = [UIColor lightGrayColor];
    effectContentLabel.numberOfLines = 0;
    [_effectView addSubview:effectContentLabel];
    [effectContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(effectTitleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(effectTitleLabel.mas_left);
        make.right.equalTo(_effectView.mas_right).with.offset(-50);
    }];
    
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_verticalScrollViewContainer);
        make.bottom.equalTo(effectContentLabel.mas_bottom).with.offset(10);
    }];
    /*
    UIImageView *goDetailImageView = [[UIImageView alloc] init];
    UIImage *goDetailImage = [UIImage imageNamed:@"goDetail"];
    goDetailImage = [goDetailImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    goDetailImageView.image = goDetailImage;
    [_effectView addSubview:goDetailImageView];
    [goDetailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_effectView.mas_centerY);
        make.right.equalTo(_effectView.mas_right).with.offset(-20);
        //        make.width.and.height.equalTo(@30);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(effectTodetail)];
    tapGesture.numberOfTapsRequired = 1;
    
    [_effectView addGestureRecognizer:tapGesture];*/
    
    NSLog(@"EffectView height = %f", _effectView.frame.size.height);
}
//食材view
- (void)initMaterialView {
    _materialView = [[UIView alloc] init];
    _materialView.backgroundColor = [UIColor whiteColor];
    
    [_verticalScrollViewContainer addSubview:_materialView];
    
    _videoPreviewImageView = [[UIImageView alloc] init];
    _videoPreviewImageView.image = [self getVideoPreviewImageWithUrl:_data.videoUrl];
    //    _videoPreviewImageView.image = [self getVideoPreviewImageWithUrl:url andTimestamp:videoDuration];
    //    _videoPreviewImageView.image = [self getVideoPreviewImageWithUrl:url];
    _videoPreviewImageView.userInteractionEnabled = YES;
    
    [_materialView addSubview:_videoPreviewImageView];
    
    [_videoPreviewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_materialView).with.offset(5);
        make.left.equalTo(_materialView).with.offset(5);
        make.right.equalTo(_materialView).with.offset(-5);
        make.height.mas_equalTo(@150);
    }];
//    播放视频
    _videoStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_videoStartButton setImage:[UIImage imageNamed:@"playBtn"] forState:UIControlStateNormal];
    [_videoStartButton addTarget:self action:@selector(videoStartButtonPress) forControlEvents:UIControlEventTouchUpInside];
    //    _videoStartButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [_videoPreviewImageView addSubview:_videoStartButton];
    [_videoStartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(_videoPreviewImageView);
        make.width.and.height.equalTo(@60);
    }];
    
    _materialTitleImageView = [[UIImageView alloc] init];
    UIImage *materialTitleImage = [UIImage imageNamed:@"flag"];
    materialTitleImage = [materialTitleImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _materialTitleImageView.image = materialTitleImage;
    [_materialView addSubview:_materialTitleImageView];
    [_materialTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_videoPreviewImageView.mas_bottom).with.offset(10);
        make.left.equalTo(_materialView).with.offset(10);
        make.width.and.height.equalTo(@25);
    }];
    
    UILabel *materialTitleLabel = [[UILabel alloc] init];
    materialTitleLabel.text = NSLocalizedString(@"cailiao", @"");
    materialTitleLabel.textColor = [AppConstants themeColor];
    [_materialView addSubview:materialTitleLabel];
    [materialTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_materialTitleImageView.mas_centerY);
        make.left.equalTo(_materialTitleImageView.mas_right).with.offset(10);
    }];
    /*
    UIImageView *materialContentImageView = [[UIImageView alloc] init];
    UIImage *materialContentImage = [UIImage imageNamed:@"banana.jpg"];
    materialContentImage = [materialContentImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    materialContentImageView.image = materialContentImage;
    [_materialView addSubview:materialContentImageView];
    [materialContentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_materialTitleImageView.mas_bottom).with.offset(10);
        make.left.equalTo(_materialTitleImageView);
        make.width.and.height.equalTo(@80);
    }];
    
    UILabel *materialContentLabel = [[UILabel alloc] init];
    materialContentLabel.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
    materialContentLabel.textColor = [UIColor lightGrayColor];
    materialContentLabel.numberOfLines = 0;
    [_materialView addSubview:materialContentLabel];
    [materialContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(materialContentImageView);
        make.left.equalTo(materialContentImageView.mas_right).with.offset(10);
        make.right.equalTo(_materialView.mas_right).with.offset(-20);
        make.height.greaterThanOrEqualTo(materialContentImageView);
        make.top.equalTo(materialContentImageView).with.priority(1000);
        make.centerY.equalTo(materialContentImageView).with.priority(500);
    }];*/
    
    UILabel *materialContentLabel = [[UILabel alloc] init];
    materialContentLabel.text = _data.ingredients;
//    materialContentLabel.textColor = [UIColor lightGrayColor];
    materialContentLabel.numberOfLines = 0;
    [_materialView addSubview:materialContentLabel];
    [materialContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(materialContentImageView);
        make.left.equalTo(_materialView).with.offset(30);
        make.right.equalTo(_materialView).with.offset(-10);
//        make.height.greaterThanOrEqualTo(materialContentImageView);
        make.top.equalTo(_materialTitleImageView.mas_bottom).with.offset(20);
//        make.centerY.equalTo(materialContentImageView).with.priority(500);
    }];
    
    [_materialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_effectView.mas_bottom).with.offset(3);
        make.bottom.equalTo(materialContentLabel.mas_bottom);
    }];
}
//步骤
- (void)initStepsView {

    _stepsView = [[UIView alloc] init];
    _stepsView.backgroundColor = [UIColor whiteColor];
    
    [_verticalScrollViewContainer addSubview:_stepsView];
    
    _stepsImageView = [[UIImageView alloc] init];
    UIImage *stepsImage = [UIImage imageNamed:@"step"];
    stepsImage = [stepsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _stepsImageView.image = stepsImage;
    [_stepsView addSubview:_stepsImageView];
    [_stepsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stepsView).with.offset(10);
        make.left.equalTo(_stepsView).with.offset(10);
        make.width.and.height.equalTo(@25);
    }];
    
    UILabel *stepsTitleLabel = [[UILabel alloc] init];
    stepsTitleLabel.text = NSLocalizedString(@"buzhou", @"");
    stepsTitleLabel.textColor = [AppConstants themeColor];
    [_stepsView addSubview:stepsTitleLabel];
    [stepsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_stepsImageView.mas_centerY);
        make.left.equalTo(_stepsImageView.mas_right).with.offset(10);
    }];
    
//    NSUInteger stepsCount = 1;
//    步骤数组个数
    NSUInteger stepsCount = [_introduceDetailDataModel.originalImageUrlArray count];
//    NSLog(@"stepsCount = %lu", (unsigned long)stepsCount);
    IntroduceDetailStepViewCell *lastView = nil;
    for (int i = 0; i < stepsCount; ++i) {
        
        NSString *remarkText = [NSString stringWithFormat:@"%@. %@", [_introduceDetailDataModel.idArray objectAtIndex:i], [_introduceDetailDataModel.remarkArray objectAtIndex:i]];
        
        NSString *imageUrl = [_introduceDetailDataModel.originalImageUrlArray objectAtIndex:i];
        
        IntroduceDetailStepViewCell *stepView = [[IntroduceDetailStepViewCell alloc] initWithRemark:remarkText AndImageUrl:imageUrl AndTag:i];
        stepView.delegate = self;
        
        [_stepsView addSubview:stepView];
        
        [stepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(_stepsView);
            make.bottom.mas_equalTo(stepView.imageView).with.offset(10);
            
            if ( lastView )
            {
                make.top.mas_equalTo(lastView.mas_bottom);
            }
            else
            {
                make.top.mas_equalTo(_stepsImageView.mas_bottom).with.offset(10);
            }
        }];
        
        lastView = stepView;
    }
    
    if (lastView != nil) {
        [_stepsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(_verticalScrollViewContainer);
            make.top.equalTo(_materialView.mas_bottom).with.offset(3);
            make.bottom.equalTo(lastView).with.offset(10);
        }];
    }
    else {
        [_stepsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(_verticalScrollViewContainer);
            make.top.equalTo(_materialView.mas_bottom).with.offset(3);
            make.bottom.equalTo(_stepsImageView.mas_bottom).with.offset(10);
        }];
    }
    

    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_stepsView.mas_bottom);
    }];
 
}

- (void)stepViewCellTouch:(NSInteger)index {
    /*
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = _stepsView; // 原图的父控件
    browser.imageCount = [_introduceDetailDataModel.originalImageArray count]; // 图片总数
    browser.currentImageIndex = (int)index;
    browser.delegate = self;
    [browser show];
    */
    NSLog(@"touchtouchtouch %ld", (long)index);
}
//评论view
- (void)initCommentView {
    _separatedView = [[UIView alloc] init];
    _separatedView.backgroundColor = [UIColor grayColor];
    [_verticalScrollViewContainer addSubview:_separatedView];
    [_separatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_stepsView.mas_bottom);
        make.height.equalTo(@3);
    }];
    
    _commentDataModel = _commentDataModelTemp;
    
    _commentView = [[CommentContainer alloc] init];
    _commentView.imageNameArray = _commentDataModel.imageNameArray;
    _commentView.nameArray = _commentDataModel.nameArray;
    _commentView.timeArray = _commentDataModel.timeArray;
    _commentView.contentArray = _commentDataModel.contentArray;
    _commentView.backgroundColor = [UIColor whiteColor];
    
    [_verticalScrollViewContainer addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_separatedView.mas_bottom);
    }];
    
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_commentView.mas_bottom);
    }];
}

/*
- (void)showComment {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentRequestDone" object:nil];
    NSLog(@"updateConstraints");
    
    _commentView.imageNameArray = _commentDataModel.imageNameArray;
    _commentView.nameArray = _commentDataModel.nameArray;
    _commentView.timeArray = _commentDataModel.timeArray;
    _commentView.contentArray = _commentDataModel.contentArray;
    
    [_commentView updateConstraints];
}*/
//评论超过5条
- (void)setupFooter {
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    refreshFooter.delegate = self;
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshFooter addToScrollView:_verticalScrollView];
    
    __weak SDRefreshFooterView *weakRefreshFooter = refreshFooter;
    refreshFooter.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"Refreshing");
            
            [NSThread detachNewThreadSelector:@selector(loadMoreComment) toTarget:self withObject:nil];
            
            [weakRefreshFooter endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    //    [refreshHeader beginRefreshing];
}

- (void)loadMoreComment {
    
    if ([_commentDataModel.nameArray count] % 10 != 0) {
        _commentCount = (int)[_commentDataModel.nameArray count];
//        [ProgressHUD showSuccess:NSLocalizedString(@"nomorecomment", @"")];
        
        return;
    }
    else {
        _commentCount += 10;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCommentView) name:@"commentRequestUpdateDone" object:nil];

    _commentDataModelTemp = [[CommentDataModel alloc] initWithFormulaId:_data.formulaID AndCommentCount:_commentCount forUpdate:YES];
}

- (void)effectTodetail{
    NSLog(@"here");
}

- (void)readAll {
    NSLog(@"readAll");
}

- (void)uploadButtonPress {
    NSLog(@"uploadButtonPress");
}
/*
- (void)playbackstateDidChange:(NSNotification *)noti
{
//    [_videoStartButton removeFromSuperview];
    
    switch (_player.playbackState) {
        case MPMoviePlaybackStateInterrupted:
            //中断
            NSLog(@"中断");
            break;
        case MPMoviePlaybackStatePaused:
            //暂停
            NSLog(@"暂停");
            break;
        case MPMoviePlaybackStatePlaying:
            //播放中
            NSLog(@"播放中");
            break;
        case MPMoviePlaybackStateSeekingBackward:
            //后退
            NSLog(@"后退");
            break;
        case MPMoviePlaybackStateSeekingForward:
            //快进
            NSLog(@"快进");
            break;
        case MPMoviePlaybackStateStopped:
            //停止
            NSLog(@"停止");
            break;
            
        default:
            break;
    }
}*/

- (void)playDidFinish:(NSNotification *)noti
{
    NSLog(@"播放完成");
    NSLog(@"noti.object %@",noti.object);
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).isPlayingVideo = NO;
}

- (void)playerWillEnterFullScreen {
    NSLog(@"进入全屏");
    
//    [_player setFullscreen:NO animated:NO];
//    [_player setControlStyle:MPMovieControlStyleEmbedded];
}
//播放视频使用的是MPMoviePlayerViewController 可更改性差
- (void)videoStartButtonPress {
    
    NSLog(@"videoStartButtonPress");
    
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).isPlayingVideo = YES;
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppConstants httpVideoHeader], _data.videoUrl];
    
    NSURL *movieURL = [NSURL URLWithString:url];
    NSLog(@"NSURL *movieURL = [NSURL URLWithString:url];     %@",movieURL);
    /*
    UIWebView *webView=[[UIWebView alloc] init];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:movieURL]];
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];*/
    
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    [self presentMoviePlayerViewControllerAnimated:movieController];
    [movieController.moviePlayer play];
    
//    [_player play];
}

/*
 * 点击输入框代理方法
 */
- (void)inputTextViewWillBeginEditing:(MessageTextView *)messageInputTextView{
    
}

- (void)inputTextViewDidBeginEditing:(MessageTextView *)messageInputTextView
{
    /*
    [self messageViewAnimationWithMessageRect:keyboardRect
                     withMessageInputViewRect:self.messageToolView.frame
                                  andDuration:animationDuration
                                     andState:ZBMessageViewStateShowNone];
    */
}

- (void)inputTextViewDidChange:(MessageTextView *)messageInputTextView
{
    NSLog(@"messageInputTextView.text = %@", messageInputTextView.text);
//    CGFloat maxHeight = [MessageInputView maxHeight];
//    CGSize size = [messageInputTextView sizeThatFits:CGSizeMake(CGRectGetWidth(messageInputTextView.frame), maxHeight)];
//    CGFloat textViewContentHeight = size.height;
    /*
    // End of textView.contentSize replacement code
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        
        [UIView animateWithDuration:0.01f
                         animations:^{
                             
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageToolView.frame;
                             self.messageToolView.frame = CGRectMake(0.0f,
                                                                     inputViewFrame.origin.y - changeInHeight,
                                                                     inputViewFrame.size.width,
                                                                     inputViewFrame.size.height + changeInHeight);
                             
                             if(!isShrinking) {
                                 [self.messageToolView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }*/
}

- (int)searchFaceStr {
    
    int location = -1;
    
    NSString *str = _messageInputView.messageInputTextView.text;
    NSUInteger strLength = [str length];
    NSString *lastChar = [str substringWithRange:NSMakeRange(strLength - 1,1)];
    if ([lastChar isEqualToString:@"]"]) {
        NSRange range = [str rangeOfString:@"["options:NSBackwardsSearch];
        //判别查找到的字符串是否正确
        if (range.length> 0) {
            location = (int)range.location;
        }
    }

    return location;
}

- (void)deleteFaceStr:(int)location {
    NSString *str = _messageInputView.messageInputTextView.text;
    
    _messageInputView.messageInputTextView.text = [str substringWithRange:NSMakeRange(0, location)];
}

#pragma mark - ZBMessageFaceViewDelegate
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele
{
    if (dele) {
        int location = [self searchFaceStr];
        if (location != -1) {
            [self deleteFaceStr:location];
        }
        else {
            [_messageInputView.messageInputTextView deleteBackward];
            
        }
        return;
    }
    
    _messageInputView.messageInputTextView.text = [_messageInputView.messageInputTextView.text stringByAppendingString:faceStr];
    [self inputTextViewDidChange:_messageInputView.messageInputTextView];
    
    [_messageInputView.messageInputTextView scrollRangeToVisible:NSMakeRange(_messageInputView.messageInputTextView.text.length, 1)];
}

- (void)reloadCommentView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentRequestUpdateDone" object:nil];
    
    [_commentView removeFromSuperview];
//    用户的头像，名称，时间，内容
    _commentDataModel = _commentDataModelTemp;
    _commentView = [[CommentContainer alloc] init];
    _commentView.imageNameArray = _commentDataModel.imageNameArray;
    _commentView.nameArray = _commentDataModel.nameArray;
    _commentView.timeArray = _commentDataModel.timeArray;
    _commentView.contentArray = _commentDataModel.contentArray;
    _commentView.backgroundColor = [UIColor whiteColor];
    
    [_verticalScrollViewContainer addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_separatedView.mas_bottom);
    }];
    
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_commentView.mas_bottom);
    }];
    /*
    if (_commentCount == 10) {
        [self rollTheScrollViewToBottom:NO];
    }
    else {
        [self rollTheScrollViewToBottom:YES];
    }*/
}

- (void)rollTheScrollViewToBottom:(BOOL)isToBottom {
    if (!isToBottom) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [_verticalScrollView setContentOffset:CGPointMake(0, _commentViewY) animated:NO];
            }completion:nil];
        });
    }
    /*
    else {
        [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [_verticalScrollView setContentOffset:CGPointMake(0, _totalHeight) animated:NO];
        }completion:nil];
    }*/
    
    
    /*
    [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (_totalHeight - _commentViewY > [AppConstants uiScreenHeight]) {
            [_verticalScrollView setContentOffset:CGPointMake(0, _totalHeight - [AppConstants uiScreenHeight] + [AppConstants uiNavigationBarHeight] + 45) animated:NO];
            
            NSLog(@">");
        }
        else {
            NSLog(@"<");
            [_verticalScrollView setContentOffset:CGPointMake(0, _totalHeight - [AppConstants uiScreenHeight] + 250) animated:NO];
        }
        
    }completion:nil];*/
}

- (void)sendComment:(NSString*)comment {/*
    
    if ([[AppConstants userInfo].accessToken isEqualToString:@""]) {
        
        [ProgressHUD showError:NSLocalizedString(@"dengluzaipinglun", @"")];
        
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *urlString = [NSString stringWithFormat:@"%@interaction/formula/comment/post/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"AccessToken": [AppConstants userInfo].accessToken, @"formulaId":_data.formulaID, @"Content":comment};
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              NSLog(@"%@ Success: %@", urlString, responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  [ProgressHUD showSuccess:NSLocalizedString(@"pinglunchenggong", @"")];
                  
                  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCommentView) name:@"commentRequestUpdateDone" object:nil];
                  
                  _commentDataModelTemp = [[CommentDataModel alloc] initWithFormulaId:_data.formulaID AndCommentCount:_commentCount forUpdate:YES];
              }
              else if ([[responseObject objectForKey:@"errno"] isEqualToString:@"4401"]) {
                  [AppConstants relogin:^(BOOL success){
                      if (success) {
                          [self sendComment:comment];
                      }
                      else {
                          [AppConstants notice2ManualRelogin];
                      }
                  }];
              }
              else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                  [ProgressHUD showError:NSLocalizedString(@"pinglunshibai", @"")];
              }

          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              NSLog(@"Error: %@", error);

              [ProgressHUD showError:NSLocalizedString(@"badNetwork", @"")];
          }];
*/}

/*
#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)req {
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@", req.openID];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    alert.tag = 1000;
    [alert show];
}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //显示微信传过来的内容
    WXAppExtendObject *obj = msg.mediaObject;
    
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", req.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //从微信启动App
    NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", req.openID, msg.messageExt];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    if (response.errCode == 0) {
        [ProgressHUD showSuccess:NSLocalizedString(@"fenxiangchenggong", @"")];
    }
    else {
        [ProgressHUD showSuccess:NSLocalizedString(@"fenxiangshibai", @"")];
    }
}

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response {
    NSMutableString* cardStr = [[NSMutableString alloc] init];
    for (WXCardItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%u\n",cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"add card resp"
                                                    message:cardStr
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}
*/
#pragma mark - Refresh delegate
- (void)viewWillRefresh {
    NSLog(@"viewWillRefresh");
    //    [self removeClickedObservers];
    
    _verticalScrollView.userInteractionEnabled = NO;
}

- (void)viewDidRefresh {
    NSLog(@"viewDidRefresh");
    
    _verticalScrollView.userInteractionEnabled = YES;
}

#pragma mark - MessageInputViewDelegate

- (void)didSendTextAction:(MessageTextView *)messageInputTextView {
    NSLog(@"text = %@", messageInputTextView.text);
    
    _messageInputView.faceButtonSelected = NO;
    [_messageInputView.faceSendButton setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7"] forState:UIControlStateNormal];
    [_messageInputView.messageInputTextView resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
            }];
            
            [_faceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_bottom);
            }];
            
            [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
            }];
            
            [_faceView layoutIfNeeded];
            [_messageInputView layoutIfNeeded];
            [_verticalScrollView layoutIfNeeded];
        }completion:nil];
    });
    
    [self sendComment:messageInputTextView.text];
    
    messageInputTextView.text = @"";
}

- (void)didSendFaceAction:(BOOL)sendFace{
    
    if (sendFace) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).with.offset(-196);
                }];
                [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).with.offset(-196);
                }];
                [_faceView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_bottom).with.offset(-196);
                }];
                
                [_messageInputView layoutIfNeeded];
                [_verticalScrollView layoutIfNeeded];
                [_faceView layoutIfNeeded];
            }completion:nil];
        });
        
    }
    else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view).with.offset(-_keyboardRect.size.height);
                }];
                [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).with.offset(-_keyboardRect.size.height);
                }];
                [_faceView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_bottom);
                }];
                
                [_messageInputView layoutIfNeeded];
                [_verticalScrollView layoutIfNeeded];
                [_faceView layoutIfNeeded];
            }completion:nil];
        });

    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"dragging");
    
    _messageInputView.faceButtonSelected = NO;
    [_messageInputView.faceSendButton setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7"] forState:UIControlStateNormal];
    [_messageInputView.messageInputTextView resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
            }];
            
            [_faceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_bottom);
            }];
            
            [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
            }];
            
            [_faceView layoutIfNeeded];
            [_messageInputView layoutIfNeeded];
            [_verticalScrollView layoutIfNeeded];
        }completion:nil];
    });
}

#pragma BLEDelegate
// 扫描结束
-(void)bleSerilaComManagerDidEnumComplete:(BLESerialComManager *)bleSerialComManager{
    NSLog(@"scan complete");
    /*
    [_spinner stopAnimating];
    
    _tableview = [[UITableView alloc] init];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    [_tableview registerClass:[KitchenMachineTableViewCell class] forCellReuseIdentifier:@"MachineCell"];
    [_tableview reloadData];
    
    [self.view addSubview:_tableview];
    
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_spinner.mas_bottom);
        make.left.right.and.bottom.equalTo(self.view);
    }];*/
}

// 扫描到可用设备
-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager didFoundPort:(BLEPort *)port{
    if (port!=nil) {
        //        NSLog(@"name = %@, PORT_STATE = %ld, connectTimer = %@, discoverTimer = %@, writeBuffer = %@, readBuffer = %@, address = %@", port.name, (long)port.state, port.connectTimer, port.discoverTimer, port.writeBuffer, port.readBuffer, port.address);
        
//        [_machineArray addObject:port];
    }
}

//打开端口结果
-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager didOpenPort:(BLEPort *)port withResult:(resultCodeType)result{
    if (result == RESULT_SUCCESS) {
        
        [BTConstants BTSetConnected:YES];
        [BTConstants BTSetCurrentPort:port];
        
        /*
        NSLog(@"连接成功");
        
        [_spinner stopAnimating];
        
        _kitchenMachineViewController = [[KitchenMachineViewController alloc] initWithPort:_currentPort];
        
        _kitchenMachineViewController.view.backgroundColor = [UIColor whiteColor];
        
        _kitchenMachineViewController.hidesBottomBarWhenPushed = YES;
        
        [BLESerialComManager sharedInstance].delegate = _kitchenMachineViewController;
        
        [self.navigationController pushViewController:_kitchenMachineViewController animated:YES];
        
        _kitchenMachineViewController = nil;*/
    }
}

// 关闭端口
-(void)bleSerialComManager:(BLESerialComManager *)bleSerialComManager didClosedPort:(BLEPort *)port{
    NSLog(@"didClosedPort");
    
    [BTConstants BTSetConnectedMachineName:@""];
    [BTConstants BTSetConnected:NO];
    [BTConstants BTSetCurrentPort:nil];
    [BTConstants BTSetAvailable:NO];
    [BTConstants BTSetStatus:BTStatusNotReady];
//    [BTConstants BTSetStepTotalTime:0];
}

// 状态改变
-(void)bleSerilaComManagerDidStateChange:(BLESerialComManager *)bleSerialComManager{
    /*
     NSString *stateStrings[6] = {@"CENTRAL_STATE_UNKNOWN",
     @"CENTRAL_STATE_RESETTING",
     @"CENTRAL_STATE_UNSUPPORTED",
     @"CENTRAL_STATE_UNAUTHORIZED",
     @"CENTRAL_STATE_POWEREDOFF",
     @"CENTRAL_STATE_POWEREDON"
     };
     
     NSString *message = [@"state change to " stringByAppendingString:stateStrings[bleSerialComManager.state]];
     
     
     UIAlertView *stateChangeAlert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:message delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:nil, nil];
     [stateChangeAlert show];*/
}

-(void)bleSerialComManager:(BLESerialComManager *)bleSerialComManager port:(BLEPort *)port didReceivedPackage:(NSData *)package{
    
    
    
}

-(void)bleSerialComManager:(BLESerialComManager *)bleSerialComManager didDataReceivedOnPort:(BLEPort *)port withLength:(unsigned int)length{
    
    
    NSLog(@"read data!!!!");
    
    NSData *recData = [bleSerialComManager readDataFromPort:port withLength:length];
    NSString *data = [[NSString alloc] initWithData:recData encoding:NSUTF8StringEncoding];
    NSLog(@"DetailViewController package is : %@ D7_1 = %@",data, [BTConstants D7_1]);
    
    if ([[BTConstants BTRequestType] isEqualToString:@"download"]) {
        
        [BTConstants BTSetRequestType:@""];
        
        if ([data hasPrefix:@"SBT:B9040002"] || [data hasPrefix:@"SBT:B9040010"]) {
            [ProgressHUD showError:NSLocalizedString(@"tishijiesuo", @"")];
        }
        else {
            [NSThread detachNewThreadSelector:@selector(downloadTimeUp) toTarget:self withObject:nil];
            
            [ProgressHUD show:NSLocalizedString(@"xiafacaipuzhong", @"")];
            
            [BTConstants BTSetDownloadingSteps:YES];
            
            _currentStepIndex = 0;
            
            NSString *countStr = [[NSString alloc] initWithFormat:@"%02x",(int)[_stepArray count]];
            
            [BTConstants BTSetRequestType:@"C5"];
            [BTConstants sendCommand:[BTConstants C5:countStr]];
        }
        
        return;
    }
    
    if ([data hasPrefix:@"SBT:D207"]) {
        if ([BTConstants BTStatus] != BTStatusRunning) {
            [BTConstants BTSetStatus:BTStatusRunning];
        }
    }
    
    if ([data hasPrefix:@"SBT:BA0205"]) {
        [ProgressHUD showError:NSLocalizedString(@"shebeiyiduankai", @"")];
        
        [[BLESerialComManager sharedInstance] closePort:[BTConstants BTcurrentPort]];
        
        [BTConstants BTResetStatus];
        
        return;
    }
    
    if ([data hasPrefix:@"SBT:BA0201"]) {
        [ProgressHUD showError:NSLocalizedString(@"jiqiyijiesuo", @"")];
        
        return;
    }
    
    if ([data hasPrefix:@"SBT:BA0203"]) {
        [ProgressHUD showError:NSLocalizedString(@"beiziweifanghao", @"")];
        
        return;
    }
    
    if ([data hasPrefix:@"SBT:BA0202"]) {
        [ProgressHUD showSuccess:NSLocalizedString(@"beiziyifanghao", @"")];
        
        return;
    }
    
    if ([data hasPrefix:@"SBT:B9040001"]) {
        [BTConstants BTSetStatus:BTStatusReady];
        return;
    }
    
    if ([data hasPrefix:@"SBT:B90400"]) {
        if ([data hasPrefix:@"SBT:B9040010"] && [BTConstants BTConnected]) {
            
            [[BLESerialComManager sharedInstance] closePort:[BTConstants BTcurrentPort]];
            
            [BTConstants BTSetConnectedMachineName:@""];
            [BTConstants BTSetConnected:NO];
            [BTConstants BTSetCurrentPort:nil];
            [BTConstants BTSetAvailable:NO];
            [BTConstants BTSetStatus:BTStatusNotReady];

            [ProgressHUD showError:NSLocalizedString(@"shebeiyiduankai", @"")];
            
            return;
        }
        
        if ([data hasPrefix:@"SBT:B9040002"]) {
            [BTConstants BTSetAvailable:NO];
        }
        else {
            [BTConstants BTSetAvailable:YES];
        }
    }
    
    if ([BTConstants BTStatus] == BTStatusRunning || [BTConstants BTStatus] == BTStatusReady) {
        if ([data length] >= 16 && [data hasPrefix:@"SBT:D207"]) {
            NSString *timeRemain = [data substringWithRange:NSMakeRange(11, 4)];
            
            NSLog(@"timeRemain = %@", timeRemain);
            
            if ([BTConstants BTStatus] == BTStatusRunning) {
                
                if ([BTConstants turnString2Time:timeRemain] == 0) {
                    [BTConstants BTSetStatus:BTStatusDone];
                }
            }
            else if ([BTConstants BTStatus] == BTStatusReady) {
                
                [BTConstants BTSetStatus:BTStatusRunning];
                
            /*
                if ([BTConstants BTStepTotalTime] == 0) {
                    [BTConstants BTSetStepTotalTime:[BTConstants turnString2Time:timeRemain]];
                    [BTConstants BTSetStatus:BTStatusRunning];
                }
             */
            }
        }
    }
    
    if ([[BTConstants BTRequestType] isEqualToString:@"C7"]) {
        [BTConstants BTSetRequestType:@""];
        if ([data hasPrefix:@"SBT:BF02C7"] && _currentStepIndex != -1) {
            [self downloadStepToMachine];
        }
    }
    else if ([[BTConstants BTRequestType] isEqualToString:@"C2"]) {
        [BTConstants BTSetRequestType:@""];
        if ([data length] > 12) {
            if ([[data substringWithRange:NSMakeRange(0, 12)] isEqualToString:@"SBT:BF02C200"]) {
                [ProgressHUD showSuccess:NSLocalizedString(@"xiafacaipuchenggong", @"")];
                
                if ([_stepArray count] != 0) {
                    [BTConstants BTSetStepTotalTime:[self getStepTotalTime:[_stepArray objectAtIndex:0]]];
                }
                
                [BTConstants BTSetStatus:BTStatusReady];
                [BTConstants BTSetCurrentRecipeName:_data.formulaName];
                [BTConstants BTSetCurrentRecipeImageName:_data.imageUrl];
                
                [AppConstants setDownloadButtonPress2Pop:YES];
                
                [NSThread detachNewThreadSelector:@selector(timedPop) toTarget:self withObject:nil];
            }
            else {
                [ProgressHUD showError:NSLocalizedString(@"xiafacaipushibai", @"")];
                
                [BTConstants BTSetStatus:BTStatusNotReady];
                [BTConstants BTSetCurrentRecipeName:@""];
                [BTConstants BTSetCurrentRecipeImageName:@""];
            }
        }
        [BTConstants BTSetDownloadingSteps:NO];
    }
    else if ([[BTConstants BTRequestType] isEqualToString:@"C5"]) {
        [BTConstants BTSetRequestType:@""];
        if ([data length] > 12) {
            if ([[data substringWithRange:NSMakeRange(0, 12)] isEqualToString:@"SBT:BF02C500"]) {
                [self downloadStepToMachine];
            }
            else {
//                [ProgressHUD showError:@"申请下载菜谱失败"];
                [ProgressHUD showError:NSLocalizedString(@"tishijiesuo", @"")];
                [BTConstants BTSetDownloadingSteps:NO];
                [BTConstants BTSetStatus:BTStatusNotReady];
                [BTConstants BTSetCurrentRecipeName:@""];
                [BTConstants BTSetCurrentRecipeImageName:@""];
            }
        }
    }
}

- (unsigned long)getStepTotalTime:(NSString*)stepStr {
    
    NSString *number1 = [stepStr substringWithRange:NSMakeRange(8, 1)];
    NSString *number2 = [stepStr substringWithRange:NSMakeRange(9, 1)];
    NSString *number3 = [stepStr substringWithRange:NSMakeRange(10, 1)];
    NSString *number4 = [stepStr substringWithRange:NSMakeRange(11, 1)];
    
    int totalTime = ([self turnString2Int:number1] * 16 * 16 * 16) + ([self turnString2Int:number2] * 16 * 16) + ([self turnString2Int:number3] * 16) + ([self turnString2Int:number4]);
    NSLog(@"stepStr = %@", stepStr);
    NSLog(@"totalTime = %d", totalTime);
    
    return totalTime;
}

- (int)turnString2Int:(NSString*)str {
    if ([str isEqualToString:@"A"] || [str isEqualToString:@"a"]) {
        return 10;
    }
    else if ([str isEqualToString:@"B"] || [str isEqualToString:@"b"]) {
        return 11;
    }
    else if ([str isEqualToString:@"C"] || [str isEqualToString:@"c"]) {
        return 12;
    }
    else if ([str isEqualToString:@"D"] || [str isEqualToString:@"d"]) {
        return 13;
    }
    else if ([str isEqualToString:@"E"] || [str isEqualToString:@"e"]) {
        return 14;
    }
    else if ([str isEqualToString:@"F"] || [str isEqualToString:@"f"]) {
        return 15;
    }
    else {
        return [str intValue];
    }
}

#pragma mark QQ login message

- (void)tencentDidLogin {

}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
}

- (void)dealloc {
    NSLog(@"dealloc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
