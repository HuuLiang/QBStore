//
//  QBSHomeCommodityCell.h
//  QBStore
//
//  Created by Sean Yue on 2016/10/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QBSHomeCommodityCellStyle) {
    QBSHomeCommodityCellNormalStyle,
    QBSHomeCommodityCellActivityStyle
};

@interface QBSHomeCommodityCell : UICollectionViewCell

@property (nonatomic) NSURL *thumbImageURL;
@property (nonatomic) NSString *title;
@property (nonatomic,retain) NSArray<NSString *> *tags;
@property (nonatomic) NSString *details;
@property (nonatomic) NSUInteger sold;

@property (nonatomic) QBSHomeCommodityCellStyle style;
@property (nonatomic,copy) QBSAction buyAction;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice;
- (void)setCountDownTime:(NSTimeInterval)countDownTime withFinishedBlock:(QBSAction)finishedBlock;

@end
