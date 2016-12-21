//
//  QBSCouponPopViewCtroller.h
//  QBStore
//
//  Created by ylz on 2016/12/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSBaseViewController.h"
@class QBSConponInfo;

@interface QBSCouponPopViewCtroller : QBSBaseViewController
- (void)popCouponViewInViewCtroller:(UIViewController *)viewCtroller withCouponPopModel:(QBSConponInfo *)info;

@end
