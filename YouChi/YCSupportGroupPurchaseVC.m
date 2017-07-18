//
//  YCSupportGroupPurchaseVC.m
//  YouChi
//
//  Created by 李李善 on 16/5/17.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCSupportGroupPurchaseVC.h"

#import "YCContainerControl.h"
#import "YCGroupPlayView.h"
#import "YCWebVC.h"
#import "YCCreateGroupPurchaseVC.h"
#import "YCGoodsCommentVC.h"
#import "YCDistributionAreaVC.h"


@interface YCSupportGroupPurchaseVCP ()
PROPERTY_STRONG_VM(YCSupportGroupPurchaseVM);
///开团按钮
@property (weak, nonatomic) IBOutlet UIButton *openGroup;
@end

@implementation YCSupportGroupPurchaseVCP
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
    RAC(self,title,@"正在加载中") = RACObserve(self.viewModel,title).deliverOnMainThread;
 
    [self.openGroup setTitle:@"马上开团" forState:UIControlStateNormal];

}

-(id)onCreateViewModel{
    return [YCSupportGroupPurchaseVM new];
}


#pragma mark-------马上开团
- (IBAction)onOpenGroup:(UIButton *)sender {
    
    CHECK(!self.viewModel.productId && !self.viewModel.specId, @"参数出错");
    [sender executeActivitySignal:self.viewModel.sponsorGroupBuy next:^(NSArray *next) {
        YCCreateGroupPurchaseVM *vm =
        [[YCCreateGroupPurchaseVM alloc] initWithParameters:@{
                                                        @"productId":self.viewModel.productId,
                                                        @"productSpecId":viewModel.specId,
                                                        @"qty":@(self.viewModel.count),
                                                        }];
        vm.shopProductStrategys = next;
        YCCreateGroupPurchaseVC *vc = [YCCreateGroupPurchaseVC vcClass];
        vc.viewModel = vm;
        
        NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
        [vcs removeLastObject];
        [vcs addObject:vc];
        [self.navigationController setViewControllers:vcs animated:YES];
    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
    
    
    
}

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

@interface YCSupportGroupPurchaseVC ()
PROPERTY_STRONG_VM(YCSupportGroupPurchaseVM);

@end

@implementation YCSupportGroupPurchaseVC
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGCColor(@"efeff4");
    
}
-(void)onMainSignalExecute:(UIRefreshControl *)sender{
    [self executeSignal:[self.viewModel mainSignal] next:self.nextBlock error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

- (void)onSetupRefreshControl
{
    
}

- (void)onSetupFooter
{
    
}

static NSString *titlekey = @"title";
static NSString *infokey = @"info";

-(void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    [super onConfigureCell:cell reuseIdentifier:reuseIdentifier];
    
    WSELF;
    float left                 = YCItemDetailInnerEdge;
    float top                  = YCItemDetailInnerEdge;
    float width                = YCItemDetailInnerGroupEdge;
    float edge                 = YCItemDetailInnerEdge-5;
    float groupEdge            = YCItemDetailInnerEdge;
    UIEdgeInsets edgeInsets    = UIEdgeInsetsMake(0, top, 0, top);
    //上左右间隔
    UIEdgeInsets TLREdgeInsets = UIEdgeInsetsMake(groupEdge, left, 0, left);
   
    
    [cell setBackgroundColor:self.tableView.backgroundColor];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
#pragma mark - 线条-
    NSArray *reuseIdentifiers = @[cell3,cell4,cell5,cell7,cell8,cell9,cell10,cell12,cell13];
    if ([reuseIdentifiers indexOfObject:reuseIdentifier] != NSNotFound) {
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIEdgeInsets insets = UIEdgeInsetsMake(0, YCItemDetailEdge, 0, YCItemDetailEdge);
            
            cell.backgroundColor = [UIColor clearColor];
            view.backgroundColor = [UIColor whiteColor];
            
            cell.selectedBackgroundView.clipsToBounds = YES;
            CGFloat height = 1/[UIScreen mainScreen].scale;
            
            CAShapeLayer *line = [CAShapeLayer layer];
            
            if (reuseIdentifier == cell3 ) {
                
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
    
#pragma mark-------参团人 OK
    if (reuseIdentifier == cell1){
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            //开团人
            UILabel *lK = [UILabel newInSuperView:view];
            //参团人
            UILabel *lC = [UILabel newInSuperView:view];
            
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
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                
                YCCreateGroupPurchaseM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if (![cell checkIsHasSetData:m]) {
                    lK.attributedText = m.openGroupMan;
                    lC.attributedText = m.joinInGroupMan;
                }
            }];
        }];
        return;
        
    }
    
#pragma mark-------选择数量 OK
    if (reuseIdentifier == cell4){
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UILabel *l1 = [UILabel newInSuperView:view];
            UILabel *l2 = [UILabel newInSuperView:view];
            UILabel *l3 = [UILabel newInSuperView:view];
            UIButton *minus = [UIButton newInSuperView:view];
            UILabel *count = [UILabel newInSuperView:view];
            UIButton *plus = [UIButton newInSuperView:view];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                
                SSELF;
                YCSupportGroupPurchaseM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                if (m.shopSpecs.count==0) {
                    return ;
                }
                YCShopSpecM *specsM   = m.shopSpecs[self.viewModel.selectedshopSpecIndex];
                
                count.text= @(self.viewModel.count).stringValue;
                l2.text   = [NSString stringWithFormat:@"¥%.2f/份",specsM.specMoneyPrice.floatValue];
                
            }];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                count.textAlignment=l1.textAlignment = NSTextAlignmentCenter;
                l1.text = @"单独购买";
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
                    [self.viewModel updatePrice:self.viewModel.count];
                }];
                [plus addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
                    SSELF
                    if (self.viewModel.sum ==0) {
                        return ;
                        
                    }
                    self.viewModel.count = MIN(++self.viewModel.count,self.viewModel.sum);
                    count.text = @(self.viewModel.count).stringValue;
                    [self.viewModel updatePrice:self.viewModel.count];
                }];
                
                //
                [@[l1,l2,minus,count,plus] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view);
                }];
                //
                [@[minus,plus] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(view).offset(-width+5);
                    make.width.equalTo(view.mas_height).offset(-width+5);
                }];
                
                [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).offset(left-5);
                    make.height.mas_equalTo(@20);
                    make.width.mas_equalTo(@60);
                }];
                [l2 mas_makeConstraints:^(MASConstraintMaker *make) {                    make.left.equalTo(l1.mas_right).offset(left);
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
            
            
        }];
        return;
    }
    
#pragma mark-------规格 OK
    if (reuseIdentifier == cell5){
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            UILabel *label = cell.textLabel;
            UIImageView *tick = [[UIImageView alloc]initWithImage:IMAGE(@"钩2")];
            cell.accessoryView = tick;
            label.font = KFont(12);
            label.textColor = color_light_text;
            label.numberOfLines = 0;
            tick.hidden = YES;
            [cell setSelectBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                
                NSInteger row = indexPath.row;
                
                if (self.viewModel.selectedshopSpecIndex != row) {
                    self.viewModel.selectedshopSpecIndex = row;
                    
                    [self.viewModel updateSelectCount];
                    
                    [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                } else {
                    if (cell.isSelected) {
                        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                    
                }
                
                
                
            }];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCShopSpecs *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                NSInteger row = indexPath.row;
                label.text = m.specName;
                BOOL b = (self.viewModel.selectedshopSpecIndex == row);
                tick.hidden = !b;
                
            }];
        }];
        
        return;
    }
    
    

}

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
