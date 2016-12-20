//
//  QBSOrderCell.m
//  QBStore
//
//  Created by ylz on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSOrderCell.h"

@implementation QBSOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.textLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        self.textLabel.font = kMediumFont;
        
        self.detailTextLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        self.detailTextLabel.font = kSmallFont;
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;

}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.detailTextLabel.text = subTitle;
}
@end
