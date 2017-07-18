//
//  YCFindChihuoCell.m
//  YouChi
//
//  Created by 李李善 on 15/8/7.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCFindChihuoCell.h"
#import "YCChihuoyingM.h"
#import "YCChihuoyingVM.h"

#import "UIViewController+Action.h"
#import "YCView.h"
#import "YCAvatarControl.h"
#import <Masonry/Masonry.h>

#import "YCMeM.h"
#import "YCChihuoyingVC.h"
#import "YCOthersInfoVC.h"
@implementation YCFindChihuoCell
-(void)dealloc{
    //    ok
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
//
    
//    UINib *nib = [UINib nibWithNibName:@"YCRecommandUsersCell" bundle:nil];
//    [_usersView registerNib:nib forCellReuseIdentifier:cell0];
//    
//    _usersView.scrollEnabled = NO;
//    _usersView.rowHeight = 58.f;
//    _usersView.backgroundColor = [UIColor clearColor];
//    _usersView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _usersView.opaque = YES;
//    
//
//    WSELF;
//    _usersView.updateBlock = ^(UITableViewCell *cell,YCMeM *m) {
//        SSELF;
//        YCAvatarControl *ac = [cell viewByTag:1];
//        UIButton *btn = [cell viewByTag:2];
//        
//        [ac updateAvatarControlWith:m.imagePath name:m.nickName sign:m.signature];
//        btn.selected = m.isFollow.boolValue;
//
//        [ac addTarget:self action:@selector(onAvatar:) forControlEvents:UIControlEventTouchUpInside];
//        [btn addTarget:self action:@selector(onFollow:) forControlEvents:UIControlEventTouchUpInside];
//    };
//
//    
//    
//    
//    
//    UIColor *normal = KBGCColor(@"272636");
//    UIColor *select = KBGCColor(@"e3e3e3");
//    [_findGuy setTitleColor:normal forState:UIControlStateNormal];
//    [_changeOthers setTitleColor:normal forState:UIControlStateNormal];
//    [_findGuy setTitleColor:select forState:UIControlStateSelected];
//    [_changeOthers setTitleColor:select forState:UIControlStateSelected];
//    
//    [_findGuy setNormalBgColor:nil selectedBgColor:nil highLightedBgColor:[UIColor lightGrayColor]];
//    [_changeOthers setNormalBgColor:nil selectedBgColor:nil highLightedBgColor:[UIColor lightGrayColor]];
//
}

- (void)update:(YCChihuoyingM_1_2 *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (_usersView.photos != model.userList) {
        _usersView.photos = model.userList;
        [_usersView reloadData];
    }
}


//-(void)onFollow:(UIButton *)sender{
//    UITableViewCell *cell = sender.findTableViewCell;
//    NSIndexPath *indexPath = [_usersView indexPathForCell:cell];
//    YCMeM *m =  _model.userList[indexPath.row];
//    BOOL isFollow = !m.isFollow.boolValue;
//    if ([self.pushedViewController isKindOfClass:[YCChihuoyingVC class]]) {
//        YCChihuoyingVC *vc = (id)self.pushedViewController;
//        [sender executeActivitySignal:[vc.viewModel followUserById:m.Id isFollow:isFollow]  next:^(id x) {
//            m.isFollow = @(isFollow);
//            sender.selected = isFollow;
//        } error:vc.errorBlock completed:nil executing:nil];
//    }
//}
//
//#pragma mark -- 用户详细信息
//- (void)onAvatar:(YCAvatarControl *)sender {
//    UITableViewCell *cell = sender.findTableViewCell;
//    if ([self.pushedViewController isKindOfClass:[YCChihuoyingVC class]]) {
//        YCChihuoyingVC *vc = (id)self.pushedViewController;
//        NSIndexPath *index = [_usersView indexPathForCell:cell];
//        YCMeM *m = _usersView.photos[index.row];
//        YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:m.Id];
//
//        [vc hideTabbar];
//        [vc pushTo:[YCOthersInfoVC class] viewModel:vm];
//    }
//
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
