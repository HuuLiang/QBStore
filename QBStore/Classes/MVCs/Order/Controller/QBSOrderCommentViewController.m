//
//  QBSOrderCommentViewController.m
//  Pods
//
//  Created by Sean Yue on 16/8/29.
//
//

#import "QBSOrderCommentViewController.h"
#import "QBSOrderCommentListCell.h"
#import "QBSTableHeaderFooterView.h"

#import "QBSOrder.h"
#import "QBSOrderCommodity.h"

static NSString *const kCellReusableIdentifier = @"CellReusableIdentifier";
static NSString *const kHeaderReusableIdentifier = @"HeaderReusableIdentifier";

@interface QBSOrderCommentViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@end

@implementation QBSOrderCommentViewController

- (instancetype)initWithOrder:(QBSOrder *)order didCommentAction:(QBSAction)action {
    self = [super init];
    if (self) {
        _order = order;
        _didCommentAction = action;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评价";
    
    _layoutTV = [[UITableView alloc] init];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTV registerClass:[QBSOrderCommentListCell class] forCellReuseIdentifier:kCellReusableIdentifier];
    [_layoutTV registerClass:[QBSTableHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kHeaderReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    
    UIButton *submitButton = [[UIButton alloc] init];
    [submitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF206F"]] forState:UIControlStateNormal];
    [submitButton setTitle:@"提交评价" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.layer.cornerRadius = 5;
    submitButton.layer.masksToBounds = YES;
    submitButton.titleLabel.font = kBigFont;
    [submitButton addTarget:self action:@selector(onSubmit) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitButton];
    {
        [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footerView);
            make.height.equalTo(footerView).multipliedBy(0.6);
            make.width.equalTo(footerView).multipliedBy(0.9);
        }];
    }
    
    _layoutTV.tableFooterView = footerView;
}

- (void)onSubmit {
    [_layoutTV endEditing:YES];
    
    QBSOrderCommodity *uncommentedCommodity = [self.order.orderCommoditys bk_match:^BOOL(QBSOrderCommodity *obj) {
        return obj.numberOfStars == 0;
    }];
    
    if (uncommentedCommodity) {
        [[QBSHUDManager sharedManager] showError:@"您必须对所有商品评分后才能提交"];
        return ;
    }
    
    @weakify(self);
    [[QBSHUDManager sharedManager] showLoading];
    [[QBSRESTManager sharedManager] request_submitCommentsOfCommodities:self.order.orderCommoditys
                                                               forOrder:self.order.orderNo
                                                  withCompletionHandler:^(id obj, NSError *error)
    {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            self.order.status = kQBSOrderStatusCommented;
            SafelyCallBlock(self.didCommentAction, self);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (BOOL)isViewControllerDependsOnUserLogin {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.order.orderCommoditys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSOrderCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReusableIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section < self.order.orderCommoditys.count) {
        QBSOrderCommodity *commodity = self.order.orderCommoditys[indexPath.section];
        cell.imageURL = [NSURL URLWithString:commodity.imgUrl];
        cell.title = commodity.commodityName;
        [cell setPrice:commodity.currentPrice.floatValue/100 withOriginalPrice:commodity.originalPrice.floatValue/100];
        cell.stars = commodity.numberOfStars;
        
        cell.starAction = ^(id obj) {
            QBSOrderCommentListCell *thisCell = obj;
            commodity.numberOfStars = thisCell.stars;
        };
        
        cell.commentAction = ^(id obj) {
            commodity.comment = obj;
        };
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QBSTableHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderReusableIdentifier];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetWidth(tableView.bounds) * 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
@end
