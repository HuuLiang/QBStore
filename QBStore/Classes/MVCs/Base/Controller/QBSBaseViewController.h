//
//  QBSBaseViewController.h
//  Pods
//
//  Created by Sean Yue on 16/6/23.
//
//

#import <UIKit/UIKit.h>

@interface QBSBaseViewController : UIViewController

- (void)pushViewControllerWithRecommendType:(QBSRecommendType)recmType
                                 columnType:(QBSColumnType)columnType
                                     isLeaf:(BOOL)isLeaf
                                      relId:(NSNumber *)relId;

- (BOOL)isViewControllerDependsOnUserLogin;

@end
