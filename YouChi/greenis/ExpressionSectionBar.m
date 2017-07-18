
#import "ExpressionSectionBar.h"
#import "Masonry.h"
#import "AppConstants.h"

@interface ExpressionSectionBar () {
    
}

@property (strong, nonatomic) UIButton          *sendButton;

@end

@implementation ExpressionSectionBar

- (id)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor colorWithRed:255.0f/255 green:250.0f/255 blue:240.0f/255 alpha:1];
       
        self.backgroundColor = [UIColor clearColor];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _sendButton.layer.cornerRadius = 3;
//        _sendButton.backgroundColor = [UIColor orangeColor];
        [_sendButton setTitle:NSLocalizedString(@"send", @"") forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize: 20.0];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_sendButton addTarget:self action:@selector(sendButtonPress) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.backgroundColor = [AppConstants themeColor];
        [self addSubview:_sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
            make.width.equalTo(@100);
            make.right.equalTo(self.mas_right);//.with.offset(-20);
        }];
    }
    return self;
}

- (void)sendButtonPress {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"commentPost" object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
