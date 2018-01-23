//
//  QBSCommonTypes.h
//  QBStore
//
//  Created by Sean Yue on 2016/10/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef QBSCommonTypes_h
#define QBSCommonTypes_h

typedef void (^QBSAction)(id obj);
typedef void (^QBSSelectionAction)(NSUInteger index, id obj);
typedef void (^QBSCompletionHandler)(id obj, NSError *error);

typedef NS_ENUM(NSInteger, QBSSortType) {
    QBSSortTypeUnknown = -1,
    QBSSortTypeGeneral,
    QBSSortTypeSales,
    QBSSortTypePrice
};

typedef NS_ENUM(NSUInteger, QBSSortMode) {
    QBSSortModeUnknown,
    QBSSortModeNone,
    QBSSortModeAscending,
    QBSSortModeDescending
};

typedef NS_ENUM(NSUInteger, QBSRecommendType) {
    QBSBannerTypeUnknown,
    QBSRecommendTypeColumn,
    QBSRecommendTypeCommodity,
    QBSRecommendTypeTag,
    QBSRecommendTypeTicket,
    QBSRecommendTypeDuoBao,
    QBSRecommendTypeZhengPin,
    QBSRecommendTypeSexZone
};

typedef NS_ENUM(NSUInteger, QBSColumnType) {
    QBSColumnTypeUnknown,
    QBSColumnTypeNormal,
    QBSColumnTypeTag
};

typedef NS_ENUM(NSUInteger, QBSPaymentResult) {
    QBSPaymentResultUnknown,
    QBSPaymentResultSuccess,
    QBSPaymentResultFailure,
    QBSPaymentResultCancelled
};

//typedef NS_ENUM(NSUInteger, QBSPaymentType) {
//    QBSPaymentTypeNone,
//    QBSPaymentTypeWeChat,
//    QBSPaymentTypeAlipay,
//    QBSPaymentTypeCOD
//};

@protocol QBSDynamicContentHeightDelegate <NSObject>

@property (nonatomic,readonly) CGFloat contentHeight;
@property (nonatomic,copy) QBSAction contentHeightChangedAction;

@end

#endif /* QBSCommonTypes_h */
