//
//  YCYCCreateGroupPurchaseVC.m
//  YouChi
//
//  Created by 李李善 on 16/5/13.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCCreateGroupPurchaseVC.h"

#import "YCRecipientAddressVC.h"
#import "YCGroupPurchaseMainVC.h"
#import "YCSupportGroupPurchaseVC.h"
#import "YCPayGroupPurchaseVC.h"
@interface YCCreateGroupPurchaseVCP ()
PROPERTY_STRONG_VM(YCCreateGroupPurchaseVM);

@end

@implementation YCCreateGroupPurchaseVCP
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
    RAC(self,title,@"正在加载中") = RACObserve(self.viewModel, title).deliverOnMainThread;
}

- (id)onCreateViewModel
{
    return [YCCreateGroupPurchaseVM new];
}


#pragma mark-------确认统一发货地址并开团按钮
- (IBAction)onYCYCCreateGroupPurchaseV:(id)sender {
    
    CHECK(!self.viewModel.AddressM.userAddressId, @"请选择你要配送的地址");
    CHECK(self.viewModel.count<=0, @"请选择购买数量");
    CHECK(!self.viewModel.Id || !self.viewModel.specId, @"参数出错");
    NSDictionary *dic = @{
                          @"productId":self.viewModel.Id,
                          @"productSpecId":self.viewModel.specId,
                          
                          @"qty":@(self.viewModel.count),
                          @"userAddressId":self.viewModel.AddressM.userAddressId,
                          
                          };
    
    YCPayGroupPurchaseVM *vm = [[YCPayGroupPurchaseVM alloc]initWithParameters:dic];
    vm.isSponsor = YES;
    vm.title = self.viewModel.title;
    YCPayGroupPurchaseVC *vc = [YCPayGroupPurchaseVC vcClass];
    
    vc.viewModel = vm;
    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
    [vcs removeLastObject];
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setViewModel:self.viewModel];
}

@end




@interface YCCreateGroupPurchaseVC ()
PROPERTY_STRONG_VM(YCCreateGroupPurchaseVM);
@end

@implementation YCCreateGroupPurchaseVC
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KBGCColor(@"efeff4");
    
    // Do any additional setup after loading the view.
}
-(void)onSetupCell
{
    [super onSetupCell];
}

- (void)onSetupFooter
{
    
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    return[self executeSignal:[self.viewModel mainSignal] next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    
    [super onConfigureCell:cell reuseIdentifier:reuseIdentifier];
    
    WSELF;
    
    float left =YCItemDetailEdge;
    float top  =YCItemDetailEdge;
    float width  =YCItemDetailEdge;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, top, 0, top);
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
#pragma mark - 线条-
    NSArray *reuseIdentifiers = @[cell1,cell2,cell3,cell4,cell5,cell6];
    if ([reuseIdentifiers indexOfObject:reuseIdentifier] != NSNotFound) {
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIEdgeInsets insets = UIEdgeInsetsMake(0, YCItemDetailEdge, 0, YCItemDetailEdge);
            
            cell.backgroundColor = [UIColor clearColor];
            view.backgroundColor = [UIColor whiteColor];
            
            cell.selectedBackgroundView.clipsToBounds = YES;
            CGFloat height = 1/[UIScreen mainScreen].scale;
            
            CAShapeLayer *line = [CAShapeLayer layer];
            
            if (reuseIdentifier == cell3 ||reuseIdentifier == cell2 ) {
                
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
    
#pragma mark-------参团人
    if (reuseIdentifier==cell1){
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            [cell setContentViewClearColor];
            //开团人
            UILabel *lK = [UILabel newInSuperView:view];
            //参团人
            UILabel *lC = [UILabel newInSuperView:view];
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                
                YCCreateGroupPurchaseM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                lK.attributedText = m.openGroupMan;
                
                lC.attributedText = m.joinInGroupMan;
                
                
            }];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                lK.numberOfLines = lC.numberOfLines = 2;
                lK.textAlignment = NSTextAlignmentLeft;
                lC.textAlignment = NSTextAlignmentRight;
                lK.font = lC.font = KFont(12);
                
                
                [lK mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(view);
                    make.left.equalTo(view).offset(left);
                    make.right.equalTo(lC.mas_left);
                }];
                [lC mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(view);
                    make.width.equalTo(lK);
                    make.right.equalTo(view).offset(-left);
                }];
            }];
        }];
        return;
        
    }
#pragma mark-------统一收货地址
    if (reuseIdentifier==cell2){
        
        
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIImageView *imageV = [UIImageView newInSuperView:view];
            UILabel *adderss = [UILabel newInSuperView:view];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                imageV.contentMode = UIViewContentModeScaleAspectFill;
                
                imageV.image = IMAGE(@"定位");
                adderss.text = @"填写统一收货地址";
                adderss.font = KFontBold(15);
                adderss.textColor = KBGCColor(@"333333");
                
                [@[imageV,adderss] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view.mas_centerY);
                }];
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(15);
                    make.width.mas_equalTo(13);
                    make.left.equalTo(view.mas_left).offset(left);
                    make.right.equalTo(adderss.mas_left).offset(-left*2);
                }];
                [adderss mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view);
                }];
                
            }];
        }];
        return;
    }
    
    #pragma mark-------添加地址
    if (reuseIdentifier==cell4){
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            //状态1
            UIImageView *imageV = [UIImageView newInSuperView:view];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            UILabel *addDiZ = [UILabel newInSuperView:view];
            
            
            //状态2
            UIImageView *jian = [UIImageView newInSuperView:view];
            //收件人
            UILabel *l1 = [UILabel newInSuperView:view];
            //收货地址
            UILabel *l2 = [UILabel newInSuperView:view];
            //电话
            UILabel *phone = [UILabel newInSuperView:view];
            
            UIView *line = [UIView newInSuperView:view];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                //状态1
                imageV.image = IMAGE(@"添加");
                addDiZ.text = @"添加地址";
                addDiZ.font = KFont(15);
                addDiZ.textColor = KBGCColor(@"333333");
                addDiZ.textAlignment = NSTextAlignmentCenter;
                line.backgroundColor = KBGCColor(@"b6b6b6");
                
                [@[imageV,addDiZ] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view.mas_centerX);
                }];
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.mas_equalTo(13);
                    make.centerY.equalTo(view.mas_centerY).offset(-5);
                }];
                [addDiZ mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.equalTo(imageV.mas_bottom).offset(top-5);
                }];
                
                
                //状态2
                jian.image = IMAGE(@"箭头");
                phone.font=l1.font = KFont(15);
                l2.font = KFont(12);
                l2.numberOfLines = 0.f;
                
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view).offset(-10);
                    make.left.equalTo(view).offset(10);
                    make.top.equalTo(view);
                    make.height.equalTo(@(1/[UIScreen mainScreen].scale));
                }];
                
                [jian mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(15);
                    make.width.mas_equalTo(10);
                    make.centerY.equalTo(view);
                    make.right.equalTo(view).offset(-left);
                }];
                //left
                [@[l1,l2] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).offset(left);
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
                    make.right.equalTo(jian.mas_left).offset(-5);
                }];
            }];
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                
                YCRecipientAddressM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                BOOL hasAdress = (m != nil);
                jian.hidden = l1.hidden = l2.hidden =  phone.hidden = !hasAdress;
                imageV.hidden =addDiZ.hidden = hasAdress;
            
                l2.text =m.completeAddress;
                l1.text = m.completeName;
                phone.text= m.receiverPhone;
                
            }];
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                view.frame= UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, 5, 10, 5));
            }];
            
            [cell setSelectBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                
                YCRecipientAddressVM *vm = [YCRecipientAddressVM new];
                YCRecipientAddressVC *vc =[YCRecipientAddressVC vcClass];
                vc.viewModel = vm;
                
                [vm.addressChangedSignal.deliverOnMainThread subscribeNext:^(id x) {
                    SSELF;
                    self.viewModel.AddressM = x;
                    NSIndexSet *indexSet =[NSIndexSet indexSetWithIndex:indexPath.section];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                }];
                [self pushToVC:vc];
            }];
        }];
        return;
    }
#pragma mark-------价钱和选择数量
    if (reuseIdentifier == cell5){
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UILabel *l1 = [UILabel newInSuperView:view];
            UILabel *l2 = [UILabel newInSuperView:view];
            UILabel *l3 = [UILabel newInSuperView:view];
            UIButton *minus = [UIButton newInSuperView:view];
            UILabel *count = [UILabel newInSuperView:view];
            UIButton *plus = [UIButton newInSuperView:view];
            UIView *line = [UIView newInSuperView:view];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                
                SSELF;
                if (indexPath.row == 0) {
                    l1.hidden  = NO;
                    minus.hidden =plus.hidden = count.hidden = YES;
                }else{
                    l1.hidden =minus.hidden =count.hidden =plus.hidden = YES;
                }
                
                YCShopProductStrategyModel *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                l2.text = [NSString stringWithFormat:@"%.1f元",m.disPrice.floatValue];
                l3.text = m.detailInfo;
                count.text = @(self.viewModel.count).stringValue;
                
            }];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                line.backgroundColor = KBGCColor(@"b6b6b6");
                count.textAlignment=l1.textAlignment = NSTextAlignmentCenter;
                count.hidden = YES;
                l1.text = @"团拼价";
                l1.font = KFont(12);
                l1.backgroundColor =  UIColorHex(333333);
                l1.clipsToBounds = YES;
                l1.cornerRadius = 3;
                l1.textColor = [UIColor whiteColor];
                [l1 sizeToFit];
                
                
                l2.font = KFont(20);
                l2.textColor = [UIColor blackColor];
                
                l3.font = KFont(13);
                l3.textColor = UIColorHex(0x333333);
                
                count.text = @(1).stringValue;
                [minus setImage:IMAGE(@"减") forState:UIControlStateNormal];
                [plus setImage:IMAGE(@"加") forState:UIControlStateNormal];
                minus.contentMode = UIViewContentModeScaleAspectFill;
                plus.contentMode = UIViewContentModeScaleAspectFill;
                
                //centerY
                [@[l1,l2,minus,count,plus] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view);
                }];
                //height。width
                [@[minus,plus] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(view).offset(-width+5);
                    make.width.equalTo(view.mas_height).offset(-width+5);
                }];
                
                [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).offset(left);
                    make.height.mas_equalTo(@20);
                    make.width.mas_equalTo(@50);
                }];
                [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(l1.mas_right).offset(left);
                }];
                [l3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(l2.mas_right).offset(5);
                    make.bottom.equalTo(l2.mas_bottom).offset(-3);
                }];
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
            
            
            //MARK:按钮点击方法
            [minus addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
                SSELF;
                if (self.viewModel.sum == 0 || self.viewModel.count == 1) {
                    return ;
                }
                
                if ( self.viewModel.count == 1) {
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
            
            
        }];
        return;
    }
    
#pragma mark-------规格
    if (reuseIdentifier == cell6){
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIView *line = [UIView newInSuperView:view];
            UILabel *label = cell.textLabel;
            UIImageView *tick = [[UIImageView alloc]initWithImage:IMAGE(@"钩2")];
            cell.accessoryView = tick;
            label.font = KFont(12);
            label.textColor = color_light_text;
            label.numberOfLines = 0;
            tick.hidden = YES;
            line.backgroundColor = KBGCColor(@"b6b6b6");
            [cell setSelectBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                
                NSInteger row = indexPath.row;
                
                if (self.viewModel.selectedshopSpecIndex != row) {
                    self.viewModel.selectedshopSpecIndex = row;
                    [self executeSignal:self.viewModel.onSelectSpecChangePrice next:^(id next) {
                        
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
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCShopSpecs *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                NSInteger row = indexPath.row;
                label.text = [NSString stringWithFormat:@"%@ ",m.specName];
                BOOL b = (self.viewModel.selectedshopSpecIndex == row);
                tick.hidden = !b;
                
            }];
            
        }];
        
        return;
    }
    /*
     #pragma mark - 线条
     if (reuseIdentifier != KGroupC0) {
     [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
     
     UIEdgeInsets insets = UIEdgeInsetsMake(0, YCItemDetailEdge, 0, YCItemDetailEdge);
     
     cell.backgroundColor = [UIColor clearColor];
     view.backgroundColor = [UIColor whiteColor];
     
     cell.selectedBackgroundView.clipsToBounds = YES;
     CGFloat height = 1/[UIScreen mainScreen].scale;
     
     //            CAShapeLayer *line = reuseIdentifier == cell2?nil:[CAShapeLayer layer];
     
     //            line.backgroundColor = [UIColor colorWithHexString:@"#c8c7cc"].CGColor;
     //            [view.layer addSublayer:line];
     
     [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
     CGRect rect = UIEdgeInsetsInsetRect(frame, insets);
     view.frame = rect;
     
     rect.origin.x = 0;
     rect.size.height = height;
     //                line.frame = UIEdgeInsetsInsetRect(rect, insets);
     
     cell.selectedBackgroundView.frame = rect;
     }];
     
     }];
     }
     */
}


#pragma mark-------下拉刷新
- (void)onSetupRefreshControl
{
    //    [super onSetupRefreshControl];
}

- (void)onSetupEmptyView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    [self onScrollToBottom:scrollView];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
