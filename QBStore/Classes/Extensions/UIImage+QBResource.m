//
//  UIImage+QBResource.m
//  Pods
//
//  Created by Sean Yue on 16/7/1.
//
//

#import "UIImage+QBResource.h"
#import "UIImage+GIF.h"

@implementation UIImage (QBResource)

+ (instancetype)QBS_imageWithResourcePath:(NSString *)imagePath {
    return [self QBS_imageWithResourcePath:imagePath ofType:@"png"];
}

+ (instancetype)QBS_imageWithResourcePath:(NSString *)imagePath ofType:(NSString *)type {
//    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"QBStoreSDK" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle mainBundle];
//#ifdef DEBUG
//    NSAssert(resourceBundle, @"QBStoreSDK: Not found QBStoreSDK.bundle resource!");
//#endif
    
//    if (!resourceBundle) {
//        return nil;
//    }
//    
    if ([type isEqualToString:@"gif"]) {
        NSString *actualPath = [resourceBundle pathForResource:imagePath ofType:type];
        
        NSData *data = [NSData dataWithContentsOfFile:actualPath];
        
        return [UIImage sd_animatedGIFWithData:data];
    } else if ([type isEqualToString:@"jpg"]) {
        NSString *actualPath = [resourceBundle pathForResource:imagePath ofType:type];
        
        return [UIImage imageWithContentsOfFile:actualPath];
    } else {
        return [UIImage imageNamed:imagePath];
    }
    
//    NSArray *imagePaths = @[imagePath, [imagePath stringByAppendingString:@"@2x"], [imagePath stringByAppendingString:@"@3x"]];
//    
//    const CGFloat scale = [UIScreen mainScreen].scale;
//    const NSInteger pathIndex = MIN((NSInteger)(scale + 0.5)-1, imagePaths.count-1);
//    
//    NSString *actualPath;
//    for (NSInteger i = pathIndex; i >= 0; --i) {
//        actualPath = [resourceBundle pathForResource:imagePaths[i] ofType:type];
//        if (actualPath) {
//            break;
//        }
//    }
//    
//    UIImage *image = [UIImage imageWithContentsOfFile:actualPath];
//#ifdef DEBUG
//    NSAssert(image, @"NO image for imagePath: %@", imagePath);
//#endif
//    return image;
}
@end
