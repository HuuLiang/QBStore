//
//  QBSActivityHeaderView.h
//  Pods
//
//  Created by Sean Yue on 16/6/27.
//
//

#import "QBSCollectionHeaderFooterView.h"

@interface QBSActivityHeaderView : QBSCollectionHeaderFooterView

- (void)setCountDownTime:(NSTimeInterval)countDownTime withFinishedBlock:(QBSAction)finishedBlock;
- (NSTimeInterval)remainTime;

@end
