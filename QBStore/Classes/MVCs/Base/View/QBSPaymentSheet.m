//
//  QBSPaymentSheet.m
//  Pods
//
//  Created by Sean Yue on 16/8/22.
//
//

#import "QBSPaymentSheet.h"
#import "QBSOrder.h"

@interface QBSPaymentSheet ()
{
    
}
@end

@implementation QBSPaymentSheet

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *items = [NSMutableArray array];
        
        @weakify(self);
        QBSGridSheetItem *itemWeChat = [QBSGridSheetItem itemWithTitle:@"微信支付" iconImage:[UIImage QBS_imageWithResourcePath:@"wechat"] action:^(id obj)
        {
            @strongify(self);
            SafelyCallBlock(self.paymentAction, kQBSOrderPayTypeWeChat);
        }];
        
        QBSGridSheetItem *itemAlipay = [QBSGridSheetItem itemWithTitle:@"支付宝支付" iconImage:[UIImage QBS_imageWithResourcePath:@"alipay"] action:^(id obj)
        {
            @strongify(self);
            SafelyCallBlock(self.paymentAction, kQBSOrderPayTypeAlipay);
        }];
        
//        QBSGridSheetItem *itemCOD = [QBSGridSheetItem itemWithTitle:@"货到付款" iconImage:[UIImage QBS_imageWithResourcePath:@"cash"] action:^(id obj)
//        {
//            @strongify(self);
//            SafelyCallBlock(self.paymentAction, kQBSOrderPayTypeCOD);
//        }];
        
        [items addObject:itemWeChat];
        [items addObject:itemAlipay];
//        [items addObject:itemCOD];
        
        self.items = items;
    }
    return self;
}

@end
