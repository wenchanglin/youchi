//
//  YCPayGroupPurchaseVC.m
//  YouChi
//
//  Created by 李李善 on 16/5/20.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
#import "YCOrderDetailedVC.h"
#import "YCOthersInfoVC.h"
#import "YCPayGroupPurchaseVC.h"
#import "YCPayGroupPurchaseVM.h"
#import "YCPurchaseInfoView.h"
#import "YCGroupSettlementView.h"
#import "YCFixOrderVC.h"
#import "YCGroupBottomActionBar.h"
#import "YCOrderDetailedVC.h"
#import "YCWebVC.h"
@interface YCPayGroupPurchaseVCP ()
PROPERTY_STRONG_VM(YCPayGroupPurchaseVM);
@property (strong, nonatomic) IBOutlet YCGroupBottomActionBar *bottomBar;

///右按钮
@property (weak, nonatomic)  UIButton *btnSponsorPay;
///左按钮
@property (weak, nonatomic)  UIButton *btnPayPeople;

@end

@implementation YCPayGroupPurchaseVCP
SYNTHESIZE_VM;

- (void)viewDidLoad {
    WSELF;
    [super viewDidLoad];
    
    ///凡是我发起的团拼
    [RACObserve(self.viewModel,model).deliverOnMainThread subscribeNext:^(YCPayGroupPurchaseM *m) {
        SSELF;
        if (m) {
            self.title = self.viewModel.title;
            ///是否可以发起支付
            
            
            [self.bottomBar updateColors];
            self.btnPayPeople = self.bottomBar.btnLeft;
            self.btnSponsorPay = self.bottomBar.btnRight;
            
            
            [self.btnPayPeople setNormalTitle:@"邀请小伙伴"];
            [self.btnSponsorPay setNormalTitle:@"发起结算"];
            
            YCGroupTag tag = m.tag.intValue;
            
            if (tag == YCGroupTagStatusSubmittedOrderDidPay) {
                [self.btnSponsorPay setNormalTitle:@"订单详情"];
            }
            
            if (tag == YCGroupTagStatusSubmittedOrderDidNotPay) {
                [self.btnSponsorPay setNormalTitle:@"直接支付"];
            }
            
            if (tag == YCGroupTagStatusSubmittedOrderDidPay) {
                
                if (m.noPayCount.intValue == 0) {
                    [self.btnPayPeople setNormalTitle:@"所有人已结算"];
                } else {
                    [self.btnPayPeople setNormalTitle:[NSString stringWithFormat:@"还有 %d 人未付款",m.noPayCount.intValue]];
                }
                
                [self.btnPayPeople  setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
                self.btnPayPeople.enabled = NO;
            }
            
            if (tag == YCGroupTagStatusComplete) {
                self.btnPayPeople.hidden = YES;
            }
            
            if (tag == YCGroupTagStatusSponsorDidNotOrder) {
                UIButton *groupAction = [UIButton new];
                groupAction.size = CGSizeMake(80, 30);
                [groupAction setNormalTitle:m.isSponsor.boolValue?@"解散团拼":@"退出团拼"];
                [groupAction sizeToFit];
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
            
            
#pragma mark - 邀请
            [self.btnPayPeople setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                SSELF;
                ///1，3
                
                if (tag == YCGroupTagStatusSubmittedOrderDidNotPay) {
                    
                    [self showmMidMessage:@"你已经提交过订单，不能邀请小伙伴了"];
                }
                
                if (tag == YCGroupTagStatusSponsorDidNotOrder || tag == YCGroupTagStatusDidNotSubmittedOrder) {
                    [self pushTo:[YCPurchaseQrCodeVC class] viewModel:[[YCPurchaseQrCodeVM alloc]initWithId:m.groupBuyId]];
                }else {
                    [self showmMidMessage:@"已结算，请等待发起人确认订单"];
                }
            }];
            
            
            
#pragma mark - 结算
            [self.btnSponsorPay setBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton * _Nonnull sender) {
                SSELF;
                ///1
                if (tag == YCGroupTagStatusSponsorDidNotOrder) {
                    ///是否发起人
                    if (m.isSponsor.boolValue) {
                        
                        if (m.isEnough.boolValue) {
                            
                            YCFixOrderVM *vm = [[YCFixOrderVM alloc] initWithParameters:@{
                                                                                          @"groupBuyId":self.viewModel.groupBuyId,
                                                                                          @"userAddressId":m.shopUserAddress.userAddressId,
                                                                                          @"qty":@(self.viewModel.count),
                                                                                          @"specId":self.viewModel.specId,
                                                                                          kToken:[YCUserDefault currentToken],}];
                            vm.Id = m.groupBuyId;
                            vm.orderType = YCOrderTypeGroup;
                            [self pushTo:[YCFixOrderVC class] viewModel:vm];
                        } else {
                            [self showmMidMessage:@"该团拼未达到最低团拼人数"];
                        }
                        
                    } else {
                        [self showmMidMessage:@"你不是发起人，不能结算"];
                    }
                    
                }
                
                ///3
                else if (tag == YCGroupTagStatusDidNotSubmittedOrder) {
                    
                    YCFixOrderVM *vm = [[YCFixOrderVM alloc]initWithParameters:@{
                                                                                 @"groupBuyId":self.viewModel.groupBuyId,
                                                                                 @"userAddressId":m.shopUserAddress.userAddressId,@"qty":@(self.viewModel.count),
                                                                                 @"specId":self.viewModel.specId,
                                                                                 kToken:[YCUserDefault currentToken],}];
                    
                    vm.orderType = YCOrderTypeGroup;
                    vm.Id = self.viewModel.groupBuyId;
                    [self pushTo:[YCFixOrderVC class] viewModel:vm];
                    
                }
                
                ///4提交过订单，未支付
                else if (tag == YCGroupTagStatusSubmittedOrderDidNotPay) {
                    
                    [sender executeActivitySignal:[self.viewModel payItNow:m.orderId] next:^(id next) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
                }
                
                ///5
                else  if (tag == YCGroupTagStatusSubmittedOrderDidPay) {
                    
                    YCOrderDetailedVC *vc = [YCOrderDetailedVC vcClass];
                    YCOrderDetailedVM *vm = [[YCOrderDetailedVM alloc]initWithId:self.viewModel.orderId];
                    vc.viewModel = vm;
                    [self pushToVC:vc];
                }
                
                
                
            }];
            
        } else {
            self.title = @"正在加载中";
        }
        
    }];
    
}


#pragma mark-------发起人解散/被邀请人退出团拼
-(void)onCancelGroup{
}

#pragma mark-------结算－跳到支付界面
- (IBAction)onPay:(id)sender {
    
    
    YCPayGroupPurchaseM *m = self.viewModel.model;
    
    NSNumber *specId = self.viewModel.specId;
    
    YCFixOrderVM *vm = [[YCFixOrderVM alloc]initWithParameters:@{
                                                                 @"groupBuyId":m.groupBuyId,@"userAddressId":m.shopUserAddress.userAddressId,
                                                                 @"qty":@(self.viewModel.count),
                                                                 @"specId":specId,
                                                                 kToken:[YCUserDefault currentToken]}];
    [self pushTo:[YCFixOrderVC class] viewModel:vm];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setViewModel:self.viewModel];
}


@end


@interface YCPayGroupPurchaseVC ()
PROPERTY_STRONG_VM(YCPayGroupPurchaseVM);

@end

@implementation YCPayGroupPurchaseVC
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGCColor(@"efeff4");
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:self.viewModel.mainSignal next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self onMainSignalExecute:nil];
}


-(void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier{
    
    [super onConfigureCell:cell reuseIdentifier:reuseIdentifier];
    float left =YCItemDetailEdge;
    float width  =YCItemDetailEdge;
    float edge = YCItemDetailInnerGroupEdge-5;
    
    cell.backgroundColor = self.tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WSELF;
    NSArray *reuseIdentifiers = @[cell2,cell3,cell4,cell5,cell6,cell3_0,cell8,cell9,cell10,cell12,cell13,@"c20",@"c21",@"c22",@"c23"];
    if ([reuseIdentifiers indexOfObject:reuseIdentifier] != NSNotFound) {
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIEdgeInsets insets = UIEdgeInsetsMake(0, YCItemDetailEdge, 0, YCItemDetailEdge);
            
            cell.backgroundColor = [UIColor clearColor];
            view.backgroundColor = [UIColor whiteColor];
            
            cell.selectedBackgroundView.clipsToBounds = YES;
            CGFloat height = 1/[UIScreen mainScreen].scale;
            
            CAShapeLayer *line = [CAShapeLayer layer];
            
            if (reuseIdentifier == cell3 || reuseIdentifier == cell2 || reuseIdentifier == cell4) {
                
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
    
#pragma mark - 图片 - KGroupC16
    if (reuseIdentifier == KGroupC16) {
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            view.contentMode        = UIViewContentModeScaleAspectFill;
            view.masksToBounds = YES;
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCBaseImageModel *m          = [self.viewModel modelForItemAtIndexPath:indexPath];
                [view ycShop_setImageWithURL:m.imagePath placeholder:PLACE_HOLDER];
            }];
            
            
        }];
        return;
    }
    
#pragma mark-------团拼发起人
    
    if (reuseIdentifier==cell1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            
            YCPurchaseInfoView *purchaseInfoView = [YCPurchaseInfoView newInSuperView:view];
            view.backgroundColor =[UIColor whiteColor];
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [purchaseInfoView yc_initView];
                
                [purchaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 14, 0, 14));
                }];
                
                purchaseInfoView.numberOfPurchaseView.photosView.selectBlock = ^(NSIndexPath *indexPath,YCshopGroupBuySubsM *model) {
                    
                    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"移出团拼",@"查看主页", nil];
                    
                    [[actionSheet.rac_buttonClickedSignal ignore:@(actionSheet.cancelButtonIndex)]subscribeNext:^(NSNumber *x) {
                        NSInteger buttonIndex = x.integerValue;
                        
                        if (buttonIndex == 0) {
                            SSELF;
                            CHECKMidMessage(self.viewModel.model.isSponsor.boolValue==NO, @"发起人才可以移除团员");
                            [self executeSignal:[self.viewModel onCancelOtherKickUserId:model.appUser.Id] next:^(id next) {
                                [self showMessage:@"已把他移除团拼"];
                            } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
                            
                        } else if (buttonIndex == 1) {
                            
                            YCOthersInfoVM *vm = [[YCOthersInfoVM alloc]initWithId:model.appUser.Id];
                            [self pushTo:[YCOthersInfoVC class] viewModel:vm];
                            
                        }
                    }];
                    
                    [actionSheet showInView:cell];
                };
                
                
                
            }];
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                view.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(8, 5, 7, 5));
            }];
            
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCItemDetailM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                [purchaseInfoView updateWithItem:m];
                
            }];
            
            
            
        }];
        return;
    }
#pragma mark-------统一收货地址
    if (reuseIdentifier==cell2){
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIImageView *imageV = [UIImageView newInSuperView:view];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            UILabel *adderss = [UILabel newInSuperView:view];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                imageV.image = IMAGE(@"定位");
                adderss.text = @"统一收货地址";
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
            
            
        }];
        return;
    }
    if (reuseIdentifier==cell4){
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UILabel *l1 = [UILabel newInSuperView:view];//收件人
            UILabel *l2 = [UILabel newInSuperView:view];//收货地址
            UILabel *phone = [UILabel newInSuperView:view];//电话
            
            UIView *line = [UIView newInSuperView:view];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                line.backgroundColor = KBGCColor(@"c8c7cc");
                phone.font=l1.font = KFont(15);
                l2.font = KFont(12);
                l2.numberOfLines = 0.f;
                
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view).offset(-10);
                    make.left.equalTo(view).offset(10);
                    make.top.equalTo(view);
                    make.height.equalTo(@(1/[UIScreen mainScreen].scale));
                }];
                //left
                [@[l1,l2] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).offset(10);
                }];
                
                //top
                [@[l1,phone] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(view).offset(2*YCCreateGroupTop).priorityHigh();
                }];
                [@[l2] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(l1.mas_bottom).offset(2*YCCreateGroupTop).priorityHigh();
                }];
                //right
                [@[phone] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view.mas_right).offset(-2*left);
                }];
                
                
            }];
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                YCRecipientAddressM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                l2.text =m.completeAddress;
                l1.text = m.completeName;
                phone.text= m.receiverPhone;
            }];
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                view.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, 5, 10, 5));
            }];
        }];
        return;
    }
#pragma mark-------选择数量
    if (reuseIdentifier==cell5){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UILabel *l1 = [UILabel newInSuperView:view];
            UILabel *l2 = [UILabel newInSuperView:view];
            UIButton *minus = [UIButton newInSuperView:view];
            UILabel *count = [UILabel newInSuperView:view];
            UIButton *plus = [UIButton newInSuperView:view];
            
            
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                
                SSELF;
                YCPayGroupPurchaseM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                l1.text = [NSString stringWithFormat:@" 团拼 %.1f折  ",[m.nowProductStrategy.discount floatValue]*10];
                
                YCShopSpecM *specsM   = m.shopProduct.shopSpecs[self.viewModel.selectedshopSpecIndex];
                
                count.text= @(self.viewModel.count).stringValue;
                l2.text   = [NSString stringWithFormat:@"¥%.2f/份",specsM.specMoneyPrice.floatValue];
            }];
            
            
            [minus addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
                SSELF;
                if (self.viewModel.sum == 0 || self.viewModel.count == 1) {
                    return ;
                }
                // 若是提交过订单，则不允许修改数量
                if ( self.viewModel.model.tag.intValue == YCGroupTagStatusSubmittedOrderDidNotPay) {
                    [self showmMidMessage:@"您已经提交过订单了，请直接支付"];
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
                // 若是提交过订单，则不允许修改数量
                if ( self.viewModel.model.tag.intValue == YCGroupTagStatusSubmittedOrderDidNotPay) {
                    [self showmMidMessage:@"您已经提交过订单了，请直接支付"];
                    return ;
                }
                self.viewModel.count = MIN(++self.viewModel.count,self.viewModel.sum);
                count.text = @(self.viewModel.count).stringValue;
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
                plus.enabled = minus.enabled = YES;
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
    if (reuseIdentifier==cell6){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            view.backgroundColor = [UIColor whiteColor];
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
                
                // 若是提交过订单，则不允许修改
                if ( self.viewModel.model.tag.intValue == YCGroupTagStatusSubmittedOrderDidNotPay) {
                    [self showmMidMessage:@"您已经提交过订单了，请直接支付"];
                    return ;
                }
                
                
                if (self.viewModel.selectedshopSpecIndex != row) {
                    self.viewModel.selectedshopSpecIndex = row;
                    
                    //                    [self updateSelectCount];
                    
                    [self.tableView reloadSection:5 withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                } else {
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
                
                
                
            }];
            
            
        }];
        
        return;
    }
#pragma mark-------结算情况
    if (reuseIdentifier==cell7){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            UILabel *lGong = [UILabel newInSuperView:view];
            
            UILabel *lbtn = [UILabel newInSuperView:view];
            [cell setSelectBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCWebVC *web = [[YCWebVC alloc]initWithUrlString:url_tuanpin];
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
                lbtn.text =@"结算与发货规则 >>";
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
    if (reuseIdentifier==cell9){
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
                        
                    }
                    
                    else if (cc.groupPayState==YCGroupPayStateSelfNotPay){
                        
                        // 若是提交过订单
                        if (self.viewModel.model.tag.intValue == YCGroupTagStatusSubmittedOrderDidNotPay) {
                            SSELF;
                            [cc.bPay executeActivitySignal:[self.viewModel payItNow:m.orderId] next:^(id next) {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
                            
                            return ;
                        }
                        
                        YCPayGroupPurchaseM *m = self.viewModel.model;
                        
                        NSNumber *specId = self.viewModel.specId;
                        
                        YCFixOrderVM *vm = [[YCFixOrderVM alloc]initWithParameters:@{
                                                                                     @"groupBuyId":m.groupBuyId,@"userAddressId":m.shopUserAddress.userAddressId,
                                                                                     @"qty":@(self.viewModel.count),
                                                                                     @"specId":specId,
                                                                                     kToken:[YCUserDefault currentToken]}];
                        
                        vm.orderType = YCOrderTypeGroup;
                        vm.Id = specId;
                        [self pushTo:[YCFixOrderVC class] viewModel:vm];
                        
                    }
                }];
                
            }];
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCPayGroupPurchaseM  *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                YCShopGroupBuySubM *subM =m.shopGroupBuySubs[indexPath.row];
                YCLoginUserM *userM =subM.appUser;
                
                [cc onUpdataUserImg:userM.imagePath userName:userM.nickName price:[subM.price floatValue] spe:m.shopSpec.specName count:[subM.qty intValue] groupPayState:subM.groupPayState];
                
            }];
            
        }];
        return;
    }
    
    
#pragma mark - 攻略 OK - KGroupC6
    if ([reuseIdentifier isEqualToString:@"c20"]){
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            view.backgroundColor = [UIColor whiteColor];
            
            UIImageView *imageV           = [UIImageView newInSuperView:view];
            
            UILabel *adderss              = [UILabel newInSuperView:view];
            
            imageV.contentMode            = UIViewContentModeScaleAspectFill;
            adderss.font                  = KFontBold(18);
            adderss.textColor     = KBGCColor(@"333333");
            
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [@[imageV,adderss] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view.mas_centerY);
                }];
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(21);
                    make.width.mas_equalTo(18);
                    make.left.equalTo(view.mas_left).offset(left);
                    make.right.equalTo(adderss.mas_left).offset(-left);
                }];
                [adderss mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view);
                }];
                
            }];
            
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                id m   = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                imageV.image                  = IMAGE(@"发起团拼_小icon");
                adderss.text                  = nil;
                adderss.text                  = m;
            }];
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                view.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(10, 5, 0, 5));
            }];
        }];
        return;
    }
#pragma mark - 攻略 OK - KGroupC7
    if ([reuseIdentifier isEqualToString:@"c21"]){
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UILabel  *l                   = [UILabel newInSuperView:view];
            UILabel *zhe                  = [UILabel newInSuperView:view];
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                l.textColor                   = UIColorHex(333333);
                l.font                        = KFont(12);
                
                zhe.font                      = KFont(12);
                zhe.textAlignment             = NSTextAlignmentCenter;
                zhe.textColor                 = UIColorHex(#FFFFFF);
                zhe.cornerRadius              = 4;
                zhe.layer.masksToBounds       = YES;
                //TODO:换颜色
                zhe.backgroundColor           = [UIColor redColor];
                [@[l,zhe] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view.mas_centerY);
                }];
                [l mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left).offset(left);
                    make.right.equalTo(zhe.mas_left).offset(-left);
                }];
                [zhe mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view).offset(-left).priorityHigh();
                    make.width.mas_equalTo(41);
                    make.height.mas_equalTo(18);
                }];
                
            }];
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                
                YCShopProductStrategyModel *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                zhe.text = [NSString stringWithFormat:@"%.1f 折",[m.discount floatValue] *10];
                [zhe backColor:m.BGColor];
                l.text                        = [NSString stringWithFormat:@"%@:%@",m.strategyName,m.details];
            }];
            
            
            
            
        }];
        return;
        
    }
#pragma mark - 团拼玩法 - KGroupC9
    if ([reuseIdentifier isEqualToString:@"c22"]){
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIImageView *imageV           = [UIImageView newInSuperView:view];
            
            
            UILabel *lGong                = [UILabel newInSuperView:view];
            
            UILabel *lbtn                 = [UILabel newInSuperView:view];
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                imageV.contentMode            = UIViewContentModeScaleAspectFill;
                cell.accessoryType            = UITableViewCellAccessoryDisclosureIndicator;
                imageV.image                  = IMAGE(@"团拼玩法");
                lGong.text                    = @"团拼玩法";
                lGong.font                    = KFontBold(18);
                lGong.textColor               = KBGCColor(@"333333");
                
                lbtn.textAlignment            = NSTextAlignmentRight;
                lbtn.text                     = @"查看团拼详情";
                lbtn.textColor                = KBGCColor(@"#848484");
                lbtn.font                     = KFont(12);
                [@[imageV,lGong,lbtn] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view.mas_centerY);
                }];
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(19);
                    make.width.mas_equalTo(18);
                    make.left.equalTo(view.mas_left).offset(left);
                    make.right.equalTo(lGong.mas_left).offset(-left);
                }];
                [lGong mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(lbtn.mas_left);
                }];
                [lbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view).offset(-25);
                }];
                
            }];
            [cell setSelectBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                //TODO:点击事件－－－团拼玩法
                SSELF;
                NSLog(@"--->>%@",@"团拼玩法");
                YCWebVC *web = [[YCWebVC alloc]initWithUrlString:url_tuanpin];
                [self pushToVC:web];
            }];
            
        }];
    }
    
#pragma mark - 团拼玩法 - KGroupC10
    if ([reuseIdentifier isEqualToString:@"c23"]){
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YCGroupPlayView *cc           = [YCGroupPlayView  newInSuperView:view];
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                view.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, 5, 0, 5));
                cc.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, 0, 0, 5));
            }];
            
        }];
        return;
    }
}

//自动播放   ---cell0)
#define KGroupC0 cell0
//详细描述---cell3)
#define KGroupC3 cell3

//认证   ---cell8)
#define KGroupC8 cell8
//发货信息---cell12)
#define KGroupC12 cell12
//商品评价，配送地址 ---cell12)
#define KGroupC13 cell13
//往上拉动---cell14)
#define KGroupC14 cell14
//图文详情---cell15)
#define KGroupC15 cell15
//图片   ---cell16)
#define KGroupC16 cell16
//保障   ---cell17)
#define KGroupC17 cell17



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

