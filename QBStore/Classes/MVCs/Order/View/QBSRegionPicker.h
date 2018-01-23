//
//  QBSRegionPicker.h
//  Pods
//
//  Created by Sean Yue on 16/8/1.
//
//

#import "ActionSheetMultipleStringPicker.h"

@class QBSRegionPicker;

@protocol QBSRegionPickerDelegate <NSObject>

@optional
- (void)pickerView:(QBSRegionPicker *)pickerView willUpdateProvincesWithCompletionBlock:(QBSAction)completionBlock;
- (void)pickerView:(QBSRegionPicker *)pickerView willUpdateCitiesInProvince:(NSString *)province completionBlock:(QBSAction)completionBlock;
- (void)pickerView:(QBSRegionPicker *)pickerView willUpdateDistrictsInCity:(NSString *)city withProvince:(NSString *)province completionBlock:(QBSAction)completionBlock;
- (void)pickerView:(QBSRegionPicker *)pickerView didSelectProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;
@end

@interface QBSRegionPicker : ActionSheetMultipleStringPicker

@property (nonatomic,retain) NSArray<NSString *> *provinces;
//@property (nonatomic) NSUInteger currentProvinceIndex;
//
@property (nonatomic,retain) NSArray<NSString *> *cities;
//@property (nonatomic) NSUInteger currentCityIndex;
//
@property (nonatomic,retain) NSArray<NSString *> *districts;
//@property (nonatomic) NSUInteger currentDistrictIndex;

@property (nonatomic,weak) id<QBSRegionPickerDelegate> delegate;

+ (instancetype)showPickerWithTitle:(NSString *)title
                    initialProvince:(NSString *)province
                        initialCity:(NSString *)city
                    initialDistrict:(NSString *)district
                           delegate:(id<QBSRegionPickerDelegate>)delegate
                             origin:(id)origin;
- (void)reloadData;

@end
