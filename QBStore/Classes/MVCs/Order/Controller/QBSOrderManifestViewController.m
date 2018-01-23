//
//  QBSOrderManifestViewController.m
//  Pods
//
//  Created by Sean Yue on 16/8/3.
//
//

#import "QBSOrderManifestViewController.h"
#import "QBSOrderManifestCell.h"

#import "QBSCartCommodity.h"
#import "QBSOrderCommodity.h"

static NSString *const kManifestCellReusableIdentifier = @"ManifestCellReusableIdentifier";

@interface QBSOrderManifestViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
    
    UILabel *_amountLabel;
}
@end

@implementation QBSOrderManifestViewController

//- (instancetype)initWithCartCommodities:(NSArray<QBSCartCommodity *> *)cartCommodities {
//    self = [super init];
//    if (self) {
//        _cartCommodities = cartCommodities;
//    }
//    return self;
//}
//
//- (instancetype)initWithOrderCommodities:(NSArray<QBSOrderCommodity *> *)orderCommodities {
//    self = [super init];
//    if (self) {
//        _orderCommodities = orderCommodities;
//    }
//    return self;
//}

- (instancetype)initWithCommodities:(NSArray *)commodities {
    self = [super init];
    if (self) {
        _commodities = commodities;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品清单";
    
    _layoutTV = [[UITableView alloc] init];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTV registerClass:[QBSOrderManifestCell class] forCellReuseIdentifier:kManifestCellReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_amountLabel) {
        NSUInteger amount = [self.commodities QBS_sumInteger:^NSInteger(id obj) {
            if ([obj isKindOfClass:[QBSCartCommodity class]]) {
                return ((QBSCartCommodity *)obj).amount.unsignedIntegerValue;
            } else if ([obj isKindOfClass:[QBSOrderCommodity class]]) {
                return ((QBSOrderCommodity *)obj).num.unsignedIntegerValue;
            }
            return 0;
        }];
        
        NSString *amountString = [NSString stringWithFormat:@"共%ld件", (unsigned long)amount];
        if (amount > 99999) {
            amountString = @"共99999+件";
        }
        
        const CGFloat amountWidth = CGRectGetWidth(self.navigationController.navigationBar.frame) * 0.25;
        const CGFloat amountX = CGRectGetWidth(self.navigationController.navigationBar.frame) - amountWidth - kLeftRightContentMarginSpacing;
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(amountX, 0, amountWidth, CGRectGetHeight(self.navigationController.navigationBar.frame))];
        _amountLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _amountLabel.font = kMediumFont;
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.text = amountString;
        [self.navigationController.navigationBar addSubview:_amountLabel];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_amountLabel removeFromSuperview];
    _amountLabel = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commodities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSOrderManifestCell *cell = [tableView dequeueReusableCellWithIdentifier:kManifestCellReusableIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row != [tableView numberOfRowsInSection:0] - 1) {
        cell.showSeparator = YES;
    } else {
        cell.showSeparator = NO;
    }
    
    if (indexPath.row < self.commodities.count) {
        id commodity = self.commodities[indexPath.row];
        
        if ([commodity isKindOfClass:[QBSCartCommodity class]]) {
            QBSCartCommodity *cartCommodity = (QBSCartCommodity *)commodity;
            cell.amount = cartCommodity.amount.unsignedIntegerValue;
            cell.title = cartCommodity.commodityName;
            cell.imageURL = [NSURL URLWithString:cartCommodity.imgUrl];
            [cell setPrice:cartCommodity.currentPrice.floatValue/100 withOriginalPrice:cartCommodity.originalPrice.floatValue/100];
        } else if ([commodity isKindOfClass:[QBSOrderCommodity class]]) {
            QBSOrderCommodity *orderCommodity = (QBSOrderCommodity *)commodity;
            cell.amount = orderCommodity.num.unsignedIntegerValue;
            cell.title = orderCommodity.commodityName;
            cell.imageURL = [NSURL URLWithString:orderCommodity.imgUrl];
            [cell setPrice:orderCommodity.currentPrice.floatValue/100 withOriginalPrice:orderCommodity.originalPrice.floatValue/100];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetWidth(tableView.bounds) / 4;
}
@end
