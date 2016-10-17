//
//  QBSShippingAddress.m
//  Pods
//
//  Created by Sean Yue on 16/7/29.
//
//

#import "QBSShippingAddress.h"

NSString *const kQBSShippingAddressErrorDomain = @"com.qbstore.errordomain.shippingaddress";

const NSInteger kQBSShippingAddressInvalidNameError = -1;
const NSInteger kQBSShippingAddressInvalidRegionError = -2;
const NSInteger kQBSShippingAddressInvalidAddressError = -3;
const NSInteger kQBSShippingAddressInvalidMobileError = -4;

@implementation QBSShippingAddress

- (NSError *)isValid {
    NSError *error;
    if (self.province.length == 0 || self.city.length == 0 || self.district.length == 0) {
        error = [NSError errorWithDomain:kQBSShippingAddressErrorDomain code:kQBSShippingAddressInvalidRegionError userInfo:@{kQBSErrorMessageKeyName:@"无效的所在地区"}];
        return error;
    }
    
    if (self.address.length < 5) {
        error = [NSError errorWithDomain:kQBSShippingAddressErrorDomain code:kQBSShippingAddressInvalidAddressError userInfo:@{kQBSErrorMessageKeyName:@"无效的详细地址：长度必须大于等于5个字符"}];
        return error;
    }
    
    if (self.name.length == 0 || [self.name rangeOfString:@" "].location != NSNotFound) {
        error = [NSError errorWithDomain:kQBSShippingAddressErrorDomain code:kQBSShippingAddressInvalidNameError userInfo:@{kQBSErrorMessageKeyName:@"无效的收件人：收件人为空或者收件人包含空格"}];
        return error;
    }
    
    if (self.mobile.length < 7) {
        error = [NSError errorWithDomain:kQBSShippingAddressErrorDomain code:kQBSShippingAddressInvalidMobileError userInfo:@{kQBSErrorMessageKeyName:@"无效的手机号码：长度必须大于等于7位数"}];
        return error;
    }
    
    return nil;
}

- (NSString *)fullAddress {
    return [NSString stringWithFormat:@"%@%@%@ %@", self.province ?: @"", self.city ?: @"", self.district?:@"", self.address?:@""];
}

- (id)copyWithZone:(NSZone *)zone {
    QBSShippingAddress *address = [[[self class] allocWithZone:zone] init];

    address.id = [self.id copyWithZone:zone];
    address.name = [self.name copyWithZone:zone];
    address.province = [self.province copyWithZone:zone];
    address.city = [self.city copyWithZone:zone];
    address.district = [self.district copyWithZone:zone];
    address.address = [self.address copyWithZone:zone];
    address.mobile = [self.mobile copyWithZone:zone];
    address.isDefault = [self.isDefault copyWithZone:zone];
    return address;
}
#ifdef DEBUG
+ (instancetype)testAddress {
    QBSShippingAddress *address = [[self alloc] init];
    address.name = @"你好吗";
    address.mobile = @"12312231313";
    address.province = @"浙江省";
    address.city = @"杭州市";
    address.district = @"西湖区";
    address.address = @"同人精华1幢507室 杭州趣吧科技有限公司";
    return address;
}
#endif
@end

@implementation QBSShippingAddressList

SynthesizeContainerPropertyElementClassMethod(data, QBSShippingAddress)

@end

@implementation QBSShippingAddressResponse

SynthesizePropertyClassMethod(data, QBSShippingAddress)

@end

@implementation QBSShippingRegionItem

@end

@implementation QBSShippingAddressProvince

SynthesizeContainerPropertyElementClassMethod(data, QBSShippingRegionItem)

@end

@implementation QBSShippingAddressCityAndDistrictData

SynthesizeContainerPropertyElementClassMethod(cities, QBSShippingRegionItem)
SynthesizeDictionaryPropertyKeyClassMethod(districts, NSString)
SynthesizeDictionaryPropertyValueElementClassMethod(districts, QBSShippingRegionItem)

@end

@implementation QBSShippingAddressCityAndDistrict

SynthesizePropertyClassMethod(data, QBSShippingAddressCityAndDistrictData)

@end

@implementation QBSCreateShippingAddressResponse

SynthesizePropertyClassMethod(data, QBSShippingAddress)

@end
