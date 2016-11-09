//
//  QBSTicketCard.h
//  QBStore
//
//  Created by Sean Yue on 2016/11/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBSTicketCard : UIView

@property (nonatomic,readonly) BOOL isFrontSide;

@property (nonatomic) NSURL *backgroundImageURL;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSString *header;
@property (nonatomic) NSString *footer;

+ (instancetype)frontSidedCard;
+ (instancetype)backSidedCard;
- (instancetype)init __attribute__((unavailable("Use +frontSidedCard or +backSidedCard instead!")));

@end
