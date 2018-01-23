//
//  QBSActivityListHeaderView.m
//  Pods
//
//  Created by Sean Yue on 16/7/21.
//
//

#import "QBSActivityListHeaderView.h"
#import "MZTimerLabel.h"

@interface QBSActivityListHeaderView ()
{
    UIImageView *_nextTimeBackgroundView;
    UILabel *_countDownTitleLabel;
    MZTimerLabel *_clockLabel;
    UILabel *_nextTimeLabel;
}
@end
@implementation QBSActivityListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        
        _nextTimeBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage QBS_imageWithResourcePath:@"ladder_shape"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self.backgroundView addSubview:_nextTimeBackgroundView];
        {
            [_nextTimeBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(self.backgroundView);
                make.width.equalTo(self.backgroundView).dividedBy(3);
            }];
        }
        
        _countDownTitleLabel = [[UILabel alloc] init];
        _countDownTitleLabel.textColor = [UIColor whiteColor];
        _countDownTitleLabel.font = kMediumFont;
        _countDownTitleLabel.text = @"距本场结束";
        [self addSubview:_countDownTitleLabel];
        {
            [_countDownTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(30);
                make.centerY.equalTo(self);
            }];
        }
        
        _clockLabel = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeTimer];
        _clockLabel.shouldCountBeyondHHLimit = YES;
        [self addSubview:_clockLabel];
        {
            [_clockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_countDownTitleLabel.mas_right).offset(kMediumHorizontalSpacing);
                
                make.centerY.equalTo(self);
            }];
        }
        
        _nextTimeLabel = [[UILabel alloc] init];
        _nextTimeLabel.numberOfLines = 2;
        _nextTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_nextTimeBackgroundView addSubview:_nextTimeLabel];
        {
            [_nextTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_nextTimeBackgroundView);
                make.centerX.equalTo(_nextTimeBackgroundView).multipliedBy(1.1);
            }];
        }
    }
    return self;
}

- (void)setCountDownBackgroundColor:(UIColor *)countDownBackgroundColor {
    _countDownBackgroundColor = countDownBackgroundColor;
    self.backgroundView.backgroundColor = countDownBackgroundColor;
}

- (void)setNextTimeBackgroundColor:(UIColor *)nextTimeBackgroundColor {
    _nextTimeBackgroundColor = nextTimeBackgroundColor;
    _nextTimeBackgroundView.tintColor = nextTimeBackgroundColor;
}

- (void)setCountDownTime:(NSTimeInterval)countDownTime
           nextBeginTime:(NSString *)nextBeginTime
       withFinishedBlock:(QBSAction)finishedBlock {
    if (_clockLabel.counting) {
        return ;
    }
    
    @weakify(self);
    [_clockLabel setCountDownTime:countDownTime];
    [_clockLabel startWithEndingBlock:^(NSTimeInterval countTime) {
        @strongify(self);
        SafelyCallBlock(finishedBlock, self);
    }];
    
    [self setNextBeginTime:nextBeginTime];
}

- (void)setNextBeginTime:(NSString *)nextBeginTime {
    NSDateFormatter *dateFormmatter = [[NSDateFormatter alloc] init];
    [dateFormmatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormmatter dateFromString:nextBeginTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    
    NSString *nextTimeString = [NSString stringWithFormat:@"下一场\n%@:%@", components ? @(components.hour).stringValue : @"??", components ? @(components.minute).stringValue : @"??"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:nextTimeString];
    
    NSUInteger lineLocation = [nextTimeString rangeOfString:@"\n"].location;
    [attrString addAttributes:@{NSFontAttributeName:kMediumFont,
                                NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, lineLocation)];
    [attrString addAttributes:@{NSFontAttributeName:kSmallFont,
                                NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(lineLocation, attrString.length-lineLocation)];
    _nextTimeLabel.attributedText = attrString;
    
}
@end
