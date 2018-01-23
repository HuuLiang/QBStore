//
//  QBSBannerCell.m
//  Pods
//
//  Created by Sean Yue on 16/6/27.
//
//

#import "QBSBannerCell.h"

@interface QBSBannerCell () <SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_bannerView;
}
@end

@implementation QBSBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _shouldAutoScroll = YES;
        _shouldInfiniteScroll = YES;
        
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:nil];
        _bannerView.backgroundColor = self.backgroundColor;
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerView.autoScrollTimeInterval = 5;
        _bannerView.autoScroll = _shouldAutoScroll;
        _bannerView.infiniteLoop = _shouldInfiniteScroll;
        _bannerView.pageDotColor = [UIColor colorWithHexString:@"#D8D8D8"];
        _bannerView.currentPageDotColor = [UIColor colorWithHexString:@"#FF206F"];
        _bannerView.delegate = self;
        _bannerView.placeholderImage = [UIImage imageNamed:@"commodity_placeholder"];
        [self addSubview:_bannerView];
    }
    return self;
}

- (void)setPageControlYAspect:(CGFloat)pageControlYAspect {
    _pageControlYAspect = pageControlYAspect;
    if (_pageControlYAspect == 0) {
        _bannerView.pageControlPositionY = nil;
    } else {
        _bannerView.pageControlPositionY = ^CGFloat(CGFloat superViewHeight) {
            return pageControlYAspect * superViewHeight;
        };
    }
}
- (void)setImageURLStrings:(NSArray *)imageURLStrings {
    BOOL hasChanged = [imageURLStrings bk_any:^BOOL(id obj) {
        return ![_imageURLStrings containsObject:obj];
    }];
    
    if (hasChanged) {
        _imageURLStrings = imageURLStrings;
        _bannerView.imageURLStringsGroup = imageURLStrings;
    }
}

- (void)setShouldAutoScroll:(BOOL)shouldAutoScroll {
    _shouldAutoScroll = shouldAutoScroll;
    _bannerView.autoScroll = shouldAutoScroll;
}

- (void)setShouldInfiniteScroll:(BOOL)shouldInfiniteScroll {
    _shouldInfiniteScroll = shouldInfiniteScroll;
    _bannerView.infiniteLoop = shouldInfiniteScroll;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _bannerView.currentPage = currentIndex;
}

- (NSUInteger)currentIndex {
    return _bannerView.currentPage;
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    SafelyCallBlock(self.selectionAction, index, self);
}

@end
