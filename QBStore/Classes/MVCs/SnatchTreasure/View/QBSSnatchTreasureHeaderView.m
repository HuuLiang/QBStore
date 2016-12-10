//
//  QBSSnatchTreasureHeaderView.m
//  QBStore
//
//  Created by Liang on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSSnatchTreasureHeaderView.h"

@interface QBSSnatchTreasureHeaderView ()
{
    UILabel *_titleLabel;
    
    UILabel *_timeLabel;
    UILabel *_dateLabel;
}
@end

@implementation QBSSnatchTreasureHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ff206f"];
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        [self addSubview:_timeLabel];
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:kWidth(26)];
        _dateLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        [self addSubview:_dateLabel];
        
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(kWidth(20));
                make.height.mas_equalTo(kWidth(32));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_titleLabel.mas_right).offset(kWidth(144));
                make.height.mas_equalTo(kWidth(28));
            }];
            
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_timeLabel.mas_right);
                make.height.mas_equalTo(kWidth(28));
            }];
        }
    }
    return self;
}

@end
