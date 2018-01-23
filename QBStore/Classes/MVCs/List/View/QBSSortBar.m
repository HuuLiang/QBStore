//
//  QBSSortBar.m
//  Pods
//
//  Created by Sean Yue on 16/7/12.
//
//

#import "QBSSortBar.h"
#import "QBSSortButton.h"

@implementation QBSSortBarItem

+ (instancetype)itemWithName:(NSString *)name hasSortMode:(BOOL)hasSortMode {
    QBSSortBarItem *item = [[self alloc] init];
    item.name = name;
    item.hasSortMode = hasSortMode;
    return item;
}
@end

@interface QBSSortBar () <QBSSortButtonDelegate>
@property (nonatomic,retain) NSMutableArray<QBSSortButton *> *sortButtons;
@end

@implementation QBSSortBar

DefineLazyPropertyInitialization(NSMutableArray, sortButtons)

- (instancetype)initWithItems:(NSArray<QBSSortBarItem *> *)items delegate:(id<QBSSortBarDelegate>)delegate {
    self = [super init];
    if (self) {
        _items = items;
        _delegate = delegate;
        _selectedIndex = NSNotFound;
        
        [items enumerateObjectsUsingBlock:^(QBSSortBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QBSSortButton *button = [QBSSortButton buttonWithTitle:obj.name hasSortMode:obj.hasSortMode delegate:self];
            [button addTarget:self action:@selector(onSortButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.sortButtons addObject:button];
            [self addSubview:button];
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.sortButtons.count == 0) {
        return ;
    }
    
    const CGFloat fullWidth = CGRectGetWidth(self.bounds);
    const CGFloat fullHeight = CGRectGetHeight(self.bounds);
    
    const CGFloat itemWidth = fullWidth / self.sortButtons.count;
    const CGFloat itemHeight = fullHeight;
    
    CGRect frame = CGRectMake(0, 0, itemWidth, itemHeight);
    [self.sortButtons enumerateObjectsUsingBlock:^(QBSSortButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectOffset(frame, idx * itemWidth, 0);
    }];
}

- (void)onSortButton:(QBSSortButton *)sortButton {
    if (sortButton.selected) {
        sortButton.sortMode = sortButton.sortMode == QBSSortModeAscending ? QBSSortModeDescending:QBSSortModeAscending;
    } else {
        sortButton.selected = YES;
        
        [self.sortButtons enumerateObjectsUsingBlock:^(QBSSortButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj != sortButton && obj.selected) {
                obj.selected = NO;
            }
        }];
    }
    
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex < self.sortButtons.count) {
        _selectedIndex = selectedIndex;
        [self onSortButton:self.sortButtons[selectedIndex]];
    }
}

#pragma mark - QBSSortButtonDelegate

- (void)sortButton:(QBSSortButton *)sortButton didChangeSortMode:(QBSSortMode)sortMode {
    if ([self.delegate respondsToSelector:@selector(sortBar:didChangeSortMode:atItemIndex:)]) {
        NSUInteger index = [self.sortButtons indexOfObject:sortButton];
        if (index != NSNotFound && index < self.items.count) {
            [self.delegate sortBar:self didChangeSortMode:sortMode atItemIndex:index];
        }
    }
}
@end
