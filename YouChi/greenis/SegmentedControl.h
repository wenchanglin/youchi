
#import <UIKit/UIKit.h>

@protocol SegmentedControlDelegate <NSObject>

@required
//代理函数 获取当前下标
- (void)segmentedControlSelectAtIndex:(NSInteger)index;

@end

@interface SegmentedControl : UIView

@property (assign, nonatomic) id<SegmentedControlDelegate>delegate;
//初始化函数 
- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate;
//提供方法改变 index
- (void)changeSegmentedControlWithIndex:(NSInteger)index;

@end
