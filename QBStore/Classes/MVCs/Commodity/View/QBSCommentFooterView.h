//
//  QBSCommentFooterView.h
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QBSCommentFooterState) {
    QBSCommentFooterStateNone,
    QBSCommentFooterStateLoading,
    QBSCommentFooterStateLoadMore,
    QBSCommentFooterStateLoadedAll,
    QBSCommentFooterStateLoadFails
};

@interface QBSCommentFooterView : UIView

@property (nonatomic,copy) QBSAction loadAction;

@property (nonatomic) QBSCommentFooterState state;

@end
