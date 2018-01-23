//
//  QBSAddressListCell.m
//  Pods
//
//  Created by Sean Yue on 16/8/2.
//
//

#import "QBSAddressListCell.h"
#import "QBSDefaultAddressButton.h"

@interface QBSAddressListCell ()
{
    UILabel *_nameLabel;
    UILabel *_phoneLabel;
    UILabel *_addressLabel;
    
    QBSDefaultAddressButton *_defaultButton;
    UIButton *_editButton;
    UIButton *_deleteButton;
}
@end

@implementation QBSAddressListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _canEdit = YES;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLabel.font = kMediumFont;
        [self addSubview:_nameLabel];
        {
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kLeftRightContentMarginSpacing);
                make.top.equalTo(self).offset(kTopBottomContentMarginSpacing);
                make.right.equalTo(self.mas_centerX).offset(-kSmallHorizontalSpacing);
            }];
        }
        
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = _nameLabel.textColor;
        _phoneLabel.font = _nameLabel.font;
        _phoneLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_phoneLabel];
        {
            [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kLeftRightContentMarginSpacing);
                make.left.equalTo(_nameLabel.mas_right).offset(kSmallHorizontalSpacing);
                make.centerY.equalTo(_nameLabel);
            }];
        }
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _addressLabel.font = kSmallFont;
        _addressLabel.numberOfLines = 2;
        [self addSubview:_addressLabel];
        {
            [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameLabel);
                make.right.equalTo(_phoneLabel);
                make.top.equalTo(_nameLabel.mas_bottom).offset(kMediumVerticalSpacing);
            }];
        }
        
        _defaultButton = [[QBSDefaultAddressButton alloc] init];
        [self addSubview:_defaultButton];
        {
            [_defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameLabel);
                make.bottom.equalTo(self).offset(-kBigVerticalSpacing);
                make.height.equalTo(self).multipliedBy(0.2);
                make.width.equalTo(self).multipliedBy(0.5);
            }];
        }
        
        _deleteButton = [[UIButton alloc] init];
        _deleteButton.backgroundColor = [UIColor colorWithHexString:@"#FD472B"];
        _deleteButton.layer.cornerRadius = 3;
//        _deleteButton.layer.masksToBounds = YES;
//        _deleteButton.layer.borderWidth = 1;
//        _deleteButton.layer.borderColor = [UIColor colorWithHexString:@"#DCDCDC"].CGColor;
        _deleteButton.titleLabel.font = kSmallFont;
        //[_deleteButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
//        [_deleteButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FD472B"]] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        {
            [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_phoneLabel);
                make.top.equalTo(_defaultButton);
                make.bottom.equalTo(_defaultButton);
                make.width.mas_equalTo(50);
            }];
        }
        
        _editButton = [[UIButton alloc] init];
        _editButton.layer.cornerRadius = _deleteButton.layer.cornerRadius;
        _editButton.layer.borderWidth = 1;
        _editButton.layer.borderColor = [UIColor colorWithHexString:@"#DCDCDC"].CGColor;
        _editButton.titleLabel.font = _deleteButton.titleLabel.font;
        [_editButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self addSubview:_editButton];
        {
            [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_deleteButton.mas_left).offset(-kLeftRightContentMarginSpacing);
                make.size.centerY.equalTo(_deleteButton);
            }];
        }
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = [UIColor colorWithHexString:@"#E9E9E9"];
        [self addSubview:separatorView];
        {
            [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameLabel);
                make.right.equalTo(self);
                make.bottom.equalTo(_deleteButton.mas_top).offset(-kMediumVerticalSpacing);
                make.height.mas_equalTo(0.5);
            }];
        }
        
        AssociatedButtonWithAction(_defaultButton, setDefaultAction);
        AssociatedButtonWithAction(_deleteButton, deleteAction);
        AssociatedButtonWithAction(_editButton, editAction);
    }
    return self;
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    _phoneLabel.text = phone;
}

- (void)setAddress:(NSString *)address {
    _address = address;
    _addressLabel.text = address;
}

- (void)setIsDefault:(BOOL)isDefault {
    _isDefault = isDefault;
    _defaultButton.selected = isDefault;
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    
    _defaultButton.enabled = canEdit;

}
@end
