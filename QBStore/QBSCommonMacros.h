//
//  QBSCommonMacros.h
//  QBStore
//
//  Created by Sean Yue on 2016/10/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef QBSCommonMacros_h
#define QBSCommonMacros_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define SafelyCallBlock(block,...) \
if (block) block(__VA_ARGS__);

#define DefineLazyPropertyInitialization(propertyType, propertyName) \
-(propertyType *)propertyName { \
if (_##propertyName) { \
return _##propertyName; \
} \
_##propertyName = [[propertyType alloc] init]; \
return _##propertyName; \
}

#define DeclareSingletonMethod(methodName) \
+ (instancetype)methodName;

#define SynthesizeSingletonMethod(methodName, className) \
+ (instancetype)methodName { \
static className *_methodName; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{\
_methodName = [[self alloc] init]; \
}); \
return _methodName; \
}

#define AssociatedButtonWithActionByPassOriginalSender(button, action) \
__weak typeof(self) button##WeakSelf = self; \
[button bk_addEventHandler:^(id sender) { \
__strong typeof(button##WeakSelf) button##StrongSelf = button##WeakSelf; \
SafelyCallBlock(button##StrongSelf.action, sender); \
} forControlEvents:UIControlEventTouchUpInside];

#define AssociatedButtonWithAction(button, action) \
__weak typeof(self) button##WeakSelf = self; \
[button bk_addEventHandler:^(id sender) { \
__strong typeof(button##WeakSelf) button##StrongSelf = button##WeakSelf; \
SafelyCallBlock(button##StrongSelf.action, self); \
} forControlEvents:UIControlEventTouchUpInside];

#define AssociatedViewWithTapAction(view, action) \
__weak typeof(self) view##WeakSelf = self; \
[view bk_whenTapped:^{ \
__strong typeof(view##WeakSelf) view##StrongSelf = view##WeakSelf; \
SafelyCallBlock(view##StrongSelf.action, self); \
}];

#ifdef  DEBUG
#define QBSLog(fmt,...) {printf("%s\n", [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);}
#define QBSLogError(error) QBSLog(@"%@", error.userInfo)
#else
#define QBSLog(...)
#define QBSLogError(error)
#endif

#define SIGN(f) f == 0 ? 0 : f < 0 ? -1 : 1

#define kHugeFont     [UIFont systemFontOfSize:MIN(26,roundf(kScreenWidth*0.075))]
#define kHugeBoldFont [UIFont boldSystemFontOfSize:MIN(26,roundf(kScreenWidth*0.075))]
#define kExtraBigFont [UIFont systemFontOfSize:MIN(20,roundf(kScreenWidth*0.055))]
#define kBigFont  [UIFont systemFontOfSize:MIN(18,roundf(kScreenWidth*0.05))]
#define kBigBoldFont [UIFont boldSystemFontOfSize:MIN(18,roundf(kScreenWidth*0.05))]
#define kMediumFont [UIFont systemFontOfSize:MIN(16, roundf(kScreenWidth*0.045))]
#define kSmallFont [UIFont systemFontOfSize:MIN(14, roundf(kScreenWidth*0.04))]
#define kExtraSmallFont [UIFont systemFontOfSize:MIN(12, roundf(kScreenWidth*0.035))]
#define kExExSmallFont [UIFont systemFontOfSize:MIN(10, roundf(kScreenWidth*0.03))]
#define kTinyFont [UIFont systemFontOfSize:MIN(8, roundf(kScreenWidth*0.025))]

#define kExtraBigVerticalSpacing roundf(kScreenHeight * 0.016)
#define kBigVerticalSpacing roundf(kScreenHeight * 0.012)
#define kMediumVerticalSpacing roundf(kScreenHeight * 0.008)
#define kSmallVerticalSpacing roundf(kScreenHeight * 0.004)

#define kExtraBigHorizontalSpacing  roundf(kScreenWidth * 0.04)
#define kBigHorizontalSpacing       roundf(kScreenWidth * 0.024)
#define kMediumHorizontalSpacing    roundf(kScreenWidth * 0.016)
#define kSmallHorizontalSpacing     roundf(kScreenWidth * 0.008)

#define kLeftRightContentMarginSpacing kExtraBigHorizontalSpacing
#define kTopBottomContentMarginSpacing kExtraBigVerticalSpacing

#define kQBSThemeColor [UIColor colorWithHexString:@"#FF206F"]
#endif /* QBSCommonMacros_h */
