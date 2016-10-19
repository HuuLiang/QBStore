//
//  QBSCommodityDetailDescriptionViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/11.
//
//

#import "QBSCommodityDetailDescriptionViewController.h"
#import "QBSCommodityDetail.h"

static NSString *const kCommodityDetailCellReusableIdentifier = @"CommodityDetailCellReusableIdentifier";
static const CGFloat kDefaultCellHeight = 100;

@interface QBSCommodityDetailDescriptionViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@property (nonatomic,retain) NSMutableDictionary<NSIndexPath *, NSNumber *> *cellHeights;
@end

@implementation QBSCommodityDetailDescriptionViewController

DefineLazyPropertyInitialization(NSMutableDictionary, cellHeights)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _layoutTV = [[UITableView alloc] init];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _layoutTV.scrollEnabled = NO;
    [_layoutTV registerClass:[UITableViewCell class] forCellReuseIdentifier:kCommodityDetailCellReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)setImageInfos:(NSArray<QBSCommodityImageInfo *> *)imageInfos {
    _imageInfos = imageInfos;
    
    for (NSUInteger i = 0; i < imageInfos.count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.cellHeights setObject:@(kDefaultCellHeight) forKey:indexPath];
    }
    
    [_layoutTV reloadData];
}

- (CGFloat)contentHeight {
    __block CGFloat contentHeight = 0;
    [self.cellHeights enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        contentHeight += obj.floatValue;
    }];
    
    if (contentHeight == 0) {
        contentHeight = self.imageInfos.count * kDefaultCellHeight;
    }
    return contentHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommodityDetailCellReusableIdentifier forIndexPath:indexPath];
    cell.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell.backgroundView) {
        cell.backgroundView = [[UIImageView alloc] init];
        cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        cell.backgroundView.clipsToBounds = YES;
    }
    
    if (indexPath.row < self.imageInfos.count) {
        @weakify(self);
        const CGFloat fullWidth = CGRectGetWidth(tableView.bounds);
        UIImageView *imageView = (UIImageView *)cell.backgroundView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageInfos[indexPath.row].imgUrl]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            @strongify(self);
            if (!self) {
                return ;
            }
            
            if (image) {
                NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                NSNumber *cellHeight = [self.cellHeights objectForKey:cellIndexPath];
                const CGFloat newHeight = image.size.width == 0 ? 0 : fullWidth * image.size.height / image.size.width;
                if (cellHeight.floatValue != newHeight) {
                    [self.cellHeights setObject:@(newHeight)
                                         forKey:cellIndexPath];
                    if ([self->_layoutTV cellForRowAtIndexPath:cellIndexPath]) {
                        [self->_layoutTV reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    
                    SafelyCallBlock(self.contentHeightChangedAction, self);
                }
                
            }
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    NSNumber *cellHeight = self.cellHeights[cellIndexPath];
    return cellHeight.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDefaultCellHeight;
}
@end
