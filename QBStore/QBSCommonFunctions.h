//
//  QBSCommonFunctions.h
//  QBStore
//
//  Created by Sean Yue on 2016/10/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef QBSCommonFunctions_h
#define QBSCommonFunctions_h

#import "QBSErrorHandler.h"
//#define QBS_PRICE_IS_INTEGRAL(price) ((unsigned long)(price * 100.) % 100==0)

FOUNDATION_STATIC_INLINE NSString * QBSIntegralPrice(const CGFloat price) {
    if ((unsigned long)(price * 100.) % 100==0) {
        return [NSString stringWithFormat:@"%ld", (unsigned long)price];
    } else {
        return [NSString stringWithFormat:@"%.2f", price];
    }
}

FOUNDATION_STATIC_INLINE void QBSHandleError(NSError *error) {
    [[QBSErrorHandler sharedHandler] handleError:error];
}

FOUNDATION_STATIC_INLINE BOOL QBSCompareObject(id object1, id object2) {
    return [object1 isEqual:object2] || object1 == object2;
}

#endif /* QBSCommonFunctions_h */
