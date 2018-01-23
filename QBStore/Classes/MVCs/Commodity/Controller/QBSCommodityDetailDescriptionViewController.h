//
//  QBSCommodityDetailDescriptionViewController.h
//  Pods
//
//  Created by Sean Yue on 16/7/11.
//
//

#import "QBSBaseViewController.h"

@class QBSCommodityImageInfo;

@interface QBSCommodityDetailDescriptionViewController : QBSBaseViewController <QBSDynamicContentHeightDelegate>

@property (nonatomic,readonly) CGFloat contentHeight;

@property (nonatomic,retain) NSArray<QBSCommodityImageInfo *> *imageInfos;
@property (nonatomic,copy) QBSAction contentHeightChangedAction;

@end
