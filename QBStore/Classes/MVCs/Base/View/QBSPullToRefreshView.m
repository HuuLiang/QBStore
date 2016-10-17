//
//  QBSPullToRefreshView.m
//  Pods
//
//  Created by Sean Yue on 2016/10/13.
//
//

#import "QBSPullToRefreshView.h"

@implementation QBSPullToRefreshView

- (void)prepare {
    [super prepare];
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
}

- (void)setGifImage:(UIImage *)gifImage {
    _gifImage = gifImage;
    
    if (gifImage.images.count > 0) {
        [self setImages:gifImage.images duration:gifImage.duration forState:MJRefreshStateRefreshing];
        [self setImages:@[gifImage.images.firstObject] duration:gifImage.duration forState:MJRefreshStatePulling];
        [self setImages:gifImage.images duration:gifImage.duration forState:MJRefreshStateIdle];
    }
}

- (void)placeSubviews {
    [super placeSubviews];
    self.gifView.contentMode = UIViewContentModeScaleAspectFit;
}
//
//- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
//    [super scrollViewContentOffsetDidChange:change];
//    
//    if (self.state == MJRefreshStatePulling || self.state == MJRefreshStateIdle) {
//        const CGFloat percent = self.pullingPercent;
//        const CGSize imageSize = _gifImage.size;
//        
//        const CGSize imageViewSize = CGSizeMake(imageSize.width*percent, imageSize.height*percent);
//        self.gifView.bounds = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
//    }
//    
//    
//}

@end
