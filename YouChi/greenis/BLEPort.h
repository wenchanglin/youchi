//
//  BLEPort.h
//  BLESerialComManager
//
//  Created by 王 维 on 3/10/13.
//  Copyright (c) 2013 王 维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


typedef  NS_ENUM(NSInteger, PORT_STATE){
    STATE_IDLE,
    STATE_OPENING,
    STATE_OPENED,
    STATE_CLOSING,
    
    STATE_TYPE_END
};


@interface BLEPort : NSObject{
    // buffer
    NSMutableData       *writeBuffer;
    NSMutableData       *readBuffer;
    //
    BOOL                bWriteInProgressFlag;
}
@property (nonatomic,retain) NSString          *name;
@property (nonatomic)        PORT_STATE        state;
@property (nonatomic,retain) CBPeripheral      *peripheral;
@property (nonatomic,retain) NSTimer           *connectTimer;
@property (nonatomic,retain) NSTimer           *discoverTimer;
@property (atomic,retain)    NSMutableData     *writeBuffer;
@property (atomic,retain)    NSMutableData     *readBuffer;
@property (nonatomic,retain) NSData            *address;


-(void)startWriteData;
//-(NSData *)readData:(int)length;


@end
