//
//  UIScrollView+Refresh.h
//  QBStoreSDK
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QBSPullToRefreshStyle) {
    QBSPullToRefreshStyleDefault,
    QBSPullToRefreshStyleDissolution
};

@interface UIScrollView (Refresh)

@property (nonatomic) BOOL QBS_showLastUpdatedTime;
@property (nonatomic) BOOL QBS_showStateLabel;
@property (nonatomic,weak,readonly) UIView *QBS_refreshView;
@property (nonatomic,readonly) BOOL isRefreshing;

- (void)QBS_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)QBS_addPullToRefreshWithStyle:(QBSPullToRefreshStyle)style handler:(void (^)(void))handler;
- (void)QBS_triggerPullToRefresh;
- (void)QBS_endPullToRefresh;

- (void)QBS_addPagingRefreshWithHandler:(void (^)(void))handler;
- (void)QBS_pagingRefreshNoMoreData;
- (void)QBS_setPagingRefreshText:(NSString *)text;
- (void)QBS_setPagingNoMoreDataText:(NSString *)text;

@end
