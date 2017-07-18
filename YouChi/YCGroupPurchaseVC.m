//
//  YCGroupVC.m
//  YouChi
//
//  Created by 李李善 on 16/5/24.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCGroupPurchaseVC.h"
#import "YCWebVC.h"
#import "YCDistributionAreaVC.h"
#import "YCContainerControl.h"
#import "YCGroupPlayView.h"
#import "YCGoodsCommentVC.h"

@interface YCBaseGroupPurchaseVC ()
PROPERTY_STRONG_VM(YCGroupPurchaseVM);

@end

@implementation YCBaseGroupPurchaseVC
SYNTHESIZE_VM;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    WSELF;
    
    float left =YCItemDetailEdge;
#pragma mark - 自动播放 - cell0
    if (reuseIdentifier == cell0) {
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            YCImagePlayerView *ipv = [YCImagePlayerView newInSuperView:view];
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                ipv.frame = frame;
            }];
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCItemDetailM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                if (![cell checkIsHasSetData:m]) {
                    ipv.dataSource = m.shopProductCoverImages;
                    ipv.autoScroll = ipv.shouldAutoScrollWhenScroll = NO;
                    [ipv reloadImageData];
                }
                
            }];
            
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [ipv yc_initView];
            }];
        }];
    }
    
    
#pragma mark - 详细描述 - cell3
    if (reuseIdentifier == cell3) {
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            YYLabel  *l = [YYLabel newInSuperView:view];
            l.numberOfLines = 0;
            l.displaysAsynchronously = YES;
            l.backgroundColor = [UIColor whiteColor];
            
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).offset(0);
                make.left.bottom.right.equalTo(view);
            }];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YYTextLayout *layout = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:layout]) {
                    return ;
                }
                l.textLayout = layout;
            }];
            
        }];
        
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



@interface YCGroupPurchaseVC ()

@end

@implementation YCGroupPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    [super onConfigureCell:cell reuseIdentifier:reuseIdentifier];
    
    float edge              = YCItemDetailInnerEdge;
    
    WSELF;
#pragma mark - 认证 - KGroupC8
    if (reuseIdentifier == KGroupC8) {
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YCContainerControl *cc  = [[[YCContainerControl alloc]initWithElementCount:3 block:^UIView *(NSInteger idx) {
                UIButton *b = [[UIButton buttonWithType:UIButtonTypeCustom]addInSuperView:view];
                
                [b setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                b.titleLabel.font       = [UIFont systemFontOfSize:20];
                [b setTitleColor:UIColorHex(#333333) forState:UIControlStateNormal];
                
                return b;
            }]addInSuperView:view];
            
            
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                NSArray *m              = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                [cc.elements enumerateObjectsUsingBlock:^(UIButton  *_Nonnull b, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx<m.count) {
                        YCShopVerifyM *spm      = m[idx];
                        [b setImageWithURL:IMAGE_HOST_SHOP(spm.imagePath) forState:UIControlStateNormal placeholder:AVATAR options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
                        b.hidden = NO;
                    } else {
                        b.hidden = YES;
                    }
                }];
            }];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                cc.enabled =YES;
                [cc mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
            }];
        }];
        
        return;
    }
    
    
#pragma mark - 发货信息 - KGroupC12
    if (reuseIdentifier == KGroupC12) {
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            UILabel *l1             = [UILabel newInSuperView:view];
            
            
            UILabel *l2= [UILabel newInSuperView:view];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                l2.font                 = l1.font;
                l2.textColor            = UIColorHex(#d09356);
                l2.textAlignment        = NSTextAlignmentRight;
                l2.text                 = @"支持货到付款";
                l1.text                 = @"48小时内发货";
                l1.font                 = KFont(12);
                l1.textColor            = UIColorHex(#333333);
                [@[l1,l2] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view);
                }];
                [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).offset(edge);
                }];
                [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view).offset(-edge);
                }];
            }];
        }];
        return;
    }
    
#pragma mark - 商品评价，配送地址 - KGroupC13
    if (reuseIdentifier == KGroupC13) {
        UILabel *l1             = [UILabel new];
        l1.font                 = KFont(12);
        l1.textColor            = UIColorHex(#333333);
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle     = UITableViewCellSelectionStyleDefault;
        cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            [l1 addInSuperView:view];
            UIImageView *l2= [UIImageView newInSuperView:view];
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                NSString *title         = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:title]) {
                    return ;
                }
                l1.text = title;
                
            }];
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [@[l1,l2] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view);
                }];
                [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).offset(edge);
                }];
                [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view).offset(-edge);
                }];
                
            }];
            
            
            [cell setSelectBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                NSString *title         = [self.viewModel modelForItemAtIndexPath:indexPath];
                UIViewController *vc;
                YCPageViewModel *vm;
                
                if (indexPath.row==0) {
                    
                    CHECK(!self.viewModel.model.commentCount.intValue, @"暂时还没有评论...");
                    vm = [[YCGoodsCommentVM alloc]initWithId:self.viewModel.Id];
                    vc  = [YCGoodsCommentVC vcClass];
                    vm.model = self.viewModel.model;
                    vm.viewModel= self.viewModel;
                    vc.viewModel  = vm;
                    [self pushToVC:vc];
                    
                    return ;
                }
                
                if (indexPath.row == 1) {
                    
                    YCItemDetailM *m        = self.viewModel.model;
                    YCAutoPageViewModel *vm = [YCAutoPageViewModel new];
                    [vm addModelsAtBack:m.shopShipping.shopShippingAreas];
                    [vm.cellInfos setArray:@[[YCCellInfo cellInfoWithId:cell0 height:^CGFloat(NSIndexPath *indexPath) {
                        return 44;
                    } number:^NSInteger(NSInteger section) {
                        return m.shopShipping.shopShippingAreas.count;
                    } model:^id(NSIndexPath *indexPath) {
                        return m.shopShipping.shopShippingAreas[indexPath.row];
                    }]]];
                    vc                      = [YCDistributionAreaVC new];
                    vc.viewModel            = vm;
                    vc.title                = title;
                    [self pushToVC:vc];
                    
                }
                
                
            }];
            
            
        }];
        return;
        
    }
#pragma mark - 往上拉动 - KGroupC14
    if (reuseIdentifier == KGroupC14) {
        cell.selectionStyle     = UITableViewCellSelectionStyleNone;
        cell.backgroundColor    = [UIColor redColor];
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIButton *b = [[UIButton buttonWithType:UIButtonTypeCustom]addInSuperView:view];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                [b setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                [b setImage:IMAGE(@"形状-1") forState:UIControlStateNormal];
                [b setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                b.titleLabel.font       = [UIFont systemFontOfSize:15];
                [b setTitle:@"往上拉动，查看图文详情" forState:UIControlStateNormal];
                [b setTitleColor:[UIColor colorWithHex:0x363636 andAlpha:0.3] forState:UIControlStateNormal];
                
                [b mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
            }];
        }];
        return;
    }
#pragma mark - 图文详情 - KGroupC15
    if (reuseIdentifier == KGroupC15) {
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            UILabel *lb             = [UILabel newInSuperView:view];
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *cell, UIView *view, CGRect frame) {
                cell.separatorInset     = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
                lb.textAlignment        = NSTextAlignmentCenter;
                lb.text                 = @"图文详情";
                lb.backgroundColor      = [UIColor whiteColor];
                lb.textColor            = [UIColor blackColor];
            }];
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                lb.frame                = frame;
            }];
        }];
        
        return;
    }
#pragma mark - 图片 - KGroupC16
    if (reuseIdentifier == KGroupC16) {
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            view.contentMode        = UIViewContentModeScaleAspectFill;
            view.masksToBounds = YES;
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCBaseImageModel *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                [view ycShop_setImageWithURL:m.imagePath placeholder:PLACE_HOLDER];
            }];
            
            
        }];
        return;
    }
#pragma mark - 保障 - KGroupC17
    if (reuseIdentifier == KGroupC17) {
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
            [view backColor:[UIColor redColor]];
            
            
            UIButton *b             = [[UIButton buttonWithType:UIButtonTypeCustom]addInSuperView:view];
            [b setBackgroundImage:[UIImage imageWithColor:self.tableView.backgroundColor] forState:UIControlStateNormal];
            [b setImage:IMAGE(@"保障") forState:UIControlStateNormal];
            [b setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            
            b.titleLabel.font = [UIFont systemFontOfSize:12];
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [b setTitle:@"购买友吃商品有什么保障呢？" forState:UIControlStateNormal];
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                b.frame  = frame;
            }];
            [[b rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                SSELF;
                YCWebVC *web = [[YCWebVC alloc]initWithUrlString:url_buy_baozhang];
                [self pushToVC:web];
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


@interface YCStrategyGroupPurchaseVC ()

@end
@implementation YCStrategyGroupPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)onConfigureCell:(YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    
    
    [super onConfigureCell:cell reuseIdentifier:reuseIdentifier];
    
    float left      = YCItemDetailInnerEdge;
    float groupEdge = YCCreateGroupPurchaseTop;
    
    WSELF;
#pragma mark - 攻略 OK - KGroupC6
    if (reuseIdentifier == KGroupC6){
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
    if (reuseIdentifier == KGroupC7){
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
                    make.right.equalTo(zhe.mas_left).offset(-groupEdge);
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
                //[zhe backColor:m.BGColor];
                l.text = [NSString stringWithFormat:@"%@:%@",m.strategyName,m.details];
            }];
            
            
            
            
        }];
        return;
        
    }
#pragma mark - 团拼玩法标题 - KGroupC9
    if (reuseIdentifier == KGroupC9){
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
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
                    make.right.equalTo(view).offset(-23);
                }];
                
            }];
            [cell setSelectBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                //TODO:点击事件－－－团拼玩法
                NSLog(@"--->>%@",@"团拼玩法");
                YCWebVC *web = [[YCWebVC alloc]initWithUrlString:url_tuanpin];
                [self pushToVC:web];
            }];
            
        }];
    }
    
#pragma mark - 团拼玩法 - KGroupC10
    if (reuseIdentifier == KGroupC10){
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


