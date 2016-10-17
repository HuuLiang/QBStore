//
//  QBSGridSheet.h
//  Pods
//
//  Created by Sean Yue on 16/8/22.
//
//

#import <UIKit/UIKit.h>

@interface QBSGridSheetItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *iconImage;
@property (nonatomic,copy) QBSAction action;

+ (instancetype)itemWithTitle:(NSString *)title iconImage:(UIImage *)iconImage action:(QBSAction)action;

@end

@interface QBSGridSheet : UIView

@property (nonatomic,retain) NSArray<QBSGridSheetItem *> *items;

- (void)showInWindow;
- (void)dismiss;

@end
