//
//  QBSCommodityDetailTitleCell.h
//  Pods
//
//  Created by Sean Yue on 16/7/9.
//
//

#import <UIKit/UIKit.h>

@interface QBSCommodityDetailTitleCell : UICollectionViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) NSUInteger sold;
@property (nonatomic) NSArray<NSString *> *tags;
@property (nonatomic) QBSAction customerServiceAction;

@property (nonatomic) BOOL onlyShowTitle;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice;
- (CGFloat)cellHeight;

@end
