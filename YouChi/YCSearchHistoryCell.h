//
//  YCSearchHistoryCell.h
//  YouChi
//
//  Created by 李李善 on 15/12/29.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *这是第一个单元格并且数组的长度>=2时候，就要用这个单元格
 */
@interface YCSearchHistoryCell : UITableViewCell
///搜索的内容
@property(nonatomic,strong)IBOutlet UILabel *searchTitle;
///删除按钮
@property(nonatomic,strong) IBOutlet UIButton *btnDelete;

@end

/**
 *除了第一个和最后单元格的时候，就要用这个单元格
 */
@interface YCSearchOneHistoryCell : YCSearchHistoryCell

@end
/**
 *最后单元格的时候，就要用这个单元格
 */
@interface YCSearchTwoHistoryCell : YCSearchHistoryCell

@end

/**
*当数组的长度为1的时候，就要用这个单元格
*/
@interface YCSearchThreeHistoryCell : YCSearchHistoryCell

@end