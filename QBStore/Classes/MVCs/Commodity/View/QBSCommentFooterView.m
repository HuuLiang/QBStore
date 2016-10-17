//
//  QBSCommentFooterView.m
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import "QBSCommentFooterView.h"

@interface QBSCommentFooterView ()
@property (nonatomic,retain,readonly) UILabel *textLabel;
@end

@implementation QBSCommentFooterView
@synthesize textLabel = _textLabel;

- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self);
        [self bk_whenTapped:^{
            @strongify(self);
            if (self.state != QBSCommentFooterStateLoadedAll) {
                self.state = QBSCommentFooterStateLoading;
            }
        }];
    }
    return self;
}

- (UILabel *)textLabel {
    if (_textLabel) {
        return _textLabel;
    }
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = kSmallFont;
    _textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:_textLabel];
    {
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _textLabel;
}

- (void)setState:(QBSCommentFooterState)state {
    if (_state == state) {
        return ;
    }
    
    _state = state;

    if (state == QBSCommentFooterStateLoadMore) {
        self.textLabel.text = @"点击加载更多";
    } else if (state == QBSCommentFooterStateLoadedAll) {
        self.textLabel.text = @"已经全部加载完毕";
    } else if (state == QBSCommentFooterStateLoadFails) {
        self.textLabel.text = @"加载失败，点击重新加载";
    } else {
        _textLabel.text = nil;
    }
    
    if (state == QBSCommentFooterStateLoading) {
        [self beginLoading];
        [self bk_performBlock:self.loadAction afterDelay:0.5];
    } else {
        [self endLoading];
    }
    
}
@end
