//
//  QBSCommodityCommentCell.h
//  Pods
//
//  Created by Sean Yue on 16/7/18.
//
//

#import "QBSTableViewCell.h"

@interface QBSCommodityCommentCell : QBSTableViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSString *content;

@property (nonatomic,retain,readonly) UILabel *titleLabel;
@property (nonatomic,retain,readonly) UILabel *subtitleLabel;
@property (nonatomic,retain,readonly) UILabel *contentLabel;

+ (UIEdgeInsets)contentInsets;

@end
