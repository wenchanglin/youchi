//
//  BTConstants.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/9/22.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEPort.h"
#import "AppConstants.h"
#import "BLESerialComManager.h"

typedef NS_ENUM(NSUInteger, BTMachineStatus) {
    BTStatusNotReady = 0,
    BTStatusReady,
    BTStatusRunning,
    BTStatusDone,
};

@interface BTConstants : NSObject


+ (NSString*)BTHeadCode;
+ (NSString*)BTTailCode;
+ (NSString*)BTCheckCode;

// 蓝牙设备是否已经连接上
+ (void)BTSetConnected:(BOOL)status;
+ (BOOL)BTConnected;

// 蓝牙设备是否正常可用
+ (void)BTSetAvailable:(BOOL)available;
+ (BOOL)BTAvailable;

// App现在连接的蓝牙设备
+ (BLEPort*)BTcurrentPort;
+ (void)BTSetCurrentPort:(BLEPort*)port;

// App发送指令到机器，通过RequestType来过滤收到的包
+ (void)BTSetRequestType:(NSString*)BTRequestType;
+ (NSString*)BTRequestType;

// 正在运行的菜谱的总时长
+ (void)BTSetStepTotalTime:(unsigned long)totalTime;
+ (unsigned long)BTStepTotalTime;

// 正在连接上的机器名称
+ (void)BTSetConnectedMachineName:(NSString*)MachineName;
+ (NSString*)BTConnectedMachineName;

// 正在连接上的机器Mac地址
+ (void)BTSetConnectedMachineMac:(NSString*)MachineMac;
+ (NSString*)BTConnectedMachineMac;

// 根据机器名称获取机器的图片
+ (UIImage*)BTConnectedMachineImage:(NSString*)machineName;

// 机器录入菜谱的名称和图片
+ (void)BTSetCurrentRecipeName:(NSString*)recipeName;
+ (NSString*)BTCurrentRecipeName;

+ (void)BTSetCurrentRecipeImageName:(NSString*)imageName;
+ (NSString*)BTCurrentRecipeImageName;

// 机器状态
+ (void)BTSetStatus:(BTMachineStatus)status;
+ (BTMachineStatus)BTStatus;

// 是否正在下载菜谱到机器
+ (void)BTSetDownloadingSteps:(BOOL)isDownloading;
+ (BOOL)BTDownloadingSteps;

// 机器运行时返回的字符串转换
+ (unsigned long)turnString2Time:(NSString*)timeStr;

// 机器转换后的状态
+ (NSString*)BTMachineCurrnetMode:(NSString*)str;
/*
// 机器是否是童锁模式
+ (void)BTSetLocked:(BOOL)isLocked;
+ (BOOL)BTLocked;
*/

// 重置所有状态
+ (void)BTResetStatus;

// App发送指令到机器
+ (void)sendCommand:(NSString*)command;

+ (NSString*)A0;
+ (NSString*)B0:(NSString*)content;

+ (NSString*)A1;
+ (NSString*)B1:(NSString*)content;

+ (NSString*)A2;
+ (NSString*)B2_1;
+ (NSString*)B2_2;

+ (NSString*)A3;
+ (NSString*)B3:(NSString*)content;

+ (NSString*)A4;
+ (BOOL)B4:(NSString*)content;

+ (NSString*)A5;
+ (NSString*)B5:(NSString*)content;

+ (NSString*)A6;
+ (NSString*)B6:(NSString*)content;

+ (NSString*)A7_1:(NSString*)content;
+ (NSString*)A7_2;
+ (NSString*)A7_3;
+ (NSString*)B7_1:(NSString*)content;
+ (NSString*)B7_2:(NSString*)content;

+ (NSString*)A8;
+ (NSString*)B8:(NSString*)content;

+ (NSString*)A9;
+ (NSString*)B9_1;
+ (NSString*)B9_2;
+ (NSString*)B9_3;
+ (NSString*)B9_4;
+ (NSString*)B9_5;
+ (NSString*)B9_6;
+ (NSString*)B9_7;
+ (NSString*)B9_8;
+ (NSString*)B9_9;
+ (NSString*)B9_10;
+ (NSString*)B9_11;
+ (NSString*)B9_12;
+ (NSString*)B9_13;

+ (NSString*)AA;
+ (NSString*)BA_1;
+ (NSString*)BA_2;
+ (NSString*)BA_3;
+ (NSString*)BA_4;
+ (NSString*)BA_5;
+ (NSString*)BA_6;
+ (NSString*)BA_7;
+ (NSString*)BA_8;
+ (NSString*)BA_9;

+ (NSString*)AB;
+ (NSString*)BB;

+ (NSString*)AC;
+ (NSString*)BC:(NSString*)content;

+ (NSString*)AD;
+ (NSString*)BD:(NSString*)content;

+ (NSString*)AE;
+ (NSString*)BE_1;
+ (NSString*)BE_2;
+ (NSString*)BE_3;
+ (NSString*)BE_4;
+ (NSString*)BE_5;
+ (NSString*)BE_6;
+ (NSString*)BE_7;
+ (NSString*)BE_8;
+ (NSString*)BE_9;
+ (NSString*)BE_10;
+ (NSString*)BE_11;
+ (NSString*)BE_12;
+ (NSString*)BE_13;
+ (NSString*)BE_14;
+ (NSString*)BE_15;
+ (NSString*)BE_16;
+ (NSString*)BE_17;
+ (NSString*)BE_18;
+ (NSString*)BE_19;
+ (NSString*)BE_20;
+ (NSString*)BE_21;

+ (NSString*)AF;
+ (NSString*)BF:(NSString*)content;

+ (NSString*)D0;

+ (NSString*)C0:(NSString*)content;
+ (NSString*)C1:(NSString*)content;
+ (NSString*)C2_1;
+ (NSString*)C2_2;
+ (NSString*)C2_3;
+ (NSString*)C2_4;
+ (NSString*)C2_5;
+ (NSString*)C2_6;
+ (NSString*)D2_1;
+ (NSString*)D2_2;
+ (NSString*)D2_3;
+ (NSString*)D2_4;
+ (NSString*)D2_5;
+ (NSString*)D2_6;

+ (NSString*)C3;
+ (NSString*)D3_1;
+ (NSString*)D3_2;
+ (NSString*)D3_3;

+ (NSString*)C4:(NSString*)content;
+ (NSString*)D4_1;
+ (NSString*)D4_2;
+ (NSString*)D4_3;

+ (NSString*)C5:(NSString*)content;
+ (NSString*)D5_1;
+ (NSString*)D5_2;
+ (NSString*)D5_3;

+ (NSString*)C6;

+ (NSString*)C7:(NSString*)content;
+ (NSString*)D7_1;
+ (NSString*)D7_2;
+ (NSString*)D7_3;
+ (NSString*)D7_4;
+ (NSString*)D7_5;
+ (NSString*)D7_6;
+ (NSString*)D7_7;
+ (NSString*)D7_8;
+ (NSString*)D7_9;
+ (NSString*)D7_10;
+ (NSString*)D7_11;

+ (NSString*)C8;
+ (NSString*)C9;
+ (NSString*)CA;

+ (NSString*)CB:(NSString*)content;
+ (NSString*)DB_1;
+ (NSString*)DB_2;
+ (NSString*)DB_3;

+ (NSString*)CC:(NSString*)content;
+ (NSString*)DC1;
+ (NSString*)DC2;

@end
