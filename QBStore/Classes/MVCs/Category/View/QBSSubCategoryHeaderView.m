//
//  QBSSubCategoryHeaderView.m
//  Pods
//
//  Created by Sean Yue on 16/7/18.
//
//

#import "QBSSubCategoryHeaderView.h"

@interface QBSSubCategoryHeaderView ()
@property (nonatomic,retain) UIImageView *imageView;
@end

@implementation QBSSubCategoryHeaderView

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self insertSubview:_imageView atIndex:0];
    {
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets([[[self class] appearance] contentInsets]);
        }];
    }
    return _imageView;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    
    [self.imageView sd_setImageWithURL:imageURL];
}

+ (CGFloat)viewHeightRelativeToViewWidth:(CGFloat)width {
    const UIEdgeInsets contentInsets = [[[self class] appearance] contentInsets];
    const CGFloat imageWidth = width - contentInsets.left - contentInsets.right;
    
    const CGFloat imageScale = [[[self class] appearance] imageScale];
    const CGFloat imageHeight = imageScale == 0 ? imageWidth : imageWidth / imageScale;
    return imageHeight + contentInsets.top + contentInsets.bottom;
}
@end
