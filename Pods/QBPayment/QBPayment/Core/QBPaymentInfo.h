//
//  QBPaymentInfo.h
//  QBPayment
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBPaymentDefines.h"

@class QBOrderInfo;
@class QBContentInfo;

@interface QBPaymentInfo : NSObject

@property (nonatomic) NSString *orderId;
@property (nonatomic) NSUInteger orderPrice;  //以分为单位
@property (nonatomic) NSString *orderDescription;

@property (nonatomic) QBPluginType pluginType;
@property (nonatomic) QBPaymentType paymentType;
@property (nonatomic) QBPayPointType payPointType;
@property (nonatomic) QBPayPointType currentPayPointType;
@property (nonatomic) QBPayPointType targetPayPointType;
@property (nonatomic) NSString *paymentTime;
@property (nonatomic) NSString *reservedData;

@property (nonatomic) QBPayResult paymentResult;
@property (nonatomic) QBPayStatus paymentStatus;

@property (nonatomic) NSNumber *contentId;
@property (nonatomic) NSNumber *contentType;
@property (nonatomic) NSNumber *contentLocation;
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *columnType;
@property (nonatomic) NSString *userId;

@property (nonatomic) NSNumber *version;

+ (NSArray<QBPaymentInfo *> *)allPaymentInfos;
- (instancetype)initWithOrderInfo:(QBOrderInfo *)orderInfo contentInfo:(QBContentInfo *)contentInfo;
//+ (instancetype)paymentInfoFromDictionary:(NSDictionary *)payment;
- (void)save;

@end
