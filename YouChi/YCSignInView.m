//
//  YCSignInView.m
//  YouChi
//
//  Created by sam on 15/10/22.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSignInView.h"

@implementation YCSignInView
{
    __weak IBOutlet UILabel *lAction;
    __weak IBOutlet UILabel *lCount;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc{
    //    ok
    
}
+ (void)showSignInView:(UIView *)view action:(NSString *)action count:(int)count
{
    UIWindow *window = view.window;
    
    if (window) {
        YCSignInView *signIn = [YCSignInView viewByClass:[YCSignInView class]];
        [window addSubview:signIn];
        
        
        CGRect bounds = window.bounds;
        bounds.size.width = 187.f;//MIN(bounds.size.width - 20, signIn.bounds.size.width);
        bounds.size.height = 69.f;//signIn.bounds.size.height;
        
        signIn.bounds = bounds;
        signIn.center = window.center;
        
        if (action) {
            UILabel *lAction = [signIn viewByTag:1];
            lAction.text = action;
        }
        
        if (count>0) {
            UILabel *lCount = [signIn viewByTag:2];
            lCount.text = @(count).stringValue;
        }
        
        [UIView animateWithDuration:3 animations:^{
            signIn.alpha = 10.f;
        } completion:^(BOOL finished) {
            [signIn removeFromSuperview];
        }];
    }
}

+ (void)showSignInView:(UIView *)view
{
    [self showSignInView:view action:nil count:0];
}
@end
