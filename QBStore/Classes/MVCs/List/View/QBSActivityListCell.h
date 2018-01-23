//
//  QBSActivityListCell.h
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import "QBSTableViewCell.h"

@interface QBSActivityListCell : QBSTableViewCell

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *title;
@property (nonatomic) CGFloat originalPrice;
@property (nonatomic) CGFloat currentPrice;
@property (nonatomic) NSUInteger soldPercent;
@property (nonatomic) NSURL *tagURL;

@property (nonatomic,copy) QBSAction buyAction;

@end
