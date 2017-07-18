//
//  YCViewController.m
//  YouChi
//
//  Created by sam on 15/5/18.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewController.h"
#import "UIViewController+Action.h"
#import "MobClick.h"
#import <EDColor/EDColor.h>
#import <Toast/UIView+Toast.h>
#import "YCLoginVC.h"
@interface YCViewController ()

@end

@implementation YCViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass(self.class)];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    YCViewModel *vm = [self onCreateViewModel];
    YCViewController *vc = [super initWithCoder:aDecoder];
    [vc onSetupBackButton];
    vc.viewModel = vm;
    return vc;
}

- (instancetype)init
{
    YCViewModel *vm = [self onCreateViewModel];
    YCViewController *vc = [super init];
    [vc onSetupBackButton];
    vc.viewModel = vm;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    __weak UINavigationController *nav = self.navigationController;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)nav;
    
    
    [self onMainSignalExecute:nil];
}

- (id)onCreateViewModel
{
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setViewModel:self.viewModel];
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

- (YCErrorBlock)errorBlock
{
    if (!_errorBlock) {
        WSELF
        _errorBlock = ^(NSError *e){
            SSELF;
            [self.view endEditing:YES];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            if ([e isKindOfClass:[NSError class]]) {
                
                [window makeToast:e.localizedDescription duration:3 position:CSToastPositionCenter];
            }
            
            if (e.code == 805 || e.code == 806 || e.code ==  818 || e.code == 816) {
                if (self.viewModel.isActive) {
                    YCLoginVC *vc = [YCLoginVC vcClass:[YCLoginVC class]];
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }

        };
    }
    return _errorBlock;
}

- (YCExecutingBlock)executingBlock
{
    if (!_executingBlock) {
        WSELF;
        _executingBlock = ^(BOOL isExecuting){
            SSELF;

                if (isExecuting) {
                    [self.activityIndicatorView startAnimating];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.activityIndicatorView stopAnimating];
                    });
                }

        };
    }
    return _executingBlock;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    return nil;
//    if (!_activityIndicatorView) {
//        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        _activityIndicatorView.hidesWhenStopped = YES;
//        [self.view addSubview:_activityIndicatorView];
//        _activityIndicatorView.center = self.view.center;
//    }
//    return _activityIndicatorView;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end




@implementation YCPopViewController
- (void)onClose:(UIButton *)sender
{
    [self hideSlideMenu];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideSlideMenu];
}

@end


@implementation YCKeyboardViewController
{
    BOOL _keyboardDidAppeare;
    BOOL _keyboardDidChange;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    _keyboardDidAppeare = NO;
    _keyboardDidChange = NO;
}

- (void)cancelForKeyboardNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)registerForKeyboardNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [center addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [center addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
}



#pragma mark - noti

- (void)keyboardWillShow:(NSNotification*)aNotification
{
//    if (_keyboardDidAppeare) {
//        return;
//    }
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//216
    NSTimeInterval ti = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.bottomLayout.constant = kbSize.height;//+CGRectGetHeight(self.inputBar.frame);
    [UIView animateWithDuration:ti animations:^{
        [self.view layoutIfNeeded];
    }];
    _keyboardDidAppeare = YES;
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    NSTimeInterval ti = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.bottomLayout.constant = 0;
    [UIView animateWithDuration:ti animations:^{
        [self.view layoutIfNeeded];
        
    }];
    _keyboardDidAppeare = NO;
    _keyboardDidChange = NO;
    
}

- (void)keyboardWillChangeFrame:(NSNotification*)aNotification
{
//    if (!_keyboardDidChange) {
//        _keyboardDidChange = YES;
//        return;
//    }
//    
//    
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    
//    NSTimeInterval ti = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    self.bottomLayout.constant = kbSize.height;
//    [UIView animateWithDuration:ti animations:^{
//        [self.view layoutIfNeeded];
//    }];
//    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc
{
    [self cancelForKeyboardNotifications];
}

@end


@implementation YCViewController_v1
- (void)loadView
{
    [super loadView];
    self.view = self.yc_view = [[YCView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
@end