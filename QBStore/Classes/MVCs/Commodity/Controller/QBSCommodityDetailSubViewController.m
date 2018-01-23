//
//  QBSCommodityDetailSubViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/18.
//
//

#import "QBSCommodityDetailSubViewController.h"
#import "HMSegmentedControl.h"
#import "QBSCommodityDetailDescriptionViewController.h"
#import "QBSCommodityDetailCommentViewController.h"
#import "QBSCommodityDetail.h"

typedef NS_ENUM(NSUInteger, QBSSegmentedSection) {
    QBSSegmentedSectionDescription,
    QBSSegmentedSectionComment
};

static const CGFloat kSegmentedControlHeight = 44;

@interface QBSCommodityDetailSubViewController ()
@property (nonatomic,retain) HMSegmentedControl *segmentedControl;
@property (nonatomic,retain,readonly) NSDictionary<NSNumber *, NSString *> *sectionNames;
@property (nonatomic,retain,readonly) NSDictionary<NSNumber *, UIViewController *> *viewControllers;
@property (nonatomic) QBSSegmentedSection currentSection;
@end

@implementation QBSCommodityDetailSubViewController
@synthesize sectionNames = _sectionNames;
@synthesize viewControllers = _viewControllers;

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
    
    [self.view addSubview:self.segmentedControl];
    {
        [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(kSegmentedControlHeight);
        }];
    }
    
    @weakify(self);
    self.segmentedControl.titleFormatter = ^NSAttributedString*(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        @strongify(self);
    
        NSDictionary *attrs = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                NSFontAttributeName:kMediumFont};
        if (index == QBSSegmentedSectionComment) {
            NSMutableAttributedString *commentAttrTitle = [[NSMutableAttributedString alloc] initWithString:title];
            [commentAttrTitle addAttributes:attrs range:NSMakeRange(0, 4)];
            if (title.length > 4 && self.commodityDetail.praisePercent) {
                [commentAttrTitle addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                                                  NSFontAttributeName:kSmallFont}
                                          range:NSMakeRange(5, title.length-5)];
            }
            return commentAttrTitle;
        } else {
            return [[NSAttributedString alloc] initWithString:title attributes:attrs];
        }
    };
    
    self.segmentedControl.indexChangeBlock = ^(NSInteger index) {
        @strongify(self);
        self.currentSection = index;
    };
    
    self.currentSection = QBSSegmentedSectionDescription;
}

- (HMSegmentedControl *)segmentedControl {
    if (_segmentedControl) {
        return _segmentedControl;
    }
    
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.sectionNames.allValues];
    _segmentedControl.selectionIndicatorColor = [UIColor redColor];
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorHeight = 3;
    return _segmentedControl;
}

- (NSDictionary<NSNumber *,NSString *> *)sectionNames {
    if (_sectionNames) {
        return _sectionNames;
    }
    
    _sectionNames = @{@(QBSSegmentedSectionDescription):@"宝贝详情",
                      @(QBSSegmentedSectionComment):@"宝贝评价"};
    return _sectionNames;
}

- (NSDictionary<NSNumber *,UIViewController *> *)viewControllers {
    if (_viewControllers) {
        return _viewControllers;
    }
    
    @weakify(self);
    QBSCommodityDetailDescriptionViewController *descVC = [[QBSCommodityDetailDescriptionViewController alloc] init];
    descVC.contentHeightChangedAction = ^(id obj) {
        @strongify(self);
        SafelyCallBlock(self.contentHeightChangedAction, self);
    };
    
    QBSCommodityDetailCommentViewController *commentVC = [[QBSCommodityDetailCommentViewController alloc] initWithCommodityId:self.commodityId];
    commentVC.contentHeightChangedAction = ^(id obj) {
        @strongify(self);
        SafelyCallBlock(self.contentHeightChangedAction, self);
    };
    
    _viewControllers = @{@(QBSSegmentedSectionDescription):descVC,
                         @(QBSSegmentedSectionComment):commentVC};
    return _viewControllers;
}

- (void)setCurrentSection:(QBSSegmentedSection)currentSection {
    _currentSection = currentSection;
    
    UIViewController *currentViewController = self.viewControllers[@(currentSection)];
    if (![self.childViewControllers containsObject:currentViewController]) {
        [self addChildViewController:currentViewController];
        
        if (![self.view.subviews containsObject:currentViewController.view]) {
            [self.view addSubview:currentViewController.view];
            {
                [currentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(self.view);
                    make.top.equalTo(_segmentedControl.mas_bottom);
                }];
            }
        }
        
        [currentViewController didMoveToParentViewController:self];
        
        SafelyCallBlock(self.contentHeightChangedAction, self);
    }
    
    [self.viewControllers enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj != currentViewController && [self.childViewControllers containsObject:obj]) {
            [obj willMoveToParentViewController:nil];
            [obj removeFromParentViewController];
            [obj.view removeFromSuperview];
        }
    }];
    
    if (currentSection == QBSSegmentedSectionDescription) {
        QBSCommodityDetailDescriptionViewController *descVC = (QBSCommodityDetailDescriptionViewController *)currentViewController;
        descVC.imageInfos = self.commodityDetail.detailList;
    }
}

- (void)setCommodityDetail:(QBSCommodityDetail *)commodityDetail {
    _commodityDetail = commodityDetail;
    
    NSNumber *praisePercent = commodityDetail.praisePercent;
    NSString *commentTitle = praisePercent ? [NSString stringWithFormat:@"宝贝评价(%@%%好评)", praisePercent] : @"宝贝评价";
    NSString *detailTitle = @"宝贝详情";
    self.segmentedControl.sectionTitles = @[detailTitle,commentTitle];
    //[self.segmentedControl setNeedsDisplay];
    
    if (self.currentSection == QBSSegmentedSectionDescription) {
        QBSCommodityDetailDescriptionViewController *descVC = (QBSCommodityDetailDescriptionViewController *)self.viewControllers[@(QBSSegmentedSectionDescription)];
        descVC.imageInfos = commodityDetail.detailList;
    }
    
    QBSCommodityDetailCommentViewController *commentVC = (QBSCommodityDetailCommentViewController *)self.viewControllers[@(QBSSegmentedSectionComment)];
    commentVC.shouldReloadData = YES;
}

- (CGFloat)contentHeight {
    UIViewController *currentViewController = self.viewControllers[@(self.currentSection)];
    if ([currentViewController conformsToProtocol:@protocol(QBSDynamicContentHeightDelegate)]) {
        id<QBSDynamicContentHeightDelegate> delegate = (id<QBSDynamicContentHeightDelegate>)currentViewController;
        return [delegate contentHeight] + kSegmentedControlHeight;
    }
    return kSegmentedControlHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
