//
//  BLESerialComManager.m
//  BLESerialComManager
//
//  Created by 王 维 on 3/10/13.
//  Copyright (c) 2013 王 维. All rights reserved.
//

#import "BLESerialComManager.h"

/**
    共享实例
 **/
static BLESerialComManager *myInstance;

/*
    串口透传使用的service id及characteristic id定义
 */
#define STR_SERVICE_ID_SERIAL_PORT      @"FFB0"
#define STR_CHARACTERISTIC_ID_COMMAND   @"FFB1"
#define STR_CHARACTERISTIC_ID_DATA      @"FFB2"

#define INT_SERVICE_ID_SERIAL_PORT      0xFFB0
#define INT_CHARACTERISTIC_ID_COMMAND   0xFFB1
#define INT_CHARACTERISTIC_ID_DATA      0xFFB2


//#define CHARACTERISTIC_ID_RX     @"FE10"

/*
    超时时间定义(s)
 */
#define TIMEOUT_CONNECT_PROCEDURE                   (10.0)
#define TIMEOUT_SERVICE_DISCOVER_PROCEDURE          (5.0)

/*
    命令定义
 */
#define  CMD_ENTER_TTM                          (0x01)
#define  RSP_ENTER_TTM                          (0x02)
#define  CMD_LEAVE_TTM                          (0x03)
#define  RSP_LEAVE_TTM                          (0x04)
#define  HAND_SHAKE_PACK                        (0x05)
#define  HAND_SHAKE_PACK_RESPONSE               (0x07)
#define  CMD_PHONE_MODE_SET                     (0x06)
#define  CMD_PHONE_MODE_SET_PAYLOAD             (0x01)


@implementation BLESerialComManager
@synthesize delegate;
@synthesize ports;
@synthesize state;


/**
 sharedInstance
 **/

+(BLESerialComManager *)sharedInstance{
    

    static BLESerialComManager *_sharedInstance = nil;
    
    static dispatch_once_t predicate; dispatch_once(&predicate, ^{
        _sharedInstance = [[self alloc] init];
                if (_sharedInstance) {
                    //默认参数设置
                    paramsPackage4Configure params;
                    params.lengthOfPackage = 10;
                    [_sharedInstance  configure:params];
        
                    [_sharedInstance initBLECentralManager];
                }
    });
    
    return _sharedInstance;
}

/**
 configure
 **/

-(resultCodeType)configure:(paramsPackage4Configure)params{
    //参数处理
    //接收长度通知参数
    _lengthOfPackageToReceive = params.lengthOfPackage;
    
    return RESULT_SUCCESS;
    
}

/**
 enumeratePorts
 **/
-(resultCodeType)startEnumeratePorts:(float)timeout{
    if (CM) {
        [CM stopScan];
        
        NSArray *services = [NSArray arrayWithObjects:[CBUUID UUIDWithString:STR_SERVICE_ID_SERIAL_PORT], nil];
        [CM scanForPeripheralsWithServices:services options:nil];
    }

    if (enumPortsTimer) {
        [enumPortsTimer invalidate];
        enumPortsTimer = nil;
    }
    
    if (ports.count > 0) {//清空
        [ports removeAllObjects];
    }
    
    
    enumPortsTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(enumPortsTimeout) userInfo:nil repeats:NO];
    
    
    return RESULT_SUCCESS;
}


/*
    stopEnumeratePorts
 */
-(resultCodeType)stopEnumeratePorts{
    if (enumPortsTimer) {
        //
        [enumPortsTimer invalidate];
        enumPortsTimer =  nil;
        
        [CM stopScan];
        
    }
    
    return RESULT_SUCCESS;
}
/**
 open:withParams:
 **/
-(resultCodeType)startOpen:(BLEPort *)port withParams:(paramsPackage4Open)params{
    if (![self isInPorts:port]) {
        return RESULT_ERROR_PORT_INVALID;
    }
    if (CM) {
        if (port.state == STATE_IDLE) {
            
            port.state = STATE_OPENING;
            //NSLog(@"connect peripheral with uuid %s",[self CFUUIDRefToString:port.peripheral.UUID]);
            [CM connectPeripheral:port.peripheral options:nil];
            port.connectTimer = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_CONNECT_PROCEDURE target:self selector:@selector(connectTimeout:) userInfo:port repeats:NO];
        }else{
            return RESULT_ERROR_STATE_WRONG;
        }

    }else{
        return RESULT_ERROR_NULL_ADDRESS;
    }
    return RESULT_SUCCESS;
    
}

/*
 writeData:toPort:withParams:
 */
-(resultCodeType)writeData:(NSData *)data toPort:(BLEPort *)port{
    
    [port.writeBuffer appendData:data];
    //NSLog(@"append data to buffer so that count %d",port.writeBuffer.length);
    [NSThread detachNewThreadSelector:@selector(startWriteData) toTarget:port withObject:nil];
    
    return RESULT_SUCCESS;
}

/*
 readDataFromPort:withLength:
 */
-(NSData *)readDataFromPort:(BLEPort *)port withLength:(int)length{
    if (port!=nil) {
        if (port.readBuffer) {
            int realLen = (length<=port.readBuffer.length)?(int)length:(int)port.readBuffer.length;
            NSData *rData = [port.readBuffer subdataWithRange:NSMakeRange(0, realLen)];
            if (realLen == port.readBuffer.length) {
                port.readBuffer = [[NSMutableData alloc] init];
            }else{
                port.readBuffer = [NSMutableData dataWithData:[port.readBuffer subdataWithRange:NSMakeRange(realLen, port.readBuffer.length-realLen)]];
            }
            return rData;
        }else{
            return nil;
        }
        
    }else{
        return nil;
    }

}
/*
    clearReadBufferInPort:
 */
-(resultCodeType)clearReadBufferInPort:(BLEPort *)port{
    if (port == nil) {
        NSLog(@"In clearReadBufferInPort : invalid param : port");
        return RESULT_ERROR_PORT_INVALID;
    }
    
    
    if (port.readBuffer && port.readBuffer.length != 0) {
        NSLog(@"In clearReadBufferInPort : cleared length = %lu",(unsigned long)port.readBuffer.length);
        [port.readBuffer resetBytesInRange:NSMakeRange(0, [port.readBuffer length])];
        [port.readBuffer setLength:0];
    }
    return RESULT_SUCCESS;
}


/*
 closePort:
 */
-(resultCodeType)closePort:(BLEPort *) port{
    if (port) {
        [CM cancelPeripheralConnection:port.peripheral];
        port.state = STATE_IDLE;
        
        return RESULT_SUCCESS;
    }
    return RESULT_ERROR_PORT_INVALID;
}

-(void)startDiscoverSerialPortServiceForPort:(BLEPort *)port{
    NSLog(@"startDiscoverSerialPortServiceForPort...\n");
    if (port) {
        if (port.state == STATE_OPENING && port.peripheral.state == CBPeripheralStateConnected) {
//            NSArray *services = [NSArray arrayWithObjects:[CBUUID UUIDWithString:STR_SERVICE_ID_SERIAL_PORT], nil];
            port.peripheral.delegate = self;
            [port.peripheral discoverServices:nil];
            port.discoverTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(serviceDiscoverTimeout:) userInfo:port repeats:NO];
        }
       
    }
}

-(void)commandCallback:(NSData *)cmd fromPort:(BLEPort *)port{
    //printf("command response %s\n",[cmd.description UTF8String]);
    unsigned char *cCmd = (unsigned char *)[cmd bytes];
    switch (*cCmd) {
        case HAND_SHAKE_PACK:
            [self sendCommand:HAND_SHAKE_PACK_RESPONSE toPort:port];
            break;
        case RSP_ENTER_TTM:
            
            break;
        case RSP_LEAVE_TTM:
            
            break;
        default:
            break;
    }
}

-(void)dataCallBack:(NSData *)data fromPort:(BLEPort *)port{
    if (data!=nil && data.length != 0) {
        [port.readBuffer appendData:data];
    }
    
   
    if ([self.delegate respondsToSelector:@selector(bleSerialComManager:didDataReceivedOnPort:withLength:)]) {
            [self.delegate bleSerialComManager:self didDataReceivedOnPort:port withLength:(int)data.length];
    }
        

}
//=============    Utilities    ================//
-(void)dataReadyForPort:(BLEPort *)port{
   // NSLog(@"data communication ready");
    [self notification:INT_SERVICE_ID_SERIAL_PORT characteristicUUID:INT_CHARACTERISTIC_ID_COMMAND p:port.peripheral on:YES];
    [self notification:INT_SERVICE_ID_SERIAL_PORT characteristicUUID:INT_CHARACTERISTIC_ID_DATA p:port.peripheral on:YES];
    
}
-(void)sendCommand:(unsigned char)command toPort:(BLEPort *)port{
    NSLog(@"send command : 0x%02x",command);
    [self writeValue:INT_SERVICE_ID_SERIAL_PORT characteristicUUID:INT_CHARACTERISTIC_ID_COMMAND p:port.peripheral data:[NSData dataWithBytes:&command length:1]];
}
-(void)setPhoneModeCommandToPort:(BLEPort *)port{
    //NSLog(@"setPhoneModeCommandToPort");
    unsigned char PhoneModeCommand[2] = {CMD_PHONE_MODE_SET,CMD_PHONE_MODE_SET_PAYLOAD};
    [self writeValue:INT_SERVICE_ID_SERIAL_PORT characteristicUUID:INT_CHARACTERISTIC_ID_COMMAND p:port.peripheral data:[NSData dataWithBytes:PhoneModeCommand length:2]];
}
-(UInt16) CBUUIDToInt:(CBUUID *) UUID {
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}
-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}
-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}
-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data
{
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];

    if (!service) {
//        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];//[[CBCharacteristic alloc] init];//
    //[characteristic setUUID:cu];
    printf("value %s write to characteristic 0x%2x!\n\n",[data.description UTF8String],characteristicUUID);
    if (!characteristic) {
//        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    
    if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
        [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    }else{
        [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on
{
    //printf("set characteristicUUID 0x%4x\n",characteristicUUID);
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
//        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self CFUUIDRefToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic)
    {
//        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
    //printf("\nsetNotifyValue characteristic : 0x%4x! ======> send out\r\n",characteristicUUID);
    
}
-(BOOL)isInPorts:(BLEPort *)port{
    for (BLEPort *p in ports) {
        if (p == port) {
            return YES;
        }
    }
    return NO;
}
-(void)initBLECentralManager{
    CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    ports = [[NSMutableArray alloc] init];
    self.state = CENTRAL_STATE_UNKNOWN;
}

-(void)enumPortsTimeout{
    [CM stopScan];
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(bleSerilaComManagerDidEnumComplete:)]) {
            [self.delegate bleSerilaComManagerDidEnumComplete:self];
        }
        
    }
}
-(void)connectTimeout:(NSTimer *)timer{
    
    BLEPort *port = timer.userInfo;
    port.state = STATE_IDLE;
    //NSLog(@"connect TIMEOUT peripheral uuid %s",[self CFUUIDRefToString:port.peripheral.UUID]);
    [CM cancelPeripheralConnection:port.peripheral];
}
-(void)clearConnectTimer:(BLEPort *)port{
    //NSLog(@"clear port connect timer\n");
    if (port.connectTimer) {
        [port.connectTimer invalidate];
        port.connectTimer = nil;
    }
}
-(void)clearDiscoverTimer:(BLEPort *)port{
    if (port.discoverTimer) {
        [port.discoverTimer invalidate];
        port.discoverTimer  = nil;
    }
}
-(void)serviceDiscoverTimeout:(NSTimer *)timer{
    BLEPort *port = [timer userInfo];
    [CM cancelPeripheralConnection:port.peripheral];
    if ([self.delegate respondsToSelector:@selector(bleSerilaComManager:didOpenPort:withResult:)]) {
        [self.delegate bleSerilaComManager:self didOpenPort:port withResult:RESULT_ERROR_DISCOVER_TIMEOUT];
    }
}

-(NSString *)getStateString:(CBCentralManagerState)lstate{
    switch (lstate) {
        case CBCentralManagerStateUnknown:
            return @"CBCentralManagerStateUnknown";
        case CBCentralManagerStatePoweredOff:
            return @"CBCentralManagerStatePoweredOff";
        case CBCentralManagerStatePoweredOn:
            return @"CBCentralManagerStatePoweredOn";
        case CBCentralManagerStateResetting:
            return @"CBCentralManagerStateResetting";
        case CBCentralManagerStateUnauthorized:
            return @"CBCentralManagerStateUnauthorized";
        case CBCentralManagerStateUnsupported:
            return @"CBCentralManagerStateUnsupported";
        default:
            break;
    }
}
-(BOOL)checkExistedInPorts:(CBPeripheral *)peripheral{
    if ([self getPortByPeripheral:peripheral] != nil) {
        return YES;
    }else{
        return NO;
    }
    
}
-(BLEPort *)getPortByPeripheral:(CBPeripheral *)peripheral{
    for (BLEPort *port in ports) {
        if (peripheral == port.peripheral) {//通过对地址的判断来确定是不是同一个peripheral
            return port;
        }
    }
    return nil;
}

-(const char *) CFUUIDRefToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}
-(const char *) CBUUIDToString:(CBUUID *) UUID {
    NSString *uuidString = [UUID.data description];
    return [[uuidString substringWithRange:NSMakeRange(1, uuidString.length-2)] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}
-(NSData *)getManufactureData:(NSDictionary *)advertisementData{
    if (advertisementData) {
        NSData *temp = [advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey];
        //NSLog(@"%s",[temp.description UTF8String]);
        NSData *header = [temp subdataWithRange:NSMakeRange(0, 4)];
        unsigned char cHeader[4] = {0x0b,0xde,0x01,0x01};
        if (header && [header isEqualToData:[NSData dataWithBytes:cHeader length:4]]) {
            //NSLog(@"corrent header found");
            return [temp subdataWithRange:NSMakeRange(4, 6)];
        
        }
    }
    return nil;
}
//=============    CBCentralManager Delegate   ==============//

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
//    NSLog(@"Central Manager Update State to  %s",[[self getStateString:central.state] UTF8String]);
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            self.state = CENTRAL_STATE_UNKNOWN;
            break;
        case CBCentralManagerStateResetting:
            self.state = CENTRAL_STATE_RESETTING;
            break;
        case CBCentralManagerStateUnsupported:
            self.state = CENTRAL_STATE_UNSUPPORTED;
            break;
        case CBCentralManagerStateUnauthorized:
            self.state = CENTRAL_STATE_UNAUTHORIZED;
            break;
        case CBCentralManagerStatePoweredOff:
            self.state = CENTRAL_STATE_POWEREDOFF;
            break;
        case CBCentralManagerStatePoweredOn:
            self.state = CENTRAL_STATE_POWEREDON;
            break;
            
        default:
            self.state = CENTRAL_STATE_END;
            break;
    }
    if ([self.delegate respondsToSelector:@selector(bleSerilaComManagerDidStateChange:)]) {
        [self.delegate bleSerilaComManagerDidStateChange:self];
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"didDiscoverPeripheral %s with advertisementdata %s",[peripheral.name UTF8String],[advertisementData.description UTF8String]);
    //端口
    BLEPort *portInPorts = [self getPortByPeripheral:peripheral];
    if (portInPorts != nil) {
        //NSLog(@"duplicate port ,update it ");
        portInPorts.peripheral = peripheral;
    }else{
       // NSLog(@"new port ,add it ,name:%s",[peripheral.name UTF8String]);
        
        portInPorts = [[BLEPort alloc] init];
        portInPorts.name = peripheral.name;//暂时使用
        portInPorts.state = STATE_IDLE;
        portInPorts.peripheral = peripheral;
        portInPorts.writeBuffer = [[NSMutableData alloc] init];
        portInPorts.readBuffer = [[NSMutableData alloc] init];
        portInPorts.address = [self getManufactureData:advertisementData];
        [ports addObject:portInPorts];
        
        if ([self.delegate respondsToSelector:@selector(bleSerilaComManager:didFoundPort:)]) {
            [self.delegate bleSerilaComManager:self didFoundPort:portInPorts];
        }
        
    }
    
   
    
}
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
   BLEPort *port = [self getPortByPeripheral:peripheral];
   
//    NSLog(@"didConnect with %s name %s",[self CFUUIDRefToString:peripheral.UUID],[peripheral.name UTF8String]);
    
    if (port == nil) {
        [CM cancelPeripheralConnection:peripheral];
    }else{

        port.peripheral.delegate = self;
        [self clearConnectTimer:port];
        [self startDiscoverSerialPortServiceForPort:port];
        
    }
    
    

    
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didDisconnectPeripheral");
     BLEPort *port = [self getPortByPeripheral:peripheral];
     port.state = STATE_IDLE;
    if ([self.delegate respondsToSelector:@selector(bleSerialComManager:didClosedPort:)]) {
        [self.delegate bleSerialComManager:self didClosedPort:port];
    }
    
    
}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{

}
//=============    CBPeripheral Delegate   ==============//

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
  
    NSLog(@"didDiscoverServices:%@",peripheral.services);
    
//    if (peripheral.services.count != 1) {//服务数量只能为1，为其他是额外的服务为不匹配
//        NSLog(@"error wrong service");
//    }else{
//        CBService *service = [peripheral.services objectAtIndex:0];
//        [peripheral discoverCharacteristics:nil forService:nil];
//    }
    for (int i=0; i < peripheral.services.count; i++) {
        CBService *s = [peripheral.services objectAtIndex:i];
        printf("Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"didDiscoverCharacteristicsForService 0x%4x",[self CBUUIDToInt:service.UUID]);
    BLEPort *port = [self getPortByPeripheral:peripheral];
    if (port == nil) {
        NSLog(@"error no found port");
        return;
    }
       // NSLog(@"=> found characteristics of service <%s>",[self CBUUIDToString:service.UUID]);
    
    for (CBCharacteristic *c in service.characteristics) {
        NSLog(@"=> characteristic <%s> 0x%2lx",[self CBUUIDToString:c.UUID],(unsigned long)c.properties);
    }
    
    
    CBService *lastService = [peripheral.services lastObject];
    
    if (lastService == service) {
       [self dataReadyForPort:port];
    }
    
//    if (service.characteristics.count == 2) {
//        [self.delegate bleSerilaComManager:self port:port withOpenResult:RESULT_SUCCESS];
//    }
    
    
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error==nil) {
         NSLog(@"update charactertistic %s 's state",[self CBUUIDToString:characteristic.UUID]);
        BLEPort *port = [self getPortByPeripheral:peripheral];
        [self clearDiscoverTimer:port];
        CBUUID *dataLine = [CBUUID UUIDWithString:STR_CHARACTERISTIC_ID_DATA];
        if ([dataLine isEqual:characteristic.UUID]) {
           // NSLog(@"set notification complete");

            [self setPhoneModeCommandToPort:port];
            [self sendCommand:CMD_ENTER_TTM toPort:port];
//            [self sendCommand:HAND_SHAKE_PACK toPort:port];
            
            if ([self.delegate respondsToSelector:@selector(bleSerilaComManager:didOpenPort:withResult:)]) {
                [self.delegate bleSerilaComManager:self didOpenPort:port withResult:RESULT_SUCCESS];
            }
            
        }
    }else{
        BLEPort *port = [self getPortByPeripheral:peripheral];
        NSLog(@"set notification error: %s",[error.description UTF8String]);
        [self.delegate bleSerilaComManager:self didOpenPort:port withResult:RESULT_ERROR_STATE_WRONG];
    }
}

-(void)delaySendOne:(BLEPort *)port{
    [NSThread sleepForTimeInterval:2.0];
    [self setPhoneModeCommandToPort:port];
}

-(void)delaySendTwo:(BLEPort *)port{
    [NSThread sleepForTimeInterval:2.0];
    [self sendCommand:CMD_ENTER_TTM toPort:port];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    NSLog(@"recevied value %s of characteristic %s ",[characteristic.value.description UTF8String],[self CBUUIDToString:characteristic.UUID]);
    BLEPort *port = [self getPortByPeripheral:peripheral];
    int characUUID = [self CBUUIDToInt:characteristic.UUID];
    switch (characUUID) {
        case INT_CHARACTERISTIC_ID_COMMAND:
            [self commandCallback:characteristic.value fromPort:port];
            break;
        case INT_CHARACTERISTIC_ID_DATA:
            [self dataCallBack:characteristic.value fromPort:port];
            break;
        
        default:
            break;
    }
}



@end
