//
//  QBSCouponCell.m
//  QBStore
//
//  Created by ylz on 2016/12/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSCouponCell.h"

typedef NS_ENUM(NSUInteger, QBSCouponStatus) {
    QBSCouponStatusUsable,//可用
    QBSCouponStatusAlreadyUsed,//已经使用
    QBSCouponStatusPastDue//过期
};

@interface QBSCouponCell ()

{
    UIImageView *_bottomImageView;//底图
    UIImageView *_statusImageView;//使用状态
    UILabel *_titleLable;
    UILabel *_subTitleLabel;
    UILabel *_useDeadlineLabel;//使用期限
    UILabel *_priceLabel;
    UILabel *_satisfyPriceLabel;//满减价格

}

@end

@implementation QBSCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        _bottomImageView = [[UIImageView alloc] init];
//        _bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bottomImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomImageView];
        {
        [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(11.);
            make.right.mas_equalTo(self).mas_offset(-9.);
//            make.height.mas_equalTo(90.);
            make.top.mas_equalTo(self).mas_offset(30);
            make.bottom.mas_equalTo(self).mas_offset(-8);
        }];
        }
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _priceLabel.font = [UIFont systemFontOfSize:32.];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomImageView addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_bottomImageView).mas_offset(17.);
                make.right.mas_equalTo(_bottomImageView).mas_offset(-13);
            }];
        }
        
        _satisfyPriceLabel = [[UILabel alloc] init];
        _satisfyPriceLabel.font = [UIFont systemFontOfSize:13.];
        _satisfyPriceLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _satisfyPriceLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomImageView addSubview:_satisfyPriceLabel];
        {
        [_satisfyPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_priceLabel.mas_bottom).mas_offset(3.);
            make.right.mas_equalTo(_bottomImageView).mas_offset(-13.);;
        }];
        }
        
        
        _statusImageView = [[UIImageView alloc] init];
//        _statusImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bottomImageView addSubview:_statusImageView];
        {
        [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bottomImageView).mas_offset(6.);
//            make.top.mas_equalTo(_bottomImageView).mas_offset(23);
            make.right.mas_equalTo(_bottomImageView).mas_offset(-28);
            make.size.mas_equalTo(CGSizeMake(70., 56.));
        }];
        
        }
        
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor colorWithHexString:@"#222222"];
        _titleLable.font = [UIFont systemFontOfSize:18];
        [_bottomImageView addSubview:_titleLable];
        {
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bottomImageView).mas_offset(14.);
            make.top.mas_equalTo(_bottomImageView).mas_offset(12);
        }];
        }
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        [_bottomImageView addSubview:_subTitleLabel];
        {
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLable);
            make.top.mas_equalTo(_titleLable.mas_bottom).mas_offset(8);
        }];
        }
        
        _useDeadlineLabel = [[UILabel alloc] init];
        _useDeadlineLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _useDeadlineLabel.font = [UIFont systemFontOfSize:12.];
        [_bottomImageView addSubview:_useDeadlineLabel];
        {
        [_useDeadlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLable);
            make.top.mas_equalTo(_subTitleLabel.mas_bottom).mas_offset(4);
        }];
        }
        
    }
    return self;
}

- (void)setCouponStatus:(NSInteger)couponStatus {
    _couponStatus = couponStatus;
    switch (couponStatus) {
        case QBSCouponStatusUsable:

            [_statusImageView removeFromSuperview];
            break;
        case QBSCouponStatusAlreadyUsed:
                 _statusImageView.image = [UIImage imageNamed:@"coupon_already_used"];
            break;
        case QBSCouponStatusPastDue:
            
            _statusImageView.image = [UIImage imageNamed:@"coupon_past_due"];
            break;
            
        default:
            break;
    }

}

- (void)setBottomImageType:(NSInteger)bottomImageType {
    _bottomImageType = bottomImageType;
    if (bottomImageType == QBSCouponStatusUsable) {
        _bottomImageView.image = [UIImage imageNamed:@"coupon_usable"];
    }else {
        _bottomImageView.image = [UIImage imageNamed:@"coupon_unusable"];
    }

}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLable.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _subTitleLabel.text = subTitle;
    
}

- (void)setUseDeadline:(NSString *)useDeadline {
    _useDeadline = useDeadline;
    _useDeadlineLabel.text = [NSString stringWithFormat:@"使用期限%@",useDeadline];

}

- (void)setCouponPrice:(NSString *)couponPrice {
    _couponPrice = couponPrice;
//    _priceLabel.text = couponPrice;
    couponPrice = [NSString stringWithFormat:@"¥%@",couponPrice];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:couponPrice];
    [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]} range:NSMakeRange(0, 1)];
    _priceLabel.attributedText = str;
}

- (void)setSatisfyPrice:(NSString *)satisfyPrice {
    _satisfyPrice = satisfyPrice;
    _satisfyPriceLabel.text = [NSString stringWithFormat:@"满%@可用",satisfyPrice];
}

@end
