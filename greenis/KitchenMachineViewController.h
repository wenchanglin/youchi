//
//  KitchenMachineViewController.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/6.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEPort.h"
#import "BLESerialComManager.h"

@interface KitchenMachineViewController : UIViewController <BLESerialComManagerDelegate>

@property (strong, nonatomic) BLEPort     *port;

- (instancetype)initWithPort:(BLEPort*)port;

@end
