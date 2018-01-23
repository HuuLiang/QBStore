//
//  QBSCartCell.h
//  Pods
//
//  Created by Sean Yue on 16/7/22.
//
//

#import "QBSTableViewCell.h"

@interface QBSCartCell : QBSTableViewCell

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *title;
@property (nonatomic) NSUInteger amount;

@property (nonatomic,copy) QBSAction selectionChangedAction;
@property (nonatomic,copy) QBSAction amountChangedAction;
@property (nonatomic,copy) QBSAction deleteAction;

@property (nonatomic) BOOL itemSelected;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice;

@end
