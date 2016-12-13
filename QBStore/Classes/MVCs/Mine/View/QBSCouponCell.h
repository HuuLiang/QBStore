//
//  QBSCouponCell.h
//  QBStore
//
//  Created by ylz on 2016/12/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSCouponCell : UITableViewCell

@property (nonatomic,assign)NSInteger couponStatus;//代金劵使用状态
@property (nonatomic,assign) NSInteger bottomImageType;//底图
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subTitle;
@property (nonatomic,copy)NSString *useDeadline;//使用期限
@property (nonatomic,copy)NSString *couponPrice;//代金券金额
@property (nonatomic,copy)NSString *satisfyPrice;//满减价格
@end
