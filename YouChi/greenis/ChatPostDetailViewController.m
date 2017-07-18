//
//  ChatPostDetailViewController.m
//  SmartKitchen
//
//  Created by LICAN LONG on 15/11/2.
//  Copyright © 2015年 LICAN LONG. All rights reserved.
//

#import "ChatPostDetailViewController.h"
#import "ProgressHUD.h"
#import "Masonry.h"
#import "PostDetailCell.h"
#import "AppConstants.h"
#import "FileOperator.h"
#import "UIImageView+YYWebImage.h"
#import "PostPhotoBrowserViewController.h"
#import "ChatPostDetailDataModel.h"
#import "CommentContainer.h"

#import "MessageInputView.h"
#import "MessageManagerFaceView.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#import "PostPhotoBrowserViewController.h"


@interface ChatPostDetailViewController () <PostDetailCellDelegate, MessageInputViewDelegate, MessageManagerFaceViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView                      *verticalScrollView;
@property (strong, nonatomic) UIView                            *verticalScrollViewContainer;

@property (strong, nonatomic) ChatPostDetailDataModel           *chatPostDetailDataModel;
@property (strong, nonatomic) ChatPostDetailDataModel           *chatPostDetailDataModelTemp;

@property (strong, nonatomic) MessageInputView                  *messageInputView;
@property (strong, nonatomic) MessageManagerFaceView            *faceView;
@property (strong, nonatomic) PostDetailCell                    *postDetailCell;
@property (strong, nonatomic) UIView                            *separatedView;
@property (strong, nonatomic) CommentContainer                  *commentView;

@property (nonatomic) double                                    animationDuration;
@property (nonatomic) CGRect                                    keyboardRect;

@property (nonatomic) BOOL                                      isChatPostDetailDataLoaded;
@property (nonatomic) BOOL                                      isDataShow;

@property (nonatomic) NSInteger                                 index;
@property (nonatomic) float                                     commentViewY;
@property (nonatomic) float                                     totalHeight;

@property (strong, nonatomic)ChatLiaoLiaoPostDataModel          *data;

@end

@implementation ChatPostDetailViewController

- (instancetype)initWithData:(ChatLiaoLiaoPostDataModel*)data andIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _data = data;
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigationBar];
    [self initMessageInputView];
    [self initFaceView];
    [self initVerticalScrollView];
    [self initStatus];
    
    [ProgressHUD show:NSLocalizedString(@"loading", @"")];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendCommentPress) name:@"commentPost" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentBeTouch) name:@"commentBeTouch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setChatPostDetailData) name:@"ChatPostDetailRequestDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail) name:@"ChatPostDetailRequestFail" object:nil];
    
    _chatPostDetailDataModelTemp = [[ChatPostDetailDataModel alloc] initWithID:[_data.Id intValue] forUpdate:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"viewWillDisappear");
    
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
    
    _messageInputView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentPost" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentBeTouch" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardChange:)
                                                name:UIKeyboardDidChangeFrameNotification
                                              object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    NSLog(@"hide");
    
    _keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSLog(@"keyboardWillHide height = %f", _keyboardRect.size.height);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        /*
        [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];*/
        
        [_messageInputView layoutIfNeeded];
//        [_verticalScrollView layoutIfNeeded];
    }completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    NSLog(@"show");
    
    _keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _animationDuration= [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSLog(@"keyboardWillShow height = %f", _keyboardRect.size.height);
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-_keyboardRect.size.height);
        }];
        /*
        [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(-_keyboardRect.size.height);
        }];*/
        
        [_messageInputView layoutIfNeeded];
//        [_verticalScrollView layoutIfNeeded];
    }completion:nil];
}

- (void)keyboardChange:(NSNotification *)notification{
    
    NSLog(@"keyboardChange");
    /*
     if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight(self.view.frame)) {
     [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
     [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
     make.bottom.equalTo(self.view).with.offset(-_keyboardRect.size.height);
     }];
     [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(self.view).with.offset(-_keyboardRect.size.height);
     }];
     
     [_messageInputView layoutIfNeeded];
     [_verticalScrollView layoutIfNeeded];
     }completion:nil];
     }*/
}

- (void)setChatPostDetailData {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatPostDetailRequestDone" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatPostDetailRequestFail" object:nil];
    
    _chatPostDetailDataModel = _chatPostDetailDataModelTemp;
    
    _postDetailCell = [[PostDetailCell alloc] initWithData:_data andIsLikeable:YES andIndex:_index];
    
//    _postDetailCell = [[PostDetailCell alloc] initWithUsername:_username andPostID:_postid andUserID:_userid andAddtime:_addtime andContent:_content andImages:_images andThumbsupDegree:_thumbsupDegree andCommentDegree:_commentDegree andIndex:0];
    
    _postDetailCell.delegate = self;
    
    _isChatPostDetailDataLoaded = YES;
    
    [self prepareToShowData];
}

- (void)getDataFail {
    
}

- (void)initNavigationBar {
    self.navigationItem.title = NSLocalizedString(@"liaoliaoxiangqing", @"");
}
//下方的输入框
- (void)initMessageInputView {
    
    _messageInputView = [[MessageInputView alloc] init];
    //    _messageInputView.messageInputViewStyle = MessageInputViewStyleDefault;
    _messageInputView.delegate = self;
    [self.view addSubview:_messageInputView];
    
    [_messageInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.equalTo(_messageInputView.messageInputTextView.mas_height).with.offset(10);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-_keyboardRect.size.height);
    }];
}

- (void)initFaceView {
    self.faceView = [[MessageManagerFaceView alloc] init];
    self.faceView.delegate = self;
    self.faceView.userInteractionEnabled = YES;
    [self.view addSubview:self.faceView];
    
    [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(196);
    }];
}

- (void)initVerticalScrollView {
    _verticalScrollView = [UIScrollView new];
    _verticalScrollView.backgroundColor = [UIColor whiteColor];
    _verticalScrollView.scrollsToTop = YES;
    _verticalScrollView.delegate = self;
    [self.view addSubview:_verticalScrollView];
    [_verticalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(_messageInputView.mas_top);
    }];
    
    _verticalScrollViewContainer = [UIView new];
    _verticalScrollViewContainer.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:234.0/255.0 blue:232.0/255.0 alpha:1.0];
    [_verticalScrollView addSubview:_verticalScrollViewContainer];
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_verticalScrollView);
        make.width.equalTo(_verticalScrollView);
    }];
}

- (void)initStatus {
    _isDataShow = NO;
    _isChatPostDetailDataLoaded = NO;
    _keyboardRect = CGRectZero;
}

- (void)reloadAllData {
    
}

- (void)prepareToShowData {
    
    if (_isChatPostDetailDataLoaded)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initViews];
        });
    }
}

- (void)initViews {
    [self initPostCell];
    [self initCommentView];
    
    [ProgressHUD dismiss];
}

- (void)initPostCell {

    _postDetailCell.backgroundColor = [UIColor whiteColor];
    
    [_postDetailCell removeFromSuperview];
    [_verticalScrollViewContainer addSubview:_postDetailCell];
    
    [_postDetailCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_verticalScrollViewContainer);
        make.left.and.right.equalTo(_verticalScrollViewContainer);
    }];
    /*
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_postContainer);
    }];*/
}

- (void)initCommentView {
    
    _separatedView = [[UIView alloc] init];
    _separatedView.backgroundColor = [UIColor grayColor];
    [_verticalScrollViewContainer addSubview:_separatedView];
    [_separatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_postDetailCell.mas_bottom);
        make.height.equalTo(@3);
    }];
    
    _commentView = [[CommentContainer alloc] init];
    
    _commentView.imageNameArray = _chatPostDetailDataModel.avatarArray;
    _commentView.nameArray = _chatPostDetailDataModel.nickNameArray;
    _commentView.timeArray = _chatPostDetailDataModel.addTimeArray;
    _commentView.contentArray = _chatPostDetailDataModel.contentArray;
    _commentView.backgroundColor = [UIColor whiteColor];
    
    [_verticalScrollViewContainer addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_separatedView.mas_bottom);
    }];
    
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_commentView.mas_bottom);
    }];
}
//登陆在评论
- (void)sendComment:(NSString*)comment {/*
    
    if ([[AppConstants userInfo].accessToken isEqualToString:@""]) {
        
        [ProgressHUD showError:NSLocalizedString(@"dengluzaipinglun", @"")];
        
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    NSString *urlString = [NSString stringWithFormat:@"%@interaction/forum/comment/index.ashx", [AppConstants httpHeader]];

    NSDictionary *parameters = @{@"AccessToken":[AppConstants userInfo].accessToken, @"PostId":_data.Id, @"Content":comment};
    
    [manager POST:urlString parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              NSLog(@"%@ Success: %@", urlString, responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  [ProgressHUD showSuccess:NSLocalizedString(@"pinglunchenggong", @"")];
                  
                  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCommentView) name:@"ChatPostDetailRequestForUpdateDone" object:nil];
                  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommentFail) name:@"ChatPostDetailRequestForUpdateFail" object:nil];
//                  聊聊详情界面
                  _chatPostDetailDataModelTemp = [[ChatPostDetailDataModel alloc] initWithID:[_data.Id intValue] forUpdate:YES];
                  
                  _messageInputView.messageInputTextView.text = @"";
              }
              else if ([[responseObject objectForKey:@"errno"] isEqualToString:@"4401"]) {
                  [AppConstants relogin:^(BOOL success){
                      if (success) {
                          [self sendComment:comment];
                      }
                      else {
                          [AppConstants notice2ManualRelogin];
                      }
                  }];
              }
              else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                  [ProgressHUD showError:NSLocalizedString(@"pinglunshibai", @"")];
              }
              
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              NSLog(@"Error: %@", error);
              
              [ProgressHUD showError:NSLocalizedString(@"badNetwork", @"")];
          }];
*/}

- (void)CommentFail {
    
}

- (void)reloadCommentView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentRequestUpdateDone" object:nil];
    
    [_commentView removeFromSuperview];
    
    _chatPostDetailDataModel = _chatPostDetailDataModelTemp;
    
    _commentView = [[CommentContainer alloc] init];
    _commentView.imageNameArray = _chatPostDetailDataModel.avatarArray;
    _commentView.nameArray = _chatPostDetailDataModel.nickNameArray;
    _commentView.timeArray = _chatPostDetailDataModel.addTimeArray;
    _commentView.contentArray = _chatPostDetailDataModel.contentArray;
    _commentView.backgroundColor = [UIColor whiteColor];
    
    [_verticalScrollViewContainer addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_verticalScrollViewContainer);
        make.top.equalTo(_separatedView.mas_bottom);
    }];
    
    [_verticalScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_commentView.mas_bottom);
    }];

//    [self rollTheScrollViewToBottom:NO];
}

- (void)rollTheScrollViewToBottom:(BOOL)isToBottom {
    if (!isToBottom) {
        [UIView animateWithDuration:2 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [_verticalScrollView setContentOffset:CGPointMake(0, _commentViewY) animated:NO];
        }completion:nil];
    }
}

- (void)viewDidLayoutSubviews {
    //    NSLog(@"effectView width = %f, height = %f", _effectView.frame.size.width, _effectView.frame.size.height);
    
    float totalY = _postDetailCell.frame.size.height + _commentView.frame.size.height;
    
    _commentViewY = _postDetailCell.frame.size.height;
    
    if (totalY > _totalHeight) {
        _totalHeight = totalY;
    }
    
    NSLog(@"_totalHeight = %f, _commentViewY = %f", _totalHeight, _commentViewY);
}

#pragma mark - postDetailCellDelegate
- (void)postDetailCellClickAtData:(ChatLiaoLiaoPostDataModel *)data andIndex:(NSInteger)index{
    NSLog(@"click");
    
    _messageInputView.faceButtonSelected = NO;
    [_messageInputView.faceSendButton setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7"] forState:UIControlStateNormal];
    [_messageInputView.messageInputTextView resignFirstResponder];
}

- (void)postDetailCellHeadImageViewClickByUserid:(NSString*)userid andUsername:(NSString*)username andUserAvatar:(NSString*)Avatar {

}

- (void)postDetailCellContentImageViewClickAtIndex:(NSInteger)index andImages:(NSArray*)images {
    PostPhotoBrowserViewController *photoBrowserViewController = [[PostPhotoBrowserViewController alloc] initWithImages:images isUrl:YES andIndex:index];
    
    [self presentViewController:photoBrowserViewController animated:YES completion:nil];
    
    //    photoBrowserViewController.hidesBottomBarWhenPushed = YES;
    
    //    [self.navigationController pushViewController:photoBrowserViewController animated:YES];
    
    //    [self.navigationController presentViewController:photoBrowserViewController animated:YES completion:nil];
}

- (void)postDetailCellLongPressAtData:(ChatLiaoLiaoPostDataModel *)data {
    
}

- (void)postDetailCellChangeWithData:(ChatLiaoLiaoPostDataModel *)data andIndex:(NSInteger)index {
    [_delegate postDetailViewChangeWithData:data andIndex:index];
}

#pragma mark - MessageInputViewDelegate

- (void)didSendTextAction:(MessageTextView *)messageInputTextView {
    NSLog(@"text = %@", messageInputTextView.text);
    
    _messageInputView.faceButtonSelected = NO;
//    笑脸
    [_messageInputView.faceSendButton setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7"] forState:UIControlStateNormal];
    [_messageInputView.messageInputTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        
        [_faceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
        }];
        
        [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
        
        [_faceView layoutIfNeeded];
        [_messageInputView layoutIfNeeded];
        [_verticalScrollView layoutIfNeeded];
    }completion:nil];
    
    [self sendComment:messageInputTextView.text];
    
    messageInputTextView.text = @"";
}

- (void)didSendFaceAction:(BOOL)sendFace{
    
    if (sendFace) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).with.offset(-196);
            }];
            /*
            [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(-196);
            }];*/
            [_faceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_bottom).with.offset(-196);
            }];
            
            [_messageInputView layoutIfNeeded];
//            [_verticalScrollView layoutIfNeeded];
            [_faceView layoutIfNeeded];
        }completion:nil];
    }
    else{
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).with.offset(-_keyboardRect.size.height);
            }];
            /*
            [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(-_keyboardRect.size.height);
            }];*/
            [_faceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_bottom);
            }];
            
            [_messageInputView layoutIfNeeded];
//            [_verticalScrollView layoutIfNeeded];
            [_faceView layoutIfNeeded];
        }completion:nil];
    }
}

- (void)sendCommentPress {
    NSLog(@"sendCommentPress");
    NSLog(@"messageInputTextView = %@", _messageInputView.messageInputTextView);
    
    [self didSendTextAction:_messageInputView.messageInputTextView];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"dragging");
    
    _messageInputView.faceButtonSelected = NO;
    [_messageInputView.faceSendButton setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7"] forState:UIControlStateNormal];
    [_messageInputView.messageInputTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        
        [_faceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
        }];
        
        [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
        
        [_faceView layoutIfNeeded];
        [_messageInputView layoutIfNeeded];
        [_verticalScrollView layoutIfNeeded];
    }completion:nil];
}

/*
 * 点击输入框代理方法
 */
- (void)inputTextViewWillBeginEditing:(MessageTextView *)messageInputTextView{
    
}

- (void)inputTextViewDidBeginEditing:(MessageTextView *)messageInputTextView
{
    /*
     [self messageViewAnimationWithMessageRect:keyboardRect
     withMessageInputViewRect:self.messageToolView.frame
     andDuration:animationDuration
     andState:ZBMessageViewStateShowNone];
     */
}

- (void)inputTextViewDidChange:(MessageTextView *)messageInputTextView
{
    NSLog(@"messageInputTextView.text = %@", messageInputTextView.text);
    //    CGFloat maxHeight = [MessageInputView maxHeight];
    //    CGSize size = [messageInputTextView sizeThatFits:CGSizeMake(CGRectGetWidth(messageInputTextView.frame), maxHeight)];
    //    CGFloat textViewContentHeight = size.height;
    /*
     // End of textView.contentSize replacement code
     BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
     CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
     
     if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
     changeInHeight = 0;
     }
     else {
     changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
     }
     
     if(changeInHeight != 0.0f) {
     
     [UIView animateWithDuration:0.01f
     animations:^{
     
     if(isShrinking) {
     // if shrinking the view, animate text view frame BEFORE input view frame
     [self.messageToolView adjustTextViewHeightBy:changeInHeight];
     }
     
     CGRect inputViewFrame = self.messageToolView.frame;
     self.messageToolView.frame = CGRectMake(0.0f,
     inputViewFrame.origin.y - changeInHeight,
     inputViewFrame.size.width,
     inputViewFrame.size.height + changeInHeight);
     
     if(!isShrinking) {
     [self.messageToolView adjustTextViewHeightBy:changeInHeight];
     }
     }
     completion:^(BOOL finished) {
     
     }];
     
     self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
     }*/
}

- (int)searchFaceStr {
    
    int location = -1;
    
    NSString *str = _messageInputView.messageInputTextView.text;
    NSUInteger strLength = [str length];
    NSString *lastChar = [str substringWithRange:NSMakeRange(strLength - 1,1)];
    if ([lastChar isEqualToString:@"]"]) {
        NSRange range = [str rangeOfString:@"["options:NSBackwardsSearch];
        //判别查找到的字符串是否正确
        if (range.length> 0) {
            location = (int)range.location;
        }
    }
    
    return location;
}

- (void)deleteFaceStr:(int)location {
    NSString *str = _messageInputView.messageInputTextView.text;
    
    _messageInputView.messageInputTextView.text = [str substringWithRange:NSMakeRange(0, location)];
}

#pragma mark - ZBMessageFaceViewDelegate
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele
{
    if (dele) {
        int location = [self searchFaceStr];
        if (location != -1) {
            [self deleteFaceStr:location];
        }
        else {
            [_messageInputView.messageInputTextView deleteBackward];
            
        }
        return;
    }
    
    _messageInputView.messageInputTextView.text = [_messageInputView.messageInputTextView.text stringByAppendingString:faceStr];
    [self inputTextViewDidChange:_messageInputView.messageInputTextView];
    
    [_messageInputView.messageInputTextView scrollRangeToVisible:NSMakeRange(_messageInputView.messageInputTextView.text.length, 1)];
}

- (void)commentBeTouch {
    NSLog(@"touch");
    
    _messageInputView.faceButtonSelected = NO;
    [_messageInputView.faceSendButton setImage:[UIImage imageNamed:@"ToolViewEmotion_ios7"] forState:UIControlStateNormal];
    [_messageInputView.messageInputTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_messageInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        
        [_faceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
        }];
        
        [_verticalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
        
        [_faceView layoutIfNeeded];
        [_messageInputView layoutIfNeeded];
        [_verticalScrollView layoutIfNeeded];
    }completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
