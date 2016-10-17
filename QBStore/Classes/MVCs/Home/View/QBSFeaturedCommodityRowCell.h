//
//  QBSFeaturedCommodityRowCell.h
//  Pods
//
//  Created by Sean Yue on 16/7/5.
//
//

#import <UIKit/UIKit.h>

@interface QBSHomeFeaturedItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) CGFloat price;
@property (nonatomic) CGFloat originalPrice;

+ (instancetype)itemWithTitle:(NSString *)title imageURL:(NSURL *)imageURL price:(CGFloat)price originalPrice:(CGFloat)originalPrice;

@end

@interface QBSFeaturedCommodityRowCell : UICollectionViewCell

@property (nonatomic,retain) NSArray<QBSHomeFeaturedItem *> *items;
@property (nonatomic,copy) QBSSelectionAction selectionAction;

@end
