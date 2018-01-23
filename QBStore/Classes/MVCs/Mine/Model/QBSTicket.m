//
//  QBSTicket.m
//  QBStore
//
//  Created by Sean Yue on 2016/11/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSTicket.h"

@implementation QBSTicket

SynthesizePropertyClassMethod(appStoreInfo, QBSTicketAppStoreInfo)

@end

@implementation QBSTicketAppStoreInfo

@end

@implementation QBSTicketList

SynthesizeContainerPropertyElementClassMethod(exchangeList, QBSTicket)

@end

@implementation QBSTicketFetchResponse

SynthesizePropertyClassMethod(userExchangeVoucherInfo, QBSTicketFetchInfo)

@end

@implementation QBSTicketFetchInfo

@end
