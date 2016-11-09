//
//  QBSTicket.h
//  QBStore
//
//  Created by Sean Yue on 2016/11/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBSTicketAppStoreInfo;

typedef NS_ENUM(NSUInteger, QBSTicketStatus) {
    QBSTicketStatusNotFetched,
    QBSTicketStatusFetched,
    QBSTicketStatusActivated
};

@interface QBSTicket : NSObject

@property (nonatomic) NSNumber *exchangeId;
@property (nonatomic) NSString *imgUrlBeforeReceive;
@property (nonatomic) NSString *imgUrlAfterReceive;
@property (nonatomic) NSNumber *minimalExpense;
@property (nonatomic) NSNumber *originalPrice;
@property (nonatomic) NSString *payPointName;
@property (nonatomic) NSNumber *payPointType;
@property (nonatomic) NSString *exchangeCode;
@property (nonatomic) NSNumber *exchangeStatus; //QBSTicketStatus

@property (nonatomic,retain) QBSTicketAppStoreInfo *appStoreInfo;

@end

@interface QBSTicketAppStoreInfo : NSObject

@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *downloadUrl;
@property (nonatomic) NSString *imgUrl;
@property (nonatomic) NSString *pkgName;
@property (nonatomic) NSString *pkgSize;
@property (nonatomic) NSString *title;

@end

@interface QBSTicketList : QBSJSONResponse

@property (nonatomic,retain) NSArray<QBSTicket *> *exchangeList;

@end

@interface QBSTicketFetchInfo : NSObject

@property (nonatomic) NSString *exchangeCode;
@property (nonatomic) NSNumber *exchangeStatus;

@end

@interface QBSTicketFetchResponse : QBSJSONResponse

@property (nonatomic,retain) QBSTicketFetchInfo *userExchangeVoucherInfo;

@end
