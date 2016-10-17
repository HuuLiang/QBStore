//
//  QBSCategoryViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/6.
//
//

#import "QBSCategoryViewController.h"
#import "QBSCategoryCell.h"
#import "QBSSubCategoryCell.h"
#import "QBSCommodityListViewController.h"
#import "QBSSubCategoryHeaderView.h"

#import "QBSCategoryList.h"
#import "QBSSubCategoryList.h"
#import "QBSBanner.h"

static NSString *const kCategoryCellReusableIdentifier = @"CategoryCellReusableIdentifier";
static NSString *const kSubCategoryCellReusableIdentifier = @"SubCategoryCellReusableIdentifier";
static NSString *const kSubCategoryHeaderReusableIdentifier = @"SubCategoryHeaderReusableIdentifier";

@interface QBSCategoryViewController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UITableView *_catTableView;
    UICollectionView *_subcatCollectionView;
}
@property (nonatomic,retain) QBSCategory *currentCategory;
@property (nonatomic,retain) QBSCategoryList *categoryList;
@property (nonatomic) NSNumber *presetColumnId;
@property (nonatomic,retain) NSMutableDictionary<NSNumber *, QBSSubCategoryList *> *subCatLists;
@end

@implementation QBSCategoryViewController

DefineLazyPropertyInitialization(NSMutableDictionary, subCatLists)

- (instancetype)initWithPresetColumnId:(NSNumber *)columnId; {
    self = [self init];
    if (self) {
        _presetColumnId = columnId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品分类";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _catTableView = [[UITableView alloc] init];
    _catTableView.backgroundColor = self.view.backgroundColor;
    _catTableView.delegate = self;
    _catTableView.dataSource = self;
    _catTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _catTableView.rowHeight = MAX(44,kScreenHeight*0.08);
    [_catTableView registerClass:[QBSCategoryCell class] forCellReuseIdentifier:kCategoryCellReusableIdentifier];
    [self.view addSubview:_catTableView];
    {
        [_catTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.view);
            make.width.mas_equalTo(MAX(88,kScreenWidth*0.27));
        }];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = layout.minimumLineSpacing;
    
    _subcatCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _subcatCollectionView.backgroundColor = [UIColor whiteColor];
    _subcatCollectionView.delegate = self;
    _subcatCollectionView.dataSource = self;
    [_subcatCollectionView registerClass:[QBSSubCategoryCell class] forCellWithReuseIdentifier:kSubCategoryCellReusableIdentifier];
    [_subcatCollectionView registerClass:[QBSSubCategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSubCategoryHeaderReusableIdentifier];
    [self.view addSubview:_subcatCollectionView];
    {
        [_subcatCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_catTableView.mas_right);
            make.top.right.bottom.equalTo(self.view);
        }];
    }
    
    [[QBSSubCategoryHeaderView appearance] setContentInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [[QBSSubCategoryHeaderView appearance] setImageScale:4./1.];
    
    @weakify(self);
    [_catTableView QBS_addPullToRefreshWithStyle:QBSPullToRefreshStyleDissolution handler:^{
        @strongify(self);
        [self loadCategories];
    }];
    [_catTableView QBS_triggerPullToRefresh];
    
    [_subcatCollectionView QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadSubCategories];
    }];
    
    
}

- (void)loadCategories {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryCategoriesWithCompletionHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_catTableView QBS_endPullToRefresh];
        
        if (obj) {
            self.categoryList = ((QBSCategoryListResponse *)obj).channelDto;
            [self->_catTableView reloadData];
            
            if (self.presetColumnId) {
                self.currentCategory = [self.categoryList.columnList bk_match:^BOOL(QBSCategory *obj) {
                    return obj.columnId && [obj.columnId isEqualToNumber:self.presetColumnId];
                }];
            }
            
            QBSCategory *newCategory = [self.categoryList.columnList bk_match:^BOOL(id obj) {
                return [obj columnId] && self.currentCategory.columnId && [[obj columnId] isEqualToNumber:self.currentCategory.columnId];
            }];
            
            if (!newCategory) {
                newCategory = self.categoryList.columnList.firstObject;
            }
            
            self.currentCategory = newCategory;
        } else {
            error.qbsErrorMessage = [NSString stringWithFormat:@"商品分类加载失败：%@", error.qbsErrorMessage];
            QBSHandleError(error);
        }
        
        self.presetColumnId = nil;
    }];
}

- (void)loadSubCategories {
    @weakify(self);
    NSNumber *columnId = self.currentCategory.columnId;
    [[QBSRESTManager sharedManager] request_querySubCategoriesWithColumnId:columnId
                                                                columnType:self.currentCategory.columnType.unsignedIntegerValue
                                                         completionHandler:^(id obj, NSError *error)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_subcatCollectionView QBS_endPullToRefresh];
        
        if (obj) {
            QBSSubCategoryListResponse *resp = obj;
            [self.subCatLists setObject:resp.columnCommodityDto forKey:columnId];
            
            [self->_subcatCollectionView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCurrentCategory:(QBSCategory *)currentCategory {
    _currentCategory = currentCategory;
    
    NSUInteger currentCategoryIndex = [self.categoryList.columnList indexOfObject:currentCategory];
    NSIndexPath *selectedCatIndexPath = _catTableView.indexPathForSelectedRow;
    if (!selectedCatIndexPath || selectedCatIndexPath.row != currentCategoryIndex) {
        [_catTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentCategoryIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    [_subcatCollectionView reloadData];
    
    if (!self.subCatLists[currentCategory.columnId]) {
        [_subcatCollectionView QBS_triggerPullToRefresh];
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryList.columnList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryCellReusableIdentifier forIndexPath:indexPath];
    cell.backgroundColor = tableView.backgroundColor;
    
    if (indexPath.row < self.categoryList.columnList.count) {
        cell.textLabel.text = self.categoryList.columnList[indexPath.row].columnName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.categoryList.columnList.count) {
        QBSCategory *cat = self.categoryList.columnList[indexPath.row];
        self.currentCategory = cat;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.currentCategory.columnId == nil) {
        return 0;
    }
    
    QBSSubCategoryList *subCatList = self.subCatLists[self.currentCategory.columnId];
    return subCatList.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBSSubCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSubCategoryCellReusableIdentifier forIndexPath:indexPath];

    if (self.currentCategory.columnId) {
        QBSSubCategoryList *subCatList = self.subCatLists[self.currentCategory.columnId];
        if (indexPath.item < subCatList.data.count) {
            QBSCategory *subCat = subCatList.data[indexPath.item];
            cell.imageURL = [NSURL URLWithString:subCat.columnImgUrl];
            cell.title = subCat.columnName;
        }
    } else {
        cell.imageURL = nil;
        cell.title = nil;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    QBSSubCategoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                   withReuseIdentifier:kSubCategoryHeaderReusableIdentifier
                                                                                          forIndexPath:indexPath];
    if (self.currentCategory.columnId) {
        QBSSubCategoryList *subCatList = self.subCatLists[self.currentCategory.columnId];
        QBSBanner *banner = subCatList.bannerList.firstObject;
        headerView.imageURL = [NSURL URLWithString:banner.bannerImgUrl];

        @weakify(self);
        headerView.tapAction = ^(id obj) {
            @strongify(self);
            if (banner.bannerType.unsignedIntegerValue == QBSRecommendTypeColumn && !banner.isLeaf.boolValue) {
                QBSCategory *category = [self.categoryList.columnList bk_match:^BOOL(QBSCategory *obj) {
                    return [obj.columnId isEqualToNumber:banner.relId];
                }];
                
                if (category) {
                    self.currentCategory = category;
                }
            } else {
                [self pushViewControllerWithRecommendType:banner.bannerType.unsignedIntegerValue
                                               columnType:banner.columnType.unsignedIntegerValue
                                                   isLeaf:banner.isLeaf.unsignedIntegerValue
                                                    relId:banner.relId];
            }
            
        };
    } else {
        headerView.imageURL = nil;
        headerView.tapAction = nil;
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat itemWidth = CGRectGetWidth(collectionView.bounds)/2;
    const CGFloat itemHeight = itemWidth * 1.1;
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.currentCategory.columnId == nil) {
        return CGSizeZero;
    }
    
    QBSSubCategoryList *subCatList = self.subCatLists[self.currentCategory.columnId];
    if (subCatList.bannerList.count == 0) {
        return CGSizeZero;
    } else {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds),
                          [QBSSubCategoryHeaderView viewHeightRelativeToViewWidth:CGRectGetWidth(collectionView.bounds)]);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentCategory.columnName == nil) {
        return ;
    }
    
    QBSSubCategoryList *subCatList = self.subCatLists[self.currentCategory.columnId];
    if (indexPath.item < subCatList.data.count) {
        QBSCategory *subCat = subCatList.data[indexPath.item];
        QBSCommodityListViewController *listVC = [[QBSCommodityListViewController alloc] initWithColumnId:subCat.columnId
                                                                                       columnType:subCat.columnType.unsignedIntegerValue
                                                                                       columnName:subCat.columnName];
        [self.navigationController pushViewController:listVC animated:YES];
    }
}
@end
