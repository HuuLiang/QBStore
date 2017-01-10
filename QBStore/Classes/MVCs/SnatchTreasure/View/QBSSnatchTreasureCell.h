//
//  QBSSnatchTreasureCell.h
//  QBStore
//
//  Created by Sean Yue on 2016/12/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSSnatchTreasureCell : UITableViewCell

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSString *title;
@property (nonatomic) NSUInteger popularity;

@property (nonatomic) UIColor *buttonBackgroundColor;
@property (nonatomic) NSString *buttonTitle;
@property (nonatomic) BOOL buttonEnabled;
//@property (nonatomic,copy) QBSAction buttonAction;

- (void)setPrice:(CGFloat)price withOriginalPrice:(CGFloat)originalPrice;

@end
