//
//  UIImageView+QBWebCache.m
//  QBStore
//
//  Created by Sean Yue on 2016/11/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "UIImageView+QBWebCache.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (QBWebCache)

- (void)QB_setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"commodity_placeholder"]];
}
@end
