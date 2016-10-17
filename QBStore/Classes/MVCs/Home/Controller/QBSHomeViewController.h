//
//  QBSHomeViewController.h
//  Pods
//
//  Created by Sean Yue on 16/6/23.
//
//

#import "QBSBaseViewController.h"

@interface QBSHomeViewController : QBSBaseViewController

@property (nonatomic) BOOL showCartButton;
@property (nonatomic) BOOL showCategoryButton;
@property (nonatomic) BOOL showOrderListButton;

- (void)showOrderViewController;
- (void)showCartViewController;

@end
