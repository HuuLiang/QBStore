//
//  QBSMineCell.m
//  QBStore
//
//  Created by Sean Yue on 2016/10/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSMineCell.h"

@implementation QBSMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:16.];
        self.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//        self.separatorInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    self.imageView.image = iconImage;
}

@end
