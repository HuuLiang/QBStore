//
//  QBSOrder.m
//  Pods
//
//  Created by Sean Yue on 16/8/4.
//
//

#import "QBSOrder.h"
#import "QBSOrderCommodity.h"

NSString *const kQBSOrderPayTypeWeChat = @"WEIXIN";
NSString *const kQBSOrderPayTypeAlipay = @"ALIPAY";
NSString *const kQBSOrderPayTypeCOD = @"USERPAY";

NSString *const kQBSOrderStatusWaitPay = @"WAIT_PAY";
NSString *const kQBSOrderStatusWaitDelivery = @"WAIT_SEND_GOODS";
NSString *const kQBSOrderStatusDelivered = @"SEND_GOODS";
NSString *const kQBSOrderStatusWaitComment = @"WAIT_ACCESS";
NSString *const kQBSOrderStatusCommented = @"ACCESS_FINISH";
NSString *const kQBSOrderStatusClosed = @"TRADE_CLOSE";

@implementation QBSOrder

- (BOOL)isValid {
    if (self.receiverUsername.length > 0
        && self.mobile.length > 0
        && self.payType.length > 0
        && self.totalPrice.unsignedIntegerValue > 0
        && self.commodityIds.length > 0
        && self.addressInfo.length > 0) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isPlaced {
    return self.orderNo.length > 0;
}

- (BOOL)isDelivered {
    return self.deliveryNo.length > 0;
}

SynthesizeContainerPropertyElementClassMethod(orderCommoditys, QBSOrderCommodity)

- (BOOL)shouldPay {
//    if ([self.status isEqualToString:kQBSOrderStatusWaitPay]) {
//        return YES;
//    }
//    
    if ([self.payType isEqualToString:kQBSOrderPayTypeCOD]) {
        return self.status.length == 0;
    }
    
    if ([self.payType isEqualToString:kQBSOrderPayTypeAlipay]
        || [self.payType isEqualToString:kQBSOrderPayTypeWeChat]) {
        return self.status.length == 0 || [self.status isEqualToString:kQBSOrderStatusWaitPay];
    }
    return NO;
}

- (NSString *)statusString {
    return [[self class] statusStringFromOrderStatus:self.status];
}

- (NSString *)paymentTypeString {
    return [[self class] paymentTypeStringWithPaymentType:self.payType];
}

+ (NSString *)paymentTypeStringWithPaymentType:(NSString *)payType {
    NSDictionary *payTypeStrMapping = @{kQBSOrderPayTypeWeChat:@"微信支付",
                                        kQBSOrderPayTypeAlipay:@"支付宝支付",
                                        kQBSOrderPayTypeCOD:@"货到付款"};
    return payTypeStrMapping[payType];
}

+ (NSString *)statusStringFromOrderStatus:(NSString *)orderStatus {
    NSDictionary *statusMapping = @{kQBSOrderStatusWaitPay:@"待付款",
                                    kQBSOrderStatusWaitDelivery:@"待发货",
                                    kQBSOrderStatusDelivered:@"已发货",
                                    kQBSOrderStatusWaitComment:@"交易成功",
                                    kQBSOrderStatusCommented:@"交易成功",
                                    kQBSOrderStatusClosed:@"交易关闭"};
    return statusMapping[orderStatus];
}

+ (instancetype)recreatedOrderWithOrder:(QBSOrder *)order {
    QBSOrder *recreatedOrder = [[self alloc] init];
    recreatedOrder.payType = order.payType;
    recreatedOrder.transportPrice = order.transportPrice;
    recreatedOrder.totalPrice = order.totalPrice;
    recreatedOrder.leaveMsg = order.leaveMsg;
    recreatedOrder.addressInfo = order.addressInfo;
    recreatedOrder.receiverUsername = order.receiverUsername;
    recreatedOrder.mobile = order.mobile;
    recreatedOrder.orderCommoditys = order.orderCommoditys;
    recreatedOrder.userId = order.userId;
    return recreatedOrder;
}
@end

@implementation QBSOrderResponse

SynthesizePropertyClassMethod(data, QBSOrder)

@end

@implementation QBSOrderList
SynthesizeContainerPropertyElementClassMethod(data, QBSOrder)
@end

