//
//  QBSActivityHeaderView.m
//  Pods
//
//  Created by Sean Yue on 16/6/27.
//
//

#import "QBSActivityHeaderView.h"
#import "MZTimerLabel.h"

@interface QBSActivityHeaderView ()
{
    UIImageView *_titleImageView;
    UILabel *_titleLabel;
    MZTimerLabel *_clockLabel;
    UILabel *_subtitleLabel;
    UIImageView *_accessoryImageView;
}
@end

@implementation QBSActivityHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleImageView = [[UIImageView alloc] initWithImage:[[UIImage QBS_imageWithResourcePath:@"sale_activity_text"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        _titleImageView.tintColor = [UIColor colorWithHexString:@"#FF206F"];
        [self addSubview:_titleImageView];
        {
            [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.centerY.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.4);
                make.width.equalTo(_titleImageView.mas_height).multipliedBy(_titleImageView.image.size.width/_titleImageView.image.size.height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kSmallFont;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.text = @"距本场结束";
        CGSize titleSize = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleImageView.mas_right).offset(5);
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(titleSize.width+2, titleSize.height));
            }];
        }
        
        _accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"accessory"]];
        [self addSubview:_accessoryImageView];
        {
            [_accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-10);
                make.centerY.equalTo(self);
                make.size.mas_equalTo(_accessoryImageView.image.size);
//                make.height.equalTo(self).multipliedBy(0.5);
//                make.width.equalTo(_accessoryImageView.mas_height).multipliedBy(_accessoryImageView.image.size.width/_accessoryImageView.image.size.height);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.text = @"更多";
        _subtitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _subtitleLabel.font = kExtraSmallFont;
        CGSize subtitleSize = [_subtitleLabel.text sizeWithAttributes:@{NSFontAttributeName:_subtitleLabel.font}];
        [self addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_accessoryImageView.mas_left).offset(-5);
                make.centerY.equalTo(self);
                make.size.mas_equalTo(subtitleSize);
            }];
        }
        
        _clockLabel = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeTimer];
        _clockLabel.shouldCountBeyondHHLimit = YES;
        [self addSubview:_clockLabel];
        {
            [_clockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel.mas_right).offset(5);
                make.right.equalTo(_subtitleLabel.mas_left).offset(-5);
                make.centerY.equalTo(self);
            }];
        }
        
        
    }
    return self;
}

- (void)setCountDownTime:(NSTimeInterval)countDownTime withFinishedBlock:(QBSAction)finishedBlock {
    if (_clockLabel.counting) {
        return ;
    }
    
    @weakify(self);
    [_clockLabel setCountDownTime:countDownTime];
    [_clockLabel startWithEndingBlock:^(NSTimeInterval countTime) {
        @strongify(self);
        SafelyCallBlock(finishedBlock, self);
    }];
}

- (NSTimeInterval)remainTime {
    return [_clockLabel getTimeRemaining];
}
@end
