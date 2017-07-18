//
//  YCItemDetailVC.m
//  YouChi
//
//  Created by sam on 16/1/7.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCItemDetailVC.h"



@interface YCItemDetailVCP ()<UIScrollViewDelegate>

PROPERTY_STRONG_VM(YCItemDetailVM);

@property (weak, nonatomic) IBOutlet YCView *actionsBar;
@property (weak, nonatomic) UIButton *favorite;
@property (weak, nonatomic) UIButton *cart ;
@property (weak, nonatomic) UIButton *buy ;
@property (weak, nonatomic) UIButton *addToCart ;
@property (strong, nonatomic) JSBadgeView *badge;

@property (weak,nonatomic) YCItemDetailVC *itemDetailVC;
@end

@implementation YCItemDetailVCP
SYNTHESIZE_VM;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self hideTabbar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    WSELF;
    self.title = @"正在加载中";
    UINavigationBar *nb = self.navigationController.navigationBar;
    
    nb.translucent = YES;
    [nb lt_setBackgroundColor:[UIColor clearColor]];
    [nb setShadowImage:[UIImage new]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [RACObserve(self.viewModel, model).deliverOnMainThread subscribeNext:^(YCItemDetailM *x) {
        if (x) {
            SSELF;
            self.title = x.productName;
            
            [self.actionsBar setInitBlock:^(YCView *view) {
                view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
                YCContainerControl *cc1 = [YCContainerControl newInSuperView:view];
                YCContainerControl *cc2 = [YCContainerControl newInSuperView:view];
                [view setLayoutBlock:^(YCView *view, CGRect frame) {
                    cc1.frame = cc2.frame = frame;
                    cc1.width = frame.size.width/3;
                    cc2.width = frame.size.width/3*2;
                    cc2.left = cc1.right;
                }];
                
                cc1.edge =  UIEdgeInsetsMake(0, 12, 0, 12);
                cc1.gap = 10;
                
                NSArray *attrs = @[@"心_",@"车"];
                NSArray *attrs_ = @[@"心已收藏",@"车"];
                NSArray *titles = @[@"收藏",@"购物车"];
                NSArray *titles_ = @[@"收藏",@"购物车"];
                [cc1 setElementCount:attrs.count block:^UIView *(NSInteger idx) {
                    YCCenterFitButton *btn = [YCCenterFitButton new];
                    [btn setImage:IMAGE(attrs[idx]) forState:UIControlStateNormal];
                    [btn setImage:IMAGE(attrs_[idx]) forState:UIControlStateSelected];
                    
                    [btn setTitle:titles[idx] forState:UIControlStateNormal];
                    [btn setTitle:titles_[idx] forState:UIControlStateSelected];
                    
                    [btn setTitleColor:UIColorHex(#838383) forState:UIControlStateNormal];
                    
                    btn.imageView.contentMode = UIViewContentModeCenter;
                    btn.titleLabel.font = KFont(12);
                    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    return btn;
                }];
                self.favorite = cc1.subviews.firstObject;
                self.cart = cc1.subviews.lastObject;
                
                
                
                NSArray *attrs2 = @[[UIColor orangeColor],[UIColor whiteColor]];
                NSArray *attrs2_ = @[[UIColor blackColor],[UIColor colorWithHex:0xf24941]];
                NSArray *titles2 = @[@"立即购买",@"加入购物车"];
                [cc2 setElementCount:titles2.count block:^UIView *(NSInteger idx) {
                    UIButton *btn = [UIButton new];
                    [btn setTitleColor:attrs2[idx] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageWithColor:attrs2_[idx]] forState:UIControlStateNormal];
                    [btn setTitle:titles2[idx] forState:UIControlStateNormal];
                    btn.titleLabel.font = KFont(18);
                    return btn;
                }];
                self.buy = cc2.subviews.firstObject;
                self.addToCart = cc2.subviews.lastObject;
                
                
                
                self.badge = [[JSBadgeView alloc]initWithParentView:self.cart alignment:JSBadgeViewAlignmentTopRight];
                self.badge.badgeBackgroundColor = UIColorHex(#d09356);
                self.badge.badgeTextColor = [UIColor blackColor];
                self.badge.badgePositionAdjustment = CGPointMake(-10, 10);
                
                
                
                [self.favorite addTarget:self action:@selector(onFavorite:) forControlEvents:UIControlEventTouchUpInside];
                [self.cart addTarget:self action:@selector(onGotoCart:) forControlEvents:UIControlEventTouchUpInside];
                [self.buy addTarget:self action:@selector(onBuy:) forControlEvents:UIControlEventTouchUpInside];
                [self.addToCart addTarget:self action:@selector(onAddToCart:) forControlEvents:UIControlEventTouchUpInside];
                
                self.favorite.hidden = self.cart.hidden = self.addToCart.hidden = self.viewModel.isYoumiPay;
                self.favorite.selected = x.isMyFavorite.boolValue;
                
                if (self.viewModel.isYoumiPay) {
                    [self.buy setTitle:@"立即兑换" forState:UIControlStateNormal];
                }
                
                if (x.isPresell.boolValue) {
                    [cc2 setElements:@[self.buy]];
                    [self.buy setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xc40000]] forState:UIControlStateNormal];
                    [self.buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
            }];
            
            
        }
    }];
    
    RAC(self,badge.badgeText) = self.viewModel.cartNumberSignal.deliverOnMainThread;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onMainSignalExecute:) name:YCPayOrderSucessNotification object:nil];
    
}



- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    self.actionsBar.userInteractionEnabled = NO;
    [self executeSignal:self.viewModel.mainSignal next:^(YCItemDetailM *next) {
        self.actionsBar.userInteractionEnabled = YES;
        self.favorite.selected = next.isMyFavorite.boolValue;
    } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
}

#pragma mark - 立即购买
- (void)onBuy:(UIButton *)sender{
    ///0 是友米支付  1是现金
    CHECKMidMessage(self.viewModel.sum == 0, @"库存不足，请联系客服");
    
#pragma mark - 友米兑换
    if (self.viewModel.isYoumiPay) {
        YCShopSpecM *model = self.viewModel.model.shopSpecs.firstObject;
        YCLoginM *user = [YCUserDefault currentUser];
        CHECK(user.appUser.antCoin.intValue<model.antPrice.intValue, @"友米不足,购买失败");
        [sender executeActivitySignal:[self.viewModel onPromptlyPayId:self.viewModel.Id specId:model.specId] next:^(YCAboutGoodsM * next) {
            YCYouMiExchangePayVC *vc = [YCYouMiExchangePayVC vcClass];
            YCYouMiExchangePayVM *vm = [[YCYouMiExchangePayVM alloc]initWithModel:next];
            YCShopSpecM *m = [YCShopSpecM new];
            m.productImagePath = next.productImagePath;
            m.productName = next.productName;
            vm.shopSpecsModel = m;
            vc.viewModel = vm;
            [self pushToVC:vc];
        } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
        return;
    }
    
#pragma mark - 非有米兑换商品
    
    if (self.viewModel.count==0) {
        [self showMessage:@"购买数量不能为0"];
        return;
    }
    
#pragma mark - 预售商品
    if (self.viewModel.isPresell) {
        YCFixOrderVM *vm = [[YCFixOrderVM alloc]initWithPresellProductId:self.viewModel.Id qty:@(self.viewModel.count) productSpecId:self.viewModel.specId];
        YCFixOrderVC *vc =[YCFixOrderVC vcClass];
        vc.viewModel = vm;
        [self pushToVC:vc];
        return;
    }
    
    [SVProgressHUD show];
    [sender executeActivitySignal:[self.viewModel promptlyPayId:self.viewModel.Id productSpecId:self.viewModel.specId count:@(self.viewModel.count)] next:^(YCItemDetailM * next) {
        YCFixOrderVM *vm = [[YCFixOrderVM alloc]initWithCartIdArray:@[next.content]];
        YCFixOrderVC *vc =[YCFixOrderVC vcClass];
        vc.viewModel = vm;
        [self pushToVC:vc];
        [MobClick event:shopItem_buy_click attributes:@{@"itemId":self.viewModel.Id,@"specId":self.viewModel.specId.stringValue,@"count":@(self.viewModel.count).stringValue}];
    } error:self.errorBlock completed:^{
        [SVProgressHUD dismiss];
    } executing:nil];
}

#pragma mark - 分享
- (IBAction)onShare:(id)sender {
    
    if (!self.viewModel.model) {
        return;
    }
    NSURL *img = IMAGE_HOST_SHOP(self.viewModel.model.imagePath);
    NSString *html5 = [NSString stringWithFormat:@"%@product2.html?id=%@",html_share,self.viewModel.Id];
    WSELF;
    [[self.viewModel shareInView:self title:self.title text:self.viewModel.model.desc image:[UIImage cacheImagewith:img] url:html5 shareId:self.viewModel.Id type:YCYCShareTypeItem].deliverOnMainThread subscribeNext:^(id x) {
        [self performSelector:@selector(showMessage:) withObject:x afterDelay:1];
    } error:^(NSError *error) {
        SSELF;
        [self performSelector:@selector(showMessage:) withObject:error.localizedDescription afterDelay:1];
    }];
}

#pragma mark - 收藏
- (void)onFavorite:(UIButton *)sender {
    
    self.viewModel.active = YES;
    BOOL isFavorite = !self.viewModel.model.isMyFavorite.boolValue;
    WSELF;
    [sender executeActivitySignal:[self.viewModel goodsFavoriteById:self.viewModel.Id isFavorite:isFavorite type:YCCheatsTypeGoods] next:^(id next) {
        SSELF;
        self.viewModel.model.isMyFavorite = @(isFavorite);
        sender.selected = isFavorite;
        [MobClick event:shopItem_favorite_click attributes:@{@"isFavorite":@(isFavorite).stringValue}];
    } error:self.errorBlock completed:nil executing:nil];
}

#pragma mark - 去购物车
- (void)onGotoCart:(UIButton *)sender {
    if ([self pushToLoginVCIfNotLogin]) {
        return;
    }
    [self pushTo:[YCMyCartVC class]];
    [MobClick event:shopItem_viewCart_click];
}

#pragma mark - 加入购物车
- (void)onAddToCart:(UIButton *)sender
{
    
    CHECKMidMessage(self.viewModel.sum == 0, @"库存不足，请联系客服");
    
    [SVProgressHUD show];
    [sender executeActivitySignal:[[self.viewModel addToCart:self.viewModel.Id productSpecId:self.viewModel.specId count:@(self.viewModel.count)]map:^id(NSDictionary *value) {
        value = value[kContent];
        return value[@"qty"];
    }] next:^(NSNumber *next) {
        [self showmMidMessage:@"已经添加到了购物车"];
        if (next.intValue == 1) {
            self.badge.badgeText = @(self.badge.badgeText.intValue+1).stringValue;
        }
        [MobClick event:shopItem_addCart_click];
    } error:self.errorBlock completed:^{
        [SVProgressHUD dismiss];
    } executing:nil];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.itemDetailVC = segue.destinationViewController;
    [segue.destinationViewController setViewModel:self.viewModel];
    
}


@end


@implementation YCItemDetailVC
SYNTHESIZE_VM;

- (void)dealloc
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.scrollsToTop = YES;
    [self  scrollViewDidScroll:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UINavigationBar *nb = self.navigationController.navigationBar;
    [nb lt_reset];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tableView.scrollsToTop = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.decelerationRate = 1.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIEdgeInsets insets = self.tableView.scrollIndicatorInsets;
    insets.top = 64;
    self.tableView.scrollIndicatorInsets = insets;
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    
    
    
    UIWebView *wv = [[UIWebView alloc]init];
    
    WSELF;
    [RACObserve(self.viewModel, model) subscribeNext:^(YCItemDetailM *x) {
        SSELF;
        if (!x) {
            return ;
        }
        
        //ceshi
        //        x.htmlPath = @"http://api1-2.youchi365.com/shop/youmi/midAutumnList.html";
        //        x.htmlPosition = 0;
        
        
        if (x.htmlPath) {
            
            wv.scrollView.scrollEnabled = NO;
            self.webView = wv;
            
            NSProgress *progress = [NSProgress new];
            NSURLRequest *req = [NSURLRequest requestWithURL:NSURL_URLWithString(x.htmlPath)];
            [wv loadRequest:req progress:&progress success:^NSString * _Nonnull(NSHTTPURLResponse * _Nonnull response, NSString * _Nonnull HTML) {
                return HTML;
            } failure:^(NSError * _Nonnull error) {
                ;
            }];
        }
        [self onReloadItems:0];
    }];
    
    
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor *color = [UIColor blackColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = 1 - ((64 - offsetY) / 64);
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
}

-(void)onSetupCell
{
    [super onSetupCell];
}

-(void)onSetupHeaderFooter
{
    
}

- (void)onSetupActivityIndicatorView
{
    
}

- (void)onConfigureCell:(__weak YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    
    WSELF;
    float edge = YCItemDetailInnerEdge;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
#pragma mark - 线条-
    NSArray *reuseIdentifiers = @[cell2,cell3,cell4,cell5,cell6,cell7,cell8];
    if ([reuseIdentifiers indexOfObject:reuseIdentifier] != NSNotFound) {
        [cell setInitBlock:^(__kindof YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIEdgeInsets insets = UIEdgeInsetsMake(0, YCItemDetailEdge, 0, YCItemDetailEdge);
            
            cell.backgroundColor = [UIColor clearColor];
            view.backgroundColor = [UIColor whiteColor];
            
            cell.selectedBackgroundView.clipsToBounds = YES;
            CGFloat height = 1/[UIScreen mainScreen].scale;
            
            CAShapeLayer *line = reuseIdentifier == cell2?nil:[CAShapeLayer layer];
            
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
    
    
#pragma mark - 自动播放-cell0
    if (reuseIdentifier == cell0) {
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            YCImagePlayerView *ipv = [YCImagePlayerView newInSuperView:view];
            [ipv yc_initView];
            [ipv setShopUpdateBlock];
            
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
        }];
        return;
    }
    
#pragma mark - 剩余，总销量-cell1
    if (reuseIdentifier == cell1) {
        cell.backgroundColor =  [UIColor clearColor];
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YYLabel *lbCount = [YYLabel newInSuperView:view];
            YYLabel *lbSum = [YYLabel newInSuperView:view];
            lbCount.numberOfLines = lbSum.numberOfLines = 2;
            lbCount.textAlignment = lbSum.textAlignment = NSTextAlignmentCenter;
            lbCount.font = lbSum.font = KFont(12);
            lbCount.textColor = lbSum.textColor = UIColorHex(#838383);
            lbCount.displaysAsynchronously = lbSum.displaysAsynchronously = YES;
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCShopSpecs *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if (![cell checkIsHasSetData:m]) {
                    
                    NSMutableAttributedString *text = [NSMutableAttributedString new];
                    [text appendString:@"此商品仅剩："];
                    text.color = UIColorHex(838383);
                    NSMutableAttributedString *num = [NSMutableAttributedString new];
                    [num appendString:[NSString stringWithFormat:@"%d份",m.specQty.intValue]];
                    num.color = UIColorHex(333333);
                    [text appendAttributedString:num];
                    text.alignment = NSTextAlignmentCenter;
                    
                    lbCount.attributedText = text;
                    lbSum.text = [NSString stringWithFormat:@"总销量：%d份",self.viewModel.model.showSalesQty.intValue];
                }
            }];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [lbCount mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.bottom.equalTo(lbCount.superview);
                    make.right.equalTo(lbSum.mas_left);
                }];
                [lbSum mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.right.bottom.equalTo(lbCount.superview);
                    make.width.equalTo(lbCount);
                }];
            }];
        }];
        return;
    }
    
    
#pragma mark - 详细描述-cell2
    if (reuseIdentifier == cell2) {
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YYLabel  *l = [YYLabel newInSuperView:view];
            l.numberOfLines = 0;
            l.displaysAsynchronously = YES;
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                
                YYTextLayout *layout = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:layout]) {
                    return ;
                }
                
                l.textLayout = layout;
            }];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [l mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
            }];
            
            
        }];
        
        return;
    }
    
    //*
#pragma mark - 价钱和选择数量-cell3
    if (reuseIdentifier == cell3) {
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
                self.viewModel.count = MIN(++self.viewModel.count, self.viewModel.sum);
                count.text = @(self.viewModel.count).stringValue;
            }];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCItemDetailM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                
                if (m.shopSpecs.count==0) {
                    return ;
                }
                YCShopSpecM *specsM = m.shopSpecs[self.viewModel.selectedshopSpecIndex];
                
                count.text = @(self.viewModel.count).stringValue;
                if (self.viewModel.isYoumiPay) {
                    l2.text = [NSString stringWithFormat:@"%d友米",specsM.antPrice.intValue];
                    minus.hidden = plus.hidden = count.hidden = YES;
                    
                } else {
                    
                    
                    l2.text = [NSString stringWithFormat:@"¥%.2f",specsM.specMoneyPrice.floatValue];
                }
            }];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                l1.text = @" 吃货价 ";
                l1.font = KFont(12);
                l1.backgroundColor =  UIColorHex(333333);
                l1.clipsToBounds = YES;
                l1.cornerRadius = 4;
                l1.textColor = [UIColor whiteColor];
                [l1 sizeToFit];
                
                l2.font = KFont(20);
                l2.textColor = [UIColor blackColor];
                count.text = @(self.viewModel.count).stringValue;
                [minus setImage:IMAGE(@"减") forState:UIControlStateNormal];
                [plus setImage:IMAGE(@"加") forState:UIControlStateNormal];
                minus.contentMode = UIViewContentModeScaleAspectFill;
                plus.contentMode = UIViewContentModeScaleAspectFill;
                
                [@[l1,l2,minus,count,plus] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(view);
                }];
                
                [@[minus,plus] mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(view).offset(-10);
                    make.width.equalTo(view.mas_height).offset(-10);
                }];
                
                [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).offset(edge);
                }];
                [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(l1.mas_right).offset(5);
                    
                }];
                [minus mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.greaterThanOrEqualTo(l2.mas_right);
                    make.right.equalTo(count.mas_left);//.offset(-edge);
                }];
                [count mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(plus.mas_left);//.offset(-edge);
                }];
                [plus mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view);//.offset(-edge);
                }];
            }];
        }];
        return;
    }
    
    
#pragma mark - 规格-cell4
    if (reuseIdentifier == cell4) {
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
                    
                    
                    [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
                    
                    
                } else {
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    
    
    
#pragma mark - 认证-cell6
    if (reuseIdentifier == cell6) {
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            YCContainerControl *cc = [YCContainerControl newInSuperView:view];
            [cc setElementCount:3 block:^UIView *(NSInteger idx) {
                UIButton *b = [[UIButton buttonWithType:UIButtonTypeCustom]addInSuperView:view];
                
                [b setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                b.titleLabel.font = [UIFont systemFontOfSize:20];
                [b setTitleColor:UIColorHex(#333333) forState:UIControlStateNormal];
                return b;
            }];
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                NSArray *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                [cc.elements enumerateObjectsUsingBlock:^(UIButton  *_Nonnull b, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx<m.count) {
                        b.hidden = NO;
                        YCShopVerifyM *svm = m[idx];
                        [b setImageWithURL:IMAGE_HOST_SHOP(svm.imagePath) forState:UIControlStateNormal placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
                    } else {
                        b.hidden = YES;
                    }
                }];
            }];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                [cc mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
            }];
        }];
        return;
    }
    
    
#pragma mark - 发货信息-cell7
    UILabel *l1 = [UILabel new];
    l1.font = KFont(12);
    l1.textColor = UIColorHex(#333333);
    if (reuseIdentifier == cell7) {
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            [l1 addInSuperView:view];
            UILabel *l2 = [UILabel newInSuperView:view];
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                l2.font = l1.font;
                l2.textColor = UIColorHex(#d09356);
                l2.textAlignment = NSTextAlignmentRight;
                
                NSString *l1text = self.viewModel.isPresell?@"预售商品":@"48小时内发货";
                
                l1.text = l1text;
                l2.text = @"支持支付宝支付和微信支付";
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
    
#pragma mark - 商品评价，配送地址 --cell8
    if (reuseIdentifier == cell8) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            [l1 addInSuperView:view];
            UIImageView *l2 = [UIImageView newInSuperView:view];
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                NSString *title = [self.viewModel modelForItemAtIndexPath:indexPath];
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
                NSString *title = [self.viewModel modelForItemAtIndexPath:indexPath];
                UIViewController *vc;
                YCPageViewModel *vm;
                
                if (indexPath.row == 1) {
                    
                    CHECK(!self.viewModel.model.commentCount.intValue, @"暂时还没有评价...");
                    vm = [[YCGoodsCommentVM alloc]initWithId:self.viewModel.Id];
                    vc = [YCGoodsCommentVC vcClass];
                    vm.model = self.viewModel.model;
                    vm.viewModel = self.viewModel;
                    vc.viewModel = vm;
                    [self pushToVC:vc];
                    return ;
                }
                
                if (indexPath.row == 0) {
                    YCItemDetailM *m = self.viewModel.model;
                    YCAutoPageViewModel *vm = [YCAutoPageViewModel new];
                    [vm.modelsProxy setArray:m.shopShipping.shopShippingAreas];
                    [vm.cellInfos setArray:@[[YCCellInfo cellInfoWithId:cell0 height:^CGFloat(NSIndexPath *indexPath) {
                        return 44;
                    } number:^NSInteger(NSInteger section) {
                        return m.shopShipping.shopShippingAreas.count;
                    } model:^id(NSIndexPath *indexPath) {
                        return m.shopShipping.shopShippingAreas[indexPath.row];
                    }]]];
                    vc = [YCDistributionAreaVC new];
                    vc.viewModel = vm;
                    vc.title = title;
                    [self pushToVC:vc];
                }
                
                if (indexPath.row == 2) {
                    YCItemDetailM *m = self.viewModel.model;
                    YCAutoPageViewModel *vm = [YCAutoPageViewModel new];
                    [vm.modelsProxy setArray:m.shopPostagePolicy.shopPostagePolicySubs];
                    [vm.cellInfos setArray:@[[YCCellInfo cellInfoWithId:cell0 height:^CGFloat(NSIndexPath *indexPath) {
                        return 44;
                    } number:^NSInteger(NSInteger section) {
                        return m.shopPostagePolicy.shopPostagePolicySubs.count;
                    } model:^id(NSIndexPath *indexPath) {
                        return m.shopPostagePolicy.shopPostagePolicySubs[indexPath.row];
                    }]]];
                    vc = [YCPostagePolicyVC new];
                    vc.viewModel = vm;
                    vc.title = title;
                    [self pushToVC:vc];
                }
                
                
            }];
            
            
        }];
        return;
        
    }
    
    
#pragma mark - 往上拉动-cell9
    if (reuseIdentifier == cell9) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIButton *b = [[UIButton buttonWithType:UIButtonTypeCustom]addInSuperView:view];
            
            
            [cell setAutoLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                [b setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                [b setImage:IMAGE(@"形状-1") forState:UIControlStateNormal];
                [b setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                b.titleLabel.font = [UIFont systemFontOfSize:15];
                [b setTitle:@"往上拉动，查看图文详情" forState:UIControlStateNormal];
                [b setTitleColor:[UIColor colorWithHex:0x363636 andAlpha:0.3] forState:UIControlStateNormal];
                
                [b mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
            }];
        }];
        return;
    }
    
#pragma mark - 视频
    if (reuseIdentifier == cell5) {
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSString *reuseIdentifier) {
            
            UIImageView *play = [UIImageView newInSuperView:view];
            
            [cell setUpdateBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCShopProductImagesM *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:m]) {
                    return ;
                }
                
                [view ycShop_setImageWithURL:m.imagePath placeholder:PLACE_HOLDER];
                
            }];
            
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, CGRect frame) {
                play.image = IMAGE(@"视频按钮_default");
                [play mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(view);
                }];
            }];
            
            [cell setSelectBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCPlayerVC *vc = [[YCPlayerVC alloc]initWithFullUrlString:self.viewModel.model.videoPath];
                vc.title = self.viewModel.model.productName;
                [self pushToVC:vc];
            }];
            
            
        }];
        return;
    }
    
#pragma mark - 图文详情-cell10
    if (reuseIdentifier == cell10) {
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            UILabel *lb = [UILabel newInSuperView:view];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
            lb.textAlignment = NSTextAlignmentCenter;
            lb.text = @"图文详情";
            lb.backgroundColor = [UIColor whiteColor];
            lb.textColor = [UIColor blackColor];
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                lb.frame = frame;
            }];
        }];
        
        return;
    }
    
#pragma mark - 图片-cell11
    if (reuseIdentifier == cell11) {
        [cell setInitAsyncBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            
            UIView *img = [UIView newInSuperView:view];
            
            __block UIWebView *wv = self.webView;
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, CGRect frame) {
                img.contentMode = UIViewContentModeScaleAspectFill;
            }];
            
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                YCBaseImageModel *m = [self.viewModel modelForItemAtIndexPath:indexPath];
                [img yc_shopFillImageWithURL:m.imagePath placeholder:PLACE_HOLDER width:m.width height:m.height];
                
                if (self.viewModel.model.htmlPath && self.viewModel.model.htmlPosition == indexPath.row) {
                    [view addSubview:wv];
                    wv.frame = view.frame;
                } else  if (wv.superview == view) {
                    [wv removeFromSuperview];
                    
                }
            }];
            
            [cell setLayoutBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, CGRect frame) {
                img.frame = frame;
            }];
            
            
        }];
        return;
    }
    
#pragma mark - 保障-cell12
    if (reuseIdentifier == cell12) {
        [cell setInitBlock:^(YCTableVIewCell *cell, UIView *view, NSString *reuseIdentifier) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *b = [[UIButton buttonWithType:UIButtonTypeCustom]addInSuperView:view];
            [b setBackgroundImage:[UIImage imageWithColor:self.tableView.backgroundColor] forState:UIControlStateNormal];
            [b setImage:IMAGE(@"保障") forState:UIControlStateNormal];
            [b setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            b.titleLabel.font = [UIFont systemFontOfSize:12];
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [b setTitle:@"购买友吃商品有什么保障呢？" forState:UIControlStateNormal];
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                b.frame = frame;
            }];
            [[b rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                SSELF;
                YCWebVC *web = [[YCWebVC alloc]initWithUrlString: url_buy_baozhang];
                [self pushToVC:web];
            }];
            
        }];
        return;
    }
    
#pragma mark - 商品推荐
    if (reuseIdentifier == cell13) {
        
        cell.backgroundColor = cell.contentView.backgroundColor = self.tableView.backgroundColor;
        [cell setInitAsyncBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, NSString *reuseIdentifier) {
            
            WSELF;
            NSMutableArray *imageViews = [NSMutableArray new];
            for (int n = 0; n < 2; n++) {
                YCItemDetailRecommendView *iv = [YCItemDetailRecommendView newInSuperView:view];
                [imageViews addObject:iv];
                
                [iv.more addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    
                    SSELF;
                    NSIndexPath *idp = [self indexPathForCell:cell];
                    NSArray *ms = [self.viewModel modelForItemAtIndexPath:idp];
                    ShopProductRecommend *m = ms[n];
                    if (m.productRecommendId) {
                        YCItemDetailVC *vc = [YCItemDetailVC vcClass];
                        YCItemDetailVM *vm = [[YCItemDetailVM alloc]initWithId:m.productRecommendId];
                        [self pushToVC:vc viewModel:vm];
                    }
                    
                }];
                
            }
            
            [cell setAutoLayoutBlock:^(__kindof YCTableVIewCell *__weak cell, UIView *view, CGRect frame) {
                [imageViews enumerateObjectsUsingBlock:^(YCItemDetailRecommendView *_Nonnull iv, NSUInteger idx, BOOL * _Nonnull stop) {
                    [iv yc_initView];
                }];
            }];
            
            
            [cell setUpdateBlock:^(YCTableVIewCell *cell, UIView *view, NSIndexPath *indexPath) {
                SSELF;
                NSArray *ms = [self.viewModel modelForItemAtIndexPath:indexPath];
                if ([cell checkIsHasSetData:ms]) {
                    return ;
                }
                [imageViews enumerateObjectsUsingBlock:^(YCItemDetailRecommendView *_Nonnull iv, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (ms.count > idx) {
                        ShopProductRecommend *m = ms[idx];
                        [iv updateItemDetailRecommendViewWith:m];
                        iv.hidden = NO;
                    } else {
                        iv.hidden = YES;
                    }
                    
                }];
                
            }];
            
            [cell setLayoutBlock:^(YCTableVIewCell *cell, UIView *view, CGRect frame) {
                
                [imageViews layoutByType:YCContainerControlTypeHorizion edge:UIEdgeInsetsMake(2, 1, 2, 1) gap:2 inFrame:frame];
            }];
        }];
    }
    
    
}

- (void)onSetupRefreshControl
{
    
}

- (void)onSetupFooter
{
    
}


@end


@implementation YCItemDetailRecommendView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *item = [UIView newInSuperView:self];
        YYLabel *detail = [YYLabel newInSuperView:self];
        
        YYLabel *price = [YYLabel newInSuperView:self];
        UIButton *more = [UIButton newInSuperView:self];
        
        _item = item;
        _detail = detail;
        _price = price;
        _more = more;
        
        _detail.numberOfLines = 2;
        
        more.size = CGSizeMake(50, 20);
        
        [self setLayoutBlock:^(YCView *__weak view, CGRect frame) {
            item.frame = frame;
            item.height = item.width;
            
            detail.frame = frame;
            detail.height = 50;
            detail.top = item.bottom;
            
            price.frame = frame;
            price.height = 50;
            price.bottom = view.bottom;
            price.width = frame.size.width - more.size.width - 4;
            
            more.right = frame.size.width - 4;
            more.bottom = view.bottom - 4;
        }];
    }
    return self;
}

- (void)yc_initView
{
    [_more setNormalTitle:@"  详情  "];
    [_more setNormalTitleColor:color_btnGold];
    [_more setBorderColor:color_btnGold];
    [_more setCornerRadius:2];
    [_more setBorderWidth:1];
    [_more sizeToFit];
}

- (void)updateItemDetailRecommendViewWith:(ShopProductRecommend *)m
{
    [_item yc_setImageWithURL:IMAGE_HOST_SHOP(m.recommendProductImage) placeholder:PLACE_HOLDER];
    NSMAString *title = NSMAString_initWithString(m.recommendProductName);
    [title appendString:@"\n"];
    title.font = KFont(16);
    title.color = [UIColor blackColor];
    title.lineSpacing = 8;
    
    NSMAString *desc = NSMAString_initWithString(m.recommendProductDesc);
    [desc appendString:@"\n"];
    desc.font = KFont(14);
    desc.color = [UIColor lightGrayColor];
    desc.lineSpacing = 6;
    [title appendAttributedString:desc];

    _detail.attributedText = title;
    
    NSMAString *price = NSMAString_initWithString(m.recommendProductPrice.stringValue);
   
    price.font = KFont(20);
    
    price.lineSpacing = 8;
    
    NSMAString *count = NSMAString_initWithString(@"元／件");
    
    count.font = KFont(10);
    count.lineSpacing = 6;
    [price appendAttributedString:count];
    price.color = color_btnGold;
    
    _price.attributedText = price;
}
@end