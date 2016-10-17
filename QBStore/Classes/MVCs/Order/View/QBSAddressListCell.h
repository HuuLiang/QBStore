//
//  QBSAddressListCell.h
//  Pods
//
//  Created by Sean Yue on 16/8/2.
//
//

#import "QBSTableViewCell.h"

@interface QBSAddressListCell : QBSTableViewCell

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *address;
@property (nonatomic) BOOL isDefault;
@property (nonatomic) BOOL canEdit;

@property (nonatomic,copy) QBSAction deleteAction;
@property (nonatomic,copy) QBSAction editAction;
@property (nonatomic,copy) QBSAction setDefaultAction;

@end
