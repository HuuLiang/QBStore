//
//  UIScrollView+QBRefresh.h
//  QBExtensions
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (QBRefresh)

@property (nonatomic) BOOL QB_showLastUpdatedTime;
@property (nonatomic) BOOL QB_showStateLabel;
@property (nonatomic,weak,readonly) UIView *QB_refreshView;
@property (nonatomic,readonly) BOOL QB_isRefreshing;

- (void)QB_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)QB_triggerPullToRefresh;
- (void)QB_endPullToRefresh;

- (void)QB_addPagingRefreshWithHandler:(void (^)(void))handler;
- (void)QB_pagingRefreshNoMoreData;
- (void)QB_setPagingRefreshText:(NSString *)text;
- (void)QB_setPagingNoMoreDataText:(NSString *)text;

@end
