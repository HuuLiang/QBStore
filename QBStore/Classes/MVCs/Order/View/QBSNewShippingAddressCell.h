//
//  QBSNewShippingAddressCell.h
//  Pods
//
//  Created by Sean Yue on 16/8/1.
//
//

#import "QBSTableViewCell.h"

@interface QBSNewShippingAddressCell : QBSTableViewCell

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSString *placeholder;

@property (nonatomic) BOOL canEdit;
@property (nonatomic,copy) QBSAction beginEditingAction;
@property (nonatomic,copy) QBSAction endEditingAtion;
@property (nonatomic,copy) QBSAction returnAction;

@property (nonatomic,retain,readonly) UITextField *subtitleTextField;

- (void)beginEditing;
- (void)endEditing;

@end
