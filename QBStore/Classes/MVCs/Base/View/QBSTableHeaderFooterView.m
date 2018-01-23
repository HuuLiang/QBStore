//
//  QBSTableHeaderFooterView.m
//  Pods
//
//  Created by Sean Yue on 16/7/29.
//
//

#import "QBSTableHeaderFooterView.h"

@implementation QBSTableHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
    }
    return self;
}

@end
