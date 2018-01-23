//
//  QBSPhoneTextField.m
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import "QBSPhoneTextField.h"

@implementation QBSPhoneTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textColor = [UIColor whiteColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入手机号"
                                                                                attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
        self.keyboardType = UIKeyboardTypePhonePad;
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.tintColor = [UIColor whiteColor];
        self.leftView = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"login_phone"]];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect textRect = [super textRectForBounds:bounds];
    return CGRectOffset(textRect, 20, 0);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end
