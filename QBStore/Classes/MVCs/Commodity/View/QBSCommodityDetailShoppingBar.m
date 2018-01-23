//
//  QBSCommodityDetailShoppingBar.m
//  Pods
//
//  Created by Sean Yue on 16/7/22.
//
//

#import "QBSCommodityDetailShoppingBar.h"
#import "QBSCartButton.h"

@implementation QBSCommodityDetailShoppingBar

- (instancetype)init {
    self = [super init];
    if (self) {
        _cartButton = [[QBSCartButton alloc] init];
        _cartButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:_cartButton];
        {
            [_cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self);
                make.width.equalTo(self).multipliedBy(0.25);
            }];
        }
        
        _addToCartButton = [[UIButton alloc] init];
        _addToCartButton.titleLabel.font = kMediumFont;
        [_addToCartButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F7F7F7"]] forState:UIControlStateNormal];
        [_addToCartButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        [_addToCartButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#AAAAAA"]] forState:UIControlStateDisabled];
        [_addToCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addToCartButton setTitleColor:[UIColor colorWithHexString:@"#FF206F"] forState:UIControlStateNormal];
        [_addToCartButton setTitleColor:[UIColor colorWithHexString:@"#DDDDDD"] forState:UIControlStateDisabled];
        [self addSubview:_addToCartButton];
        {
            [_addToCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(_cartButton.mas_right);
                make.width.equalTo(self).multipliedBy(3./8.);
            }];
        }
        
        _buyButton = [[UIButton alloc] init];
        _buyButton.titleLabel.font = kMediumFont;
        [_buyButton setTitle:@"直接购买" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF206F"]] forState:UIControlStateNormal];
        [_buyButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#AAAAAA"]] forState:UIControlStateDisabled];
        [_buyButton setTitleColor:[UIColor colorWithHexString:@"#DDDDDD"] forState:UIControlStateDisabled];
        [self addSubview:_buyButton];
        {
            [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_addToCartButton.mas_right);
                make.top.bottom.right.equalTo(self);
            }];
        }
        
        AssociatedButtonWithActionByPassOriginalSender(_cartButton, cartAction);
        AssociatedButtonWithActionByPassOriginalSender(_addToCartButton, addToCartAction)
        AssociatedButtonWithActionByPassOriginalSender(_buyButton, buyAction)
    }
    return self;
}

- (void)setNumberOfCommodities:(NSUInteger)numberOfCommodities {
    _numberOfCommodities = numberOfCommodities;
    ((QBSCartButton *)_cartButton).numberOfCommodities = numberOfCommodities;
}
@end
