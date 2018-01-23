//
//  QBSAmountPicker.m
//  Pods
//
//  Created by Sean Yue on 16/7/22.
//
//

#import "QBSAmountPicker.h"

@interface QBSAmountPicker ()
{
    UIButton *_minusButton;
    UIButton *_plusButton;
    UILabel *_amountLabel;
}
@end

@implementation QBSAmountPicker

- (instancetype)init {
    self = [super init];
    if (self) {
        _minAmount = 1;
        _amount = _minAmount;
        
        _minusButton = [[UIButton alloc] init];
        _minusButton.enabled = NO;
        _minusButton.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _minusButton.layer.borderWidth = 1;
        _minusButton.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        [_minusButton setImage:[[UIImage QBS_imageWithResourcePath:@"cart_item_amount_minus"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _minusButton.tintColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:_minusButton];
        {
            [_minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.top.equalTo(self);
                make.width.equalTo(_minusButton.mas_height);
            }];
        }
        
        _plusButton = [[UIButton alloc] init];
        _plusButton.layer.borderWidth = _minusButton.layer.borderWidth;
        _plusButton.layer.borderColor = _minusButton.layer.borderColor;
        [_plusButton setImage:[[UIImage QBS_imageWithResourcePath:@"cart_item_amount_plus"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _plusButton.tintColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:_plusButton];
        {
            [_plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(self);
                make.width.equalTo(_plusButton.mas_height);
            }];
        }

        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [UIColor redColor];
        _amountLabel.font = kSmallFont;
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.text = @(_minAmount).stringValue;
        _amountLabel.layer.borderColor = _minusButton.layer.borderColor;
        _amountLabel.layer.borderWidth = _minusButton.layer.borderWidth;
        [self addSubview:_amountLabel];
        {
            [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_minusButton.mas_right).offset(-_amountLabel.layer.borderWidth);
                make.right.equalTo(_plusButton.mas_left).offset(_amountLabel.layer.borderWidth);
                make.top.bottom.equalTo(_minusButton);
            }];
        }
        
        @weakify(self);
        [_minusButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.amount > self.minAmount) {
                self.amount = self.amount - 1;
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_plusButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            self.amount = self.amount + 1;
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setAmount:(NSUInteger)amount {
    if (_amount == amount) {
        return ;
    }
    
    _amount = amount;
    _amountLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)amount];
    
    if (amount <= self.minAmount) {
        _minusButton.enabled = NO;
    } else {
        _minusButton.enabled = YES;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
@end
