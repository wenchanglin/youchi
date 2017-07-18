//
//  YCOrderNumView.h
//  YouChi
//
//  Created by 朱国林 on 16/1/14.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCAboutGoodsM.h"
/// 订单状态
typedef NS_ENUM(NSUInteger, YCOrderState) {
    YCOrderStateNotAudit = 0,/// 未审核
    YCOrderStateHadAudit,     ///   已审核
    YCOrderStateHadCancel,       ///   已取消
    YCOrderStateHadLost,     ///    无效
    YCOrderStateTimeOut,     /// 过期
    YCOrderStateFinish,     ///    已完成
    YCOrderStateHadRefund,     ///    已退款
    YCOrderStateRefunding,     ///    退款审核中
    YCOrderStateGroupBuy,      ///  部分结算
    YCOrderStateAllHadPay,     /// 全部结算
};

/// 发货状态
typedef NS_ENUM(NSUInteger, YCGoodsState) {
    YCGoodsStateNotSend = 0,    ///     未发货，未付款
    YCGoodsStateHadSend,       ///      已发货
    YCGoodsStateHadAccept,       ///   已收货
    YCGoodsStateHadAcceptSome,  /// 部分发货
    YCGoodsStateNotSendAndHadPay,    /// 未发货，已付款
    YCGoodsStatePayNow     ,///    未支付
    YCGoodsStateNon     ,///    无效状态
    YCGoodsStateHadPay, ///    已付款
    YCGoodsStateDelete     ///    删除订单
};


/// 按钮状态
typedef NS_ENUM(NSUInteger, YCOrderButton) {
    YCOrderButtonFinish = 0,           /// 已收货
    YCOrderButtonIsReFund,     ///   查看退货
    YCOrderButtonAddToCart,       ///   加入购物车
    YCOrderButtonComment,         /// 评论晒单
    YCOrderButtonNone,            /// 隐藏所有按钮
    YCOrderButtonIsPresell,            /// 预售商品完成时
    YCOrderButtonIsPresellIsReFund,    /// 预售退货
};

@interface YCOrderNumView : UIView


@property(nonatomic,strong)UILabel *lOrderText;

/// 订单号
@property(nonatomic,strong)UILabel *lOrderNumber;

/// 发货状态
@property(nonatomic,strong)UILabel *lOrderState;
@property(nonatomic,assign) YCOrderState YCOrderState;
@end

@interface YCOrderPayView : YCOrderNumView  // 订单列表
/// 取消订单
@property(nonatomic,strong)UIButton *bCancelOrder;
/// 马上支付
@property(nonatomic,strong)UIButton *bPayOrder;
/// 确认收货
@property(nonatomic,strong)UIButton *bAcceptOrder;
/// 申请退款
@property(nonatomic,strong)UIButton *bReFundOrder;
/// 删除订单
@property(nonatomic,strong)UIButton *bDeleteOrder;

@property(nonatomic,strong)UILabel *lPayText;

@property(nonatomic,strong)UILabel *lSymbol;
/// 实际付款
@property(nonatomic,strong)UILabel *lPaySumOrder;

@property (nonatomic,assign)YCGoodsState YCGoodsState;
@end

@interface YCOrderStatueView : YCOrderNumView  // 订单详情

/// 加入购物车
@property(nonatomic,strong)UIButton *bAddToCart;
/// 申请退款
@property(nonatomic,strong)UIButton *bApplyRefund;
/// 晒单评价
@property(nonatomic,strong)UIButton *bComment;
/// 查看退货
@property(nonatomic,strong)UIButton *bViewTheReturn;

@property(nonatomic,assign) YCOrderButton YCOrderButton;
@end
