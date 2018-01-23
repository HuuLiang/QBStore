//
//  QBSBaseViewController.h
//  Pods
//
//  Created by Sean Yue on 16/6/23.
//
//

#import <UIKit/UIKit.h>

@interface QBSBaseViewController : UIViewController

@property (nonatomic) BOOL alwaysHideNavigationBar;

- (void)pushViewControllerWithRecommendType:(QBSRecommendType)recmType
                                 columnType:(QBSColumnType)columnType
                                     isLeaf:(BOOL)isLeaf
                                      relId:(NSNumber *)relId
                                    relName:(NSString *)relName
                                     relUrl:(NSURL *)relUrl;

- (BOOL)isViewControllerDependsOnUserLogin;

@end
