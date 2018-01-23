//
//  QBSTableViewCell.h
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import <UIKit/UIKit.h>

@interface QBSTableViewCell : UITableViewCell

@property (nonatomic) BOOL showSeparator;
@property (nonatomic) UIEdgeInsets separatorInsets;
@property (nonatomic) UIColor *separatorColor UI_APPEARANCE_SELECTOR;

@end
