//
//  QBSSubtitledTableViewCell.h
//  Pods
//
//  Created by Sean Yue on 16/8/22.
//
//

#import "QBSTableViewCell.h"

@interface QBSSubtitledTableViewCell : QBSTableViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;

@property (nonatomic) UIColor *titleColor;
@property (nonatomic) UIColor *subtitleColor;

#ifdef DEBUG_TOOL_ENABLED
@property (nonatomic,copy) QBSAction longPressAction;
#endif

@end
