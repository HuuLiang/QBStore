//
//  QBSTreasureCommodityDetailViewController.m
//  QBStore
//
//  Created by Sean Yue on 2016/12/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSTreasureCommodityDetailViewController.h"

typedef NS_ENUM(NSUInteger, QBSTreasureSection) {
    QBSBannerSection,
    QBSTitleSection,
    QBSRewardSection,
    QBSInstructionSection,
    QBSDetailSection
};

@interface QBSTreasureCommodityDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@end

@implementation QBSTreasureCommodityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _layoutTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
