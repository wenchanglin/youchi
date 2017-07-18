//
//  YCOrderNumView.m
//  YouChi
//
//  Created by 朱国林 on 16/1/14.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCOrderNumView.h"
#import <Masonry/Masonry.h>
#import "YCView.h"

@implementation YCOrderNumView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{

    [self.lOrderText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(8);
    }];
    
    [self.lOrderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.lOrderText.mas_right).offset(8);

    }];
    
    [self.lOrderState mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-11);
    }];
    
}

- (UILabel *)lOrderText{

    if (!_lOrderText) {
        
        _lOrderText = [[UILabel alloc] init];
        _lOrderText.textColor = KBGCColor(@"#272636");
        _lOrderText.text = @"订单号:";
        _lOrderText.textAlignment = NSTextAlignmentCenter;
        _lOrderText.font = [UIFont systemFontOfSize:12];
        [self addSubview:_lOrderText];
        
    }
    
    return _lOrderText;
}


- (UILabel *)lOrderNumber{
    
    if (!_lOrderNumber) {
        
        _lOrderNumber = [[UILabel alloc] init];
        _lOrderNumber.textColor = KBGCColor(@"#272636");
        _lOrderNumber.text = @"2016010102143998";
        _lOrderNumber.textAlignment = NSTextAlignmentCenter;
        _lOrderNumber.font = [UIFont systemFontOfSize:12];
        [self addSubview:_lOrderNumber];
    }
    
    return _lOrderNumber;
}

- (UILabel *)lOrderState{
    
    if (!_lOrderState) {
        
        _lOrderState = [[UILabel alloc] init];
        _lOrderState.textColor = KBGCColor(@"#f24941");
        _lOrderState.text = @"";
        _lOrderState.textAlignment = NSTextAlignmentRight;
        _lOrderState.font = [UIFont systemFontOfSize:12];
        [self addSubview:_lOrderState];
    }
    
    return _lOrderState;
}


-(void)setYCOrderState:(YCOrderState)YCOrderState
{
    NSString *YCOrderStateTypeStr;
    if (YCOrderState == YCOrderStateNotAudit) {
        YCOrderStateTypeStr = @"未审核";
    }else if (YCOrderState == YCOrderStateHadAudit){
        YCOrderStateTypeStr = @"已审核";
    }else if (YCOrderState == YCOrderStateHadCancel){
        YCOrderStateTypeStr = @"已取消";
    }else if (YCOrderState == YCOrderStateHadLost){
        YCOrderStateTypeStr = @"无效";
    }else if (YCOrderState == YCOrderStateTimeOut){
        YCOrderStateTypeStr = @"未付款已过期";
    }else if (YCOrderState == YCOrderStateFinish){
        YCOrderStateTypeStr = @"完成";
    }else if (YCOrderState == YCOrderStateHadRefund){
        YCOrderStateTypeStr = @"已退款";
    }else if (YCOrderState == YCOrderStateRefunding){
        YCOrderStateTypeStr = @"退款审核中";
    } else if (YCOrderState == YCOrderStateGroupBuy){
        YCOrderStateTypeStr = @"部分结算";
    } else if (YCOrderState == YCOrderStateAllHadPay){
        YCOrderStateTypeStr = @"全部结算";
    }


    
    self.lOrderState.text = YCOrderStateTypeStr;
    
}

@end


@implementation YCOrderPayView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)_init{

    [self.lPayText mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom);

    }];
    
    [self.lSymbol mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(3);
        make.left.equalTo(self.lPayText.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-2);
        
    }];
    
    [self.lPaySumOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.lSymbol.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
    
    [self.bPayOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-8);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.width.equalTo(@(70));
        
    }];
    
    [self.bCancelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.bPayOrder.mas_left).offset(-8);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.width.equalTo(@70);
    }];
    
    [self.bReFundOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@70);
    }];
    
    [self.bAcceptOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@70);
    }];
    
    
}

- (UILabel *)lPayText{

    if (!_lPayText) {
        _lPayText = [[UILabel alloc] init];
        _lPayText.textAlignment = NSTextAlignmentCenter;
        _lPayText.font = [UIFont systemFontOfSize:11];
        _lPayText.textColor = KBGCColor(@"#272636");
        [self addSubview:_lPayText];
    }
    
    return _lPayText;
}

- (UILabel *)lSymbol{

    if (!_lSymbol) {
        _lSymbol = [[UILabel alloc] init];
        _lSymbol.font = [UIFont systemFontOfSize:11];
        _lSymbol.text = @"￥";
        _lSymbol.textColor = KBGCColor(@"#272636");
        [self addSubview:_lSymbol];
    }
    
   return _lSymbol;
}

- (UILabel *)lPaySumOrder{

    if (!_lPaySumOrder) {
        _lPaySumOrder = [[UILabel alloc] init];
        _lPaySumOrder.font = [UIFont systemFontOfSize:11];
        _lPaySumOrder.text = @"176";
        _lPaySumOrder.textAlignment = NSTextAlignmentCenter;
        _lPaySumOrder.textColor = KBGCColor(@"#272636");
        [self addSubview:_lPaySumOrder];
    }
    
    return _lPaySumOrder;
    
}

- (UIButton *)bCancelOrder{

    if (!_bCancelOrder) {
        _bCancelOrder = [[UIButton alloc] init];
        [_bCancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
        [_bCancelOrder setTitleColor:KBGCColor(@"#65656d") forState:UIControlStateNormal];
        _bCancelOrder.titleLabel.font = [UIFont systemFontOfSize:12];
        _bCancelOrder.borderColor = KBGCColor(@"#65656d");
        _bCancelOrder.cornerRadius = 3;
        _bCancelOrder.borderWidth = 0.8;
        _bCancelOrder.hidden = YES;
        [self addSubview:_bCancelOrder];
    }
    
    return _bCancelOrder;
}

- (UIButton *)bPayOrder{

    if (!_bPayOrder) {
        _bPayOrder = [[UIButton alloc] init];
        [_bPayOrder setTitle:@"马上支付" forState:UIControlStateNormal];
        [_bPayOrder setTitleColor:KBGCColor(@"#65656d") forState:UIControlStateNormal];
        _bPayOrder.titleLabel.font = [UIFont systemFontOfSize:12];
        _bPayOrder.cornerRadius = 3;
        _bPayOrder.borderColor = KBGCColor(@"#65656d");
        _bPayOrder.borderWidth = 0.8;
        _bPayOrder.hidden = YES;
        [self addSubview:_bPayOrder];
    }
    
    return _bPayOrder;
}

- (UIButton *)bAcceptOrder{

    if (!_bAcceptOrder) {
        _bAcceptOrder = [[UIButton alloc] init];
        [_bAcceptOrder setTitle:@"确认收货" forState:UIControlStateNormal];
        [_bAcceptOrder setTitleColor:color_yellow forState:UIControlStateNormal];
        _bAcceptOrder.titleLabel.font = [UIFont systemFontOfSize:12];
        _bAcceptOrder.cornerRadius = 3;
        _bAcceptOrder.borderColor = color_yellow;
        _bAcceptOrder.borderWidth = 0.8;
        [self addSubview:_bAcceptOrder];
        _bAcceptOrder.hidden = YES;
    }
    
    return _bAcceptOrder;
}

- (UIButton *)bReFundOrder{

    if (!_bReFundOrder) {
        _bReFundOrder = [[UIButton alloc] init];
        [_bReFundOrder setTitle:@"申请退款" forState:UIControlStateNormal];
        [_bReFundOrder setTitleColor:KBGCColor(@"#65656d") forState:UIControlStateNormal];
        _bReFundOrder.titleLabel.font = [UIFont systemFontOfSize:12];
        _bReFundOrder.cornerRadius = 3;
        _bReFundOrder.borderColor = KBGCColor(@"#65656d");
        _bReFundOrder.borderWidth = 0.8;
        [self addSubview:_bReFundOrder];
        _bReFundOrder.hidden = YES;
    }
    
    return _bReFundOrder;
}


- (UIButton *)bDeleteOrder{
    
    if (!_bDeleteOrder) {
        _bDeleteOrder = [[UIButton alloc] init];
        [_bDeleteOrder setTitle:@"删除订单" forState:UIControlStateNormal];
        [_bDeleteOrder setTitleColor:KBGCColor(@"#65656d") forState:UIControlStateNormal];
        _bDeleteOrder.titleLabel.font = [UIFont systemFontOfSize:12];
        _bDeleteOrder.cornerRadius = 3;
        _bDeleteOrder.borderColor = KBGCColor(@"#65656d");
        _bDeleteOrder.borderWidth = 0.8;
        [self addSubview:_bDeleteOrder];
        _bDeleteOrder.hidden = YES;
    }
    
    return _bDeleteOrder;
}



- (void)setYCGoodsState:(YCGoodsState)YCGoodsState{

    if (YCGoodsState == YCGoodsStateNotSend) { // 未发货未付款   取消订单 马上支付
        
        [self updateConstraintsStateNotSend];
    }else if (YCGoodsState == YCGoodsStateNotSendAndHadPay){ // 未发货已付款 申请退款
    
        [self updateConstraintsStateNotSendAndHadPay];
    }else if (YCGoodsState == YCGoodsStateHadSend){ // 已发货    确认收货
    
        [self updateConstraintsStateHadSend];
    }else if (YCGoodsState == YCGoodsStateNon){
    
        [self updateConstraintsStateNone];
    }else if (YCGoodsState == YCGoodsStateDelete){  // 删除订单
    
        [self updateConstraintsStateDeleteOrder];
    }
    
}



#pragma mark --删除订单保留   其他隐藏
- (void)updateConstraintsStateDeleteOrder{
    
    self.bDeleteOrder.hidden  = NO;
    self.bPayOrder.hidden = self.bCancelOrder.hidden = self.bReFundOrder.hidden = self.bAcceptOrder.hidden = YES;
    
    [self.bDeleteOrder mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.bPayOrder);
        make.width.equalTo(@70);
    }];
}


#pragma mark --未发货，未付款   只保留取消订单，马上支付   bCancelOrder（右2）  bPayOrder(右1)
- (void)updateConstraintsStateNotSend{
    

    self.bPayOrder.hidden = self.bCancelOrder.hidden = NO;
    self.bReFundOrder.hidden = self.bAcceptOrder.hidden = self.bDeleteOrder.hidden = YES;
    
}

#pragma mark --未发货，已付款   保留申请退款,其他隐藏
- (void)updateConstraintsStateNotSendAndHadPay{

    self.bReFundOrder.hidden = NO;
    self.bPayOrder.hidden = self.bCancelOrder.hidden = self.bCancelOrder.hidden  = self.bDeleteOrder.hidden = YES;
    self.bReFundOrder.center = self.bPayOrder.center;
    
    [self.bReFundOrder mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self.bPayOrder);
        make.width.equalTo(@70);
    }];
}

#pragma mark --已发货时(包括已付款)  保留确认收货，其他隐藏
- (void)updateConstraintsStateHadSend{
    
    self.bAcceptOrder.hidden = NO;
    self.bPayOrder.hidden = self.bReFundOrder.hidden = self.bCancelOrder.hidden = self.bDeleteOrder.hidden = YES;
    self.bAcceptOrder.center = self.bPayOrder.center;
    
    [self.bAcceptOrder mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.bPayOrder);
        make.width.equalTo(@70);
    }];
}

#pragma mark --其他状态全部隐藏
- (void)updateConstraintsStateNone{

    self.bPayOrder.hidden = self.bReFundOrder.hidden = self.bCancelOrder.hidden =self.bAcceptOrder.hidden = YES;
    
}

@end

@implementation YCOrderStatueView

- (void)_init{

    self.userInteractionEnabled = YES;
    
    [self.bComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
    }];
    
    [self.bApplyRefund mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
        make.right.equalTo(self.bComment.mas_left).offset(-9);
        make.bottom.equalTo(self).offset(-8);

    }];

    [self.bAddToCart mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
        make.right.equalTo(self.bApplyRefund.mas_left).offset(-9);
        make.bottom.equalTo(self).offset(-8);

    }];
    
    [self.bViewTheReturn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
        make.right.equalTo(self.bAddToCart.mas_left).offset(-9);
        make.bottom.equalTo(self).offset(-8);
    }];
    
}

- (UIButton *)bComment{

    if (!_bComment) {
        _bComment = [[UIButton alloc] init];
        _bComment.cornerRadius = 3;
        _bComment.titleLabel.font = [UIFont systemFontOfSize:12];
        _bComment.backgroundColor =color_btnGold;
        [_bComment setTitle:@"晒单评价" forState:UIControlStateNormal];
        [self addSubview:_bComment];
    }
    
    return _bComment;
}

- (UIButton *)bApplyRefund{
    
    if (!_bApplyRefund) {
        _bApplyRefund = [[UIButton alloc] init];
        
        _bApplyRefund.titleLabel.font = [UIFont systemFontOfSize:12];
        _bApplyRefund.borderColor = KBGCColor(@"#65656d");
        _bApplyRefund.cornerRadius = 3;
        _bApplyRefund.borderWidth = 0.5;
        [_bApplyRefund setTitle:@"申请退货" forState:UIControlStateNormal];
        [_bApplyRefund setTitleColor:KBGCColor(@"#232133") forState:UIControlStateNormal];
        [self addSubview:_bApplyRefund];
    }
    
    return _bApplyRefund;
}


- (UIButton *)bAddToCart{
    
    if (!_bAddToCart) {
        _bAddToCart = [[UIButton alloc] init];
        _bAddToCart.titleLabel.font = [UIFont systemFontOfSize:12];
        _bAddToCart.borderColor = KBGCColor(@"#65656d");
        _bAddToCart.cornerRadius = 3;
        _bAddToCart.borderWidth = 0.5;
        [_bAddToCart setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_bAddToCart setTitleColor:KBGCColor(@"#232133") forState:UIControlStateNormal];
        [self addSubview:_bAddToCart];
    }

    return _bAddToCart;
}

- (UIButton *)bViewTheReturn{

    if (!_bViewTheReturn) {
        _bViewTheReturn = [[UIButton alloc] init];
        _bViewTheReturn.hidden = NO;
        _bViewTheReturn.titleLabel.font = [UIFont systemFontOfSize:12];
        _bViewTheReturn.borderColor = KBGCColor(@"#65656d");
        _bViewTheReturn.cornerRadius = 3;
        _bViewTheReturn.borderWidth = 0.5;
        [_bViewTheReturn setTitle:@"查看退货" forState:UIControlStateNormal];
        [_bViewTheReturn setTitleColor:KBGCColor(@"#232133") forState:UIControlStateNormal];
        [self addSubview:_bViewTheReturn];
    }
    return _bViewTheReturn;
}

-(void)setYCOrderButton:(YCOrderButton)YCOrderButton{
    
    if (YCOrderButton == YCOrderButtonFinish) {  // 已收货
        [self updateConstraintsForFinish];
        
    }else if (YCOrderButton == YCOrderButtonIsReFund){ // 查看退货
        [self updateConstraintsForViewTheReturn];
        
    }else if (YCOrderButton == YCOrderButtonAddToCart){ // 加入购物车
        [self updateConstraintsForAddToCart];
    }else if (YCOrderButton == YCOrderButtonNone){    // 全部隐藏
        
        [self updateConstraintsNone];
        
    }else if (YCOrderButton == YCOrderButtonIsPresell){ // 预售商品完成时
        
        [self updateConstraintsIsPresellComplete];
    }else if (YCOrderButton == YCOrderButtonIsPresellIsReFund){ // 预售商品退货时
        
        [self updateConstraintsIsPresellIsReFundn];
    }
    
}

#pragma mark --已收货时，查看退货情况隐藏
- (void)updateConstraintsForFinish{
    
    self.bViewTheReturn.hidden = YES;
    self.bComment.hidden = self.bApplyRefund.hidden = NO;
    
    [self.bComment mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
    }];
    
    [self.bApplyRefund mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
        make.right.equalTo(self.bComment.mas_left).offset(-9);
        make.bottom.equalTo(self).offset(-8);
        
    }];
    
    [self.bAddToCart mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
        make.right.equalTo(self.bApplyRefund.mas_left).offset(-9);
        make.bottom.equalTo(self).offset(-8);
        
    }];
}

#pragma mark --正在退货. 晒单评价，申请退货隐藏
- (void)updateConstraintsForViewTheReturn{
    
    self.bViewTheReturn.hidden = NO;
    self.bComment.hidden = self.bApplyRefund.hidden = YES;
    
    [_bViewTheReturn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
        make.right.equalTo(self).offset(-9);
        make.bottom.equalTo(self).offset(-8);

    }];

    [_bAddToCart mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
        make.right.equalTo(_bViewTheReturn.mas_left).offset(-9);
        make.bottom.equalTo(self).offset(-8);

    }];
    
}
#pragma mark --其他情况，除了加入购物车，全部隐藏
- (void)updateConstraintsForAddToCart{

    self.bAddToCart.hidden = NO;
    _bComment.hidden = _bApplyRefund.hidden = _bViewTheReturn.hidden =YES;
    
    [self.bAddToCart mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
        make.right.equalTo(self).offset(-9);
        make.bottom.equalTo(self).offset(-8);
    }];
}

#pragma mark --预售（未收货） ，全部隐藏
- (void)updateConstraintsNone{
    
    self.bViewTheReturn.hidden =self.bAddToCart.hidden  = self.bComment.hidden = self.bApplyRefund.hidden = YES;
    
}

#pragma mark --预售商品完成时
- (void)updateConstraintsIsPresellComplete{
    
    
    self.bAddToCart.hidden = self.bViewTheReturn.hidden = YES;
    self.bComment.hidden = self.bApplyRefund.hidden = NO;
    
    [self.bComment mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
    }];
    
    [self.bApplyRefund mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
        make.right.equalTo(self.bComment.mas_left).offset(-9);
        make.bottom.equalTo(self).offset(-8);
        
    }];
}

#pragma mark --预售商品退货时，只保留查看退货
- (void)updateConstraintsIsPresellIsReFundn{
    
    self.bViewTheReturn.hidden = NO;
    self.bAddToCart.hidden = self.bComment.hidden = self.bApplyRefund.hidden = YES;
    
    [_bViewTheReturn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(73));
        make.height.equalTo(@(23));
        make.right.equalTo(self).offset(-9);
        make.bottom.equalTo(self).offset(-8);
        
    }];
}
@end
