//
//  QBSTicketCell.m
//  QBStore
//
//  Created by Sean Yue on 2016/11/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSTicketCell.h"
#import "QBSTicketCard.h"

@interface QBSTicketCell () <CAAnimationDelegate>
@property (nonatomic,retain) QBSTicketCard *frontCard;
@property (nonatomic,retain) QBSTicketCard *backCard;
@property (nonatomic,retain,readonly) QBSTicketCard *currentCard;
@property (nonatomic,retain,readonly) QBSTicketCard *theOtherCard;
@end

@implementation QBSTicketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setIsFront:NO];
        
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [self addGestureRecognizer:longPressGes];
    }
    return self;
}

- (void)onLongPress:(UILongPressGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        SafelyCallBlock(self.longPressAction, self);
    }
}

- (QBSTicketCard *)frontCard {
    if (_frontCard) {
        return _frontCard;
    }
    
    _frontCard = [QBSTicketCard frontSidedCard];
    return _frontCard;
}

- (QBSTicketCard *)backCard {
    if (_backCard) {
        return _backCard;
    }
    
    _backCard = [QBSTicketCard backSidedCard];
    return _backCard;
}

- (QBSTicketCard *)currentCard {
    return self.isFront ? self.frontCard : self.backCard;
}

- (QBSTicketCard *)theOtherCard {
    return self.isFront ? _backCard : _frontCard;
}

- (void)switchCardSide:(BOOL)isFrontSide withBackgroundImageURL:(NSURL *)backgroundImageURL animated:(BOOL)animated {
    _isFront = isFrontSide;
    
    self.backgroundImageURL = backgroundImageURL;
    
    self.currentCard.title = _title;
    self.currentCard.subtitle = _subtitle;
    self.currentCard.header = _header;
    self.currentCard.footer = _footer;
    
    if (![self.subviews containsObject:self.currentCard]) {
        if (animated && self.theOtherCard) {
            [self.layer addAnimation:[self rotationAnimationFromAngle:0 toAngle:M_PI_2 withTimingFunctionName:kCAMediaTimingFunctionEaseIn]
                              forKey:@"oldAnimation"];
            
        } else {
            [self addSubview:self.currentCard];
            {
                [self.currentCard mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self);
                }];
            }
            
            [self.theOtherCard removeFromSuperview];
        }
    }
}

- (CABasicAnimation *)rotationAnimationFromAngle:(CGFloat)fromAngle toAngle:(CGFloat)toAngle withTimingFunctionName:(NSString *)timingFunctionName {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @(fromAngle);
    animation.toValue = @(toAngle);
    animation.duration = 0.5;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
    return animation;
}

- (void)setIsFront:(BOOL)isFront {
    [self switchCardSide:isFront withBackgroundImageURL:_backgroundImageURL animated:NO];
}

- (void)setBackgroundImageURL:(NSURL *)backgroundImageURL {
    _backgroundImageURL = backgroundImageURL;
    
    self.currentCard.backgroundImageURL = backgroundImageURL;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.currentCard.title = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    self.currentCard.subtitle = subtitle;
}

- (void)setHeader:(NSString *)header {
    _header = header;
    self.currentCard.header = header;
}

- (void)setFooter:(NSString *)footer {
    _footer = footer;
    self.currentCard.footer = footer;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self.layer animationForKey:@"oldAnimation"] == anim) {
        [self.layer removeAnimationForKey:@"oldAnimation"];
        
        [self.theOtherCard removeFromSuperview];

        [self addSubview:self.currentCard];
        {
            [self.currentCard mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        [self.currentCard.layer addAnimation:[self rotationAnimationFromAngle:-M_PI_2 toAngle:0 withTimingFunctionName:kCAMediaTimingFunctionEaseOut] forKey:@"newAnimation"];
    } else {
        [self.layer removeAllAnimations];
    }
}
@end
