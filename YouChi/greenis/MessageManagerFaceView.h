
#import <UIKit/UIKit.h>
#import "FaceView.h"

@protocol MessageManagerFaceViewDelegate <NSObject>

- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele;

@end

@interface MessageManagerFaceView : UIView <UIScrollViewDelegate,FaceViewDelegate>

@property (nonatomic,strong) id <MessageManagerFaceViewDelegate> delegate;

@end
