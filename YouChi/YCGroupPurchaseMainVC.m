//
//  YCGroupPurchaseMainVC.m
//  YouChi
//
//  Created by 李李善 on 16/5/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCOthersInfoVC.h"
#import "YCGroupPurchaseMainVC.h"
#import "YCRecipientAddressVC.h"
#import "YCContainerControl.h"
#import "YCPurchaseQrCodeVC.h"
#import "YCWebVC.h"
#import "YCGoodsCommentVC.h"
#import "YCGroupPlayView.h"
#import "YCPayGroupPurchaseVC.h"
#import "YCGroupPurchaseVCP.h"
#import "YCFixOrderVC.h"
#import "YCGroupBottomActionBar.h"
#import "YCOrderDetailedVC.h"
@interface YCGroupPurchaseMainVCP ()
PROPERTY_STRONG_VM(YCGroupPurchaseMainVM);
@property (strong, nonatomic) IBOutlet YCGroupBottomActionBar *bottomBar;
///右按钮
@property (weak, nonatomic)  UIButton *btnSponsorPay;
///左按钮
@property (weak, nonatomic)  UIButton *btnPayPeople;
@property (weak, nonatomic) UITableViewController *tvc;
@end

@implementation YCGroupPurchaseMainVCP
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///结算情况问题
    WSELF;
    self.view.backgroundColor = KBGCColor(@"efeff4");
    [RACObserve(self.viewModel,model).deliverOnMainThread subscribeNext:^(YCCreateGroupPurchaseM * m) {
        SSELF;
        if(m) {
            self.title = self.viewModel.title;
            
            
            if (m.isJoin.boolValue) {
                UIButton *groupAction = [UIButton new];
                groupAction.size = CGSizeMake(80, 30);
                [groupAction setNormalTitle:m.isSponsor.boolValue?@"解散团拼":@"退出团拼"];
                [groupAction setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    BOOL b = m.isSponsor.boolValue;
                    NSString *msg = b?@"确定解散团拼？":@"确定退出团拼？";
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [[av.rac_buttonClickedSignal ignore:@(av.cancelButtonIndex)]subscribeNext:^(id x) {
                        SSELF;
                        [self executeSignal:b?[self.viewModel dissolveGroupBuyByGroupBuyId:self.viewModel.groupBuyId]:[self.viewModel cancelGroupByGroupBuyId:self.viewModel.groupBuyId] next:^(id next) {
                            [self showMessage:@"成功"];
                            
                            [self onReturn];
                            [[NSNotificationCenter defaultCenter]postNotificationName:YCPayGroupPurchaseVCNotification object:nil];
                        } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
                    }];
                    
                    [av show];
                }];
                
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:groupAction];
            } else {
                self.navigationItem.rightBarButtonItem = nil;
            }
            
            [self.bottomBar updateColors];
            self.btnPayPeople = self.bottomBar.btnLeft;
            self.btnSponsorPay = self.bottomBar.btnRight;
            
            
            [self.btnPayPeople setNormalTitle:@"邀请小伙伴"];
            
            YCGroupTag tag = m.tag.intValue;
            YCGroupStatus status = m.status.intValue;
            
            if (tag == YCGroupTagStatusSubmittedOrderDidNotPay || tag == YCGroupTagStatusSubmittedOrderDidPay) {
                
                if (m.noPayCount.intValue == 0) {
                    [self.btnPayPeople setNormalTitle:@"所有人已结算"];
                } else {
                    [self.btnPayPeople setNormalTitle:[NSString stringWithFormat:@"还有 %d 人未付款",m.noPayCount.intValue]];
                }
                
                [self.btnPayPeople  setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
                self.btnPayPeople.enabled = NO;
            }
            
            if (tag == YCGroupTagStatusComplete) {
                self.btnPayPeople.hidden = YES;
            }
            
            
#pragma mark - 邀请
            [self.btnPayPeople setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                SSELF;
                ///1，3
                if (tag == YCGroupTagStatusSponsorDidNotOrder || tag == YCGroupTagStatusDidNotSubmittedOrder) {
                    [self pushTo:[YCPurchaseQrCodeVC class] viewModel:[[YCPurchaseQrCodeVM alloc]initWithId:m.groupBuyId]];
                }else {
                    [self showmMidMessage:@"已结算，请等待发起人确认订单"];
                }
            }];
            
            
            
            
#pragma mark - 结算
            [self.btnSponsorPay setNormalTitle:@"参与团拼"];
            self.btnSponsorPay.enabled = YES;
            [self.btnSponsorPay setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
            
            //1
            if (tag == YCGroupTagStatusSponsorDidNotOrder && m.isJoin.boolValue) {
                [self.btnSponsorPay setTitle:@"等待发起人支付" forState:UIControlStateDisabled];
                [self.btnSponsorPay setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
                self.btnSponsorPay.enabled = NO;
            }
            //2
            else if (tag == YCGroupTagStatusSponsorDidOrder) {
                if (status == 2 && !m.isPay.boolValue) {
                    [self.btnSponsorPay setNormalTitle:@"结算"];
                }
                self.btnPayPeople.enabled = YES;
            }
            
            //3
            else if (tag == YCGroupTagStatusDidNotSubmittedOrder) {
                [self.btnSponsorPay setNormalTitle:@"结算"];
            }
            
            else if (tag == YCGroupTagStatusSubmittedOrderDidNotPay) {
                [self.btnSponsorPay setNormalTitle:@"立即支付"];
            }
            
            //5
            else if (tag == YCGroupTagStatusSubmittedOrderDidPay ) {
                if (m.isPay.boolValue) {
                    [self.btnSponsorPay setNormalTitle:@"查看订单"];
                    self.btnPayPeople.enabled = YES;
                } else {
                    [self.btnSponsorPay setNormalTitle:@"结算"];
                    self.btnPayPeople.enabled = YES;
                }
                
                
            }
            
            
            
            
            [self.btnSponsorPay setBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * _Nonnull sender) {
                SSELF;
                ///1
                if (tag == YCGroupTagStatusSponsorDidNotOrder) {
                    
                    
                    [sender executeActivitySignal:self.viewModel.joinGroup next:^(id next) {
                        [self.tvc.tableView reloadData];
                    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
                    //                    }
                    
                }
                
                ///3
                else if (tag == YCGroupTagStatusDidNotSubmittedOrder) {
                    
                    
                    YCFixOrderVM *vm =
                    [[YCFixOrderVM alloc]initWithParameters:@{
                                                              @"groupBuyId":self.viewModel.groupBuyId,
                                                              @"userAddressId":m.shopUserAddress.userAddressId,
                                                              @"qty":@(self.viewModel.count),
                                                              @"specId":self.viewModel.specId,
                                                              kToken:[YCUserDefault currentToken],
                                                              }];
                    
                    vm.orderType = YCOrderTypeGroup;
                    vm.Id = self.viewModel.groupBuyId;
                    [self pushTo:[YCFixOrderVC class] viewModel:vm];
                }
                
                ///4提交过订单，未支付
                else if (tag == YCGroupTagStatusSubmittedOrderDidNotPay) {
                    SSELF;
                    [sender executeActivitySignal:[self.viewModel payItNow:m.orderId] next:^(id next) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
                }
                
                ///5
                else  if (tag == YCGroupTagStatusSubmittedOrderDidPay) {
                    
                    
                    
                    YCOrderDetailedVC *vc = [YCOrderDetailedVC vcClass];
                    YCOrderDetailedVM *vm = [[YCOrderDetailedVM alloc]initWithParameters:@{@"orderId":m.orderId}];
                    vm.viewModel = vm;
                    [self pushToVC:vc];
                    vc.viewModel.parameters = @{@"orderId":m.orderId};
                }
                
                
                
            }];
            
        } else {
            self.title = @"正在加载中";
        }
    }];
    
}

#pragma mark-------解散团拼
-(void)onDissolveGroup
{
    //    WSELF;
    //    NSString *msg = self.viewModel.model.isSponsor.boolValue?@"解散团拼":@"退出团拼";
    //    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    [[[alertView rac_buttonClickedSignal]ignore:@(alertView.cancelButtonIndex)]subscribeNext:^(id x) {
    //        SSELF;
    //        [self executeSignal:self.viewModel.ondissolveGroupBuy next:^(id next) {
    //            [self showMessage:@"成功"];
    //            [self onReturn];
    //            [[NSNotificationCenter defaultCenter]postNotificationName:YCPayGroupPurchaseVCNotification object:nil];
    //        } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
    //
    //    }];
    //    [alertView show];
}


#pragma mark-------邀请伙伴
-(IBAction)onInvite:(id)sender{
    
    //    YCPurchaseQrCodeVM *vm = [[YCPurchaseQrCodeVM alloc]initWithId:self.viewModel.groupBuyId];
    //    [self pushTo:[YCPurchaseQrCodeVC class] viewModel:vm];
    
}

#pragma mark-------立即结算/马上加入团拼
- (IBAction)onPurchaes:(UIButton *)sender {
    
    //    YCPayGroupPurchaseM *model = (id)self.viewModel.model;
    //
    //    if ([self.viewModel.groupBuyId intValue]==0) {
    //        return;
    //    }
    //
    //    if (self.viewModel.isQrCode) { //  若是二维码  则加入团拼
    //
    //        YCPayGroupPurchaseVM *vm = [[YCPayGroupPurchaseVM alloc]initWithParameters:@{@"groupBuyId":self.viewModel.groupBuyId
    //                                                                                ,@"qty":model.qty,
    //                                                                                @"specId":model.shopSpec.specId,
    //                                                                                kToken:[YCUserDefault currentToken],}];
    //        vm.groupPeople = YCGroupPurchaseMember;
    //        [self pushTo:[YCPayGroupPurchaseVC class] viewModel:vm];
    //
    //    }else{  // 发起人时 直接付款
    //
    //        YCFixOrderVM *vm = [[YCFixOrderVM alloc]initWithId:self.viewModel.groupBuyId];
    //
    //        vm.orderType = YCOrderTypeGroup;
    //        [self pushTo:[YCFixOrderVC class] viewModel:vm];
    //    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setViewModel:self.viewModel];
    self.tvc = segue.destinationViewController;
}


@end




@interface YCGroupPurchaseMainVC ()
PROPERTY_STRONG_VM(YCGroupPurchaseMainVM);
@property (strong,nonatomic) UILabel *receiverLbl;//收货人
@property (strong,nonatomic) UILabel *addressLbl;//收货地址
@property (strong,nonatomic) UILabel *phoneLbl;//联系电话


@end

@implementation YCGroupPurchaseMainVC
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)onSetupCell
{
    [super onSetupCell];
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self onMainSignalExecute:nil];
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier{
    
    [super onConfigureCell:cell reuseIdentifier:reuseIdentifier];
    WSELF;
    
    float edge = YCItemDetailInnerGroupEdge-5;
    float groupEdge =YCCreateGroupTop;
    float left =YCItemDetailInnerGroupEdge;
    float top  =YCItemDetailInnerGroupEdge;
    float width  =YCItemDetailInnerGroupEdge;
    //左右间隔
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, groupEdge, 0, groupEdge);
    //上左右间隔
    UIEdgeInsets TLREdgeInsets = UIEdgeInsetsMake(groupEdge, groupEdge, 0, groupEdge);
    
    cell.backgroundColor = self.tableView.backgroundColor;
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
#pragma mark - 线条-
    NSArray *reuseIdentifiers = @[cell2,cell3,cell4,cell5,cell3_0,cell7,cell8,cell9,cell10,cell12,cell13,@"c20",@"c21"];
    if ([reuseIdentifiers indexOfObject:reuseIdentifier] != NSNotFound) {
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIEdgeInsets insets = UIEdgeInsetsMake(0, YCItemDetailEdge, 0, YCItemDetailEdge);
            
            cell.backgroundColor = [UIColor clearColor];
            view.backgroundColor = [UIColor whiteColor];
            
            cell.selectedBackgroundView.clipsToBounds = YES;
            CGFloat height = 1/[UIScreen mainScreen].scale;
            
            CAShapeLayer *line = [CAShapeLayer layer];
            
            if (reuseIdentifier == cell3 || reuseIdentifier == cell2 || reuseIdentifier == cell4 ||[reuseIdentifier  isEqualToString: @"c20"]) {
                
                line = nil;
            }
            
            line.backgroundColor = [UIColor colorWithHexString:@"#c8c7cc"].CGColor;
            [view.layer addSublayer:line];
            
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                CGRect rect = UIEdgeInsetsInsetRect(frame, insets);
                view.frame = rect;
                
                rect.origin.x = 0;
                rect.size.height = height;
                line.frame = UIEdgeInsetsInsetRect(rect, insets);
                
                cell.selectedBackgroundView.frame = rect;
            }];
            
        }];
    }
    
#pragma mark - 团拼发起人
    if(reuseIdentifier == cell1){
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YCPurchaseInfoView *purchaseInfoView = [YCPurchaseInfoView newInSuperView:view];
            view.backgroundColor = [UIColor whiteColor];
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [purchaseInfoView yc_initView];
                
                [purchaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 14, 0, 14));
                }];
                    #pragma mark - 点击头像
                purchaseInfoView.numberOfPurchaseView.photosView.selectBlock = ^(NSIndexPath *indexPath,YCshopGroupBuySubsM *model) {
                    SSELF;
                    YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:model.appUser.Id];
                    [self pushTo:[YCOthersInfoVC class] viewModel:vm];
                    
                };
                
            }];
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCItemDetailM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                if (![cell checkIsHasSetData:m]) {
                    [purchaseInfoView updateWithItem:m];
                }
            }];
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                view.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(8, 5, 8, 5));
            }];
        }];
        return;
    }
    
#pragma mark-------统一收货地址
    if (reuseIdentifier==cell2){
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIImageView *imageV = [UIImageView newInSuperView:view];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            UILabel *adderss = [UILabel newInSuperView:view];
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                adderss.font = KFontBold(15);
                adderss.textColor = KBGCColor(@"333333");
                
                [@[imageV,adderss] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view.mas_centerY);
                }];
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(15);
                    make.width.mas_equalTo(12);
                    make.left.equalTo(view.mas_left).offset(10);
                    make.right.equalTo(adderss.mas_left).offset(-10);
                }];
                [adderss mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view);
                }];
                
            }];
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                
                id m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                imageV.image = indexPath.section==2?IMAGE(@"定位"):IMAGE(@"发起团拼_小icon");
                adderss.text = m;
            }];
            
        }];
        return;
    }
    if (reuseIdentifier==cell4){
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            if (self.receiverLbl == nil) {
                self.receiverLbl = [UILabel newInSuperView:view];//收件人
            }
            if (self.addressLbl == nil) {
                self.addressLbl = [UILabel newInSuperView:view];//收货地址
            }
            if (self.phoneLbl == nil) {
                self.phoneLbl = [UILabel newInSuperView:view];//电话
            }
            
            UIView *line = [UIView newInSuperView:view];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                line.backgroundColor = [UIColor colorWithHexString:@"#c8c7cc"];
                self.phoneLbl.font=self.receiverLbl.font = KFont(15);
                self.addressLbl.font = KFont(12);
                self.addressLbl.numberOfLines = 0.f;
                
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view).offset(-10);
                    make.left.equalTo(view).offset(10);
                    make.top.equalTo(view);
                    make.height.equalTo(@(1/[UIScreen mainScreen].scale));
                }];
                //left
                [@[self.receiverLbl,self.addressLbl] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).offset(10);
                }];
                
                //top
                [@[self.receiverLbl,self.phoneLbl] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(view).offset(2*YCCreateGroupTop).priorityHigh();
                }];
                [@[self.addressLbl] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.receiverLbl.mas_bottom).offset(2*YCCreateGroupTop).priorityHigh();
                }];
                //right
                [@[self.phoneLbl] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view.mas_right).offset(-2*left);
                }];
            }];
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                YCRecipientAddressM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                self.addressLbl.text = m.completeAddress;
                self.receiverLbl.text = m.completeName;
                self.phoneLbl.text = m.receiverPhone;
                
            }];
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                view.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, 5, 10, 5));
            }];
        }];
        return;
    }
#pragma mark-------选择数量
    if (reuseIdentifier == cell3_0) {
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UILabel *l1 = [UILabel newInSuperView:view];
            UILabel *l2 = [UILabel newInSuperView:view];
            UIButton *minus = [UIButton newInSuperView:view];
            UILabel *count = [UILabel newInSuperView:view];
            UIButton *plus = [UIButton newInSuperView:view];
            
            
            [minus addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
                SSELF;
                if (self.viewModel.sum == 0 || self.viewModel.count == 1) {
                    return ;
                }
                
                self.viewModel.count = MAX(--self.viewModel.count, 0);
                count.text = @(self.viewModel.count).stringValue;
            }];
            
            [plus addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
                SSELF
                if (self.viewModel.sum ==0) {
                    return ;
                    
                }
                self.viewModel.count = MIN(++self.viewModel.count,self.viewModel.sum);
                count.text = @(self.viewModel.count).stringValue;
            }];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                
                SSELF;
                YCItemDetailM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                l1.text = [NSString stringWithFormat:@" 团拼 %.1f折  ",[m.nowProductStrategy.discount floatValue]*10];
                
                YCShopSpecM *specsM   = m.shopProduct.shopSpecs[self.viewModel.selectedshopSpecIndex];
                
                count.text= @(self.viewModel.count).stringValue;
                l2.text = @"";
                l2.text   = [NSString stringWithFormat:@"¥%.2f/份",specsM.specMoneyPrice.floatValue];
            }];
            
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                count.textAlignment=l1.textAlignment = NSTextAlignmentCenter;
                l1.font = KFont(12);
                l1.backgroundColor =  UIColorHex(333333);
                l1.clipsToBounds = YES;
                l1.cornerRadius = 4;
                l1.textColor = [UIColor whiteColor];
                [l1 sizeToFit];
                
                l2.font = KFont(20);
                l2.textColor = [UIColor blackColor];
                
                
                count.text = @(1).stringValue;
                [minus setImage:IMAGE(@"减") forState:UIControlStateNormal];
                [plus setImage:IMAGE(@"加") forState:UIControlStateNormal];
                minus.contentMode = UIViewContentModeScaleAspectFill;
                plus.contentMode = UIViewContentModeScaleAspectFill;
                //                plus.enabled = minus.enabled = NO;
                //centerY
                [@[l1,l2,minus,count,plus] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view);
                }];
                //height.width
                [@[minus,plus] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(view).offset(-width+5);
                    make.width.equalTo(view.mas_height).offset(-10);
                }];
                //left
                [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).offset(edge);
                    make.height.mas_equalTo(@20);
                    //                    make.width.mas_equalTo(@40);
                }];
                [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(l1.mas_right).offset(left);
                }];
                //right
                [minus mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.greaterThanOrEqualTo(l2.mas_right);
                    make.right.equalTo(count.mas_left);//.offset(-edge);
                }];
                [count mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(plus.mas_left);//.offset(-edge);
                    make.width.mas_equalTo(22);
                }];
                [plus mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view).offset(-5);
                }];
                
            }];
            
            
        }];
        return;
    }
#pragma mark-------规格
    if (reuseIdentifier == cell5) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            UILabel *label = cell.textLabel;
            UIImageView *tick = [[UIImageView alloc]initWithImage:IMAGE(@"钩2")];
            cell.accessoryView = tick;
            label.font = KFont(12);
            label.textColor = color_light_text;
            label.numberOfLines = 0;
            tick.hidden = NO;
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                
                SSELF;
                YCShopSpecM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                NSInteger row = indexPath.row;
                label.text = m.specName;
                BOOL b = (self.viewModel.selectedshopSpecIndex == row);
                tick.hidden = !b;
                
            }];
            
            [cell setSelectBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                
                NSInteger row = indexPath.row;
                
                if (self.viewModel.selectedshopSpecIndex != row) {
                    
                    [self executeSignal:self.viewModel.onSelectSpecChangePrice next:^(id next) {
                        self.viewModel.selectedshopSpecIndex = row;
                        //TODO:这里没有改变到
                        [self.viewModel updateSelectCount];
                        
                        [self.tableView reloadSection:5 withRowAnimation:UITableViewRowAnimationNone];
                        
                        [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
                        
                        //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
                    
                } else {
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
                
                
                
            }];
            
            
        }];
        
        return;
    }
    
#pragma mark ----结算
    if ([reuseIdentifier isEqualToString:@"c20"]){
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            UILabel *lGong = [UILabel newInSuperView:view];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *lbtn = [UILabel newInSuperView:view];
            [cell setSelectBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                //TODO:点击事件－－－团拼玩法
                NSLog(@"--->>%@",@"结算规则");
                YCWebVC *web = [[YCWebVC alloc]initWithUrlString: url_jiesuan];
                [self pushToVC:web];
            }];
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                
                view.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(10, 5, 0, 5));
            }];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                lGong.text = @"结算情况";
                lGong.font = KFontBold(14);
                lGong.textColor = KBGCColor(@"333333");
                
                lbtn.textAlignment = NSTextAlignmentRight;
                lbtn.text = @"结算与发货规则 >>";
                lbtn.textColor = KBGCColor(@"#848484");
                lbtn.font = KFont(12);
                view.backgroundColor = [UIColor whiteColor];
                
                [@[lGong,lbtn] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view.mas_centerY);
                }];
                [lGong mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left).offset(left);
                }];
                [lbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view).offset(-10);
                }];
                
            }];
            
            
        }];
        return;
    }
    
#pragma mark-------催结算
    if ([reuseIdentifier isEqualToString:@"c21"]){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            YCGroupSettlementView *cc = [YCGroupSettlementView  newInSuperView:view];
            
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [cc yc_initView];
                
                [cc mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(2, 14, 0,20));
                }];
                
                
                [[cc.bPay rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                    SSELF;
                    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                    YCPayGroupPurchaseM  *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                    YCShopGroupBuySubM *subM = m.shopGroupBuySubs[indexPath.row];
                    YCLoginUserM *userM =subM.appUser;
                    if (cc.groupPayState==YCGroupPayStateNotPay) {
                        
                        [self executeSignal:[self.viewModel onUrgePay:userM.Id groupBuyId:m.groupBuyId] next:^(id next) {
                            cc.bPay.enabled = NO;
                            [cc.bPay backColor:KBGCColor(@"a9a9a9")];
                            [self showMessage:@"催款成功!!"];
                        } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
                        
                    }else if (cc.groupPayState==YCGroupPayStateSelfNotPay){
                        
                        
                        // 若是提交过订单
                        if (self.viewModel.model.tag.intValue == YCGroupTagStatusSubmittedOrderDidNotPay) {
                            SSELF;
                            [cc.bPay executeActivitySignal:[self.viewModel payItNow:m.orderId] next:^(id next) {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
                            
                            return ;
                        }
                        
                        YCFixOrderVM *vm =
                        [[YCFixOrderVM alloc]initWithParameters:@{
                                                                  @"groupBuyId":self.viewModel.groupBuyId,
                                                                  @"userAddressId":m.shopUserAddress.userAddressId,
                                                                  @"qty":@(self.viewModel.count),
                                                                  @"specId":self.viewModel.specId,
                                                                  kToken:[YCUserDefault currentToken],
                                                                  }];
                        
                        vm.orderType = YCOrderTypeGroup;
                        vm.Id = self.viewModel.groupBuyId;
                        [self pushTo:[YCFixOrderVC class] viewModel:vm];
                    }
                }];
                
            }];
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                YCPayGroupPurchaseM  *m = [self.viewModel modelForItemAtIndexPath:indexPath];
               
                YCShopGroupBuySubM *subM =m.shopGroupBuySubs[indexPath.row];
                YCLoginUserM *userM =subM.appUser;
                
                [cc onUpdataUserImg:userM.imagePath userName:userM.nickName price:[subM.price floatValue] spe:m.shopSpec.specName count:[subM.qty intValue] groupPayState:subM.groupPayState];
                
            }];
            
        }];
        return;
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
