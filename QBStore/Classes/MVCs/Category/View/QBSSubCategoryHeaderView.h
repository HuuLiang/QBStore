//
//  QBSSubCategoryHeaderView.h
//  Pods
//
//  Created by Sean Yue on 16/7/18.
//
//

#import "QBSCollectionHeaderFooterView.h"

@interface QBSSubCategoryHeaderView : QBSCollectionHeaderFooterView

@property (nonatomic) NSURL *imageURL;

@property (nonatomic) UIEdgeInsets contentInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat imageScale UI_APPEARANCE_SELECTOR;

+ (CGFloat)viewHeightRelativeToViewWidth:(CGFloat)width;

@end
