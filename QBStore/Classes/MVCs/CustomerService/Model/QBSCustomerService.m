//
//  QBSCustomerService.m
//  Pods
//
//  Created by Sean Yue on 16/7/20.
//
//

#import "QBSCustomerService.h"

static NSString *const kCustomerServiceUserDefaultsKeyName = @"com.qbstore.userdefaults.customerservice";
static QBSCustomerServiceList *_sharedList;

@implementation QBSCustomerService

@end

@implementation QBSCustomerServiceList

SynthesizeContainerPropertyElementClassMethod(cscidList, QBSCustomerService)

+ (instancetype)sharedList {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *csInUserDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:kCustomerServiceUserDefaultsKeyName];
        _sharedList = [self objectFromDictionary:csInUserDefaults];
    });
    return _sharedList;
}

- (void)saveAsSharedList {
    NSDictionary *dic = [self dictionaryRepresentation];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kCustomerServiceUserDefaultsKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _sharedList = self;
}
@end
