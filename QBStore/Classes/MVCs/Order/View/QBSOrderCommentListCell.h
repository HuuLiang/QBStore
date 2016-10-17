//
//  QBSOrderCommentListCell.h
//  Pods
//
//  Created by Sean Yue on 16/8/29.
//
//

#import "QBSTableViewCell.h"

@interface QBSOrderCommentListCell : QBSTableViewCell

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *title;
@property (nonatomic) QBSAction starAction;
@property (nonatomic) QBSAction commentAction;
@property (nonatomic) NSUInteger stars;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice;

@end
