//
//  BLESerialComManager.h
//  BLESerialComManager
//
//  Created by 王 维 on 3/10/13.
//  Copyright (c) 2013 王 维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLESerialComDefinition.h"
#import "BLEPort.h"



@protocol  BLESerialComManagerDelegate;


@interface BLESerialComManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager    *CM;
    NSMutableArray      *ports;
    unsigned int        _lengthOfPackageToReceive;
    
    // timer
    NSTimer             *enumPortsTimer;

    

}

@property (assign,nonatomic) id<BLESerialComManagerDelegate> delegate;
@property (nonatomic,retain) NSMutableArray                 *ports;
@property (nonatomic)        centralStateType               state;

/*****
  @方法       sharedInstance;
  @描述       使用此静态方法得到BLESerialComManager的实例
 *****/

+(BLESerialComManager *)sharedInstance;

/*
 @方法        configure
 @描述        参数设置
 @查看        resultCodeType paramsPackage4Configure  
 
 */
-(resultCodeType)configure:(paramsPackage4Configure)params;

/*
 @方法        startEnumeratePorts;
 @描述        枚举所有BLE端口,timeout设置超时时间,bleSerilaComManager:withPorts:返回端口列表
 @查看        resultCodeType
 @查看        bleSerilaComManager:withPorts:
 */
-(resultCodeType)startEnumeratePorts:(float)timeout;

/*
 @方法        stopEnumeratePorts;
 @描述        枚举所有BLE端口,timeout设置超时时间,bleSerilaComManager:withPorts:返回端口列表
 @查看        resultCodeType
 @查看        bleSerilaComManager:withPorts:
 */
-(resultCodeType)stopEnumeratePorts;

/*
 @方法        open:withParams:
 @描述        打开port,bleSerilaComManager:didOpenPort:withResult:返回结果
 @查看        resultCodeType
 @查看        BLEPort
 @查看        paramsPackage4Open
 @查看        bleSerilaComManager:didOpenPort:withResult:
 
 */
-(resultCodeType)startOpen:(BLEPort *)port withParams:(paramsPackage4Open)params;


/*
 @方法        readDataFromPort:withLenght:
 @描述        写数据
 @查看        BLEPort
 */

-(NSData *)readDataFromPort:(BLEPort *)port withLength:(int)length;

/*
 @方法        writeData:toPort:withParams:
 @描述        写数据
 @查看        resultCodeType
 @查看        BLEPort

 */
-(resultCodeType)writeData:(NSData *)data toPort:(BLEPort *)port;

/*
 @方法        clearReadBufferInPort:
 @描述        清空接收区缓存数据
 @查看        resultCodeType
 @查看        BLEPort
 
 */
-(resultCodeType)clearReadBufferInPort:(BLEPort *)port;



/*
 @方法        closePort:
 @描述        关闭串口
 @查看        BLEPort
 @查看        resultCodeType
 */
-(resultCodeType)closePort:(BLEPort *) port;



@end



@protocol BLESerialComManagerDelegate <NSObject>
@required

/*
 @接口        bleSerilaComManagerDidStateChange:
 @描述        当BLESerialComManager的state变量改变时，此接口被调用
 @查看        BLESerialComManager
 */
-(void)bleSerilaComManagerDidStateChange:(BLESerialComManager *)bleSerialComManager;


/*
 @接口        bleSerilaComManager:withEnumeratedPorts:
 @描述        在调用startEnumeratePorts:方法后，此接口返回结果
 @查看        startEnumeratePorts
 */
-(void)bleSerilaComManagerDidEnumComplete:(BLESerialComManager *)bleSerialComManager;

/*
 @接口        bleSerilaComManager:didFoundPort:
 @描述        在调用startEnumeratePorts:方法后，此接口返回各个接口
 @查看        startEnumeratePorts
 */
-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager didFoundPort:(BLEPort *)port;


/*
 @接口        bleSerilaComManager:didOpenPort:withResult:
 @描述        在调用startEnumeratePorts:方法后，此接口返回结果
 @查看        startEnumeratePorts
 */

-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager didOpenPort:(BLEPort *)port withResult:(resultCodeType)result;

/*
 @接口        bleSerilaComManager:didDataReceivedOnPort:
 @描述        接收到数据后，以配置参数的长度作为调用此接口的标准
 @查看        BLEPort
 */


-(void)bleSerialComManager:(BLESerialComManager *)bleSerialComManager didDataReceivedOnPort:(BLEPort *)port withLength:(unsigned int)length;

/*
 @接口        bleSerilaComManager:didClosedPort:
 @描述        关闭串口
 @查看        BLEPort
 */


-(void)bleSerialComManager:(BLESerialComManager *)bleSerialComManager didClosedPort:(BLEPort *)port;

@optional

@end




