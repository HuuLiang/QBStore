//
//  NSArray+Utilities.h
//  Pods
//
//  Created by Sean Yue on 16/7/26.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (Utilities)

- (CGFloat)QBS_sumFloat:(CGFloat (^)(id obj))block;
- (NSInteger)QBS_sumInteger:(NSInteger (^)(id obj))block;

@end
