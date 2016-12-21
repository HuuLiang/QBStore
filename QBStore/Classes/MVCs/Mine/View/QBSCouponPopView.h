//
//  QBSCouponPopView.h
//  QBStore
//
//  Created by ylz on 2016/12/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSCouponPopView : UIView
@property (nonatomic,copy)QBSAction closeAction;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)QBSAction getTicketAction;
@property (nonatomic) NSString *title;
@end
