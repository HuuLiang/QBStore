//
//  QBSCommodityDetailActivityCell.h
//  QBStore
//
//  Created by Sean Yue on 2016/11/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSCommodityDetailActivityCell : UICollectionViewCell

@property (nonatomic) CGFloat currentPrice;
@property (nonatomic) CGFloat originalPrice;
@property (nonatomic) NSUInteger sold;

- (void)setCountDownTime:(NSTimeInterval)countDownTime withFinishedBlock:(QBSAction)finishedBlock;

@end
