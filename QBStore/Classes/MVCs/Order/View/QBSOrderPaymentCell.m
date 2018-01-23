//
//  QBSOrderPaymentCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/29.
//
//

#import "QBSOrderPaymentCell.h"

@interface QBSOrderPaymentCell ()
{
    UIImageView *_selectionImageView;
}
@end

@implementation QBSOrderPaymentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = kMediumFont;
        
        _selectionImageView = [[UIImageView alloc] initWithImage:[UIImage QBS_imageWithResourcePath:@"unselected_icon"]];
        _selectionImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_selectionImageView];
        {
            [_selectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.bottom.equalTo(self.contentView);
                make.width.mas_equalTo(50);
            }];
        }
    }
    return self;
}

- (void)setCurrentIsSelected:(BOOL)currentIsSelected {
    _currentIsSelected = currentIsSelected;
    
    if (currentIsSelected) {
        _selectionImageView.image = [UIImage QBS_imageWithResourcePath:@"selected_icon"];
    } else {
        _selectionImageView.image = self.shouldHideUnselectedIcon ? nil : [UIImage QBS_imageWithResourcePath:@"unselected_icon"] ;
    }
}

- (void)setShouldHideUnselectedIcon:(BOOL)shouldHideUnselectedIcon {
    _shouldHideUnselectedIcon = shouldHideUnselectedIcon;
    
    if (!self.currentIsSelected) {
        _selectionImageView.image = self.shouldHideUnselectedIcon ? nil : [UIImage QBS_imageWithResourcePath:@"unselected_icon"];
    }
}

@end
