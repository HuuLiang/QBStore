//
//  QBSOrderActionBar.h
//  Pods
//
//  Created by Sean Yue on 16/8/26.
//
//

#import <UIKit/UIKit.h>

@class QBSOrderActionBar;

@protocol QBSOrderActionBarDataSource <NSObject>

@required
- (NSUInteger)numberOfButtons:(QBSOrderActionBar *)actionBar;

@optional
- (NSString *)actionBar:(QBSOrderActionBar *)actionBar titleAtIndex:(NSUInteger)index;
- (UIImage *)actionBar:(QBSOrderActionBar *)actionBar imageAtIndex:(NSUInteger)index;

@end

@protocol QBSOrderActionBarDelegate <NSObject>

- (void)actionBar:(QBSOrderActionBar *)actionBar didClickButtonAtIndex:(NSUInteger)index;

@end

@interface QBSOrderActionBar : UIView

@property (nonatomic,weak) id<QBSOrderActionBarDataSource> dataSource;
@property (nonatomic,weak) id<QBSOrderActionBarDelegate> delegate;

- (void)reloadButtons;

- (NSString *)buttonTitleAtIndex:(NSUInteger)index;

@end
