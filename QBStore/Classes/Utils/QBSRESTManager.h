//
//  QBSRESTManager.h
//  Pods
//
//  Created by Sean Yue on 16/7/7.
//
//

#import <Foundation/Foundation.h>

@class QBSUser;
@class QBSShippingAddress;
@class QBSOrder;
@class QBSOrderCommodity;
@class QBSTicket;

@interface QBSRESTManager : NSObject

DeclareSingletonMethod(sharedManager)

// Home
- (void)request_queryHomeBannerWithCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_queryFavouritesInPage:(NSUInteger)page withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_queryHomeFeaturedTypesAndActivitiesWithCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_queryHomeFeaturedCommoditiesInPage:(NSUInteger)page withCompletionHandler:(QBSCompletionHandler)completionHandler;

// Category
- (void)request_queryCategoriesWithCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_querySubCategoriesWithColumnId:(NSNumber *)columnId
                                    columnType:(QBSColumnType)columnType
                             completionHandler:(QBSCompletionHandler)completionHandler;

// List
- (void)request_queryCommodityListWithColumnId:(NSNumber *)columnId
                                    columnType:(QBSColumnType)columnType
                                bySortWithType:(QBSSortType)sortType
                                          mode:(QBSSortMode)sortMode
                                        inPage:(NSUInteger)pageNo
                             completionHandler:(QBSCompletionHandler)completionHandler;

- (void)request_queryActivityListWithColumnId:(NSNumber *)columnId
                                   columnType:(QBSColumnType)columnType
                                       inPage:(NSUInteger)pageNo
                            completionHandler:(QBSCompletionHandler)completionHandler;

// Detail
- (void)request_queryCommodityDetailWithCommodityId:(NSNumber *)commodityId
                                           columnId:(NSNumber *)columnId
                                  completionHandler:(QBSCompletionHandler)completionHandler;

- (void)request_queryCommodityCommentWithCommodityId:(NSNumber *)commodityId
                                              inPage:(NSUInteger)pageNo
                                   completionHandler:(QBSCompletionHandler)completionHandler;

// Customer Service
- (void)request_queryCustomerServiceWithCompletionHandler:(QBSCompletionHandler)completionHandler;

// User
- (void)request_loignWithUser:(QBSUser *)user completionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_sendSMSToMobile:(NSString *)mobile withCompletionHandler:(QBSCompletionHandler)completionHandler;

// Shipping Address
- (void)request_queryShippingProvincesWithCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_queryCitiesAndDistrictsInProvince:(NSString *)provinceCode completionHandler:(QBSCompletionHandler)completionHandler;

- (void)request_newShippingAddress:(QBSShippingAddress *)address withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_queryShippingAddressesWithCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_setDefaultShippingAddress:(QBSShippingAddress *)address withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_queryDefaultShippingAddressWithCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_updateShippingAddress:(QBSShippingAddress *)address withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_deleteShippingAddress:(QBSShippingAddress *)address withCompletionHandler:(QBSCompletionHandler)completionHandler;

// Order
- (void)request_queryOrdersInPage:(NSUInteger)page withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_createOrder:(QBSOrder *)order withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_queryOrderById:(NSString *)orderId withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_modifyStatusOfOrder:(NSString *)orderId toStatus:(NSString *)status withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_modifyPayTypeOfOrder:(NSString *)orderId toPayType:(NSString *)payType withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_submitCommentsOfCommodities:(NSArray<QBSOrderCommodity *> *)commodities forOrder:(NSString *)orderId withCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_modifyPaymentTypeByCODForOrder:(NSString *)orderId withCompletionHandler:(QBSCompletionHandler)completionHandler;

// Payment
//- (void)request_queryPaymentConfigWithCompletionHandler:(QBSCompletionHandler)completionHandler;

// Tickets
- (void)request_queryActivityTicketsWithCompletionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_fetchActivityTicketNoWithTicket:(QBSTicket *)ticket completionHandler:(QBSCompletionHandler)completionHandler;
- (void)request_queryActivityInstructionWithCompletionHandler:(QBSCompletionHandler)completionHandler;

@end

extern NSString *const kQBSRESTErrorDomain;
extern NSString *const kQBSErrorMessageKeyName;
extern const NSInteger kQBSRESTParameterErrorCode;
extern const NSInteger kQBSRESTUserNotLoginErrorCode;
extern const NSInteger kQBSRESTOrderInvalidErrorCode;
extern const NSInteger kQBSRESTInvalidShippingAddressErrorCode;
extern const NSInteger kQBSRESTInvalidUserAccess;
extern const NSInteger kQBSRESTLogicErrorCode;
extern const NSInteger kQBSRESTNetworkErrorCode;
