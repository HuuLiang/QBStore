//
//  QBSShippingAddress.h
//  Pods
//
//  Created by Sean Yue on 16/7/29.
//
//

#import <Foundation/Foundation.h>
#import "QBSJSONResponse.h"

@interface QBSShippingAddress : NSObject <NSCopying>

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *province;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *district;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *mobile;
@property (nonatomic) NSNumber *isDefault;

@property (nonatomic,readonly) NSString *fullAddress;
@property (nonatomic,readonly) NSString *addressInfo;

#ifdef DEBUG
+ (instancetype)testAddress;
#endif

- (NSError *)isValid;

@end

extern NSString *const kQBSShippingAddressErrorDomain;

extern const NSInteger kQBSShippingAddressInvalidNameError;
extern const NSInteger kQBSShippingAddressInvalidRegionError;
extern const NSInteger kQBSShippingAddressInvalidAddressError;
extern const NSInteger kQBSShippingAddressInvalidMobileError;

@interface QBSShippingAddressList : QBSJSONResponse

@property (nonatomic,retain) NSArray<QBSShippingAddress *> *data;

@end

@interface QBSShippingAddressResponse : QBSJSONResponse

@property (nonatomic,retain) QBSShippingAddress *data;

@end

@interface QBSShippingRegionItem : NSObject

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *parentCode;

@end

@interface QBSShippingAddressProvince : QBSJSONResponse

@property (nonatomic,retain) NSArray<QBSShippingRegionItem *> *data;

@end

@interface QBSShippingAddressCityAndDistrictData : NSObject

@property (nonatomic,retain) NSArray<QBSShippingRegionItem *> *cities;
@property (nonatomic,retain) NSDictionary<NSString *, NSArray<QBSShippingRegionItem *> *> *districts;

@end

@interface QBSShippingAddressCityAndDistrict : QBSJSONResponse

@property (nonatomic,retain) QBSShippingAddressCityAndDistrictData *data;

@end

@interface QBSCreateShippingAddressResponse : QBSJSONResponse

@property (nonatomic,retain) QBSShippingAddress *data;

@end