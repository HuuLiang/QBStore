//
//  QBSOrderAddressCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/26.
//
//

#import "QBSOrderAddressCell.h"

@interface QBSOrderAddressCell ()
{
    UIImageView *_locImageView;
    UIImageView *_stripeImageView;
}
@property (nonatomic,retain) UILabel *placeholderLabel;
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *phoneLabel;
@property (nonatomic,retain) UILabel *addressLabel;
@end

@implementation QBSOrderAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _locImageView = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"location_icon"]];
        _locImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_locImageView];
        {
            [_locImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kLeftRightContentMarginSpacing);
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
        }
        
        _stripeImageView = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"address_stripe"]];
        [self addSubview:_stripeImageView];
        {
            [_stripeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.equalTo(_stripeImageView.mas_width).multipliedBy(_stripeImageView.image.size.height/_stripeImageView.image.size.width);
            }];
        }
    }
    return self;
}

- (UILabel *)placeholderLabel {
    if (_placeholderLabel) {
        return _placeholderLabel;
    }
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
    _placeholderLabel.font = kMediumFont;
    _placeholderLabel.hidden = YES;
    _placeholderLabel.text = _placeholder;
    [self.contentView addSubview:_placeholderLabel];
    {
        [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
    
    [self updateVisibilitiesOfLabels];
}

- (UILabel *)nameLabel {
    if (_nameLabel) {
        return _nameLabel;
    }
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _nameLabel.font = kMediumFont;
    _nameLabel.text = _name;
    [self.contentView addSubview:_nameLabel];
    {
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_locImageView.mas_right).offset(kMediumHorizontalSpacing);
            make.right.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView).offset(kTopBottomContentMarginSpacing);
            make.height.mas_equalTo(_nameLabel.font.pointSize);
        }];
    }
    return _nameLabel;
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
    
    [self updateVisibilitiesOfLabels];
}

- (UILabel *)phoneLabel {
    if (_phoneLabel) {
        return _phoneLabel;
    }
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _phoneLabel.font = kMediumFont;
    _phoneLabel.text = _phone;
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_phoneLabel];
    {
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(kSmallHorizontalSpacing);
            make.right.equalTo(self.contentView).offset(-kLeftRightContentMarginSpacing);
            make.top.equalTo(self.nameLabel);
        }];
    }
    return _phoneLabel;
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    _phoneLabel.text = phone;
    
    [self updateVisibilitiesOfLabels];
}

- (UILabel *)addressLabel {
    if (_addressLabel) {
        return _addressLabel;
    }
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _addressLabel.font = kSmallFont;
    _addressLabel.text = _address;
    _addressLabel.numberOfLines = 3;
    [self.contentView addSubview:_addressLabel];
    {
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.phoneLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(kSmallVerticalSpacing);
            make.bottom.equalTo(_stripeImageView.mas_top).offset(-kSmallVerticalSpacing);
        }];
    }
    return _addressLabel;
}

- (void)setAddress:(NSString *)address {
    _address = address;
    _addressLabel.text = address;
    
    [self updateVisibilitiesOfLabels];
}

- (void)updateVisibilitiesOfLabels {
    if (_name || _phone || _address) {
        _placeholderLabel.hidden = YES;
        self.nameLabel.hidden = NO;
        self.phoneLabel.hidden = NO;
        self.addressLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = NO;
        _nameLabel.hidden = YES;
        _phoneLabel.hidden = YES;
        _addressLabel.hidden = YES;
    }
}
@end
