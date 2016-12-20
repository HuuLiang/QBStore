//
//  QBSCouponPopViewCtroller.m
//  QBStore
//
//  Created by ylz on 2016/12/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSCouponPopViewCtroller.h"
#import "QBSCouponPopView.h"

@interface QBSCouponPopViewCtroller ()
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

}

- (void)popCouponViewInView:(UIView *)view withTicketPrice:(NSInteger)price{
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    self.popView.alpha = 0;
    [view addSubview:self.popView];
    [self.popView willMoveToWindow:view.window];
    self.popView.price = [NSString stringWithFormat:@"%ld",price];
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
