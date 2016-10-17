//
//  QBSSortBar.h
//  Pods
//
//  Created by Sean Yue on 16/7/12.
//
//

#import <UIKit/UIKit.h>

@class QBSSortBar;
@class QBSSortBarItem;

@protocol QBSSortBarDelegate <NSObject>

@optional
- (void)sortBar:(QBSSortBar *)sortBar didChangeSortMode:(QBSSortMode)sortMode atItemIndex:(NSUInteger)itemIndex;

@end

@interface QBSSortBarItem : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) BOOL hasSortMode;

+ (instancetype)itemWithName:(NSString *)name hasSortMode:(BOOL)hasSortMode;

@end

@interface QBSSortBar : UIView

@property (nonatomic,retain,readonly) NSArray<QBSSortBarItem *> *items;
@property (nonatomic,weak) id<QBSSortBarDelegate> delegate;

@property (nonatomic) NSUInteger selectedIndex;

- (instancetype)init __attribute__((unavailable("Use - initWithItems:delegate: instead")));
- (instancetype)initWithItems:(NSArray<QBSSortBarItem *> *)items delegate:(id<QBSSortBarDelegate>)delegate;

@end
