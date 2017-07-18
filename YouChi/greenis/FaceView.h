
#import <UIKit/UIKit.h>

@protocol FaceViewDelegate <NSObject>
@optional

/*
 * 点击表情代理
 * @param faceName 表情对应的名称
 * @param del      是否点击删除
 *
 */
- (void)didSelecteFace:(NSString *)faceName andIsSelecteDelete:(BOOL)del;

@end

@interface FaceView : UIView

@property (nonatomic,strong) id <FaceViewDelegate> delegate;

/*
 * 初始化表情页面
 * @param frame     大小
 * @param indexPath 创建第几个
 *
 */
- (id)initWithIndex:(NSInteger)index;

@end
