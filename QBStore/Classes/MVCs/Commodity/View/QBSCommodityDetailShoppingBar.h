//
//  QBSCommodityDetailShoppingBar.h
//  Pods
//
//  Created by Sean Yue on 16/7/22.
//
//

#import <UIKit/UIKit.h>

@interface QBSCommodityDetailShoppingBar : UIView

@property (nonatomic,copy) QBSAction cartAction;
@property (nonatomic,copy) QBSAction addToCartAction;
@property (nonatomic,copy) QBSAction buyAction;

@property (nonatomic) NSUInteger numberOfCommodities;
@property (nonatomic) NSUInteger cartDuration;

@property (nonatomic,retain,readonly) UIButton *cartButton;
@property (nonatomic,retain,readonly) UIButton *addToCartButton;
@property (nonatomic,retain,readonly) UIButton *buyButton;

@end
