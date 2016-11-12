//
//  QBSTicketsPromptionView.h
//  QBStore
//
//  Created by Sean Yue on 2016/11/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSTicketsPromptionView : UIView

+ (instancetype)showPromptionInView:(UIView *)view;
- (void)showInView:(UIView *)view;
- (void)hide;

@end
