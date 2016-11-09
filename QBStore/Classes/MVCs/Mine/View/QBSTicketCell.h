//
//  QBSTicketCell.h
//  QBStore
//
//  Created by Sean Yue on 2016/11/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSTicketCell : UITableViewCell

@property (nonatomic) BOOL isFront;

@property (nonatomic) NSURL *backgroundImageURL;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSString *header;
@property (nonatomic) NSString *footer;

@property (nonatomic,copy) QBSAction longPressAction;

- (void)switchCardSide:(BOOL)isFrontSide withBackgroundImageURL:(NSURL *)backgroundImageURL animated:(BOOL)animated;

@end
