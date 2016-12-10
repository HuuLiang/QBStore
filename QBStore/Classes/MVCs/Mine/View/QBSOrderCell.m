//
//  QBSOrderCell.m
//  QBStore
//
//  Created by ylz on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSOrderCell.h"

@interface QBSOrderCell ()
{
    UILabel *_titleLable;
    UILabel *_subTitleLabel;
}

@end

@implementation QBSOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor colorWithHexString:@"#222222"];
        _titleLable.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLable];
        {
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).mas_offset(11);
            make.size.mas_equalTo(CGSizeMake(70, 22));
        }];
        }
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"#555555"];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_subTitleLabel];
        {
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_titleLable);
            make.right.mas_equalTo(self).mas_offset(-30);
            make.size.mas_equalTo(CGSizeMake(60, 18));
        }];
        }
        
    }
    return self;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLable.text = title;

}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _subTitleLabel.text = subTitle;
}


@end
