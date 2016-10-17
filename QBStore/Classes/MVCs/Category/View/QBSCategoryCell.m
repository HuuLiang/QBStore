//
//  QBSCategoryCell.m
//  Pods
//
//  Created by Sean Yue on 16/7/6.
//
//

#import "QBSCategoryCell.h"

@implementation QBSCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = kMediumFont;
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.textLabel.textColor = [UIColor colorWithHexString:@"#FF206F"];
    } else {
        self.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
}
@end
