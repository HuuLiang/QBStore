//
//  QBSProgressView.h
//  Pods
//
//  Created by Sean Yue on 16/7/20.
//
//

#import <UIKit/UIKit.h>

@interface QBSProgressView : UIView

@property (nonatomic) UIColor *progressTintColor;
@property (nonatomic) UIColor *trackTintColor;
@property (nonatomic) NSUInteger progress;  // 0~100

@end
