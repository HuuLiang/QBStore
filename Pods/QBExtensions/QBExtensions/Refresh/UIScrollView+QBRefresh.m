//
//  UIScrollView+QBRefresh.m
//  QBExtensions
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 iqu8. All rights reserved.
//

#import "UIScrollView+QBRefresh.h"
#import <MJRefresh.h>

static const void *kQBRefreshViewAssociatedKey = &kQBRefreshViewAssociatedKey;
static const void *kQBShowLastUpdatedTimeAssociatedKey = &kQBShowLastUpdatedTimeAssociatedKey;
static const void *kQBShowStateAssociatedKey = &kQBShowStateAssociatedKey;

@implementation UIScrollView (QBRefresh)

- (UIColor *)QB_refreshTextColor {
    return [UIColor colorWithWhite:0.5 alpha:1];
}

- (BOOL)QB_isRefreshing {
    if ([self.QB_refreshView isKindOfClass:[MJRefreshComponent class]]) {
        MJRefreshComponent *refresh = (MJRefreshComponent *)self.QB_refreshView;
        return refresh.state == MJRefreshStateRefreshing;
    }
    return NO;
}

- (UIView *)QB_refreshView {
    return objc_getAssociatedObject(self, kQBRefreshViewAssociatedKey);
}

- (void)setQB_showLastUpdatedTime:(BOOL)QB_showLastUpdatedTime {
    objc_setAssociatedObject(self, kQBShowLastUpdatedTimeAssociatedKey, @(QB_showLastUpdatedTime), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if ([self.mj_header isKindOfClass:[MJRefreshStateHeader class]]) {
        MJRefreshStateHeader *header = (MJRefreshStateHeader *)self.mj_header;
        header.lastUpdatedTimeLabel.hidden = !QB_showLastUpdatedTime;
    }
}

- (BOOL)QB_showLastUpdatedTime {
    NSNumber *value = objc_getAssociatedObject(self, kQBShowLastUpdatedTimeAssociatedKey);
    return value.boolValue;
}

- (void)setQB_showStateLabel:(BOOL)QB_showStateLabel {
    objc_setAssociatedObject(self, kQBShowStateAssociatedKey, @(QB_showStateLabel), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if ([self.mj_header isKindOfClass:[MJRefreshStateHeader class]]) {
        MJRefreshStateHeader *header = (MJRefreshStateHeader *)self.mj_header;
        header.stateLabel.hidden = !QB_showStateLabel;
    }
}

- (BOOL)QB_showStateLabel {
    NSNumber *value = objc_getAssociatedObject(self, kQBShowStateAssociatedKey);
    return value.boolValue;
}

- (void)QB_addPullToRefreshWithHandler:(void (^)(void))handler {
    if (!self.mj_header) {
            MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:handler];
//            refreshHeader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            refreshHeader.lastUpdatedTimeLabel.textColor = [self QB_refreshTextColor];
            refreshHeader.stateLabel.textColor = [self QB_refreshTextColor];
            refreshHeader.lastUpdatedTimeLabel.hidden = !self.QB_showLastUpdatedTime;
        self.mj_header = refreshHeader;
        
        objc_setAssociatedObject(self, kQBRefreshViewAssociatedKey, refreshHeader, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (void)QB_triggerPullToRefresh {
    
    if ([self.QB_refreshView isKindOfClass:[MJRefreshComponent class]]) {
        MJRefreshComponent *refresh = (MJRefreshComponent *)self.QB_refreshView;
        [refresh beginRefreshing];
    }
}

- (void)QB_endPullToRefresh {
    if ([self.QB_refreshView isKindOfClass:[MJRefreshComponent class]]) {
        MJRefreshComponent *refresh = (MJRefreshComponent *)self.QB_refreshView;
        [refresh endRefreshing];
    }
    
    [self.mj_footer resetNoMoreData];
}

- (void)QB_addPagingRefreshWithHandler:(void (^)(void))handler {
    if (!self.mj_footer) {
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:handler];
        refreshFooter.automaticallyHidden = YES;
        refreshFooter.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        refreshFooter.stateLabel.textColor = [self QB_refreshTextColor];
        self.mj_footer = refreshFooter;
    }
}

- (void)QB_pagingRefreshNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)QB_setPagingRefreshText:(NSString *)text {
    if ([self.mj_footer isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mj_footer;
        [footer setTitle:text forState:MJRefreshStateIdle];
    }
}

- (void)QB_setPagingNoMoreDataText:(NSString *)text {
    if ([self.mj_footer isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.mj_footer;
        [footer setTitle:text forState:MJRefreshStateNoMoreData];
    }
}
@end
