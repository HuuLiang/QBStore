//
//  QBSSubtitledTableViewCell.m
//  Pods
//
//  Created by Sean Yue on 16/8/22.
//
//

#import "QBSSubtitledTableViewCell.h"

@interface QBSSubtitledTableViewCell ()
@property (nonatomic,readonly) UIColor *defaultTextColor;
@end

@implementation QBSSubtitledTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        _defaultTextColor = [UIColor colorWithHexString:@"#666666"];
        
        self.textLabel.textColor = _defaultTextColor;
        self.textLabel.font = kSmallFont;
        
        self.detailTextLabel.textColor = self.textLabel.textColor;
        self.detailTextLabel.font = self.textLabel.font;
        
#ifdef DEBUG_TOOL_ENABLED
        @weakify(self);
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if (state == UIGestureRecognizerStateBegan) {
                @strongify(self);
                SafelyCallBlock(self.longPressAction, self);
            }
        }]];
#endif
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    self.detailTextLabel.text = subtitle;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    if (!titleColor) {
        titleColor = _defaultTextColor;
    }
    self.textLabel.textColor = titleColor;
}

- (void)setSubtitleColor:(UIColor *)subtitleColor {
    _subtitleColor = subtitleColor;
    
    if (!subtitleColor) {
        subtitleColor = _defaultTextColor;
    }
    
    self.detailTextLabel.textColor = subtitleColor;
}
@end
