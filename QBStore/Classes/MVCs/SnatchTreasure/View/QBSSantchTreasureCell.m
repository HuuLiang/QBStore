//
//  QBSSantchTreasureCell.m
//  QBStore
//
//  Created by Liang on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSSantchTreasureCell.h"

@interface QBSSantchTreasureCell ()
{
    UIImageView *_commodityImgV;
    UIImageView *_brandImgV;
    
    UILabel *_titleLabel;
    UILabel *_priceDescLabel;
    UILabel *_currentPriceLabel;
    UILabel *_originalPriceLabel;
    
    UILabel *_joinLabel;
    UIButton *_joinButton;
}
@end

@implementation QBSSantchTreasureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blueColor];
        
        _commodityImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_commodityImgV];
        
        _brandImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_brandImgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        [self.contentView addSubview:_titleLabel];
        
        _priceDescLabel = [[UILabel alloc] init];
        _priceDescLabel.text = @"快抢价";
        _priceDescLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        _priceDescLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        [self.contentView addSubview:_priceDescLabel];
        
        _currentPriceLabel = [[UILabel alloc] init];
        _currentPriceLabel.textColor = [UIColor colorWithHexString:@"#ff206f"];
        _currentPriceLabel.font = [UIFont systemFontOfSize:kWidth(40)];
        [self.contentView addSubview:_currentPriceLabel];
        
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _originalPriceLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self.contentView addSubview:_originalPriceLabel];
        
        _joinLabel = [[UILabel alloc] init];
        _joinLabel.textColor = [UIColor colorWithHexString:@"#555555"];;
        _joinLabel.font = [UIFont systemFontOfSize:kWidth(28)];
        [self.contentView addSubview:_joinLabel];
        
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinButton setTitle:@"立即申请" forState:UIControlStateNormal];
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _joinButton.layer.cornerRadius = kWidth(10);
        _joinButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_joinButton];
        
        {
            [_commodityImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.left.equalTo(self.contentView).offset(kWidth(20));
                make.size.mas_equalTo(CGSizeMake(kWidth(260), kWidth(260)));
            }];
            
            [_brandImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_commodityImgV.mas_left).offset(kWidth(2));
                make.top.equalTo(_commodityImgV.mas_top).offset(kWidth(2));
                make.size.mas_equalTo(CGSizeMake(kWidth(78), kWidth(78)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(kWidth(20));
                make.left.equalTo(_commodityImgV.mas_right).offset(kWidth(20));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(20));
                make.height.mas_equalTo(kWidth(32));
            }];
            
            [_priceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_bottom).offset(kWidth(48));
                make.left.equalTo(_commodityImgV.mas_right).offset(kWidth(20));
                make.height.mas_equalTo(kWidth(28));
            }];
            
            [_currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_priceDescLabel.mas_right).offset(kWidth(10));
                make.bottom.equalTo(_priceDescLabel.mas_bottom);
                make.height.mas_equalTo(kWidth(40));
            }];
            
            [_originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_currentPriceLabel.mas_right).offset(kWidth(12));
                make.bottom.equalTo(_currentPriceLabel.mas_bottom);
                make.height.mas_equalTo(kWidth(28));
            }];
            
            [_joinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_commodityImgV.mas_right).offset(kWidth(20));
                make.top.equalTo(_priceDescLabel.mas_bottom).offset(kWidth(32));
                make.height.mas_equalTo(kWidth(28));
            }];
            
            [_joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_commodityImgV.mas_right).offset(kWidth(20));
                make.bottom.equalTo(_commodityImgV.mas_bottom);
                make.top.equalTo(_joinLabel.mas_bottom).offset(kWidth(24));
                make.right.equalTo(self.contentView.mas_right).offset(-kWidth(62));
            }];
        }
    }
    return self;
}

- (void)setCommodityUrl:(NSString *)commodityUrl {
    [_commodityImgV sd_setImageWithURL:[NSURL URLWithString:commodityUrl]];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setCurrentPrice:(NSString *)currentPrice {
    _currentPriceLabel.text = [NSString stringWithFormat:@"¥%@.00元",currentPrice];
}

- (void)setOriginalPrice:(NSString *)originalPrice {
    _originalPriceLabel.text = [NSString stringWithFormat:@"¥%@元",originalPrice];
}

- (void)setJoinCount:(NSString *)joinCount {
    _joinLabel.text = [NSString stringWithFormat:@"%@人参与",joinCount];
}


@end
