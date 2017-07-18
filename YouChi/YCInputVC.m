//
//  YCMeMessagSixVC.m
//  YouChi
//
//  Created by 李李善 on 15/6/23.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCInputVC.h"
#import "YCMeMessageVM.h"
#import "YCCommentVM.h"
#import "YCCommentListVC.h"
@interface YCInputVC ()
{
    float keyboardhight;
}
@end

@implementation YCInputVC

- (void)dealloc{
//    OK
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.Qianming becomeFirstResponder];
    
  

    if (self.viewModel.title) {
        self.title = self.viewModel.title;
    }
    
    self.Qianming.placeholder = @"输入点什么";
    
    if ([self.viewModel.viewModel isKindOfClass:[YCMeMessageVM class]]) {
        YCMeMessageVM *vm = self.viewModel.viewModel;
        if(vm.signture.length > 0) {
            self.Qianming.text = vm.signture;
        }
    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [[UIScreen mainScreen]bounds].size.height-64-216-70;
    
}



//关闭键盘(TextView) 换行时。隐藏键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



- (IBAction)onGoBack:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
    self.Qianming.text = [self.Qianming.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    CHECK(self.Qianming.text<=0, @"请输入");
    
    YCViewModel *vvm = self.viewModel.viewModel;
    if ([vvm isKindOfClass:[YCMeMessageVM class]]){
        YCMeMessageVM *vm = (id)vvm;
        [sender executeSignal:[vm saveSignal:@"signature" value:self.Qianming.text] next:^(id next) {
            [self showMessage:@"保存成功"];
            [self onReturn];
        } error:self.errorBlock completed:nil executing:self.executingBlock];
    }
  
    else if ([vvm isKindOfClass:[YCCommentVM class]]) {
        YCCommentVM *vm = (id)vvm;
        YCUserCommentM *m = vm.selectedModel;
        NSNumber *targetId = m.targetBody.Id;
        YCOriginalType originalType = m.originalType.intValue;
        YCCheatsType type;
        if (originalType == YCOriginalTypeYouChi) {
            type = YCCheatsTypeYouChi;
        }
        
        else if (originalType == YCOriginalTypeRecipe) {
            type = YCCheatsTypeRecipe;
        }
        
        else if (originalType == YCOriginalTypeNews) {
            type = YCCheatsTypeNews;
        }
        
        else {
            NSAssert(NO, @"没有这种评论");
        }
        
        [sender executeSignal:[self.viewModel replySignalId:targetId   replyCommentId:m.messageId replyUserId:m.pushUserId  comment:self.Qianming.text type:type] next:^(id next) {
            [self showMessage:@"评论成功"];
            [self.navigationController  popViewControllerAnimated:YES];
        } error:self.errorBlock completed:nil executing:nil];
        
        
        
    }
    
    else if ([vvm isKindOfClass:[YCCommentListVM class]]) {
        YCCommentListVM *vm = (id)vvm;
        YCCommentM *m = vm.selectedModel;
        
        [sender executeSignal:[vm replySignalId:m.youchiId   replyCommentId:m.Id replyUserId:m.userId  comment:self.Qianming.text type:0] next:^(id next) {
            [self showMessage:@"评论成功"];
            [self.navigationController  popViewControllerAnimated:YES];
        } error:self.errorBlock completed:nil executing:nil];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end