//
//  QBSOrderManifestCell.h
//  Pods
//
//  Created by Sean Yue on 16/8/3.
//
//

#import "QBSTableViewCell.h"

@interface QBSOrderManifestCell : QBSTableViewCell

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *title;
@property (nonatomic) NSUInteger amount;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice;

@end
