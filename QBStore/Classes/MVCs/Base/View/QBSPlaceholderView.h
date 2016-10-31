//
//  QBSPlaceholderView.h
//  QBStore
//
//  Created by Sean Yue on 2016/10/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSPlaceholderView : UIView

@property (nonatomic,retain) UIImage *image;
@property (nonatomic) NSString *title;

@property (nonatomic,retain,readonly) UIButton *actionButton;
@property (nonatomic,copy) QBSAction action;

+ (instancetype)showPlaceholderForView:(UIView *)view
                             withImage:(UIImage *)image
                                 title:(NSString *)title
                           buttonTitle:(NSString *)buttonTitle
                          buttonAction:(QBSAction)buttonAction;
+ (instancetype)placeholderForView:(UIView *)view;

- (void)showPlaceholderForView:(UIView *)view;
- (void)hide;

@end
