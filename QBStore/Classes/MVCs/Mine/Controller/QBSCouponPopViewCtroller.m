//
//  QBSCouponPopViewCtroller.m
//  QBStore
//
//  Created by ylz on 2016/12/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSCouponPopViewCtroller.h"
#import "QBSCouponPopView.h"
#import "QBSCouponPopModel.h"

@interface QBSCouponPopViewCtroller ()
{
    QBSConponInfo *_couponInfo;
}
@property (nonatomic,retain) QBSCouponPopView *popView;

@end

@implementation QBSCouponPopViewCtroller

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (QBSCouponPopView *)popView {
    if (_popView) {
        return _popView;
    }
    @weakify(self);
    _popView = [[QBSCouponPopView alloc] init];
    _popView.frame = self.view.bounds;
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hideCouponPopView];
    };
    
    _popView.getTicketAction = ^(id sender){
      @strongify(self);
        [self hideCouponPopView];
        [self fetchCouponTicketModel];
    };
    
    return _popView;
}
/**
 确认领取优惠券
 */
- (void)fetchCouponTicketModel{
//    [_popView beginLoading];
    if (!QBSCurrentUserIsLogin)
      [QBSUIHelper presentLoginViewControllerIfNotLoginInViewController:self withCompletionHandler:^(BOOL success) {
          if (success) {
              [[QBSRESTManager sharedManager] request_getCouponGiftPackWithGiftPackId:_couponInfo.giftPackId completetionHandler:^(id obj, NSError *error) {
                  if ([obj isKindOfClass:[NSDictionary class]]) {
                      NSDictionary *valueDic = obj;
                      NSString *value = valueDic.allValues.firstObject;
                      if (value.integerValue == 200) {
                          [[QBSHUDManager sharedManager] showSuccess:@"领取成功"];
                      }else if (value.integerValue == 2021) {
                              [[QBSHUDManager sharedManager] showSuccess:@"您已经领取过"];
                      }else{//2022 礼包id不合法
                       [[QBSHUDManager sharedManager] showError:@"领取失败"];
                      }
                  }
              }];
          }
      }];

}

- (void)popCouponViewInViewCtroller:(UIViewController *)viewCtroller withCouponPopModel:(QBSConponInfo *)info{
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    _couponInfo = info;
    [viewCtroller addChildViewController:self];
    self.popView.alpha = 0;
    [viewCtroller.view addSubview:self.popView];
    [self.popView willMoveToWindow:viewCtroller.view.window];
    self.popView.price = [NSString stringWithFormat:@"%ld",info.amount.integerValue/100];
    self.popView.title = info.name;
    [UIView animateWithDuration:0.5 animations:^{
        self.popView.alpha = 1;
    }];
}

- (void)hideCouponPopView {
    
  [UIView animateWithDuration:0.5 animations:^{
    self.popView.alpha = 0;
  } completion:^(BOOL finished) {
    [self.popView removeFromSuperview];
  }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
