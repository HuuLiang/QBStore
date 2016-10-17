//
//  QBSFeaturedCommodityCell.h
//  Pods
//
//  Created by Sean Yue on 16/7/5.
//
//

#import <UIKit/UIKit.h>

@interface QBSFeaturedCommodityCell : UICollectionViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) NSURL *imageURL;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice;

@end
