//
//  QBSSortButton.h
//  Pods
//
//  Created by Sean Yue on 16/7/12.
//
//

#import <UIKit/UIKit.h>

@class QBSSortButton;

@protocol QBSSortButtonDelegate <NSObject>

@optional
- (void)sortButton:(QBSSortButton *)sortButton didChangeSortMode:(QBSSortMode)sortMode;

@end

@interface QBSSortButton : UIButton

@property (nonatomic,readonly) BOOL hasSortMode;
@property (nonatomic) QBSSortMode sortMode;
@property (nonatomic,weak) id<QBSSortButtonDelegate> delegate;

+ (instancetype)buttonWithTitle:(NSString *)title hasSortMode:(BOOL)hasSortMode delegate:(id<QBSSortButtonDelegate>)delegate;
- (instancetype)initWithTitle:(NSString *)title hasSortMode:(BOOL)hasSortMode delegate:(id<QBSSortButtonDelegate>)delegate;

@end
