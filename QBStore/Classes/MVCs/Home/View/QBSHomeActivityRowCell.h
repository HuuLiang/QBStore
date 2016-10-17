//
//  QBSHomeActivityRowCell.h
//  Pods
//
//  Created by Sean Yue on 16/7/1.
//
//

#import <UIKit/UIKit.h>

@interface QBSHomeActivityItem : NSObject

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) CGFloat price;
@property (nonatomic) CGFloat originalPrice;
@property (nonatomic) NSURL *tagURL;

+ (instancetype)itemWithImageURL:(NSURL *)imageURL price:(CGFloat)price originalPrice:(CGFloat)originalPrice tagURL:(NSURL *)tagURL;

@end

@interface QBSHomeActivityRowCell : UICollectionViewCell

@property (nonatomic,retain) NSArray<QBSHomeActivityItem *> *items;
@property (nonatomic,copy) QBSSelectionAction selectionAction;

@end
