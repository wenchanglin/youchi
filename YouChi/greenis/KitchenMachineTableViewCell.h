//
//  KitchenMachineTableViewCell.h
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/6.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface KitchenMachineTableViewCell : UITableViewCell

@property (strong, nonatomic) BLEPort     *data;
@property (nonatomic) BOOL                 isConnected;
@end
