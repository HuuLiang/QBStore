//
//  QBSCollectionViewCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/17.
//
//

#import "QBSCollectionViewCell.h"

@implementation QBSCollectionViewCell
@synthesize textLabel = _textLabel;

- (UILabel *)textLabel {
    if (_textLabel) {
        return _textLabel;
    }
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = kMediumFont;
    [self addSubview:_textLabel];
    {
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _textLabel;
}

@end
