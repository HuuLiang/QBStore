//
//  NSArray+Utilities.m
//  Pods
//
//  Created by Sean Yue on 16/7/26.
//
//

#import "NSArray+Utilities.h"

@implementation NSArray (Utilities)

- (CGFloat)QBS_sumFloat:(CGFloat (^)(id obj))block {
    __block CGFloat result = 0;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result += block(obj);
    }];
    return result;
}

- (NSInteger)QBS_sumInteger:(NSInteger (^)(id obj))block {
    __block NSInteger result = 0;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result += block(obj);
    }];
    return result;
}
@end
