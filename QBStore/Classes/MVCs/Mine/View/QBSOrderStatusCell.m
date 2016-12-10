//
//  QBSOrderStatusCell.m
//  QBStore
//
//  Created by ylz on 2016/12/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSOrderStatusCell.h"
#import "QBSOrderStatusButton.h"

@implementation QBSorderStatusModel

+ (instancetype)creatOrderStatusModelWithTitle:(NSString *)title image:(NSString *)image {
    QBSorderStatusModel *model = [[QBSorderStatusModel alloc] init];
    model.image = image;
    model.title = title;
    return model;
}

@end


@interface QBSOrderStatusCell ()

@property (nonatomic,retain) NSMutableArray <QBSOrderStatusButton *>*statusBtns;

@end

@implementation QBSOrderStatusCell
DefineLazyPropertyInitialization(NSMutableArray, statusBtns)

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setModels:(NSArray<QBSorderStatusModel *> *)models {
    _models = models;
    if (self.statusBtns.count == 0) {
        for (QBSorderStatusModel *model in models) {
        QBSOrderStatusButton *statusBtn = [[QBSOrderStatusButton alloc] init];
            [statusBtn setImage:[UIImage imageNamed:model.image] forState:UIControlStateNormal];
            [statusBtn setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
            [statusBtn setTitle:model.title forState:UIControlStateNormal];
            [statusBtn addTarget:self action:@selector(statusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:statusBtn];
            [self.statusBtns addObject:statusBtn];
        }
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.statusBtns.count != 0) {
        CGFloat btnWidth = kScreenWidth / self.statusBtns.count;
        for (int i = 0; i<self.statusBtns.count; i++) {
            QBSOrderStatusButton *btn = self.statusBtns[i];
            btn.frame = CGRectMake(i *btnWidth,0, btnWidth, CGRectGetHeight(self.bounds));
        }
        
    }
}

- (void)statusBtnClick:(UIButton *)sender {
    if (self.orderStatusAction) {
        self.orderStatusAction(sender);
    }
}

@end
