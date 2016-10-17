//
//  QBSRegionPicker.m
//  Pods
//
//  Created by Sean Yue on 16/8/1.
//
//

#import "QBSRegionPicker.h"

@interface QBSRegionPicker ()
@property (nonatomic,readonly) NSString *initialProvince;
@property (nonatomic,readonly) NSString *initialCity;
@property (nonatomic,readonly) NSString *initialDistrict;

@property (nonatomic) BOOL isInitialLoad;
@end

@implementation QBSRegionPicker

+ (instancetype)showPickerWithTitle:(NSString *)title
                    initialProvince:(NSString *)province
                        initialCity:(NSString *)city
                    initialDistrict:(NSString *)district
                           delegate:(id<QBSRegionPickerDelegate>)delegate
                             origin:(id)origin
{
    QBSRegionPicker *picker = [[self alloc] initWithTitle:title initialProvince:province initialCity:city initialDistrict:district origin:origin];
    picker.delegate = delegate;
    picker.onActionSheetDone = ^(ActionSheetMultipleStringPicker *pickerView, NSArray *selectedIndexes, id selectedValues) {
        QBSRegionPicker *p = (QBSRegionPicker *)pickerView;
        if ([p.delegate respondsToSelector:@selector(pickerView:didSelectProvince:city:district:)]) {
            [p.delegate pickerView:p didSelectProvince:selectedValues[0] city:selectedValues[1] district:selectedValues[2]];
        }
    };
    [picker showActionSheetPicker];
    [picker initialReloadData];
    return picker;
};

- (instancetype)initWithTitle:(NSString *)title
              initialProvince:(NSString *)province
                  initialCity:(NSString *)city
              initialDistrict:(NSString *)district
                       origin:(id)origin
{
    self = [self initWithTitle:title rows:@[@[],@[],@[]] initialSelection:nil doneBlock:nil cancelBlock:nil origin:origin];
    if (self) {
        _initialProvince = province;
        _initialCity = city;
        _initialDistrict = district;
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinces.count;
    } else if (component == 1) {
        return self.cities.count;
    } else if (component == 2) {
        return self.districts.count;
    }
    
    return 0;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return nil;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return row < self.provinces.count ? self.provinces[row] : nil;
    } else if (component == 1) {
        return row < self.cities.count ? self.cities[row] : nil;
    } else if (component == 2) {
        return row < self.districts.count ? self.districts[row] : nil;
    }
    return nil;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0 && row < self.provinces.count) {
        if ([self.delegate respondsToSelector:@selector(pickerView:willUpdateCitiesInProvince:completionBlock:)]) {
            @weakify(self);
            QBSAction completionBlock = ^(id obj) {
                @strongify(self);
                self.cities = obj;
                
                NSUInteger selRow = 0;
                if (self.isInitialLoad && self.initialCity.length > 0) {
                    selRow = [self.cities indexOfObject:self.initialCity];
                    if (selRow == NSNotFound) {
                        selRow = 0;
                    }
                }
                
                [pickerView selectRow:selRow inComponent:1 animated:YES];
                [self pickerView:pickerView didSelectRow:selRow inComponent:1];
            };
            [self.delegate pickerView:self willUpdateCitiesInProvince:self.provinces[row] completionBlock:[completionBlock copy]];
        }
    } else if (component == 1 && row < self.cities.count) {

        if ([self.delegate respondsToSelector:@selector(pickerView:willUpdateDistrictsInCity:withProvince:completionBlock:)]) {
            NSUInteger selectedProvinceIndex = [pickerView selectedRowInComponent:0];
            if (selectedProvinceIndex < self.provinces.count) {
                NSString *province = self.provinces[selectedProvinceIndex];
                
                @weakify(self);
                QBSAction completionBlock = ^(id obj) {
                    @strongify(self);
                    self.districts = obj;
                    
                    NSUInteger selRow = 0;
                    if (self.isInitialLoad && self.initialDistrict.length > 0) {
                        selRow = [self.districts indexOfObject:self.initialDistrict];
                        if (selRow == NSNotFound) {
                            selRow = 0;
                        }
                    }
                    
                    [pickerView selectRow:selRow inComponent:2 animated:YES];
                };
                [self.delegate pickerView:self willUpdateDistrictsInCity:self.cities[row] withProvince:province completionBlock:[completionBlock copy]];
            }
            
        }
    }
}

- (void)initialReloadData {
    self.isInitialLoad = YES;
    [self internalReloadData];
}

- (void)reloadData {
    self.isInitialLoad = NO;
    [self internalReloadData];
}

- (void)internalReloadData {
    
    @weakify(self);
    if ([self.delegate respondsToSelector:@selector(pickerView:willUpdateProvincesWithCompletionBlock:)]) {
        
        QBSAction completionBlock = ^(id obj) {
            @strongify(self);
            self.provinces = obj;
            
            NSUInteger selRow = 0;
            if (self.isInitialLoad && self.initialProvince.length > 0) {
                selRow = [self.provinces indexOfObject:self.initialProvince];
                if (selRow == NSNotFound) {
                    selRow = 0;
                }
            }
            
            [(UIPickerView *)self.pickerView selectRow:selRow inComponent:0 animated:YES];
            [self pickerView:(UIPickerView *)self.pickerView didSelectRow:selRow inComponent:0];
        };
        [self.delegate pickerView:self willUpdateProvincesWithCompletionBlock:[completionBlock copy]];
    }
}

- (NSArray *)selection {
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSArray *data = i == 0 ? self.provinces : i == 1 ? self.cities : self.districts;
        
        id object = data[[(UIPickerView *)self.pickerView selectedRowInComponent:(NSInteger)i]];
        [array addObject: object ?: @""];
    }
    return [array copy];
}

- (void)setProvinces:(NSArray<NSString *> *)provinces {
    if ([provinces isEqualToArray:_provinces]) {
        return ;
    }
    
    _provinces = provinces;
    _cities = nil;
    _districts = nil;
    [(UIPickerView *)self.pickerView reloadAllComponents];
    
}

- (void)setCities:(NSArray<NSString *> *)cities {
    if ([_cities isEqualToArray:cities]) {
        return ;
    }
    
    _cities = cities;
    _districts = nil;
    [(UIPickerView *)self.pickerView reloadComponent:1];
    [(UIPickerView *)self.pickerView reloadComponent:2];
}

- (void)setDistricts:(NSArray<NSString *> *)districts {
    if ([_districts isEqualToArray:districts]) {
        return ;
    }
    
    _districts = districts;
    
    [(UIPickerView *)self.pickerView reloadComponent:2];
}

- (void)dealloc {
    QBSLog(@"%@ dealloc", [self class]);
}
@end
