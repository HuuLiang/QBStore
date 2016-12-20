//
//  QBSCouponPopView.m
//  QBStore
//
//  Created by ylz on 2016/12/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSCouponPopView.h"

@interface QBSCouponPopView ()
{
    UIImageView *_bacImageView;
    UIButton *_closeBtn;
    UIButton *_getTicketBtn;
    UILabel *_priceLabel;
}

@end

@implementation QBSCouponPopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _bacImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_pop_bacview"]];
        [self addSubview:_bacImageView];
        {
        [_bacImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).mas_offset(kWidth(-125));
            make.size.mas_equalTo(CGSizeMake(kWidth(560.), kWidth(780.)));
        }];
        }
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn setImage:[UIImage imageNamed:@"coupon_close_btn"] forState:UIControlStateNormal];
        [self addSubview:_closeBtn];
        {
            [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(_bacImageView.mas_top);
                make.right.mas_equalTo(self).mas_offset(kWidth(-110.));
                make.size.mas_equalTo(CGSizeMake(kWidth(40), kWidth(82.)));
            }];
        }
        @weakify(self);
        [_closeBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock(self.closeAction,self);
        } forControlEvents:UIControlEventTouchUpInside];
        
        _getTicketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getTicketBtn setBackgroundImage:[UIImage imageNamed:@"coupon_get_ticket_icon"] forState:UIControlStateNormal];
        [_getTicketBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        _getTicketBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(34.)];
        [_bacImageView addSubview:_getTicketBtn];
        {
        [_getTicketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bacImageView);
            make.bottom.mas_equalTo(_bacImageView).mas_offset(kWidth(-66));
            make.size.mas_equalTo(CGSizeMake(kWidth(308), kWidth(102)));
        }];
        }
        _bacImageView.userInteractionEnabled = YES;
        [_getTicketBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock(self.getTicketAction,self);
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:kWidth(100.)];
        _priceLabel.textColor = [UIColor blackColor];
        [_bacImageView addSubview:_priceLabel];
        {
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_getTicketBtn.mas_top).mas_offset(kWidth(-80));
            make.left.mas_equalTo(_bacImageView).mas_offset(kWidth(122));
            make.size.mas_equalTo(CGSizeMake(kWidth(175), kWidth(140)));
        }];
        
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        titleLabel.text = @"新人专享大礼包";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.numberOfLines = 2;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [_bacImageView addSubview:titleLabel];
        {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_priceLabel.mas_right).mas_offset(kWidth(10.));
            make.centerY.mas_equalTo(_priceLabel);
//            make.right.mas_equalTo(_bacImageView).mas_offset(kWidth(-124));
            make.width.mas_equalTo(kWidth(140));
        }];
        }
        
    }
    return self;
}


- (void)setPrice:(NSString *)price {
    _price = price;
    price = [NSString stringWithFormat:@"¥%@",price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
    [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kWidth(34.)]} range:NSMakeRange(0, 1)];
    _priceLabel.attributedText = str;
}


@end
