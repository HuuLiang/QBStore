//
//  QBSRESTManager.m
//  Pods
//
//  Created by Sean Yue on 16/7/7.
//
//

#import "QBSRESTManager.h"
#import "QBSHttpClient.h"

#import "QBSBanner.h"
#import "QBSHomeFavourites.h"
#import "QBSFeaturedCommodity.h"
#import "QBSCommodityDetail.h"
#import "QBSCategoryList.h"
#import "QBSSubCategoryList.h"
#import "QBSCommodityList.h"
#import "QBSCommodityComment.h"
#import "QBSCustomerService.h"
#import "QBSUser.h"
#import "QBSShippingAddress.h"
#import "QBSOrder.h"
#import "QBSOrderCommodity.h"
#import "QBSTicket.h"
#import "QBSTicketInstruction.h"

#define QBS_CHANNEL_NO [QBSConfiguration defaultConfiguration].channelNo
#define kDefaultHttpMethod QBSHttpMethodPOST

NSString *const kQBSRESTErrorDomain = @"com.qbstore.errordomain.rest";
const NSInteger kQBSRESTParameterErrorCode = -1;
const NSInteger kQBSRESTUserNotLoginErrorCode = -2;
const NSInteger kQBSRESTOrderInvalidErrorCode = -3;
const NSInteger kQBSRESTInvalidShippingAddressErrorCode = -4;
const NSInteger kQBSRESTInvalidUserAccess = -5;
const NSInteger kQBSRESTLogicErrorCode = -998;
const NSInteger kQBSRESTNetworkErrorCode = -999;

@implementation QBSRESTManager

SynthesizeSingletonMethod(sharedManager, QBSRESTManager)

- (void)request_queryHomeBannerWithCompletionHandler:(QBSCompletionHandler)completionHandler {
    [[QBSHttpClient sharedClient] requestURL:@"banner.service"
                                  withParams:@{@"channelNo":QBS_CHANNEL_NO}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id data, NSError *error)
    {
        [self onResponseWithObject:data error:error modelClass:[QBSBannerResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryFavouritesInPage:(NSUInteger)page
          withCompletionHandler:(QBSCompletionHandler)completionHandler
{
    [[QBSHttpClient sharedClient] requestURL:@"guess.service"
                                  withParams:@{@"channelNo":QBS_CHANNEL_NO,@"pageNum":@(page)}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSHomeFavourites class] completionHandler:completionHandler];
    }];
}

- (void)request_queryHomeFeaturedTypesAndActivitiesWithCompletionHandler:(QBSCompletionHandler)completionHandler {
    [[QBSHttpClient sharedClient] requestURL:@"comProRmd.service"
                                  withParams:@{@"channelNo":QBS_CHANNEL_NO}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
     {
         [self onResponseWithObject:obj error:error modelClass:[QBSFeaturedCommodityListResponse class] completionHandler:completionHandler];
     }];
}

- (void)request_queryHomeFeaturedCommoditiesInPage:(NSUInteger)page withCompletionHandler:(QBSCompletionHandler)completionHandler {
    [[QBSHttpClient sharedClient] requestURL:@"colComRmd.service"
                                  withParams:@{@"channelNo":QBS_CHANNEL_NO,
                                               @"pageNum":@(page)}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSFeaturedCommodityResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryCategoriesWithCompletionHandler:(QBSCompletionHandler)completionHandler {
    [[QBSHttpClient sharedClient] requestURL:@"chnlList.service"
                                  withParams:@{@"channelNo":QBS_CHANNEL_NO}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSCategoryListResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_querySubCategoriesWithColumnId:(NSNumber *)columnId
                                    columnType:(QBSColumnType)columnType
                             completionHandler:(QBSCompletionHandler)completionHandler
{
    if (!columnId) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"请求参数为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *params = @{@"columnId":columnId, @"columnType":@(columnType), @"isLeaf":@0, @"entry":@"CHNL"};
    [[QBSHttpClient sharedClient] requestURL:@"subColOrCom.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSSubCategoryListResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryCommodityListWithColumnId:(NSNumber *)columnId
                                    columnType:(QBSColumnType)columnType
                                bySortWithType:(QBSSortType)sortType
                                          mode:(QBSSortMode)sortMode
                                        inPage:(NSUInteger)pageNo
                             completionHandler:(QBSCompletionHandler)completionHandler
{
    if (columnId == nil || sortType == QBSSortTypeUnknown) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"请求参数为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *sortTypeMapping = @{@(QBSSortTypeGeneral):@"comprehensive",
                                      @(QBSSortTypeSales):@"numsold",
                                      @(QBSSortTypePrice):@"price"};
    
    NSDictionary *sortModeMapping = @{@(QBSSortModeNone):@"desc",
                                      @(QBSSortModeAscending):@"asc",
                                      @(QBSSortModeDescending):@"desc"};
    
    NSDictionary *params = @{@"columnId":columnId,
                             @"columnType":@(columnType),
                             @"isLeaf":@1,
                             @"pageNum":@(pageNo),
                             @"sortType":sortTypeMapping[@(sortType)],
                             @"sortDirection":sortModeMapping[@(sortMode)]};
    
    [[QBSHttpClient sharedClient] requestURL:@"comSort.service" withParams:params methodType:kDefaultHttpMethod completionHandler:^(id obj, NSError *error) {
        [self onResponseWithObject:obj error:error modelClass:[QBSCommodityListResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryActivityListWithColumnId:(NSNumber *)columnId
                                   columnType:(QBSColumnType)columnType
                                       inPage:(NSUInteger)pageNo
                            completionHandler:(QBSCompletionHandler)completionHandler
{
    if (!columnId) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"请求参数为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *params = @{@"columnId":columnId, @"columnType":@(columnType), @"isLeaf":@1, @"pageNum":@(pageNo)};
    [[QBSHttpClient sharedClient] requestURL:@"subColOrCom.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
     {
         [self onResponseWithObject:obj error:error modelClass:[QBSCommodityListResponse class] completionHandler:completionHandler];
     }];
}

- (void)request_queryCommodityDetailWithCommodityId:(NSNumber *)commodityId
                                           columnId:(NSNumber *)columnId
                                  completionHandler:(QBSCompletionHandler)completionHandler {
    if (!commodityId) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"请求参数为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    [[QBSHttpClient sharedClient] requestURL:@"comDtl.service"
                                  withParams:columnId ? NSDictionaryOfVariableBindings(commodityId,columnId) : NSDictionaryOfVariableBindings(commodityId)
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSCommodityDetailResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryCommodityCommentWithCommodityId:(NSNumber *)commodityId
                                              inPage:(NSUInteger)pageNo
                                   completionHandler:(QBSCompletionHandler)completionHandler
{
    if (!commodityId) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"请求参数为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *params = @{@"commodityId":commodityId, @"pageNum":@(pageNo)};
    [[QBSHttpClient sharedClient] requestURL:@"eval.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSCommodityCommentListResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryCustomerServiceWithCompletionHandler:(QBSCompletionHandler)completionHandler {
    [[QBSHttpClient sharedClient] requestURL:@"contact.service"
                                  withParams:@{@"channelNo":QBS_CHANNEL_NO}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSCustomerServiceList class] completionHandler:completionHandler];
    }];
}

- (void)request_loignWithUser:(QBSUser *)user completionHandler:(QBSCompletionHandler)completionHandler {
    if (![user isValid]) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"登录的用户不合法"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:user.userType forKey:@"userType"];
    if ([user.userType isEqualToString:kQBSUserTypeNormal]) {
        [params setObject:user.mobile forKey:@"mobile"];
        [params safelySetObject:user.veriCode forKey:@"verCode"];
    } else if ([user.userType isEqualToString:kQBSUserTypeWeChat]) {
        [params safelySetObject:user.name forKey:@"name"];
        [params safelySetObject:user.sex forKey:@"sex"];
        [params safelySetObject:user.age forKey:@"age"];
        [params safelySetObject:user.openid forKey:@"openid"];
        [params safelySetObject:user.logoUrl forKey:@"logoUrl"];
    }
    
    
    [[QBSHttpClient sharedClient] requestURL:@"user/login.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSUserLoginResponse class] completionHandler:^(id obj, NSError *error) {
            if (error.logicCode == 2001) {
                error.qbsErrorMessage = @"验证码已过期";
            } else if (error.logicCode == 2002) {
                error.qbsErrorMessage = @"验证码错误";
            }
            
            SafelyCallBlock(completionHandler, obj, error);
        }];
    }];
}

- (void)request_sendSMSToMobile:(NSString *)mobile withCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (mobile.length == 0) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"手机号码不能为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    [[QBSHttpClient sharedClient] requestURL:@"sendVC.service"
                                  withParams:NSDictionaryOfVariableBindings(mobile)
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSJSONResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryShippingProvincesWithCompletionHandler:(QBSCompletionHandler)completionHandler {
    [[QBSHttpClient sharedClient] requestURL:@"order/queryProvince.service"
                                  withParams:@{@"channelNo":QBS_CHANNEL_NO}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSShippingAddressProvince class] completionHandler:completionHandler];
    }];
}

- (void)request_queryCitiesAndDistrictsInProvince:(NSString *)provinceCode completionHandler:(QBSCompletionHandler)completionHandler {
    [[QBSHttpClient sharedClient] requestURL:@"order/queryArea.service"
                                  withParams:@{@"provincecode":provinceCode}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSShippingAddressCityAndDistrict class] completionHandler:completionHandler];
    }];
}

- (void)request_newShippingAddress:(QBSShippingAddress *)address withCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSError *error = [address isValid];
    if (error) {
        SafelyCallBlock(completionHandler, nil, [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTInvalidShippingAddressErrorCode errorMessage:@"无效的收获地址"]);
        return ;
    }
    
    NSDictionary *params = @{@"userId":[QBSUser currentUser].userId,
                             @"name":address.name,
                             @"province":address.province,
                             @"city":address.city,
                             @"district":address.district,
                             @"address":address.address,
                             @"mobile":address.mobile,
                             @"accessToken":[QBSUser currentUser].accessToken};
    [[QBSHttpClient sharedClient] requestURL:@"user/insertAddress.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSCreateShippingAddressResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryShippingAddressesWithCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    [[QBSHttpClient sharedClient] requestURL:@"user/queryByUserId.service"
                                  withParams:@{@"userId":[QBSUser currentUser].userId,
                                               @"accessToken":[QBSUser currentUser].accessToken}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSShippingAddressList class] completionHandler:completionHandler];
    }];
}

- (void)request_setDefaultShippingAddress:(QBSShippingAddress *)address withCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    if (!address.id) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTInvalidShippingAddressErrorCode errorMessage:@"无效的收获地址"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *params = @{@"id":address.id, @"userId":[QBSUser currentUser].userId, @"accessToken":[QBSUser currentUser].accessToken};
    [[QBSHttpClient sharedClient] requestURL:@"user/defaultAddress.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSJSONResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryDefaultShippingAddressWithCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    [[QBSHttpClient sharedClient] requestURL:@"user/queryDefaultAddress.service"
                                  withParams:@{@"userId":[QBSUser currentUser].userId,
                                               @"accessToken":[QBSUser currentUser].accessToken}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSShippingAddressResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_updateShippingAddress:(QBSShippingAddress *)address withCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSError *addressError = [address isValid];
    if (addressError) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTInvalidShippingAddressErrorCode errorMessage:@"无效的收获地址"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *params = @{@"id":address.id,
                             @"userId":[QBSUser currentUser].userId,
                             @"name":address.name,
                             @"province":address.province,
                             @"city":address.city,
                             @"district":address.district,
                             @"address":address.address,
                             @"mobile":address.mobile,
                             @"accessToken":[QBSUser currentUser].accessToken};
    
    [[QBSHttpClient sharedClient] requestURL:@"user/modifyAddress.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSJSONResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_deleteShippingAddress:(QBSShippingAddress *)address withCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    [[QBSHttpClient sharedClient] requestURL:@"user/deleteAddress.service"
                                  withParams:@{@"id":address.id,
                                               @"userId":[QBSUser currentUser].userId,
                                               @"accessToken":[QBSUser currentUser].accessToken}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSJSONResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryOrdersInPage:(NSUInteger)page withCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    [[QBSHttpClient sharedClient] requestURL:@"order/queryOrders.service"
                                  withParams:@{@"userId":[QBSUser currentUser].userId,
                                               @"accessToken":[QBSUser currentUser].accessToken,
                                               @"pageNum":@(page)}
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSOrderList class] completionHandler:completionHandler];
    }];
}

- (void)request_createOrder:(QBSOrder *)order withCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (order.userId.length == 0) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTOrderInvalidErrorCode errorMessage:@"订单没有指定用户"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    } 
    
    if (![order isValid]) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTOrderInvalidErrorCode errorMessage:@"无效的订单"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSMutableDictionary *params = @{@"userId":order.userId,
                                    @"channelNo":QBS_CHANNEL_NO,
                                    @"payType":order.payType,
                                    @"transportPrice":order.transportPrice ?: @0,
                                    @"totalPrice":order.totalPrice,
                                    @"leaveMsg":order.leaveMsg ?: @"",
                                    @"addressInfo":order.addressInfo,
                                    @"receiverUsername":order.receiverUsername,
                                    @"mobile":order.mobile,
                                    @"commodityIds":order.commodityIds,
                                    @"accessToken":[QBSUser currentUser].accessToken}.mutableCopy;
    
    [params safelySetObject:order.status forKey:@"status"];
    
    [[QBSHttpClient sharedClient] requestURL:@"order/insertOrder.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSOrderResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryOrderById:(NSString *)orderId withCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    if (orderId.length == 0) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"查询的订单号不能为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *params = @{@"orderNo":orderId,
                             @"userId":[QBSUser currentUser].userId,
                             @"accessToken":[QBSUser currentUser].accessToken};
    
    [[QBSHttpClient sharedClient] requestURL:@"order/queryByOrderNo.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSOrderResponse class] completionHandler:completionHandler];
    }];
    
}

- (void)request_modifyStatusOfOrder:(NSString *)orderId toStatus:(NSString *)status withCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    if (orderId.length == 0 || status.length == 0) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"订单号和状态不能为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *params = @{@"orderNo":orderId,
                             @"status":status,
                             @"userId":[QBSUser currentUser].userId,
                             @"accessToken":[QBSUser currentUser].accessToken};
    
    [[QBSHttpClient sharedClient] requestURL:@"order/modifyStatus.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSJSONResponse class] completionHandler:completionHandler];
    }];
    
}

- (void)request_modifyPayTypeOfOrder:(NSString *)orderId
                           toPayType:(NSString *)payType
               withCompletionHandler:(QBSCompletionHandler)completionHandler
{
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    if (orderId.length == 0 || payType.length == 0) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"订单号和支付方式不能为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *params = @{@"orderNo":orderId,
                             @"payType":payType,
                             @"userId":[QBSUser currentUser].userId,
                             @"accessToken":[QBSUser currentUser].accessToken};
    
    [[QBSHttpClient sharedClient] requestURL:@"order/modifyPayType.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSJSONResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_submitCommentsOfCommodities:(NSArray<QBSOrderCommodity *> *)commodities
                                   forOrder:(NSString *)orderId
                      withCompletionHandler:(QBSCompletionHandler)completionHandler
{
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    if (orderId.length == 0) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"订单号不能为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSMutableArray *commEvals = [NSMutableArray array];
    [commodities enumerateObjectsUsingBlock:^(QBSOrderCommodity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *eval = [[NSMutableDictionary alloc] initWithDictionary:@{@"commodityId":obj.commodityId,
                                                                                      @"score":@(obj.numberOfStars),
                                                                                      @"userName":[QBSUser currentUser].name ?: [QBSUser currentUser].mobile ?: @"匿名用户",
                                                                                      @"content":obj.comment ?: @""}];
        [commEvals addObject:eval];
    }];
    
    NSDictionary *params = @{@"userId":[QBSUser currentUser].userId,
                             @"accessToken":[QBSUser currentUser].accessToken,
                             @"commEvals":commEvals,
                             @"orderNo":orderId};
    
    [[QBSHttpClient sharedClient] requestURL:@"order/insertCommEvals.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSJSONResponse class] completionHandler:completionHandler];
    }];
}
//- (void)request_queryPaymentConfigWithCompletionHandler:(QBSCompletionHandler)completionHandler {
//    NSDictionary *params = @{@"appId":[QBSConfiguration defaultConfiguration].RESTAppId,
//                             @"channelNo":[QBSConfiguration defaultConfiguration].channelNo,
//                             @"pV":[QBSConfiguration defaultConfiguration].paymentRESTVersion};
//    
//    [[QBSHttpClient paymentClient] requestURL:@"appPayConfig.json" withParams:params methodType:kDefaultHttpMethod completionHandler:^(id obj, NSError *error) {
//        [self onResponseWithObject:obj error:error modelClass:[QBSJSONResponse class] errorMessagePrefix:nil completionHandler:completionHandler];
//    }];
//}

- (void)request_modifyPaymentTypeByCODForOrder:(NSString *)orderId withCompletionHandler:(QBSCompletionHandler)completionHandler {
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    if (orderId.length == 0) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"订单号不能为空"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *params = @{@"orderNo":orderId,
                             @"userId":[QBSUser currentUser].userId,
                             @"accessToken":[QBSUser currentUser].accessToken};
    [[QBSHttpClient sharedClient] requestURL:@"order/modiOrdStsOnCash.service"
                                  withParams:params
                                  methodType:kDefaultHttpMethod
                           completionHandler:^(id obj, NSError *error)
    {
        [self onResponseWithObject:obj error:error modelClass:[QBSJSONResponse class] completionHandler:completionHandler];
    }];
}

- (void)request_queryActivityTicketsWithCompletionHandler:(QBSCompletionHandler)completionHandler {
//    if (!QBSCurrentUserIsLogin) {
//        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
//        SafelyCallBlock(completionHandler, nil, error);
//        return ;
//    }
//    
    NSDictionary *params = @{@"channelNo":QBS_CHANNEL_NO,
                             @"osType":@"iv",
                             @"accessToken":[QBSUser currentUser].accessToken ?: @"",
                             @"userId":[QBSUser currentUser].userId ?: @""};
    [[QBSHttpClient sharedClient] requestURL:@"exchange.service" withParams:params methodType:kDefaultHttpMethod completionHandler:^(id obj, NSError *error) {
        [self onResponseWithObject:obj error:error modelClass:[QBSTicketList class] completionHandler:completionHandler];
    }];
}

- (void)request_fetchActivityTicketNoWithTicket:(QBSTicket *)ticket
                              completionHandler:(QBSCompletionHandler)completionHandler
{
    if (!QBSCurrentUserIsLogin) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTUserNotLoginErrorCode errorMessage:@"用户未登录"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    if (!ticket.appStoreInfo.appId || !ticket.payPointType) {
        NSError *error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTParameterErrorCode errorMessage:@"非法的请求参数"];
        SafelyCallBlock(completionHandler, nil, error);
        return ;
    }
    
    NSDictionary *params = @{@"channelNo":QBS_CHANNEL_NO,
                             @"userId":[QBSUser currentUser].userId,
                             @"accessToken":[QBSUser currentUser].accessToken,
                             @"appId":ticket.appStoreInfo.appId,
                             @"payPointType":ticket.payPointType
                             };
    [[QBSHttpClient sharedClient] requestURL:@"excode.service" withParams:params methodType:kDefaultHttpMethod completionHandler:^(id obj, NSError *error) {
        [self onResponseWithObject:obj error:error modelClass:[QBSTicketFetchResponse class] completionHandler:^(id obj, NSError *error) {
            if (error.logicCode == 2002) {
                error.qbsErrorMessage = @"亲，您还未达到领取礼券的条件，再接再厉哦~~~";
            }
            
            SafelyCallBlock(completionHandler, obj, error);
        }];
    }];
}

- (void)request_queryActivityInstructionWithCompletionHandler:(QBSCompletionHandler)completionHandler {
    NSDictionary *params = @{@"channelNo":QBS_CHANNEL_NO};
    [[QBSHttpClient sharedClient] requestURL:@"exUsageSpec.service" withParams:params methodType:kDefaultHttpMethod completionHandler:^(id obj, NSError *error) {
        [self onResponseWithObject:obj error:error modelClass:[QBSTicketInstruction class] completionHandler:completionHandler];
    }];
}

- (void)onResponseWithObject:(id)object
                       error:(NSError *)error
                  modelClass:(Class)modelClass
           completionHandler:(QBSCompletionHandler)completionHandler
{
    if (!object) {
        error = [self errorFromURLError:error];
        SafelyCallBlock(completionHandler, object, error);
    } else {
        NSParameterAssert([modelClass isSubclassOfClass:[QBSJSONResponse class]]);
    
        QBSJSONResponse *instance = [modelClass objectFromDictionary:object];
        if (![instance success]) {
            if ([instance userShouldReLogin]) {
                NSString *errorMessage = @"用户登录失效，需要重新登录";
                error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTInvalidUserAccess errorMessage:errorMessage];
            } else {
                NSString *errorMessage = [NSString stringWithFormat:@"网络数据返回错误(错误码：%@)", [instance code]];
                error = [NSError errorWithDomain:kQBSRESTErrorDomain code:kQBSRESTLogicErrorCode errorMessage:errorMessage logicCode:[instance code].integerValue];
            }
            SafelyCallBlock(completionHandler, nil, error);
            
            if ([instance userShouldReLogin]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kQBSUserShouldReLoginNotification object:error];
            }
        } else {
            SafelyCallBlock(completionHandler, instance, nil);
        }
    }
}

- (NSError *)errorFromURLError:(NSError *)error {

    NSDictionary *errorMessages = @{@(NSURLErrorBadURL):@"地址错误",
                                    @(NSURLErrorTimedOut):@"请求超时",
                                    @(NSURLErrorUnsupportedURL):@"不支持的网络地址",
                                    @(NSURLErrorCannotFindHost):@"找不到目标服务器",
                                    @(NSURLErrorCannotConnectToHost):@"无法连接到服务器",
                                    @(NSURLErrorDataLengthExceedsMaximum):@"请求数据长度超出限制",
                                    @(NSURLErrorNetworkConnectionLost):@"网络连接断开",
                                    @(NSURLErrorDNSLookupFailed):@"DNS查找失败",
                                    @(NSURLErrorHTTPTooManyRedirects):@"HTTP重定向太多",
                                    @(NSURLErrorResourceUnavailable):@"网络资源无效",
                                    @(NSURLErrorNotConnectedToInternet):@"设备未连接到网络",
                                    @(NSURLErrorRedirectToNonExistentLocation):@"重定向到不存在的地址",
                                    @(NSURLErrorBadServerResponse):@"服务器响应错误",
                                    @(NSURLErrorUserCancelledAuthentication):@"网络授权取消",
                                    @(NSURLErrorUserAuthenticationRequired):@"需要用户授权"};
    
    
    NSString *errorMessage = errorMessages[@(error.code)];
    errorMessage = errorMessage ? [NSString stringWithFormat:@"网络请求错误：%@", errorMessage] : @"网络请求错误";
    
    return [NSError errorWithDomain:kQBSRESTErrorDomain
                               code:kQBSRESTNetworkErrorCode
                       errorMessage:errorMessage];
}
@end
