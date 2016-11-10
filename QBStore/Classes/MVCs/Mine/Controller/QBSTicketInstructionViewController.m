//
//  QBSTicketInstructionViewController.m
//  QBStore
//
//  Created by Sean Yue on 2016/11/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSTicketInstructionViewController.h"
#import "QBSTicketInstruction.h"

static NSString *const kCellReusableIdentifier = @"CellReusableIdentifier";

@interface QBSTicketInstructionViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@property (nonatomic,retain) NSArray<NSString *> *instructions;
@property (nonatomic,retain) NSMutableDictionary<NSIndexPath *, NSNumber *> *cellHeights;
@end

@implementation QBSTicketInstructionViewController

DefineLazyPropertyInitialization(NSMutableDictionary, cellHeights)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"礼券使用说明";
    
    _layoutTV = [[UITableView alloc] init];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _layoutTV.estimatedRowHeight = kScreenHeight;
    [_layoutTV registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTV QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadInstructions];
    }];
    [_layoutTV QBS_triggerPullToRefresh];
}

- (void)loadInstructions {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryActivityInstructionWithCompletionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutTV QBS_endPullToRefresh];
        
        if (obj) {
            self.instructions = ((QBSTicketInstruction *)obj).exUsageSpecList;
            
            [self.cellHeights removeAllObjects];
            for (NSUInteger i = 0; i < self.instructions.count; ++i) {
                [self.cellHeights setObject:@(kScreenHeight) forKey:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [self->_layoutTV reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instructions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReusableIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell.backgroundView) {
        cell.backgroundView = [[UIImageView alloc] init];
        cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        cell.backgroundView.clipsToBounds = YES;
    }
    
    if (indexPath.row < self.instructions.count) {
        NSString *url = self.instructions[indexPath.row];
        UIImageView *imageView = (UIImageView *)cell.backgroundView;
        
        @weakify(self);
        const CGFloat fullWidth = CGRectGetWidth(tableView.bounds);
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
                }
            }
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    return [self.cellHeights[cellIndexPath] floatValue];
}
@end
