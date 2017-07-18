//
//  KitchenViewController.m
//  Fruit-juice-iOS6
//
//  Created by LICAN LONG on 15/7/13.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "KitchenViewController.h"
#import "KitchenMachineTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "KitchenMachineViewController.h"
#import "AppConstants.h"
#import "BLESerialComManager.h"
#import "Masonry.h"
#import "BTConstants.h"
#import "ProgressHUD.h"
#import "FileOperator.h"
#import "UIImageView+YYWebImage.h"

@interface KitchenViewController () <BLESerialComManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView                       *tableview;

@property (strong, nonatomic) KitchenMachineViewController      *kitchenMachineViewController;

@property (strong, nonatomic) NSMutableArray                    *machineArray;
@property (strong, nonatomic) UIImageView                       *searchBarImageView;
@property (strong, nonatomic) UIImageView                       *searchBGImageView;
@property (strong, nonatomic) UIImageView                       *machineImageView;
@property (strong, nonatomic) UILabel                           *tipLabel;
@property (strong, nonatomic) UILabel                           *nameLabel;
@property (strong, nonatomic) UILabel                           *recipeLabel;
@property (strong, nonatomic) UIImageView                       *recipeImageView;
@property (strong, nonatomic) UIButton                          *startButton;
@property (strong, nonatomic) UIButton                          *disconnectButton;
//搜索按钮
@property (strong, nonatomic) UIButton                          *searchButton;
@property (nonatomic) BOOL                                      isStopScan;
@property (nonatomic) BOOL                                      isShowDisconnect;

@end

@implementation KitchenViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    停止扫描
    _isStopScan = YES;
//    设备未连接
    _isShowDisconnect = YES;
//  设备数组
    _machineArray = [NSMutableArray arrayWithCapacity:100];
    
    [self initNavigationBar];
//    暗灰色
    self.view.backgroundColor = [AppConstants backgroundColor];
    [self initBLE];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self reloadViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initBLE];
//    [_tableview reloadData];
}

- (void)reloadViews {
    [_tableview removeFromSuperview];
    [_searchBarImageView removeFromSuperview];
    [_tipLabel removeFromSuperview];
    [_searchBGImageView removeFromSuperview];
    [_machineImageView removeFromSuperview];
    [_startButton removeFromSuperview];
    [_disconnectButton removeFromSuperview];
    [_nameLabel removeFromSuperview];
    [_searchButton removeFromSuperview];
    [_recipeLabel removeFromSuperview];
    [_recipeImageView removeFromSuperview];
//    当机器没有连接时
    if (![BTConstants BTConnected]) {
//        请先扫描蓝牙果汁机设备lable
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = NSLocalizedString(@"qingxiansaomiao", @"");
        _tipLabel.textColor = [AppConstants themeColor];
        [self.view addSubview:_tipLabel];
        
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(5);
            make.centerX.equalTo(self.view.mas_centerX);
            //        make.width.and.height.equalTo(@40);
        }];
//        蓝色底图
        _searchBGImageView = [[UIImageView alloc] init];
        _searchBGImageView.image = [UIImage imageNamed:@"BTSearchBg.png"];
        [self.view addSubview:_searchBGImageView];
        
        [_searchBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tipLabel.mas_bottom);
            make.left.equalTo(self.view).with.offset(50);
            make.right.equalTo(self.view).with.offset(-50);
            make.height.equalTo(_searchBGImageView.mas_width);
        }];
//        白色扫描图
        _searchBarImageView = [[UIImageView alloc] init];
        _searchBarImageView.image = [UIImage imageNamed:@"BTSearchBar.png"];
        [self.view addSubview:_searchBarImageView];
        
        [_searchBarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.and.right.equalTo(_searchBGImageView);
        }];
//        搜索按钮
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setImage:[UIImage imageNamed:@"BTSearchButton.png"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(enumAllPorts) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_searchButton];
        
        [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_searchBarImageView);
            make.centerY.equalTo(_searchBarImageView);
            make.width.and.height.equalTo(@40);
        }];
    }
    else if ([BTConstants BTConnected] && ![BTConstants BTAvailable]) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = NSLocalizedString(@"jiqizhuanhuanweitongsuomoshi", @"");
        _tipLabel.textColor = [UIColor redColor];
        [self.view addSubview:_tipLabel];
        
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(5);
            make.centerX.equalTo(self.view.mas_centerX);
            //        make.width.and.height.equalTo(@40);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = [NSString stringWithFormat:@"%@：\n%@", NSLocalizedString(@"jiqimingcheng", @""), [BTConstants BTConnectedMachineName]];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
        [self.view addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(_tipLabel.mas_bottom).with.offset(5);
            //        make.width.and.height.equalTo(@40);
        }];
        
        _machineImageView = [[UIImageView alloc] init];
        _machineImageView.image = [BTConstants BTConnectedMachineImage:[BTConstants BTConnectedMachineName]];
        [self.view addSubview:_machineImageView];
        
        [_machineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(5);
            make.centerX.equalTo(self.view);
//            make.right.equalTo(self.view).with.offset(-20);
            make.width.mas_equalTo([AppConstants uiScreenWidth] / 2 - 20);
            make.height.mas_equalTo(([AppConstants uiScreenWidth] / 2 - 30) * (_machineImageView.image.size.height / _machineImageView.image.size.width));
        }];
        
        _disconnectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _disconnectButton.layer.cornerRadius = 10;
        [_disconnectButton setTitle:NSLocalizedString(@"duankailianjie", @"") forState:UIControlStateNormal];
        [_disconnectButton addTarget:self action:@selector(disconnectBT) forControlEvents:UIControlEventTouchUpInside];
        
        _disconnectButton.titleLabel.font = [UIFont systemFontOfSize: 18.0];
        [_disconnectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _disconnectButton.backgroundColor = [AppConstants themeColor];
        [self.view addSubview:_disconnectButton];
        [_disconnectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
            make.left.equalTo(self.view.mas_left).with.offset(30);
            make.right.equalTo(self.view.mas_right).with.offset(-30);
            make.height.equalTo(@30);
        }];
    }
    else if ([BTConstants BTAvailable] && [BTConstants BTStatus] == BTStatusNotReady) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = NSLocalizedString(@"meiyoucaipu", @"");
        _tipLabel.textColor = [UIColor redColor];
        [self.view addSubview:_tipLabel];
        
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(5);
            make.centerX.equalTo(self.view.mas_centerX);
            //        make.width.and.height.equalTo(@40);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = [NSString stringWithFormat:@"%@：\n%@", NSLocalizedString(@"jiqimingcheng", @""), [BTConstants BTConnectedMachineName]];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
        [self.view addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(_tipLabel.mas_bottom).with.offset(5);
            //        make.width.and.height.equalTo(@40);
        }];
        
        _machineImageView = [[UIImageView alloc] init];
        _machineImageView.image = [BTConstants BTConnectedMachineImage:[BTConstants BTConnectedMachineName]];
        [self.view addSubview:_machineImageView];
        
        [_machineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(5);
            make.centerX.equalTo(self.view);
            //            make.right.equalTo(self.view).with.offset(-20);
            make.width.mas_equalTo([AppConstants uiScreenWidth] / 2 - 20);
            make.height.mas_equalTo(([AppConstants uiScreenWidth] / 2 - 30) * (_machineImageView.image.size.height / _machineImageView.image.size.width));
        }];
        
        _disconnectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _disconnectButton.layer.cornerRadius = 10;
        [_disconnectButton setTitle:NSLocalizedString(@"duankailianjie", @"") forState:UIControlStateNormal];
        [_disconnectButton addTarget:self action:@selector(disconnectBT) forControlEvents:UIControlEventTouchUpInside];
        
        _disconnectButton.titleLabel.font = [UIFont systemFontOfSize: 18.0];
        [_disconnectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _disconnectButton.backgroundColor = [AppConstants themeColor];
        [self.view addSubview:_disconnectButton];
        [_disconnectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
            make.left.equalTo(self.view.mas_left).with.offset(30);
            make.right.equalTo(self.view.mas_right).with.offset(-30);
            make.height.equalTo(@30);
        }];
    }
    else if ([BTConstants BTStatus] == BTStatusDone || [BTConstants BTStatus] == BTStatusRunning || [BTConstants BTStatus] == BTStatusReady) {
        
        _tipLabel = [[UILabel alloc] init];
        if ([BTConstants BTStatus] == BTStatusReady) {
            _tipLabel.text = NSLocalizedString(@"machineready", @"");
        }
        else if ([BTConstants BTStatus] == BTStatusRunning) {
            _tipLabel.text = NSLocalizedString(@"machineworking", @"");
        }
        else if ([BTConstants BTStatus] == BTStatusDone) {
            _tipLabel.text = NSLocalizedString(@"machinefinish", @"");
        }
        
        _tipLabel.textColor = [UIColor redColor];
        [self.view addSubview:_tipLabel];
        
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(5);
            make.centerX.equalTo(self.view.mas_centerX);
            //        make.width.and.height.equalTo(@40);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = [NSString stringWithFormat:@"%@：\n%@", NSLocalizedString(@"jiqimingcheng", @""), [BTConstants BTConnectedMachineName]];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
        [self.view addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tipLabel.mas_bottom).with.offset(5);
            make.centerX.equalTo(self.view).with.offset([AppConstants uiScreenWidth] / 4);
            //        make.width.and.height.equalTo(@40);
        }];
        
        _machineImageView = [[UIImageView alloc] init];
        _machineImageView.image = [BTConstants BTConnectedMachineImage:[BTConstants BTConnectedMachineName]];
        [self.view addSubview:_machineImageView];
        
        [_machineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(5);
            make.left.equalTo(self.view).with.offset([AppConstants uiScreenWidth] / 2);
            make.right.equalTo(self.view).with.offset(-20);
            make.height.mas_equalTo(([AppConstants uiScreenWidth] / 2 - 30) * (_machineImageView.image.size.height / _machineImageView.image.size.width));
        }];
        
        _recipeLabel = [[UILabel alloc] init];
        _recipeLabel.text = [NSString stringWithFormat:@"%@：\n%@", NSLocalizedString(@"dangqiancaipu", @""), [BTConstants BTCurrentRecipeName]];
        _recipeLabel.textColor = [UIColor blackColor];
        _recipeLabel.numberOfLines = 0;
        [self.view addSubview:_recipeLabel];
        
        [_recipeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tipLabel.mas_bottom).with.offset(5);
            make.centerX.equalTo(self.view).with.offset(-[AppConstants uiScreenWidth] / 4);
        }];
        
        _recipeImageView = [[UIImageView alloc] init];

        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", [AppConstants httpImageHeader], [BTConstants BTCurrentRecipeImageName]];
        
        [_recipeImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"placeholder.png"]];

        [self.view addSubview:_recipeImageView];
        
        [_recipeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_machineImageView);
            make.centerX.equalTo(self.view).with.offset(-[AppConstants uiScreenWidth] / 4);
            make.width.and.height.mas_equalTo(@100);
        }];
        
        _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _startButton.layer.cornerRadius = 10;
        if ([BTConstants BTStatus] == BTStatusReady) {
            [_startButton setTitle:NSLocalizedString(@"kaishi", @"") forState:UIControlStateNormal];
            [_startButton addTarget:self action:@selector(sendC2_6ToMakeSureStepIsReady) forControlEvents:UIControlEventTouchUpInside];
        }
        else if ([BTConstants BTStatus] == BTStatusDone || [BTConstants BTStatus] == BTStatusRunning) {
            [_startButton setTitle:NSLocalizedString(@"jinruchakan", @"") forState:UIControlStateNormal];
            [_startButton addTarget:self action:@selector(letsGoGetIt) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _startButton.titleLabel.font = [UIFont systemFontOfSize: 18.0];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _startButton.backgroundColor = [AppConstants themeColor];
        [self.view addSubview:_startButton];
        [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
            make.left.equalTo(self.view.mas_left).with.offset(30);
            make.right.equalTo(self.view.mas_centerX).with.offset(-10);
            make.height.equalTo(@30);
        }];
        
        _disconnectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _disconnectButton.layer.cornerRadius = 10;
        [_disconnectButton setTitle:NSLocalizedString(@"duankailianjie", @"") forState:UIControlStateNormal];
        [_disconnectButton addTarget:self action:@selector(disconnectBT) forControlEvents:UIControlEventTouchUpInside];
        
        _disconnectButton.titleLabel.font = [UIFont systemFontOfSize: 18.0];
        [_disconnectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _disconnectButton.backgroundColor = [AppConstants themeColor];
        [self.view addSubview:_disconnectButton];
        [_disconnectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
            make.left.equalTo(self.view.mas_centerX).with.offset(10);
            make.right.equalTo(self.view.mas_right).with.offset(-30);
            make.height.equalTo(@30);
        }];
    }
}

- (void)disconnectBT {
    [[BLESerialComManager sharedInstance] closePort:[BTConstants BTcurrentPort]];
    
    [BTConstants BTSetConnectedMachineName:@""];
    [BTConstants BTSetConnected:NO];
    [BTConstants BTSetCurrentPort:nil];
    [BTConstants BTSetAvailable:NO];
    [BTConstants BTSetStatus:BTStatusNotReady];
//    [BTConstants BTSetStepTotalTime:0];
    
    _isShowDisconnect = NO;
    [ProgressHUD showError:NSLocalizedString(@"shebeiyiduankai", @"")];

    [self reloadViews];
}

- (void)initNavigationBar {
//   navigationBar的颜色就是浅蓝色
    self.navigationController.navigationBar.barTintColor = [AppConstants themeColor];
    self.navigationItem.title = NSLocalizedString(@"chufang", @"");
}

- (void)initBLE {
    [BLESerialComManager sharedInstance].delegate = self;
}

- (void)enumAllPorts {
    [_machineArray removeAllObjects];
    [[BLESerialComManager sharedInstance] startEnumeratePorts:4.0];
    
    _isStopScan = NO;
    [self spin];
}

- (void)spin {
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _searchBarImageView.transform = CGAffineTransformRotate(_searchBarImageView.transform, M_PI);
    }completion:^(BOOL finish){
        if (!_isStopScan) {
            [self spin];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)timedPush
{
    @autoreleasepool
    {
        NSTimeInterval sleep = 3.0;
        
        [NSThread sleepForTimeInterval:sleep];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"letsGoGetIt" object:nil];    // *** 将UI操作放到主线程中执行 ***
        });
    }
}*/

- (void)sendC2_6ToMakeSureStepIsReady {
    /*
    [BTConstants BTSetRequestType:@"about2Run"];
    [BTConstants sendCommand:[BTConstants A9]];
    */
    
    [BTConstants BTSetRequestType:@"C2"];
    [BTConstants sendCommand:[BTConstants C2_6]];
}

- (void)letsGoGetIt {
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"letsGoGetIt" object:nil];
    /*
    if ([BTConstants BTLocked]) {
        [ProgressHUD showError:@"请先对机器进行解锁"];
        return;
    }*/

    if ([BTConstants BTStatus] == BTStatusRunning || [BTConstants BTStatus] == BTStatusDone) {
        _kitchenMachineViewController = [[KitchenMachineViewController alloc] initWithPort:[BTConstants BTcurrentPort]];
        
        _kitchenMachineViewController.view.backgroundColor = [UIColor whiteColor];
        
        _kitchenMachineViewController.hidesBottomBarWhenPushed = YES;
        
        [BLESerialComManager sharedInstance].delegate = _kitchenMachineViewController;
        
        [self.navigationController pushViewController:_kitchenMachineViewController animated:YES];
        
        _kitchenMachineViewController = nil;
    }
    /*
    else if ([BTConstants BTStatus] == BTStatusDone) {
        
    }*/
    else if ([BTConstants BTStatus] == BTStatusReady) {
        [BTConstants BTSetRequestType:@"about2Run"];
        [BTConstants sendCommand:[BTConstants A9]];
    }
    
    /*
    _kitchenMachineViewController = [[KitchenMachineViewController alloc] initWithPort:[BTConstants BTcurrentPort]];
    
    _kitchenMachineViewController.view.backgroundColor = [UIColor whiteColor];
    
    _kitchenMachineViewController.hidesBottomBarWhenPushed = YES;
    
    [BLESerialComManager sharedInstance].delegate = _kitchenMachineViewController;
    
    [self.navigationController pushViewController:_kitchenMachineViewController animated:YES];
    
    _kitchenMachineViewController = nil;
     */
}

#pragma tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_machineArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KitchenMachineTableViewCell *machineCell = [tableView dequeueReusableCellWithIdentifier:@"MachineCell"];

    [self setupModelOfMachineCell:machineCell atIndexPath:indexPath];
    
    return machineCell;

}

- (void)setupModelOfMachineCell:(KitchenMachineTableViewCell *) cell atIndexPath:(NSIndexPath *) indexPath {
    
    cell.data = [_machineArray objectAtIndex:indexPath.row];
    
    if ([BTConstants BTcurrentPort] != nil && [[BTConstants BTcurrentPort].name isEqualToString:[NSString stringWithFormat:@"%@", ((BLEPort*)[_machineArray objectAtIndex:indexPath.row]).name]]) {
        cell.isConnected = YES;
    }
    else {
        cell.isConnected = NO;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_tableview fd_heightForCellWithIdentifier:@"MachineCell" cacheByIndexPath:indexPath configuration:^(KitchenMachineTableViewCell *MachineCell) {
        
        // 在这个block中，重新cell配置数据源
        [self setupModelOfMachineCell:MachineCell atIndexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [_spinner startAnimating];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:@"connectSuccess" object:nil];
    
    NSLog(@"didSelectRowAtIndexPath");

    if (![BTConstants BTConnected]) {
        paramsPackage4Open params;
        [[BLESerialComManager sharedInstance] startOpen:[_machineArray objectAtIndex:indexPath.row] withParams:params];
    }
    else if (![BTConstants BTAvailable]) {
        // 查询机器运行状态
        [BTConstants BTSetRequestType:@"A4"];
        [BTConstants sendCommand:[BTConstants A4]];
    }
    else if ([BTConstants BTAvailable]) {
        [ProgressHUD showSuccess:NSLocalizedString(@"shebeiyiduankai", @"")];
//        [NSThread detachNewThreadSelector:@selector(timedPush) toTarget:self withObject:nil];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma BLEDelegate
// 扫描结束
-(void)bleSerilaComManagerDidEnumComplete:(BLESerialComManager *)bleSerialComManager{
    NSLog(@"scan complete");
    
    _isStopScan = YES;
    
    _tableview = [[UITableView alloc] init];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    [_tableview registerClass:[KitchenMachineTableViewCell class] forCellReuseIdentifier:@"MachineCell"];
    [_tableview reloadData];
    
    [self.view addSubview:_tableview];
    
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBarImageView.mas_bottom);
        make.left.right.and.bottom.equalTo(self.view);
    }];
}

// 扫描到可用设备
-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager didFoundPort:(BLEPort *)port{
    
    NSLog(@"didFoundPort");
    
    if (port!=nil) {
        
//        NSLog(@"name = %@, PORT_STATE = %ld, connectTimer = %@, discoverTimer = %@, writeBuffer = %@, readBuffer = %@, address = %@", port.name, (long)port.state, port.connectTimer, port.discoverTimer, port.writeBuffer, port.readBuffer, port.address);
        
        [_machineArray addObject:port];
    }
}

//打开端口结果
-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager didOpenPort:(BLEPort *)port withResult:(resultCodeType)result{
    NSLog(@"didOpenPort");
    
    if (result == RESULT_SUCCESS) {
        
        [BTConstants BTSetConnectedMachineName:port.name];
        [BTConstants BTSetCurrentPort:port];
        [BTConstants BTSetAvailable:NO];
        
        [NSThread detachNewThreadSelector:@selector(setConnected) toTarget:self withObject:nil];
        
        
        // 查询机器运行状态
        [BTConstants BTSetRequestType:@"A4"];
        [BTConstants sendCommand:[BTConstants A4]];
        [BTConstants BTSetStepTotalTime:0];
    }
}

- (void)setConnected {
    [NSThread sleepForTimeInterval:1];
    
    [BTConstants BTSetConnected:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadViews];
    });
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
    
    if (_isShowDisconnect == YES) {
        [ProgressHUD showError:NSLocalizedString(@"shebeiyiduankai", @"")];
    }
    
    _isShowDisconnect = YES;
    
    [self reloadViews];
}

// 状态改变
-(void)bleSerilaComManagerDidStateChange:(BLESerialComManager *)bleSerialComManager{
    
    NSLog(@"bleSerilaComManagerDidStateChange");
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
    
    NSLog(@"didReceivedPackage");
    
}

-(void)bleSerialComManager:(BLESerialComManager *)bleSerialComManager didDataReceivedOnPort:(BLEPort *)port withLength:(unsigned int)length{
    
    NSLog(@"read data!!!!");
    
    NSData *recData = [bleSerialComManager readDataFromPort:port withLength:length];
    NSString *data = [[NSString alloc] initWithData:recData encoding:NSUTF8StringEncoding];
    NSLog(@"KitchenViewController package is : %@",data);
    
    
    if ([data hasPrefix:@"SBT:D207"]) {
        if ([BTConstants BTStatus] != BTStatusRunning) {
            [BTConstants BTSetStatus:BTStatusRunning];
            
            [self reloadViews];
        }
    }
    
    if ([data hasPrefix:@"SBT:BA0205"]) {
        [ProgressHUD showError:NSLocalizedString(@"shebeiyiduankai", @"")];
        
        [[BLESerialComManager sharedInstance] closePort:[BTConstants BTcurrentPort]];
        
        [BTConstants BTResetStatus];
        
        return;
    }
    
    if ([data hasPrefix:@"SBT:BA0201"]) {
        [ProgressHUD showSuccess:NSLocalizedString(@"jiqiyijiesuo", @"")];
        
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
    
    if ([data hasPrefix:@"SBT:B90400"]) {
        
        if ([data hasPrefix:@"SBT:B9040010"] && [BTConstants BTConnected]) {
            
            NSLog(@"1");
            
            [self disconnectBT];
            
            NSLog(@"2");
            
            return;
        }
        
        NSString *str = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"currentmodeis", @""), [BTConstants BTMachineCurrnetMode:data]];
        
        [ProgressHUD showSuccess:str];
        
        _tipLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"currentmodeis", @""), [BTConstants BTMachineCurrnetMode:data]];
        
        if ([BTConstants BTStepTotalTime] != 0) {
            [BTConstants BTSetStatus:BTStatusReady];
        }
        
        /*
        if ([data hasPrefix:@"SBT:B9040020"]) {
            [BTConstants BTSetLocked:YES];
        }
        else {
            [BTConstants BTSetLocked:NO];
        }*/
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
                /*
                if ([BTConstants BTStepTotalTime] == 0) {
                    [BTConstants BTSetStepTotalTime:[BTConstants turnString2Time:timeRemain]];
                    [BTConstants BTSetStatus:BTStatusRunning];
                }*/
                
                [BTConstants BTSetStatus:BTStatusRunning];
            }
        }
    }
    
    // C3 请求蓝牙连接
    if ([[BTConstants BTRequestType] isEqualToString:@"C3"]) {
        [BTConstants BTSetRequestType:@"SBT:B201000"];
        if ([data hasPrefix:@"SBT:B201000"]) {//isEqualToString:[BTConstants D3_1]]) {
            
            [BTConstants BTSetAvailable:NO];
            [self reloadViews];
            [ProgressHUD showError:NSLocalizedString(@"lanyajinyong", @"")];
            
            [BTConstants BTSetRequestType:@"A9"];
        }
        else if ([data hasPrefix:@"SBT:B201100"]) {//isEqualToString:[BTConstants D3_2]]) {
            
            [BTConstants BTSetAvailable:YES];
            
            [ProgressHUD showSuccess:NSLocalizedString(@"lianjiechenggong", @"")];
            
            [self reloadViews];
            
//            [NSThread detachNewThreadSelector:@selector(timedPush) toTarget:self withObject:nil];
        }
        else if ([data hasPrefix:@"SBT:B201300"]) {//isEqualToString:[BTConstants D3_3]]) {
            
            [BTConstants BTSetAvailable:NO];
            
            [ProgressHUD showError:NSLocalizedString(@"lianjieshibai", @"")];
        }
    }
    else if ([[BTConstants BTRequestType] isEqualToString:@"about2Run"]) {
        if ([data hasPrefix:@"SBT:B9040002"]) {
            [ProgressHUD showError:NSLocalizedString(@"tishijiesuo", @"")];
        }
        else {
            _kitchenMachineViewController = [[KitchenMachineViewController alloc] initWithPort:[BTConstants BTcurrentPort]];
            
            _kitchenMachineViewController.view.backgroundColor = [UIColor whiteColor];
            
            _kitchenMachineViewController.hidesBottomBarWhenPushed = YES;
            
            [BLESerialComManager sharedInstance].delegate = _kitchenMachineViewController;
            
            [self.navigationController pushViewController:_kitchenMachineViewController animated:YES];
            
            _kitchenMachineViewController = nil;
        }
        
        [BTConstants BTSetRequestType:@""];
    }
    else if ([[BTConstants BTRequestType] isEqualToString:@"C2"]) {
        [BTConstants BTSetRequestType:@""];
        if ([data length] > 12) {
            if ([[data substringWithRange:NSMakeRange(0, 12)] isEqualToString:@"SBT:BF02C200"]) {
                
                [self letsGoGetIt];
                
                [BTConstants BTSetStatus:BTStatusReady];
            }
            else {
//                [ProgressHUD showError:@"下载菜谱失败"];
//                [ProgressHUD showError:NSLocalizedString(@"caipushixiao", @"")];
                
                [BTConstants BTSetStatus:BTStatusNotReady];
            }
        }
        [BTConstants BTSetDownloadingSteps:NO];
    }
    else if ([[BTConstants BTRequestType] isEqualToString:@"A4"]) {
        [BTConstants BTSetRequestType:@""];

        if ([BTConstants B4:data]) {
            NSLog(@"send A9");
            [BTConstants BTSetRequestType:@"A9"];
            [BTConstants sendCommand:[BTConstants A9]];
        }
        else {
            [ProgressHUD showError:NSLocalizedString(@"tingzhizailianjie", @"")];
            
            _isShowDisconnect = NO;
            [[BLESerialComManager sharedInstance] closePort:[BTConstants BTcurrentPort]];
        }
    }
    else if ([[BTConstants BTRequestType] isEqualToString:@"A9"]) {
        [BTConstants BTSetRequestType:@""];
        if ([data hasPrefix:@"SBT:B904000200"]) {//isEqualToString:[BTConstants B9_2]]) {
            [ProgressHUD showError:NSLocalizedString(@"tishijiesuo", @"")];
            
            _isShowDisconnect = NO;
            [[BLESerialComManager sharedInstance] closePort:[BTConstants BTcurrentPort]];
        }
        else if ([data hasPrefix:@"SBT:B904001000"]) {//isEqualToString:[BTConstants B9_11]]) {
            [ProgressHUD showError:NSLocalizedString(@"tishijiesuo", @"")];
            
            _isShowDisconnect = NO;
            [[BLESerialComManager sharedInstance] closePort:[BTConstants BTcurrentPort]];
        }
        else {
            [BTConstants BTSetRequestType:@"C3"];
            [BTConstants sendCommand:[BTConstants C3]];
        }
    }
}

@end
