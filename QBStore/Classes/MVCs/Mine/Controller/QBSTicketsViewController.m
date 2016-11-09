//
//  QBSTicketsViewController.m
//  QBStore
//
//  Created by Sean Yue on 2016/11/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSTicketsViewController.h"
#import "QBSTicketCell.h"
#import "QBSTicketAppCell.h"
#import "QBSTicket.h"

static NSString *const kTicketCellReusableIdentifier = @"TicketCellReusableIdentifier";
static NSString *const kTicketAppReusableIdentifier = @"TicketAppReusableIdentifier";

typedef NS_ENUM(NSUInteger, QBSTicketSection) {
    QBSTicketCardSection,
    QBSTicketAppSection
};

@interface QBSTicketsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_layoutTV;
}
@property (nonatomic,retain) NSMutableArray *sections;
@property (nonatomic,retain) NSArray<QBSTicket *> *tickets;
@end

@implementation QBSTicketsViewController

DefineLazyPropertyInitialization(NSMutableArray, sections)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动礼券";
    
    _layoutTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _layoutTV.backgroundColor = self.view.backgroundColor;
    _layoutTV.delegate = self;
    _layoutTV.dataSource = self;
    _layoutTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _layoutTV.sectionFooterHeight = 0;
    [_layoutTV registerClass:[QBSTicketCell class] forCellReuseIdentifier:kTicketCellReusableIdentifier];
    [_layoutTV registerClass:[QBSTicketAppCell class] forCellReuseIdentifier:kTicketAppReusableIdentifier];
    [self.view addSubview:_layoutTV];
    {
        [_layoutTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, kLeftRightContentMarginSpacing, 0, kLeftRightContentMarginSpacing));
        }];
    }
    
    @weakify(self);
    [_layoutTV QBS_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadTickets];
    }];
    [_layoutTV QBS_triggerPullToRefresh];
}

- (void)loadTickets {
    @weakify(self);
    [[QBSRESTManager sharedManager] request_queryActivityTicketsWithCompletionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutTV QBS_endPullToRefresh];
        
        if (obj) {
            self.tickets = ((QBSTicketList *)obj).exchangeList;
            [self decideSections];
            [self->_layoutTV reloadData];
        }
    }];
}

- (void)decideSections {
    [self.sections removeAllObjects];
    [self.tickets enumerateObjectsUsingBlock:^(QBSTicket * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.sections addObject:@(QBSTicketCardSection)];
        
        if (obj.appStoreInfo) {
            [self.sections addObject:@(QBSTicketAppSection)];
        }
    }];
}

- (BOOL)isViewControllerDependsOnUserLogin {
    return YES;
}

- (NSUInteger)ticketIndexInSection:(NSUInteger)section {
    __block NSUInteger ticketIndex = NSNotFound;
    if (section < self.sections.count) {
        [self.sections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > section) {
                *stop = YES;
                return ;
            }
            
            if ([obj unsignedIntegerValue] == QBSTicketCardSection) {
                if (ticketIndex == NSNotFound) {
                    ticketIndex = 0;
                } else {
                    ++ticketIndex;
                }
            }
        }];
    }
    return ticketIndex;
}

- (void)ticketCell:(QBSTicketCell *)ticketCell didFetchTicket:(QBSTicket *)ticket {
    ticketCell.header = ticket.appStoreInfo.title;
    ticketCell.footer = [NSString stringWithFormat:@"券码(长按复制)：%@", ticket.exchangeCode];
    [ticketCell switchCardSide:YES withBackgroundImageURL:[NSURL URLWithString:ticket.imgUrlAfterReceive] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.sections.count) {
        return nil;
    }
    
    QBSTicketSection sectionType = [self.sections[indexPath.section] unsignedIntegerValue];
    
    if (sectionType == QBSTicketCardSection) {
        QBSTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:kTicketCellReusableIdentifier forIndexPath:indexPath];
        cell.backgroundColor = tableView.backgroundColor;
        
        const NSUInteger ticketIndex = [self ticketIndexInSection:indexPath.section];
        QBSTicket *ticket = ticketIndex == NSNotFound ? nil : self.tickets[ticketIndex];
        
        cell.isFront = ticket.exchangeStatus.unsignedIntegerValue == QBSTicketStatusFetched || ticket.exchangeStatus.unsignedIntegerValue == QBSTicketStatusActivated;
        cell.title = ticket.payPointName;

        if (ticket.exchangeStatus.unsignedIntegerValue == QBSTicketStatusNotFetched) {
            NSString *expenseString = ticket.minimalExpense.integerValue > 0 ? [NSString stringWithFormat:@"购物满%ld元", ticket.minimalExpense.unsignedIntegerValue/100] : @"购买任意商品";
            cell.subtitle = [NSString stringWithFormat:@"即日起，用户%@即可免费获得价值%ld元的“%@”%@。", expenseString, ticket.originalPrice.unsignedIntegerValue /100, ticket.appStoreInfo.title, ticket.payPointName];
            cell.backgroundImageURL = [NSURL URLWithString:ticket.imgUrlBeforeReceive];
        } else {
            cell.header = ticket.appStoreInfo.title;
            cell.footer = [NSString stringWithFormat:@"券码(长按复制)：%@", ticket.exchangeCode];
            cell.backgroundImageURL = [NSURL URLWithString:ticket.imgUrlAfterReceive];
        }
        return cell;
    } else if (sectionType == QBSTicketAppSection) {
        QBSTicketAppCell *cell = [tableView dequeueReusableCellWithIdentifier:kTicketAppReusableIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        const NSUInteger ticketIndex = [self ticketIndexInSection:indexPath.section];
        QBSTicket *ticket = ticketIndex == NSNotFound ? nil : self.tickets[ticketIndex];
        
        cell.title = ticket.appStoreInfo.title;
        cell.detail = ticket.appStoreInfo.desc;
        cell.imageURL = [NSURL URLWithString:ticket.appStoreInfo.imgUrl];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.sections.count) {
        return 0;
    }
    
    QBSTicketSection sectionType = [self.sections[indexPath.section] unsignedIntegerValue];
    if (sectionType == QBSTicketCardSection) {
        return CGRectGetWidth(tableView.bounds) *0.63;
    } else if (sectionType == QBSTicketAppSection) {
        return CGRectGetWidth(tableView.bounds) * 0.3;
    } else {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= self.sections.count) {
        return 0;
    }
    
    QBSTicketSection sectionType = [self.sections[section] unsignedIntegerValue];
    if (sectionType == QBSTicketCardSection) {
        return 15;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section >= self.sections.count) {
        return ;
    }
    
    QBSTicketSection sectionType = [self.sections[indexPath.section] unsignedIntegerValue];
    const NSUInteger ticketIndex = [self ticketIndexInSection:indexPath.section];
    QBSTicket *ticket = ticketIndex == NSNotFound ? nil : self.tickets[ticketIndex];
    if (sectionType == QBSTicketCardSection) {
        QBSTicketCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (ticket.exchangeStatus.unsignedIntegerValue == QBSTicketStatusNotFetched) {
            @weakify(self);
            [[QBSHUDManager sharedManager] showLoading];
            [[QBSRESTManager sharedManager] request_fetchActivityTicketNoWithTicket:ticket completionHandler:^(id obj, NSError *error) {
                @strongify(self);
                QBSHandleError(error);
                
                if (!self) {
                    return ;
                }
                
                if (obj) {
                    QBSTicketFetchResponse *resp = obj;
                    if (resp.userExchangeVoucherInfo.exchangeStatus.unsignedIntegerValue == QBSTicketStatusFetched) {
                        ticket.exchangeCode = resp.userExchangeVoucherInfo.exchangeCode;
                        ticket.exchangeStatus = @(QBSTicketStatusFetched);
                        [self ticketCell:cell didFetchTicket:ticket];
                    }
                }
            }];
        }
    } else if (sectionType == QBSTicketAppSection) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ticket.appStoreInfo.downloadUrl]];
    }
}
@end
