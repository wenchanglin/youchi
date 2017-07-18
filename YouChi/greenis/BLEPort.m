//
//  BLEPort.m
//  BLESerialComManager
//
//  Created by 王 维 on 3/10/13.
//  Copyright (c) 2013 王 维. All rights reserved.
//

#import "BLEPort.h"
static int allSend = 0;

@implementation BLEPort
@synthesize name;
@synthesize state;
@synthesize peripheral;
@synthesize connectTimer;
@synthesize discoverTimer;
@synthesize writeBuffer;
@synthesize readBuffer;
@synthesize address;

-(void)startWriteData{
    
    if (bWriteInProgressFlag) {
        NSLog(@"attention:re-call write when write thread in progress");
        return;
    }
    
    while (1) {

        bWriteInProgressFlag = YES;
        //[NSThread sleepForTimeInterval:0.02];
        NSData *package = [self getMaxPackageToWrite];
//        NSLog(@"package %@",package);
        CBCharacteristic *txCharac = [self getTXCharacteristic];
        if (package != nil) {
            if (txCharac!=nil) {
                allSend += package.length;
               // NSLog(@"write data count %d with left count %d",allSend,writeBuffer.length);
                
                
                if (txCharac.properties & CBCharacteristicPropertyWriteWithoutResponse) {
                    [peripheral writeValue:package forCharacteristic:txCharac type:CBCharacteristicWriteWithoutResponse];
                }else{
                    [peripheral writeValue:package forCharacteristic:txCharac type:CBCharacteristicWriteWithResponse];
                }
            }
        }else{
           // NSLog(@"write data complete");
            break;
        }
    }
    bWriteInProgressFlag = NO;
    
}



-(NSData*)getMaxPackageToWrite{
    NSData *maxPack;
    if (0 < writeBuffer.length && writeBuffer.length <= 20) {
        maxPack = [writeBuffer subdataWithRange:NSMakeRange(0, writeBuffer.length)];
        [writeBuffer setData:nil];
        //[writeBuffer replaceBytesInRange:NSMakeRange(0, writeBuffer.length) withBytes:nil];
    }else if(writeBuffer.length > 20){
        maxPack = [writeBuffer subdataWithRange:NSMakeRange(0, 20)];
        writeBuffer = [NSMutableData dataWithData:[writeBuffer subdataWithRange:NSMakeRange(20, writeBuffer.length - 20)]];
        
    }else{
        return nil;
    }
    return maxPack;
    
}
-(NSString *) CBUUIDToString:(CBUUID *) UUID {
    NSString *uuidString = [UUID.data description];
    return [uuidString substringWithRange:NSMakeRange(1, uuidString.length-2)];
}
-(CBCharacteristic *)getTXCharacteristic{
    CBService *service = nil;
    
    for (CBService *s in peripheral.services) {
        NSString *sString = [self CBUUIDToString:s.UUID];
        if (![sString compare:@"ffb0"]) {
            service = s;
            break;
        }
    }
    
    for (CBCharacteristic *c in service.characteristics) {
        NSString *cString = [self CBUUIDToString:c.UUID];
//        NSLog(@"characteristic : %@",cString);
        if (![cString compare:@"ffb2"]) {
            return c;
        }
    }
    
    return nil;
}
@end
