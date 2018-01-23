//
//  QBSCommodityDetailCommentViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/11.
//
//

#import "QBSCommodityDetailCommentViewController.h"
#import "QBSCommodityComment.h"
#import "QBSCommodityCommentCell.h"
#import "QBSCommentFooterView.h"

static NSString *const kCommentCellReusableIdentifier = @"CommentCellReusableIdentifier";
static NSString *const kLoadMoreText = @"加载更多";
static NSString *const kLoadedAllText = @"全部加载完毕";
static NSString *const kLoadFailedText = @"加载失败，点击重新加载";

#define kContentFont kSmallFont
#define kFooterHeight (30)

@interface QBSCommodityDetailCommentViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@property (nonatomic,retain) NSMutableArray<QBSCommodityComment *> *comments;
@property (nonatomic) NSUInteger currentPage;

@property (nonatomic,retain) NSMutableDictionary<NSIndexPath *,NSNumber *> *cellHeights;
@property (nonatomic,retain) QBSCommentFooterView *footerView;
@end

@implementation QBSCommodityDetailCommentViewController

DefineLazyPropertyInitialization(NSMutableArray, comments)
DefineLazyPropertyInitialization(NSMutableDictionary, cellHeights)

- (instancetype)initWithCommodityId:(NSNumber *)commodityId {
    self = [super init];
    if (self) {
        _commodityId = commodityId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _shouldReloadData = YES;
    
    _layoutTV = [[UITableView alloc] init];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.scrollEnabled = NO;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTV registerClass:[QBSCommodityCommentCell class] forCellReuseIdentifier:kCommentCellReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadDataIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShouldReloadData:(BOOL)shouldReloadData {
    _shouldReloadData = shouldReloadData;
    
    [self reloadDataIfNeeded];
}

- (void)reloadDataIfNeeded {
    if (self.shouldReloadData && self.parentViewController) {
        [self.comments removeAllObjects];
        [self.cellHeights removeAllObjects];
        [_layoutTV reloadData];
        
        self.footerView.state = QBSCommentFooterStateLoading;
    }
}

- (void)loadData {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryCommodityCommentWithCommodityId:self.commodityId
                                                                          inPage:self.shouldReloadData ? 1 : self.currentPage+1
                                                               completionHandler:^(id obj, NSError *error)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            if (self.shouldReloadData) {
                [self.comments removeAllObjects];
            }
            
            QBSCommodityCommentListResponse *resp = obj;
            self.currentPage = resp.commodityEvalDto.pageNum.unsignedIntegerValue;
            
            if (resp.commodityEvalDto.evalList) {
                [self.comments addObjectsFromArray:resp.commodityEvalDto.evalList];
                [self calculateCellHeights];
                [self->_layoutTV reloadData];
                
                SafelyCallBlock(self.contentHeightChangedAction, self);
                self.shouldReloadData = NO;
            }
            
            if (self.currentPage == resp.commodityEvalDto.pageCount.unsignedIntegerValue) {
                self.footerView.state = QBSCommentFooterStateLoadedAll;
            } else {
                self.footerView.state = QBSCommentFooterStateLoadMore;
            }
        } else {
            self.footerView.state = QBSCommentFooterStateLoadFails;
        }
    }];
}

- (void)calculateCellHeights {
    [self.comments enumerateObjectsUsingBlock:^(QBSCommodityComment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const CGFloat maxWidth = CGRectGetWidth(_layoutTV.bounds)-[QBSCommodityCommentCell contentInsets].left-[QBSCommodityCommentCell contentInsets].right;
        CGRect contentRect = [obj.content boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                    attributes:@{NSFontAttributeName:kContentFont}
                                                       context:nil];
        
        [self.cellHeights setObject:@(contentRect.size.height + 30) forKey:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
}

- (CGFloat)contentHeight {
    if (self.comments.count == 0) {
        return kFooterHeight;
    }
    
    __block CGFloat contentHeight = 0;
    [self.cellHeights enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        contentHeight += obj.floatValue;
    }];
    return contentHeight + kFooterHeight;
}

- (QBSCommentFooterView *)footerView {
    if (_footerView) {
        return _footerView;
    }
    
    @weakify(self);
    _footerView = [[QBSCommentFooterView alloc] init];
    _footerView.backgroundColor = _layoutTV.backgroundColor;
    _footerView.loadAction = ^(QBSCommentFooterView *obj) {
        @strongify(self);
        [self loadData];
    };
    return _footerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBSCommodityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCellReusableIdentifier forIndexPath:indexPath];
    cell.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentLabel.font = kContentFont;
    cell.showSeparator = YES;
    
    if (indexPath.item == [tableView numberOfRowsInSection:0] - 1) {
        cell.separatorInsets = UIEdgeInsetsZero;
    } else {
        cell.separatorInsets = UIEdgeInsetsMake(0, [QBSCommodityCommentCell contentInsets].left, 0, 0);
    }
    
    if (indexPath.row < self.comments.count) {
        QBSCommodityComment *comment = self.comments[indexPath.row];
        cell.title = comment.mobilePhone;
        cell.subtitle = comment.evalTime;
        cell.content = comment.content;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    return [self.cellHeights[cellIndexPath] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kFooterHeight;
}
@end
