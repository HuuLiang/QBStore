//
//  QBSCustomerServiceController.m
//  Pods
//
//  Created by Sean Yue on 16/7/19.
//
//

#import "QBSCustomerServiceController.h"
#import "QBSCustomerServiceCell.h"
#import "QBSCustomerService.h"

static NSString *const kCSCellReusableIdentifier = @"CSCellReusableIdentifier";
static const CGFloat kItemsPerRow = 4;
static const void *kQBSCSAssociatedKey = &kQBSCSAssociatedKey;

typedef NS_ENUM(NSUInteger, QBSCustomerServiceType) {
    QBSCustomerServiceTypeQQ,
    QBSCustomerServiceTypePhone,
    QBSCustomerServiceTypeCount
};

@interface QBSCustomerServiceController () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_gridCollectionView;
}
@property (nonatomic,readonly) CGSize itemSize;
@property (nonatomic,readonly) CGFloat collectionViewHeight;
@property (nonatomic,retain) NSArray<QBSCustomerService *> *customerServices;
@end

@implementation QBSCustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = layout.minimumLineSpacing;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    _gridCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _gridCollectionView.backgroundColor = [UIColor whiteColor];
    _gridCollectionView.delegate = self;
    _gridCollectionView.dataSource = self;
    [_gridCollectionView registerClass:[QBSCustomerServiceCell class] forCellWithReuseIdentifier:kCSCellReusableIdentifier];
    [self.view addSubview:_gridCollectionView];
}

- (void)reloadCustomerServices {
    @weakify(self);
    [_gridCollectionView beginLoading];
    
    [[QBSRESTManager sharedManager] request_queryCustomerServiceWithCompletionHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            [obj saveAsSharedList];
            [self->_gridCollectionView reloadData];
        } else {
            error.qbsErrorMessage = [NSString stringWithFormat:@"客户热线加载失败：%@", error.qbsErrorMessage];
            QBSHandleError(error);
        }
        
        [self->_gridCollectionView endLoading];
    }];
}

- (void)showInView:(UIView *)superView {
    if ([superView.subviews containsObject:self.view]) {
        return ;
    }
    
    self.view.frame = superView.bounds;
    self.view.alpha = 0;
    [superView addSubview:self.view];
    
    if (!objc_getAssociatedObject(superView, kQBSCSAssociatedKey)) {
        objc_setAssociatedObject(superView, kQBSCSAssociatedKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
    }];
    
    
    const CGFloat collectionViewHeight = self.collectionViewHeight;
    _gridCollectionView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds),
                                           CGRectGetWidth(self.view.bounds), collectionViewHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        _gridCollectionView.frame = CGRectOffset(_gridCollectionView.frame, 0, -collectionViewHeight);
    }];
    
    if ([QBSCustomerServiceList sharedList].cscidList.count == 0) {
        [self reloadCustomerServices];
    }
}

//- (void)showInViewController:(UIViewController *)viewController {
//    if (![viewController.childViewControllers containsObject:self]) {
//        [viewController addChildViewController:self];
//    }
//    
//    self.view.frame = viewController.view.bounds;
//    self.view.alpha = 0;
//    if (![viewController.view.subviews containsObject:self.view]) {
//        [viewController.view addSubview:self.view];
//        [self didMoveToParentViewController:viewController];
//    }
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.alpha = 1;
//    }];
//    
//    
//    const CGFloat collectionViewHeight = self.collectionViewHeight;
//    _gridCollectionView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds),
//                                           CGRectGetWidth(self.view.bounds), collectionViewHeight);
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        _gridCollectionView.frame = CGRectOffset(_gridCollectionView.frame, 0, -collectionViewHeight);
//    }];
//    
//    if ([QBSCustomerServiceList sharedList].cscidList.count == 0) {
//        [self reloadCustomerServices];
//    }
//}

- (void)hide {
    if (self.view.superview) {
        UIView *superView = self.view.superview;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            
            [self.view removeFromSuperview];
            objc_setAssociatedObject(superView, kQBSCSAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            _gridCollectionView.frame = CGRectOffset(_gridCollectionView.frame, 0, CGRectGetHeight(_gridCollectionView.frame));
        }];
    }
}

- (CGSize)itemSize {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_gridCollectionView.collectionViewLayout;
    
    const CGFloat fullWidth = CGRectGetWidth(self.view.bounds);
    const CGFloat itemWidth = (fullWidth - layout.minimumInteritemSpacing * (kItemsPerRow-1) - layout.sectionInset.left - layout.sectionInset.right)/kItemsPerRow;
    const CGFloat itemHeight = itemWidth;
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionViewHeight {
    const NSUInteger numberOfRows = (QBSCustomerServiceTypeCount+kItemsPerRow-1) / kItemsPerRow;
    const CGSize itemSize = [self itemSize];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_gridCollectionView.collectionViewLayout;
    
    return itemSize.height * numberOfRows + layout.sectionInset.top + layout.sectionInset.bottom + layout.minimumLineSpacing * (numberOfRows-1);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)customerServiceIsInServiceTime:(QBSCustomerService *)customerService {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    NSDate *currentDate = [NSDate date];
    [dateFormatter setDateFormat:@"yyyy/MM/dd "];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    __block BOOL isInServiceTime = NO;
    NSArray<NSString *> *timePeriods = [customerService.serviceTime componentsSeparatedByString:@";"];
    [timePeriods enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<NSString *> *beginEndTimes = [obj componentsSeparatedByString:@"-"];
        if (beginEndTimes.count != 2) {
            return ;
        }
        
        NSDate *beginDate = [dateFormatter dateFromString:[currentDateString stringByAppendingString:beginEndTimes.firstObject]];
        NSDate *endDate = [dateFormatter dateFromString:[currentDateString stringByAppendingString:beginEndTimes.lastObject]];
        
        NSTimeInterval currentToBegin = [currentDate timeIntervalSinceDate:beginDate];
        NSTimeInterval currentToEnd = [currentDate timeIntervalSinceDate:endDate];
        if (SIGN(currentToBegin) * SIGN(currentToEnd) <= 0) {
            *stop = YES;
            isInServiceTime = YES;
        }
    }];
    return isInServiceTime;
}
#pragma mark - UICollectionViewDelegateFlowLayout,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [QBSCustomerServiceList sharedList].cscidList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QBSCustomerServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCSCellReusableIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.item < [QBSCustomerServiceList sharedList].cscidList.count) {
        QBSCustomerService *customerService = [QBSCustomerServiceList sharedList].cscidList[indexPath.item];
        cell.imageURL = [NSURL URLWithString:customerService.contImgUrl];
        cell.title = customerService.contName;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < [QBSCustomerServiceList sharedList].cscidList.count) {
        QBSCustomerService *customerService = [QBSCustomerServiceList sharedList].cscidList[indexPath.item];
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customerService.contScheme]]) {
            [UIAlertView bk_showAlertViewWithTitle:@"无法打开对应的App!"
                                           message:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil
                                           handler:nil];
            return ;
        }
        
        if ([self customerServiceIsInServiceTime:customerService]) {
            [self hide];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customerService.contScheme]];
        } else {
            @weakify(self);
            [UIAlertView bk_showAlertViewWithTitle:@"客服已下班"
                                           message:[NSString stringWithFormat:@"客服营业时间为%@。\n当前时间已经超出了客服营业时间，是否继续联系客服？", customerService.serviceTime]
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles:@[@"确定"]
                                           handler:^(UIAlertView *alertView, NSInteger buttonIndex)
            {
                NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
                if ([buttonTitle isEqualToString:@"确定"]) {
                    @strongify(self);
                    [self hide];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customerService.contScheme]];
                }
            }];
        }
        
        
    }
}
@end
