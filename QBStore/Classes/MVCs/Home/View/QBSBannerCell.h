//
//  QBSBannerCell.h
//  Pods
//
//  Created by Sean Yue on 16/6/27.
//
//

#import <UIKit/UIKit.h>

@interface QBSBannerCell : UICollectionViewCell

@property (nonatomic,retain) NSArray *imageURLStrings;
@property (nonatomic) BOOL shouldAutoScroll;
@property (nonatomic) BOOL shouldInfiniteScroll;
@property (nonatomic,copy) QBSSelectionAction selectionAction;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) CGFloat pageControlYAspect;

@end
