//
//  BTConstants.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/9/22.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "BTConstants.h"


@implementation BTConstants

+ (NSString*)BTHeadCode {
    return @"SBT:";
}

+ (NSString*)BTTailCode {
    return @"\r\n\0";
}

+ (NSString*)BTCheckCode {
    return @"00";
}

+ (void)BTSetConnected:(BOOL)status {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTConnectStatus = status;
}

+ (BOOL)BTConnected {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTConnectStatus;
}

+ (void)BTSetRequestType:(NSString*)BTRequestType {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTRequestType = BTRequestType;
}

+ (NSString*)BTRequestType {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTRequestType;
}
/*
+ (NSString*)turnInt2HexString:(int)number {
    switch (number) {
        case 1:
            return @"01";
            break;
            
        default:
            break;
    }
}*/

+ (void)BTSetAvailable:(BOOL)available {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTAvailable = available;
}

+ (BOOL)BTAvailable {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTAvailable;
}

+ (BLEPort*)BTcurrentPort {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).currentBTPort;
}

+ (void)BTSetCurrentPort:(BLEPort*)port {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).currentBTPort = port;
}

+ (void)BTSetStepTotalTime:(unsigned long)totalTime {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).stepTotalTime = totalTime;
}

+ (unsigned long)BTStepTotalTime {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).stepTotalTime;
}

+ (void)BTSetConnectedMachineName:(NSString*)MachineName {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTConnectedMachineName = MachineName;
}

+ (NSString*)BTConnectedMachineName {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTConnectedMachineName;
}

+ (void)BTSetConnectedMachineMac:(NSString*)MachineMac {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTConnectedMachineMac = MachineMac;
}

+ (NSString*)BTConnectedMachineMac {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTConnectedMachineMac;
}

+ (UIImage*)BTConnectedMachineImage:(NSString*)machineName {
    if ([machineName hasSuffix:@"8800"]) {
        return [UIImage imageNamed:@"device8800.jpg"];
    }
    else if ([machineName hasSuffix:@"8830"]) {
        return [UIImage imageNamed:@"device8830.png"];
    }
    else if ([machineName hasSuffix:@"8840"]) {
        return [UIImage imageNamed:@"device8840.png"];
    }
    else if ([machineName hasPrefix:@"8880S"]) {
        return [UIImage imageNamed:@"device8880S.jpg"];
    }
    else if ([machineName hasPrefix:@"8880T"]) {
        return [UIImage imageNamed:@"device8880T.jpg"];
    }
    else if ([machineName hasPrefix:@"8880R"]) {
        return [UIImage imageNamed:@"deviceG-8880R.jpg"];
    }
    else {
        return nil;
    }
}

+ (void)BTSetCurrentRecipeName:(NSString*)recipeName {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTCurrentRecipeName = recipeName;
}

+ (NSString*)BTCurrentRecipeName {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTCurrentRecipeName;
}

+ (void)BTSetCurrentRecipeImageName:(NSString*)imageName {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTCurrentRecipeImageName = imageName;
}

+ (NSString*)BTCurrentRecipeImageName {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTCurrentRecipeImageName;
}

+ (void)BTSetStatus:(BTMachineStatus)status {
    switch (status) {
        case BTStatusReady:
            NSLog(@"BTStatusReady");
            break;
        case BTStatusNotReady:
            NSLog(@"BTStatusNotReady");
            break;
        case BTStatusDone:
            NSLog(@"BTStatusDone");
            break;
        case BTStatusRunning:
            NSLog(@"BTStatusRunning");
            break;
        default:
            break;
    }
    
    //((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTStatus = status;
}

+ (BTMachineStatus)BTStatus {
    return 0;//((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTStatus;
}

+ (void)BTSetDownloadingSteps:(BOOL)isDownloading {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTDownloadingSteps = isDownloading;
}

+ (BOOL)BTDownloadingSteps {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTDownloadingSteps;
}

+ (unsigned long)turnString2Time:(NSString*)timeStr {
    unsigned long result = strtoul([timeStr UTF8String], 0, 16);
    return result;
}

+ (NSString*)BTMachineCurrnetMode:(NSString*)str {
    NSString *result;
    
    if ([str hasPrefix:@"SBT:B9040001"]) {
        result = NSLocalizedString(@"shougongmoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040002"]) {
        result = NSLocalizedString(@"tongsuomoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040003"]) {
        result = NSLocalizedString(@"miantuanmoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040004"]) {
        result = NSLocalizedString(@"shuguomoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040005"]) {
        result = NSLocalizedString(@"mofenmoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040006"]) {
        result = NSLocalizedString(@"shabingmoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040007"]) {
        result = NSLocalizedString(@"jiangliaomoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040008"]) {
        result = NSLocalizedString(@"doujiangmoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040009"]) {
        result = NSLocalizedString(@"bingkuaimoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B904000A"]) {
        result = NSLocalizedString(@"diandongmoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040010"]) {
        result = NSLocalizedString(@"xiumianmoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040020"]) {
        result = NSLocalizedString(@"lanyamoshi", @"");
    }
    else if ([str hasPrefix:@"SBT:B9040030"]) {
        result = NSLocalizedString(@"chucuomoshi", @"");
    }
    
    return result;
}
/*
+ (void)BTSetLocked:(BOOL)isLocked {
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTLocked = isLocked;
}

+ (BOOL)BTLocked {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).BTLocked;
}
*/
+ (void)BTResetStatus {
    [BTConstants BTSetConnected:NO];
    [BTConstants BTSetAvailable:NO];
    [BTConstants BTSetCurrentPort:nil];
    [BTConstants BTSetRequestType:@""];
    [BTConstants BTSetStepTotalTime:0];
    [BTConstants BTSetConnectedMachineName:@""];
    [BTConstants BTSetConnectedMachineMac:@""];
    [BTConstants BTConnectedMachineImage:@""];
    [BTConstants BTSetCurrentRecipeName:@""];
    [BTConstants BTSetCurrentRecipeImageName:@""];
    [BTConstants BTSetStatus:BTStatusNotReady];
    [BTConstants BTSetDownloadingSteps:NO];
}

+ (void)sendCommand:(NSString*)command {
    NSLog(@"sendCommand : %@", command);
    
    [[BLESerialComManager sharedInstance] writeData:[command dataUsingEncoding:NSUTF8StringEncoding] toPort:[BTConstants BTcurrentPort]];
}

+ (NSString*)A0 {
    NSString *data = [NSString stringWithFormat:@"%@A000%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return data;
}

+ (NSString*)B0:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)A1 {
    NSString *data = [NSString stringWithFormat:@"%@A100%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return data;
}

+ (NSString*)B1:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)A2 {
    NSString *data = [NSString stringWithFormat:@"%@A200%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return data;
}

+ (NSString*)B2_1 {
    NSString *str = [NSString stringWithFormat:@"%@B20200%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    ;
    
    return str;
}

+ (NSString*)B2_2 {
    NSString *str = [NSString stringWithFormat:@"%@B20201%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)A3 {
    NSString *data = [NSString stringWithFormat:@"%@A300%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)B3:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)A4 {
    NSString *data = [NSString stringWithFormat:@"%@A400%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return data;
}

+ (BOOL)B4:(NSString*)content {
    /*
    if ([content length] != 15) {
        return NO;
    }
    if (![[content substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"SBT:B402"]) {
        return NO;
    }
    if (![[content substringWithRange:NSMakeRange(10, 5)] isEqualToString:@"00\r\n\0"]) {
        return NO;
    }
    if ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"80"]) {
        return YES;
    }*/
    
    if ([[content substringWithRange:NSMakeRange(0, 10)] isEqualToString:@"SBT:B40280"]) {
        return YES;
    }
    else {
        return NO;
    }
    
    return NO;
}

+ (NSString*)A5 {
    NSString *data = [NSString stringWithFormat:@"%@A500%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return data;
}

+ (NSString*)B5:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)A6 {
    NSString *data = [NSString stringWithFormat:@"%@A600%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)B6:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)A7_1:(NSString*)content {
    NSString *data = [NSString stringWithFormat:@"%@A702%@%@%@", [BTConstants BTHeadCode], content, [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)A7_2 {
    NSString *data = [NSString stringWithFormat:@"%@A70201%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)A7_3 {
    NSString *data = [NSString stringWithFormat:@"%@A70202%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)B7_1:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)B7_2:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)A8 {
    NSString *data = [NSString stringWithFormat:@"%@A800%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)B8:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)A9 {
    NSString *data = [NSString stringWithFormat:@"%@A900%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)B9_1 {
    NSString *str = [NSString stringWithFormat:@"%@B9040001%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_2 {
    NSString *str = [NSString stringWithFormat:@"%@B9040002%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_3 {
    NSString *str = [NSString stringWithFormat:@"%@B9040003%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_4 {
    NSString *str = [NSString stringWithFormat:@"%@B9040004%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_5 {
    NSString *str = [NSString stringWithFormat:@"%@B9040005%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_6 {
    NSString *str = [NSString stringWithFormat:@"%@B9040006%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_7 {
    NSString *str = [NSString stringWithFormat:@"%@B9040007%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_8 {
    NSString *str = [NSString stringWithFormat:@"%@B9040008%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_9 {
    NSString *str = [NSString stringWithFormat:@"%@B9040009%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_10 {
    NSString *str = [NSString stringWithFormat:@"%@B904000A%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_11 {
    NSString *str = [NSString stringWithFormat:@"%@B9040010%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_12 {
    NSString *str = [NSString stringWithFormat:@"%@B9040020%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)B9_13 {
    NSString *str = [NSString stringWithFormat:@"%@B9040030%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)AA {
    NSString *data;
    
    return data;
}

+ (NSString*)BA_1 {
    NSString *str = [NSString stringWithFormat:@"%@BA0201%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)BA_2 {
    NSString *str = [NSString stringWithFormat:@"%@BA0202%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)BA_3 {
    NSString *str = [NSString stringWithFormat:@"%@BA0203%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)BA_4 {
    NSString *str = [NSString stringWithFormat:@"%@BA0204%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)BA_5 {
    NSString *str = [NSString stringWithFormat:@"%@BA0205%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)BA_6 {
    NSString *str = [NSString stringWithFormat:@"%@BA0206%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)BA_7 {
    NSString *str = [NSString stringWithFormat:@"%@BA0207%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)BA_8 {
    NSString *str = [NSString stringWithFormat:@"%@BA0208%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)BA_9 {
    NSString *str = [NSString stringWithFormat:@"%@BA0209%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)AB {
    NSString *data;
    
    return data;
}

+ (NSString*)BB {
    NSString *str;
    
    return str;
}

+ (NSString*)AC {
    NSString *data = [NSString stringWithFormat:@"%@AC00%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)BC:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)AD {
    NSString *data = [NSString stringWithFormat:@"%@AD00%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)BD:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)AE {
    NSString *data;
    
    return data;
}

+ (NSString*)BE_1 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_2 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_3 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_4 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_5 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_6 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_7 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_8 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_9 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_10 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_11 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_12 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_13 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_14 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_15 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_16 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_17 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_18 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_19 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_20 {
    NSString *str;
    
    return str;
}

+ (NSString*)BE_21 {
    NSString *str;
    
    return str;
}

+ (NSString*)AF {
    NSString *data;
    
    return data;
}

+ (NSString*)BF:(NSString*)content {
    NSString *str;
    
    return str;
}

+ (NSString*)D0 {
    NSString *str;
    
    return str;
}

+ (NSString*)C0:(NSString*)content {
    NSString *data;
    
    return data;
}

+ (NSString*)C1:(NSString*)content {
    NSString *data;
    
    return data;
}

+ (NSString*)C2_1 {
    NSString *data = [NSString stringWithFormat:@"%@C20201%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)C2_2 {
    NSString *data = [NSString stringWithFormat:@"%@C20202%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)C2_3 {
    NSString *data = [NSString stringWithFormat:@"%@C20203%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)C2_4 {
    NSString *data = [NSString stringWithFormat:@"%@C20204%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)C2_5 {
    NSString *data = [NSString stringWithFormat:@"%@C20205%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)C2_6 {
    NSString *data = [NSString stringWithFormat:@"%@C20206%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return data;
}

+ (NSString*)D2_1 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%31%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D2_2 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%32%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D2_3 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%33%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D2_4 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%34%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D2_5 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%35%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D2_6 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%36%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)C3 {
    NSString *data = [NSString stringWithFormat:@"%@C3041C5A%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return data;
}

+ (NSString*)D3_1 {
    NSString *str = [NSString stringWithFormat:@"%@B2010%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D3_2 {
    NSString *str = [NSString stringWithFormat:@"%@B2011%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D3_3 {
    NSString *str = [NSString stringWithFormat:@"%@B2013%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)C4:(NSString*)content {
    NSString *data;
    
    return data;
}

+ (NSString*)D4_1 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C4%10%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D4_2 {
    NSString *str = [NSString stringWithFormat:@"%@BE02C4%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D4_3 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C4%02%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)C5:(NSString*)content {
    NSString *data = [NSString stringWithFormat:@"%@C502%@%@%@", [BTConstants BTHeadCode], content, [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return data;
}

+ (NSString*)D5_1 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C5%03%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return str;
}

+ (NSString*)D5_2 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C5%01%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D5_3 {
    NSString *str = [NSString stringWithFormat:@"%@BF02C5%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)C6 {
    NSString *data;
    
    return data;
}

+ (NSString*)C7:(NSString*)content {
    NSString *data = [NSString stringWithFormat:@"%@C714%@%@%@", [BTConstants BTHeadCode], content, [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return data;
}

+ (NSString*)D7_1 {
    NSString *str = [NSString stringWithFormat:@"%@BF02C7%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D7_2 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C7%21%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D7_3 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C7%22%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D7_4 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C7%23%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D7_5 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C7%24%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D7_6 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C7%25%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D7_7 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%31%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D7_8 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%32%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D7_9 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%33%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D7_10 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%34%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)D7_11 {
    NSString *str = [NSString stringWithFormat:@"%@BE06C2%35%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)C8 {
    NSString *data;
    
    return data;
}

+ (NSString*)C9 {
    NSString *data;
    
    return data;
}

+ (NSString*)CA {
    NSString *data;
    
    return data;
}

+ (NSString*)CB:(NSString*)content {
    NSString *data = [NSString stringWithFormat:@"%@CB02%@%@%@", [BTConstants BTHeadCode], content, [BTConstants BTCheckCode], [BTConstants BTTailCode]];

    return data;
}

+ (NSString*)DB_1 {
    NSString *str = [NSString stringWithFormat:@"%@BF02CB%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)DB_2 {
    NSString *str = [NSString stringWithFormat:@"%@BE06CC%05%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    return str;
}

+ (NSString*)DB_3 {
    NSString *str = [NSString stringWithFormat:@"%@BE06CC%02%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return str;
}

+ (NSString*)CC:(NSString*)content {
    NSString *data;
    
    return data;
}

+ (NSString*)DC1 {
    NSString *str = [NSString stringWithFormat:@"%@BF02CC%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return str;
}

+ (NSString*)DC2 {
    NSString *str = [NSString stringWithFormat:@"%@BF06CC%03%%@%@", [BTConstants BTHeadCode], [BTConstants BTCheckCode], [BTConstants BTTailCode]];
    
    
    return str;
}

@end
