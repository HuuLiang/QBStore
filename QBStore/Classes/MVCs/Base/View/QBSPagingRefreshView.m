//
//  QBSPagingRefreshView.m
//  Pods
//
//  Created by Sean Yue on 2016/10/13.
//
//

#import "QBSPagingRefreshView.h"

@implementation QBSPagingRefreshView

- (void)prepare {
    [super prepare];
    self.automaticallyHidden = YES;
    self.refreshingTitleHidden = YES;
    
}

- (void)setGifImage:(UIImage *)gifImage {
    _gifImage = gifImage;
    [self setImages:gifImage.images duration:gifImage.duration forState:MJRefreshStateRefreshing];
    
}

@end
