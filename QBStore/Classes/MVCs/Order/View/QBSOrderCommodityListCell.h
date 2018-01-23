//
//  QBSOrderCommodityListCell.h
//  Pods
//
//  Created by Sean Yue on 16/7/29.
//
//

#import "QBSTableViewCell.h"

@interface QBSOrderCommodityListCell : QBSTableViewCell

@property (nonatomic,retain) NSArray *imageURLStrings;
@property (nonatomic) NSUInteger amount;

@property (nonatomic,copy) QBSAction commodityAction;

@end
