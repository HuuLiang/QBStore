//
//  QBSCollectionHeaderFooterView.m
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import "QBSCollectionHeaderFooterView.h"

@implementation QBSCollectionHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        @weakify(self);
        [self bk_whenTapped:^{
            @strongify(self);
            SafelyCallBlock(self.tapAction, self);
        }];
    }
    return self;
}
@end
