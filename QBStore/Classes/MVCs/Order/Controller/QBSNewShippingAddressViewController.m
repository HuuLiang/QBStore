//
//  QBSNewShippingAddressViewController.m
//  Pods
//
//  Created by Sean Yue on 16/8/1.
//
//

#import "QBSNewShippingAddressViewController.h"
#import "QBSNewShippingAddressCell.h"
#import "QBSRegionPicker.h"

#import "QBSShippingAddress.h"
#import "QBSJSONResponse.h"

#import "TPKeyboardAvoidingTableView.h"

static NSString *const kNewShippingAddressCellReusableIdentifier = @"NewShippingAddressCellReusableIdentifier";

typedef NS_ENUM(NSUInteger, QBSAdressCellIndex) {
    QBSRegionCell,
    QBSDetailCell,
    QBSConsigneeCell,
    QBSPhoneCell,
    QBSAdressCellIndexCount
};

@interface QBSNewShippingAddressViewController () <UITableViewDelegate,UITableViewDataSource,QBSRegionPickerDelegate>
{
    TPKeyboardAvoidingTableView *_layoutTV;
}
@property (nonatomic,retain,readonly) NSDictionary<NSNumber *, NSString *> *cellTitles;
@property (nonatomic,retain,readonly) NSDictionary<NSNumber *, NSString *> *cellPlaceholders;
//@property (nonatomic,retain) QBSRegionPicker *pickerView;

@property (nonatomic,retain) QBSShippingAddress *address;
@property (nonatomic,copy) QBSAction completionAction;
@property (nonatomic,retain) QBSNewShippingAddressCell *editingCell;
@property (nonatomic,retain) NSArray<QBSShippingRegionItem *> *provinces;
@property (nonatomic,retain) NSArray<QBSShippingRegionItem *> *cities;
@property (nonatomic,retain) NSDictionary<NSString *, NSArray<QBSShippingRegionItem *> *> *districts;
@end

@implementation QBSNewShippingAddressViewController
@synthesize cellTitles = _cellTitles;
@synthesize cellPlaceholders = _cellPlaceholders;

DefineLazyPropertyInitialization(QBSShippingAddress, address)

- (instancetype)initWithCompletionAction:(QBSAction)completionAction {
    return [self initWithAddress:nil completionAction:completionAction];
}

- (instancetype)initWithAddress:(QBSShippingAddress *)address completionAction:(QBSAction)completionAction {
    self = [self init];
    if (self) {
        _isUpdateAddress = address != nil;
        _address = [address copy];
        _completionAction = [completionAction copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _isUpdateAddress ? @"编辑收货地址" : @"新增收货地址";
    
    _layoutTV = [[TPKeyboardAvoidingTableView alloc] init];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.rowHeight = MAX(kScreenHeight * 0.08,44);
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTV registerClass:[QBSNewShippingAddressCell class] forCellReuseIdentifier:kNewShippingAddressCellReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    _layoutTV.tableFooterView = footerView;
    
    UIButton *okButton = [[UIButton alloc] init];
    okButton.titleLabel.font = kBigFont;
    okButton.layer.cornerRadius = 5;
    okButton.layer.masksToBounds = YES;
    [okButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF206F"]] forState:UIControlStateNormal];
    [okButton setTitle:@"确认" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(onOK) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:okButton];
    {
        [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footerView);
            make.width.equalTo(footerView).multipliedBy(0.8);
            make.height.mas_equalTo(44);
        }];
    }
}

- (NSDictionary<NSNumber *,NSString *> *)cellTitles {
    if (_cellTitles) {
        return _cellTitles;
    }
    
    _cellTitles = @{@(QBSRegionCell):@"所在地区",
                    @(QBSDetailCell):@"详细地址",
                    @(QBSConsigneeCell):@"收件人",
                    @(QBSPhoneCell):@"手机号码"};
    return _cellTitles;
}

- (NSDictionary<NSNumber *,NSString *> *)cellPlaceholders {
    if (_cellPlaceholders) {
        return _cellPlaceholders;
    }
    
    _cellPlaceholders = @{@(QBSRegionCell):@"请选择收件人所在省市区",
                          @(QBSDetailCell):@"请输入收件人详细地址",
                          @(QBSConsigneeCell):@"请输入收件人姓名",
                          @(QBSPhoneCell):@"请输入收件人手机号码"};
    return _cellPlaceholders;
}

- (void)onSelectRegion {
    [QBSRegionPicker showPickerWithTitle:@"选择省市区"
                         initialProvince:self.address.province
                             initialCity:self.address.city
                         initialDistrict:self.address.district
                                delegate:self
                                  origin:self.view];
}

- (void)onOK {
    @weakify(self);
    [self.editingCell endEditing];
    
    NSError *error = [self.address isValid];
    if (error) {
        @weakify(self);
        [[QBSHUDManager sharedManager] showError:error.qbsErrorMessage afterDismiss:^(id obj) {
            @strongify(self);
            if (!self) {
                return ;
            }
            
            QBSNewShippingAddressCell *cell;
            if (error.code == kQBSShippingAddressInvalidRegionError) {
                cell = [self->_layoutTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:QBSRegionCell inSection:0]];
            } else if (error.code == kQBSShippingAddressInvalidAddressError) {
                cell = [self->_layoutTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:QBSDetailCell inSection:0]];
            } else if (error.code == kQBSShippingAddressInvalidNameError) {
                cell = [self->_layoutTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:QBSConsigneeCell inSection:0]];
            } else if (error.code == kQBSShippingAddressInvalidMobileError) {
                cell = [self->_layoutTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:QBSPhoneCell inSection:0]];
            }
            
            [cell beginEditing];
//            [cell performSelector:@selector(beginEditing) withObject:nil afterDelay:3];
        }];
        
        return ;
    }
    
    
    QBSCompletionHandler completionHandler = ^(id obj, NSError *error) {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if ([obj success]) {
            if (!self.isUpdateAddress) {
                QBSCreateShippingAddressResponse *resp = obj;
                self.address = resp.data;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            SafelyCallBlock(self.completionAction, self.address);
        } 
    };
    
    [[QBSHUDManager sharedManager] showLoading];
    
    if (_isUpdateAddress) {
        [[QBSRESTManager sharedManager] request_updateShippingAddress:self.address withCompletionHandler:completionHandler];
    } else {
        [[QBSRESTManager sharedManager] request_newShippingAddress:self.address withCompletionHandler:completionHandler];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - QBSRegionPickerDelegate

- (void)pickerView:(QBSRegionPicker *)pickerView didSelectProvince:(NSString *)province city:(NSString *)city district:(NSString *)district {
    if (province.length > 0 && city.length > 0 && district.length > 0) {
        self.address.province = province;
        self.address.city = city;
        self.address.district = district;

        [_layoutTV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:QBSRegionCell inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)pickerView:(QBSRegionPicker *)pickerView willUpdateProvincesWithCompletionBlock:(QBSAction)completionBlock {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryShippingProvincesWithCompletionHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            QBSShippingAddressProvince *provinces = obj;
            self.provinces = provinces.data;
            
            completionBlock([self.provinces bk_map:^id(QBSShippingRegionItem *obj) {
                return obj.name;
            }]);
        }
    }];
}

- (void)pickerView:(QBSRegionPicker *)pickerView willUpdateCitiesInProvince:(NSString *)province completionBlock:(QBSAction)completionBlock {
    NSString *provinceCode = [(QBSShippingRegionItem *)[self.provinces bk_match:^BOOL(QBSShippingRegionItem *obj) {
        return [obj.name isEqualToString:province];
    }] code];
    
    if (!provinceCode) {
        completionBlock(nil);
        return ;
    }
    
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryCitiesAndDistrictsInProvince:provinceCode completionHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        QBSShippingAddressCityAndDistrict *resp = obj;
        self.cities = resp.data.cities;
        self.districts = resp.data.districts;
        
        completionBlock([self.cities bk_map:^id(QBSShippingRegionItem *obj) {
            return obj.name;
        }]);
    }];
}

- (void)pickerView:(QBSRegionPicker *)pickerView willUpdateDistrictsInCity:(NSString *)city withProvince:(NSString *)province completionBlock:(QBSAction)completionBlock {
    NSString *cityCode = [(QBSShippingRegionItem *)[self.cities bk_match:^BOOL(QBSShippingRegionItem *obj) {
        return [obj.name isEqualToString:city];
    }] code];
    
    if (!cityCode) {
        completionBlock(nil);
        return ;
    }
    
    NSArray<QBSShippingRegionItem *> *districts = self.districts[cityCode];
    completionBlock([districts bk_map:^id(QBSShippingRegionItem *obj) {
        return obj.name;
    }]);
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return QBSAdressCellIndexCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSNewShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewShippingAddressCellReusableIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = indexPath.row == QBSRegionCell ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    cell.canEdit = indexPath.row != QBSRegionCell;
    cell.showSeparator = YES;
    cell.subtitleTextField.keyboardType = UIKeyboardTypeDefault;
    cell.subtitleTextField.returnKeyType = UIReturnKeyNext;
    
    if (indexPath.row != [tableView numberOfRowsInSection:indexPath.section] - 1) {
        cell.separatorInsets = UIEdgeInsetsMake(0, kLeftRightContentMarginSpacing, 0, 0);
    } else {
        cell.separatorInsets = UIEdgeInsetsZero;
    }
    
    cell.title = self.cellTitles[@(indexPath.row)];
    cell.placeholder = self.cellPlaceholders[@(indexPath.row)];
    
    @weakify(self);
    cell.beginEditingAction = ^(id obj) {
        @strongify(self);
        QBSNewShippingAddressCell *prevEditingCell = self.editingCell;
        self.editingCell = obj;
        if (indexPath.row == QBSRegionCell) {
            [prevEditingCell endEditing];
            [self onSelectRegion];
        }
    };
    
    cell.endEditingAtion = ^(id obj) {
        @strongify(self);
        if (self.editingCell == obj) {
            self.editingCell = nil;
        }
        
        if (indexPath.row == QBSRegionCell) {
            return ;
        }
        
        QBSNewShippingAddressCell *thisCell = obj;
        if (indexPath.row == QBSDetailCell) {
            self.address.address = thisCell.subtitle;
        } else if (indexPath.row == QBSPhoneCell) {
            self.address.mobile = thisCell.subtitle;
        } else if (indexPath.row == QBSConsigneeCell) {
            self.address.name = thisCell.subtitle;
        }
    };
    
    cell.returnAction = ^(id obj) {
        @strongify(self);
        [self->_layoutTV focusNextTextField];
    };
    
    NSError *addressError = [self.address isValid];
    if (indexPath.row == QBSRegionCell) {
        if (addressError.code != kQBSShippingAddressInvalidRegionError) {
            cell.subtitle = [NSString stringWithFormat:@"%@%@%@", self.address.province, self.address.city, self.address.district];
        } else {
            cell.subtitle = nil;
        }
        
    } else if (indexPath.row == QBSDetailCell) {
        cell.subtitle = addressError.code == kQBSShippingAddressInvalidAddressError ? nil : self.address.address;
    } else if (indexPath.row == QBSConsigneeCell) {
        cell.subtitle = addressError.code == kQBSShippingAddressInvalidNameError ? nil : self.address.name;
    } else if (indexPath.row == QBSPhoneCell) {
        cell.subtitle = addressError.code == kQBSShippingAddressInvalidMobileError ? nil : self.address.mobile;
        cell.subtitleTextField.keyboardType = UIKeyboardTypePhonePad;
        cell.subtitleTextField.returnKeyType = UIReturnKeyDone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSNewShippingAddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell beginEditing];
}
@end
