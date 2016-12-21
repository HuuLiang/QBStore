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
@property (nonatomic,retain) NSMutableDictionary<NSIndexPath *, UIImage *> *images;
@end

@implementation QBSCommodityDetailDescriptionViewController

DefineLazyPropertyInitialization(NSMutableDictionary, images)

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
    
    UIImage *placeholderImage = [UIImage imageNamed:@"commodity_placeholder_2_1"];
    NSMutableDictionary<NSIndexPath *, UIImage *> *addedPlaceholderImages = [NSMutableDictionary dictionary];
    for (NSUInteger i = 0; i < imageInfos.count; ++i) {
        [addedPlaceholderImages setObject:placeholderImage forKey:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.images enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, UIImage * _Nonnull obj, BOOL * _Nonnull stop) {
        [addedPlaceholderImages removeObjectForKey:key];
    }];
    
    [self.images addEntriesFromDictionary:addedPlaceholderImages];
    [_layoutTV reloadData];
    
    @weakify(self);
    [imageInfos enumerateObjectsUsingBlock:^(QBSCommodityImageInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:obj.imgUrl]
                                                        options:0
                                                       progress:nil
                                                      completed:^(UIImage *image,
                                                                  NSError *error,
                                                                  SDImageCacheType cacheType,
                                                                  BOOL finished,
                                                                  NSURL *imageURL)
        {
            @strongify(self);
            if (!self) {
                return ;
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            
            if (!image) {
                image = [UIImage imageNamed:@"commodity_error_load"];
            }
            [self.images setObject:image forKey:indexPath];
            
            if ([self->_layoutTV cellForRowAtIndexPath:indexPath]) {
                [self->_layoutTV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }];
}

- (CGFloat)contentHeight {
    __block CGFloat contentHeight = 0;
    [self.images enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, UIImage * _Nonnull obj, BOOL * _Nonnull stop) {
        CGFloat imageHeight = obj.size.width == 0 ? 0 : CGRectGetWidth(self.view.bounds) * obj.size.height / obj.size.width;
        contentHeight += imageHeight;
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
    
    UIImageView *imageView = (UIImageView *)cell.backgroundView;
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    UIImage *image = self.images[cellIndexPath];
    imageView.image = image;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    const CGFloat fullWidth = CGRectGetWidth(self.view.bounds);
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    UIImage *image = self.images[cellIndexPath];
    if (!image || image.size.width == 0) {
        return 0;
    }
    
    return fullWidth * image.size.height / image.size.width;
}

@end
