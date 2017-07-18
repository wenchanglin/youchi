//
//  KitchenMachineViewController.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/6.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "KitchenMachineViewController.h"
#import "AppConstants.h"

@interface KitchenMachineViewController ()

@property (strong, nonatomic) GIFImageView          *gifView;
@property (strong, nonatomic) NSData                *gifData;
@property (strong, nonatomic) UILabel               *progressTipLabel;
@property (strong, nonatomic) UILabel               *speedTipLabel;
@property (strong, nonatomic) ProgressPopUpView     *progressView;
@property (strong, nonatomic) ProgressPopUpView     *speedView;
@property (nonatomic) unsigned long                 totalTime;

@end

@implementation KitchenMachineViewController

- (instancetype)initWithPort:(BLEPort*)port {
    if (self = [super init]) {
        
        _port = port;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationBar];
    [self initViews];
}

- (void)initNavigationBar {
//    self.navigationController.navigationBar.barTintColor = [AppConstants themeColor];
    self.navigationItem.title = _port.name;
}

- (void)initViews {
    
    
    _gifView = [[GIFImageView alloc] init];
    _gifView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_gifView];
    // notice: before start, content is nil. You can set image for yourself
    [_gifView startGIF];
    
    [_gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view).with.offset(70);
        make.right.equalTo(self.view).with.offset(-70);
        make.height.equalTo(self.view.mas_width);
    }];
    
    _progressTipLabel = [[UILabel alloc] init];
    _progressTipLabel.textColor = [AppConstants themeColor];
    _progressTipLabel.text = NSLocalizedString(@"progress", @"");
    [self.view addSubview:_progressTipLabel];
    [_progressTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_gifView.mas_bottom).with.offset(20);
        make.left.equalTo(self.view).with.offset(30);
        make.height.equalTo(@20);
    }];
    
    _speedTipLabel = [[UILabel alloc] init];
    _speedTipLabel.textColor = [AppConstants themeColor];
    _speedTipLabel.text = NSLocalizedString(@"speed", @"");
    [self.view addSubview:_speedTipLabel];
    [_speedTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressTipLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(30);
        make.height.equalTo(@20);
    }];
    
    _progressView = [[ProgressPopUpView alloc] init];
    _progressView.layer.cornerRadius = 3;
    _progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
    _progressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
    [_progressView showPopUpViewAnimated:YES];
    [self.view addSubview:_progressView];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_progressTipLabel);
        make.left.equalTo(self.view).with.offset(100);
        make.right.equalTo(self.view).with.offset(-30);
        make.height.equalTo(@6);
    }];
    
    _speedView = [[ProgressPopUpView alloc] init];
    _speedView.layer.cornerRadius = 3;
    _speedView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
    _speedView.popUpViewAnimatedColors = @[[UIColor greenColor], [UIColor orangeColor], [UIColor redColor]];
    [_speedView hidePopUpViewAnimated:NO];
    [self.view addSubview:_speedView];
    
    [_speedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_speedTipLabel);
        make.left.equalTo(self.view).with.offset(100);
        make.right.equalTo(self.view).with.offset(-30);
        make.height.equalTo(@6);
    }];
    
    // 读取gif图片数据
    if ([BTConstants BTStatus] == BTStatusReady) {
        _gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"gif_3" ofType:@"gif"]];
    }
    else if ([BTConstants BTStatus] == BTStatusRunning) {
        _gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"gif_1" ofType:@"gif"]];
    }
    else if ([BTConstants BTStatus] == BTStatusDone) {
        _gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"gif_6" ofType:@"gif"]];
        [self setProgress:0];
    }
    _gifView.gifData = _gifData;
    [_gifView startGIF];
}

- (void)setProgress:(unsigned long)timeRemain {
    float percentage = (double)([BTConstants BTStepTotalTime] - timeRemain) / (double)[BTConstants BTStepTotalTime];
    
    NSLog(@"BTStepTotalTime = %lu, timeRemain = %lu, %f", [BTConstants BTStepTotalTime], timeRemain, percentage);
    
    [_progressView setProgress:percentage];
    
    if (percentage >= 1.0) {
        NSLog(@"done");
        
//        [BTConstants BTSetStepTotalTime:0.0];
        [BTConstants BTSetStatus:BTStatusDone];
        
        [_gifView stopGIF];
        _gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"gif_6" ofType:@"gif"]];
        _gifView.gifData = _gifData;
        [_gifView startGIF];
    }
}

- (void)setSpeedProgress:(int)speed {
//    _speedTipLabel.text = [NSString stringWithFormat:@"转速: %d rpm", speed];
    [_speedView setProgress:(double)speed / 15000.0];
}

- (int)turnSpeedLevel2Speed:(NSString*)speedLevel {
    if ([speedLevel isEqualToString:@"00"]) {
        return 0;
    }
    else if ([speedLevel isEqualToString:@"01"]) {
        return 2000;
    }
    else if ([speedLevel isEqualToString:@"02"]) {
        return 4000;
    }
    else if ([speedLevel isEqualToString:@"03"]) {
        return 5000;
    }
    else if ([speedLevel isEqualToString:@"04"]) {
        return 6000;
    }
    else if ([speedLevel isEqualToString:@"05"]) {
        return 7500;
    }
    else if ([speedLevel isEqualToString:@"06"]) {
        return 9000;
    }
    else if ([speedLevel isEqualToString:@"07"]) {
        return 10500;
    }
    else if ([speedLevel isEqualToString:@"08"]) {
        return 12000;
    }
    else if ([speedLevel isEqualToString:@"09"]) {
        return 13500;
    }
    else if ([speedLevel isEqualToString:@"0A"]) {
        return 15000;
    }
    else {
        return 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma BLEDelegate
// 扫描结束
-(void)bleSerilaComManagerDidEnumComplete:(BLESerialComManager *)bleSerialComManager{
    NSLog(@"scan complete");
    
}

// 扫描到可用设备
-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager didFoundPort:(BLEPort *)port{

}

//打开端口结果
-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager didOpenPort:(BLEPort *)port withResult:(resultCodeType)result{
    if (result == RESULT_SUCCESS) {
        [BTConstants BTSetConnected:YES];
        [BTConstants BTSetCurrentPort:port];
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
    
    [ProgressHUD showSuccess:NSLocalizedString(@"shebeiyiduankai", @"")];
    
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)bleSerialComManager:(BLESerialComManager *)bleSerialComManager port:(BLEPort *)port didReceivedPackage:(NSData *)packag
{
    
    
    
}

-(void)bleSerialComManager:(BLESerialComManager *)bleSerialComManager didDataReceivedOnPort:(BLEPort *)port withLength:(unsigned int)length{
    
    NSLog(@"read data!!!!");
    
    NSData *recData = [bleSerialComManager readDataFromPort:port withLength:length];
    NSString *data = [[NSString alloc] initWithData:recData encoding:NSUTF8StringEncoding];
    NSLog(@"KitchenMachine package is : %@",data);
    
    if ([data hasPrefix:@"SBT:D207"]) {
        if ([BTConstants BTStatus] != BTStatusRunning) {
            [BTConstants BTSetStatus:BTStatusRunning];
        }
    }
    
    if ([data hasPrefix:@"SBT:BA0205"]) {
        [ProgressHUD showError:NSLocalizedString(@"shebeiyiduankai", @"")];
        
        [[BLESerialComManager sharedInstance] closePort:[BTConstants BTcurrentPort]];
        
        [BTConstants BTResetStatus];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    if ([data hasPrefix:@"SBT:BA0201"]) {
        [ProgressHUD showError:NSLocalizedString(@"jiqiyijiesuo", @"")];
        
        return;
    }
    
    if ([data hasPrefix:@"SBT:BA0203"]) {
        [ProgressHUD showError:NSLocalizedString(@"beiziweifanghao", @"")];
        
        [_gifView stopGIF];
        
        _gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"gif_2" ofType:@"gif"]];
    
        _gifView.gifData = _gifData;
        [_gifView startGIF];
        
        return;
    }
    
    if ([data hasPrefix:@"SBT:BA0202"]) {
        [ProgressHUD showSuccess:NSLocalizedString(@"beiziyifanghao", @"")];
        
        [_gifView stopGIF];
        
        _gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"gif_4" ofType:@"gif"]];
        
        _gifView.gifData = _gifData;
        [_gifView startGIF];
        
        return;
    }

    if ([BTConstants BTStatus] == BTStatusRunning || [BTConstants BTStatus] == BTStatusReady || [BTConstants BTStatus] == BTStatusDone) {
        if ([data length] >= 16 && [data hasPrefix:@"SBT:D207"]) {
            NSString *speedLevel = [data substringWithRange:NSMakeRange(8, 2)];
            NSString *timeRemain = [data substringWithRange:NSMakeRange(11, 4)];
            
            NSLog(@"speedLevel = %@, speed = %d, timeRemain = %@, time = %lu", speedLevel, [self turnSpeedLevel2Speed:speedLevel], timeRemain, [BTConstants turnString2Time:timeRemain]);
            /*
            if ([BTConstants BTStepTotalTime] == 0) {
                [BTConstants BTSetStepTotalTime:[BTConstants turnString2Time:timeRemain]];
                
                [_gifView stopGIF];
                _gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"gif_1" ofType:@"gif"]];
                _gifView.gifData = _gifData;
                [_gifView startGIF];
            }*/
            
            [_gifView stopGIF];
            _gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"gif_1" ofType:@"gif"]];
            _gifView.gifData = _gifData;
            [_gifView startGIF];
            
            [BTConstants BTSetStatus:BTStatusRunning];
            [self setProgress:[BTConstants turnString2Time:timeRemain]];
            [self setSpeedProgress:[self turnSpeedLevel2Speed:speedLevel]];
        }
        else if ([data hasPrefix:@"SBT:B90400"] && [BTConstants BTStatus] != BTStatusDone) {
            
            if ([data hasPrefix:@"SBT:B9040010"]) {
                return;
            }
            
            NSString *str = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"currentmodeis", @""), [BTConstants BTMachineCurrnetMode:data]];
            
            [ProgressHUD showSuccess:str];
            
            if (![data hasPrefix:@"SBT:B9040020"]) {
                [BTConstants BTSetStatus:BTStatusReady];
//                [BTConstants BTSetStepTotalTime:0];
                [self.navigationController popViewControllerAnimated:YES];
            }
            /*
             if ([data hasPrefix:@"SBT:B9040020"]) {
             [BTConstants BTSetLocked:YES];
             }
             else {
             [BTConstants BTSetLocked:NO];
             }*/
            
            //        [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
    }
    
}

@end
