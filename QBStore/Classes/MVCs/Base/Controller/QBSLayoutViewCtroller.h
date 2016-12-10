//
//  QBSLayoutViewCtroller.h
//  QBStore
//
//  Created by ylz on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSBaseViewController.h"

typedef void (^QBSLayoutTableViewAction)(NSIndexPath *indexPath, UITableViewCell *cell);

@interface QBSLayoutViewCtroller : QBSBaseViewController<UITableViewSeparatorDelegate,UITableViewDataSource>

@property (nonatomic,retain,readonly) UITableView *layoutTableView;
@property (nonatomic,copy) QBSLayoutTableViewAction layoutTableViewAction;

// Cell & Cell Height
- (void)setLayoutCell:(UITableViewCell *)cell
                inRow:(NSUInteger)row
           andSection:(NSUInteger)section;

- (void)setLayoutCell:(UITableViewCell *)cell
           cellHeight:(CGFloat)height
                inRow:(NSUInteger)row
           andSection:(NSUInteger)section;

- (void)removeAllLayoutCells;
- (void)removeCell:(UITableViewCell *)cell
             inRow:(NSUInteger)row
        andSection:(NSUInteger)section;

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary<NSIndexPath *, UITableViewCell *> *)allCells;

// Header height & title
- (void)setHeaderHeight:(CGFloat)height inSection:(NSUInteger)section;
- (void)setHeaderTitle:(NSString *)title height:(CGFloat)height inSection:(NSUInteger)section;



@end
