//
//  YCErweimaVC.m
//  YouChi
//
//  Created by sam on 15/6/15.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCGroupPurchaseMainVC.h"
#import "YCErweimaVC.h"
#import <AVFoundation/AVFoundation.h>
#import "YCWebVC.h"
#import <Regexer/NSArray+Regexer.h>
#import "YCCatolog.h"

#import "YCRecipeDetailVC.h"
#import "YCYouChiDetailVC.h"
#import "YCOthersInfoVC.h"
#import "YCNewsVC.h"
#import "YCVideosDetailVC.h"
#import "YCGuodanDetailVC.h"
@interface YCErweimaVC ()
@property (weak, nonatomic) IBOutlet UIImageView *qr;
@property (strong,nonatomic) YCQRScanningViewController *qrVC;
@end

@implementation YCErweimaVC

- (void)dealloc{
    //ok
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //if (![self.qr.layer animationForKey:cell]) {
        CGPoint center = CGPointMake(CGRectGetMidX(self.qr.superview.bounds), self.qr.center.y);
        CABasicAnimation * tranformAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        tranformAnimation.fromValue = [NSValue valueWithCGPoint:center];
        tranformAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(center.x, self.qr.superview.bounds.size.height*2)];
        tranformAnimation.duration = 2;
        tranformAnimation.autoreverses = NO;
        tranformAnimation.repeatCount = HUGE_VALF;
        [self.qr.layer addAnimation:tranformAnimation forKey:cell0];
    //}
    [self hideTabbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //{"action":"81","type":"3"}
    WSELF;
    _qrVC.resultBlock = ^(NSString *scanResult) {
        NSLog(@"%@",scanResult);
        SSELF;
        NSData *jsonData = [scanResult dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            [self showMessage:err.localizedDescription];
            return ;
        }

        id targetId = dic[@"action"];
        NSNumber *type = dic[@"type"];

        Class vcClass;
        id vm;
        switch (type.intValue) {
            case YCOriginalTypeUrl:
            {
                vm = [[YCWebVM alloc]initWithUrl:targetId];

                vcClass = [YCWebVC class];
            }
                break;
            case YCOriginalTypeUser:
            {
                vm = [[YCOthersInfoVM alloc]initWithId:targetId];
                vcClass = [YCOthersInfoVC class];
            }
                break;
            case YCOriginalTypeRecipe:
            {
                vm = [[YCRecipeDetailVM alloc]initWithId:targetId];
                vcClass = [YCRecipeDetailVC class];
            }
                break;
            case YCOriginalTypeMaterial:
            {
                vm = [[YCGuodanDetailVM alloc]initWithId:targetId];
                vcClass = [YCGuodanDetailVM class];
            }
                break;
            case YCOriginalTypeItem:
            {
                //vm = [[YCRecipeDetailVM alloc]initWithId:targetId];
                //vcClass = [YCRecipeDetailVC class];
                [self showMessage:@"未知信息"];
            }
                break;
            case YCOriginalTypeYouChi:
            {
                vm = [[YCYouChiDetailVM alloc]initWithId:targetId];
                vcClass = [YCYouChiDetailVC class];
            }
                break;
            case YCOriginalTypeNews:
            {
                vm = [[YCNewsVM alloc]initWithId:targetId];
                vcClass = [YCNewsVC class];
            }
                break;
            case YCOriginalTypeVideo:
            {
                vm = [[YCVideosDetailVM alloc]initWithId:targetId];
                vcClass = [YCVideosDetailVC class];
            }
                
            case YCOriginalTypeGroup:
            {
                YCGroupPurchaseMainVM *vmm = [[YCGroupPurchaseMainVM alloc]initWithParameters:@{@"groupBuyId":targetId}];
                vmm.isQrCode = YES;
                vm = vmm;
                vcClass = [YCGroupPurchaseMainVC class];
                
            }

                
                break;
            default:
                break;
        }
        if (vcClass && vm) {
            UIViewController *vc = [UIViewController vcClass:vcClass];
            
            if ([vm isKindOfClass:[YCGroupPurchaseMainVM class]]) {
                
                vc.navigationItem.leftBarButtonItem.action = @selector(onReturnToGroupBuy);
                vc.navigationItem.leftBarButtonItem.target = vc;
                
            }else{
                
                vc.navigationItem.leftBarButtonItem.action = @selector(onPopToRootVC);
                vc.navigationItem.leftBarButtonItem.target = vc;
            }

            vc.viewModel = vm;
            [self.navigationController pushViewController:vc animated:YES];
        }

    };

    _qrVC.errorBlock = ^(NSError *error) {
        SSELF;
        self.errorBlock(error);
    };
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _qrVC = segue.destinationViewController;
    
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


@interface YCQRScanningViewController ()
@property (nonatomic, strong, readwrite) NSArray *metadataObjectTypes;
@end
@implementation YCQRScanningViewController
@synthesize metadataObjectTypes;
- (void)dealloc{
    //ok
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ];
    }
    return self;
}

/*
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    self.isScanning = YES;
    NSString *result;
    
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([self.metadataObjectTypes containsObject:metadata.type]) {
            result = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }
    }
    
    if (result) {
        if (self.resultBlock) self.resultBlock(result);
    } else {
        if (self.errorBlock) {
            self.errorBlock(error(@"无法识别二维码"));
        }
    }
    self.isScanning = NO;
}
 */
@end