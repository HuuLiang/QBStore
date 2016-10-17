//
//  QBSNewShippingAddressCell.m
//  Pods
//
//  Created by Sean Yue on 16/8/1.
//
//

#import "QBSNewShippingAddressCell.h"

@interface QBSNewShippingAddressCell () <UITextFieldDelegate>
{
    UILabel *_titleLabel;
}
@end

@implementation QBSNewShippingAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _canEdit = YES;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLabel.font = kMediumFont;
        [self.contentView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(kLeftRightContentMarginSpacing);
                make.centerY.equalTo(self.contentView);
                make.width.mas_equalTo(70);
            }];
        }
        
        _subtitleTextField = [[UITextField alloc] init];
        _subtitleTextField.font = _titleLabel.font;
        _subtitleTextField.textColor = _titleLabel.textColor;
        _subtitleTextField.delegate = self;
        _subtitleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_subtitleTextField];
        {
            [_subtitleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel.mas_right).offset(kLeftRightContentMarginSpacing);
                make.right.equalTo(self.contentView).offset(-kLeftRightContentMarginSpacing);
                make.centerY.equalTo(self.contentView);
            }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitleTextField.text = subtitle;
}

- (NSString *)subtitle {
    return _subtitleTextField.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _subtitleTextField.placeholder = placeholder;
}

- (NSString *)placeholder {
    return _subtitleTextField.placeholder;
}

- (void)beginEditing {
    if (self.canEdit) {
        [_subtitleTextField becomeFirstResponder];
    } else {
        SafelyCallBlock(self.beginEditingAction, self);
    }
    
}

- (void)endEditing {
    if (self.canEdit) {
        [_subtitleTextField resignFirstResponder];
    } else {
        SafelyCallBlock(self.endEditingAtion, self);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    SafelyCallBlock(self.beginEditingAction, self);
    return self.canEdit;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    SafelyCallBlock(self.endEditingAtion, self);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    SafelyCallBlock(self.returnAction, self);
    return YES;
}
@end
