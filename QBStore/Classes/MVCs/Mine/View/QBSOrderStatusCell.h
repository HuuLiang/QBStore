//
//  QBSOrderStatusCell.h
//  QBStore
//
//  Created by ylz on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QBSOrderStatusAction)(UIButton *btn);

@interface QBSorderStatusModel : NSObject
@property (nonatomic,copy)NSString *image;
@property (nonatomic,copy)NSString *title;
+ (instancetype)creatOrderStatusModelWithTitle:(NSString *)title image:(NSString *)image;

@end

@interface QBSOrderStatusCell : UITableViewCell

@property (nonatomic,retain) NSArray<QBSorderStatusModel *> *models;
@property (nonatomic,copy) QBSOrderStatusAction orderStatusAction;

@end
