//
//  QBSSMSVerificationViewController.h
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import "QBSUserViewController.h"

@interface QBSSMSVerificationViewController : QBSUserViewController

@property (nonatomic,retain,readonly) NSString *phoneNum;

- (instancetype)init __attribute__((unavailable("Use initWithPhoneNum: instead")));
- (instancetype)initWithPhoneNum:(NSString *)phoneNum;

@end
