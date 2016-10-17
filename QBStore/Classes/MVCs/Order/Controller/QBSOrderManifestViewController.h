//
//  QBSOrderManifestViewController.h
//  Pods
//
//  Created by Sean Yue on 16/8/3.
//
//

#import "QBSBaseViewController.h"

//@class QBSCartCommodity;
//@class QBSOrderCommodity;

@interface QBSOrderManifestViewController : QBSBaseViewController

//@property (nonatomic,retain,readonly) NSArray<QBSCartCommodity *> *cartCommodities;
//@property (nonatomic,retain,readonly) NSArray<QBSOrderCommodity *> *orderCommodities;
@property (nonatomic,retain,readonly) NSArray *commodities;

- (instancetype)init __attribute__((unavailable("Use - initWithCommodities: instead!")));
//- (instancetype)initWithCartCommodities:(NSArray<QBSCartCommodity *> *)cartCommodities;
//- (instancetype)initWithOrderCommodities:(NSArray<QBSOrderCommodity *> *)orderCommodities;
- (instancetype)initWithCommodities:(NSArray *)commodities;

@end
