//
//  QBSCommodityCell.h
//  Pods
//
//  Created by Sean Yue on 16/7/5.
//
//

#import <UIKit/UIKit.h>

@interface QBSCommodityCell : UICollectionViewCell

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *title;
@property (nonatomic) NSUInteger sold;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice;

+ (CGFloat)cellAspects;

@end
