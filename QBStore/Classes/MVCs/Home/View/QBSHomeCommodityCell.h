//
//  QBSHomeCommodityCell.h
//  QBStore
//
//  Created by Sean Yue on 2016/10/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSHomeCommodityCell : UICollectionViewCell

@property (nonatomic) NSURL *thumbImageURL;
@property (nonatomic) NSString *title;
@property (nonatomic,retain) NSArray<NSString *> *tags;
@property (nonatomic,retain) NSArray<NSString *> *details;
@property (nonatomic) NSUInteger sold;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice;
- (void)setCountDownTime:(NSTimeInterval)countDownTime withFinishedBlock:(QBSAction)finishedBlock;

@end
