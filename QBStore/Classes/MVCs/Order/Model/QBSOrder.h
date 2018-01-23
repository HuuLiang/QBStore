//
//  QBSOrder.h
//  Pods
//
//  Created by Sean Yue on 16/8/4.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"

extern NSString *const kQBSOrderPayTypeWeChat;
extern NSString *const kQBSOrderPayTypeAlipay;
extern NSString *const kQBSOrderPayTypeCOD;

extern NSString *const kQBSOrderStatusWaitPay;
extern NSString *const kQBSOrderStatusWaitDelivery;
extern NSString *const kQBSOrderStatusDelivered;
extern NSString *const kQBSOrderStatusWaitComment;
extern NSString *const kQBSOrderStatusCommented;
extern NSString *const kQBSOrderStatusClosed;

extern NSString *const kQBSOrderDeliverySTO;
extern NSString *const kQBSOrderDeliverySF;
extern NSString *const kQBSOrderDeliveryYTO;
extern NSString *const kQBSOrderDeliveryYTO;

@class QBSOrderCommodity;

@interface QBSOrder : NSObject

@property (nonatomic) NSString *payType;
@property (nonatomic) NSNumber *transportPrice;
@property (nonatomic) NSNumber *totalPrice;
@property (nonatomic) NSString *leaveMsg;
@property (nonatomic) NSString *addressInfo;
@property (nonatomic) NSString *receiverUsername;
@property (nonatomic) NSString *mobile;
@property (nonatomic) NSString *status;

@property (nonatomic) NSString *deliveryName;
@property (nonatomic) NSString *deliveryNo;

// To create the order
@property (nonatomic) NSString *commodityIds;

// To query orders
@property (nonatomic) NSString *orderNo;
@property (nonatomic) NSArray<QBSOrderCommodity *> *orderCommoditys;
@property (nonatomic) NSString *createTime;
@property (nonatomic) NSString *userId;

- (BOOL)isValid;
- (BOOL)isPlaced;
- (BOOL)isDelivered;

- (BOOL)shouldPay;
- (NSString *)statusString;
- (NSString *)paymentTypeString;

+ (NSString *)paymentTypeStringWithPaymentType:(NSString *)payType;
+ (NSString *)statusStringFromOrderStatus:(NSString *)orderStatus;
+ (instancetype)recreatedOrderWithOrder:(QBSOrder *)order;

@end

@interface QBSOrderResponse : QBSJSONResponse

@property (nonatomic) QBSOrder *data;

@end

@interface QBSOrderList : QBSJSONResponse
@property (nonatomic,retain) NSArray<QBSOrder *> *data;
@end
