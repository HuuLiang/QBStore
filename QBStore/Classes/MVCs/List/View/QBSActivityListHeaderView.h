//
//  QBSActivityListHeaderView.h
//  Pods
//
//  Created by Sean Yue on 16/7/21.
//
//

#import <UIKit/UIKit.h>

@interface QBSActivityListHeaderView : UITableViewHeaderFooterView

@property (nonatomic) UIColor *countDownBackgroundColor;
@property (nonatomic) UIColor *nextTimeBackgroundColor;

- (void)setCountDownTime:(NSTimeInterval)countDownTime
           nextBeginTime:(NSString *)nextBeginTime
       withFinishedBlock:(QBSAction)finishedBlock;

@end
