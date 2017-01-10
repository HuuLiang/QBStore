//
//  QBSSnatchCell.m
//  QBStore
//
//  Created by ylz on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSSnatchCell.h"

@interface QBSSnatchCell ()
{
    UIButton *_snatchButton;
    UIButton *_couponButton;
}

@end

@implementation QBSSnatchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _snatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _snatchButton.imageEdgeInsets = UIEdgeInsetsMake(-2, -7, 0, 0);
        _snatchButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_snatchButton setTitle:@"我的夺宝" forState:UIControlStateNormal];
        [_snatchButton setImage:[UIImage imageNamed:@"mine_snatch_icon"] forState:UIControlStateNormal];
        [_snatchButton setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [_snatchButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.5 alpha:0.5]] forState:UIControlStateHighlighted];
        [self addSubview:_snatchButton];
        {
        [_snatchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.centerX.mas_equalTo(self).mas_offset(-kScreenWidth/4-0.5);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth-1)/2, CGRectGetHeight(self.bounds)));
        }];
        }
        @weakify(self);
        [_snatchButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock(self.snatchAction,self);
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
        [self addSubview:lineView];
        {
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.size.mas_equalTo(CGSizeMake(1, 20));
            }];
        }
        
        _couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _couponButton.imageEdgeInsets = UIEdgeInsetsMake(-2, -7, 0, 0);
        _couponButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_couponButton setTitle:@"优惠券" forState:UIControlStateNormal];
        [_couponButton setImage:[UIImage imageNamed:@"mine_ coupon_icon"] forState:UIControlStateNormal];
        [_couponButton setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [_couponButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.5 alpha:0.5]] forState:UIControlStateHighlighted];
        [self addSubview:_couponButton];
        {
        [_couponButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.centerX.mas_equalTo(self).mas_offset(kScreenWidth/4+0.5);
            make.size.mas_equalTo(CGSizeMake((kScreenWidth-1)/2, CGRectGetHeight(self.bounds)));
        }];
        }
        
        [_couponButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock(self.couponAction,self);
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
