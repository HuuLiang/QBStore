//
//  QBSSMSVerificationViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/27.
//
//

#import "QBSSMSVerificationViewController.h"
#import "QBSUser.h"

@interface QBSSMSVerificationViewController () <UITextFieldDelegate>
{
    UIButton *_okButton;
    UIButton *_sendVeriButton;
}
@property (nonatomic,retain) NSMutableArray<UITextField *> *veriCodes;
@property (nonatomic) NSString *replacingString;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic) NSInteger resendCountDownTime;
@end

@implementation QBSSMSVerificationViewController

DefineLazyPropertyInitialization(NSMutableArray, veriCodes)

- (instancetype)initWithPhoneNum:(NSString *)phoneNum {
    self = [super init];
    if (self) {
        _phoneNum = phoneNum;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"输入短信验证码";
    
    NSString *placeholder = @"输验证码";
    for (NSUInteger i = 0; i < 4; ++i) {
        UITextField *veriCode = [[UITextField alloc] init];
        veriCode.textAlignment = NSTextAlignmentCenter;
        veriCode.delegate = self;
        veriCode.textColor = [UIColor whiteColor];
        veriCode.font = [UIFont systemFontOfSize:36];
        veriCode.clearsOnBeginEditing = YES;
        veriCode.clearsOnInsertion = YES;
        veriCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[placeholder substringWithRange:NSMakeRange(i, 1)]
                                                                         attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
        veriCode.keyboardType = UIKeyboardTypeNumberPad;
        veriCode.returnKeyType = UIReturnKeyNext;
        [self.view addSubview:veriCode];
        {
            [veriCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.view).multipliedBy(0.5);
                make.centerX.equalTo(self.view).multipliedBy(0.4*(i+1));
            }];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextChangedNotification:) name:UITextFieldTextDidChangeNotification object:veriCode];
        [self.veriCodes addObject:veriCode];
        
        UIView *underline = [[UIView alloc] init];
        underline.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:underline];
        {
            [underline mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(veriCode.mas_bottom);
                make.centerX.equalTo(veriCode);
                make.width.equalTo(veriCode).multipliedBy(1.5);
                make.height.mas_equalTo(0.5);
            }];
        }
        
        @weakify(self);
        [veriCode aspect_hookSelector:@selector(deleteBackward) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo)
        {
            @strongify(self);
            UITextField *thisTextField = [aspectInfo instance];
            if (thisTextField.text.length == 0 && i > 0) {
//                self.veriCodes[i-1].text = nil;
                [self.veriCodes[i-1] becomeFirstResponder];
            }
        } error:nil];
    }
    
    _okButton = [[UIButton alloc] init];
    [_okButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF206F"]] forState:UIControlStateNormal];
    [_okButton setTitle:@"确认" forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [_okButton addTarget:self action:@selector(onOK) forControlEvents:UIControlEventTouchUpInside];
    _okButton.layer.cornerRadius = 5;
    _okButton.layer.masksToBounds = YES;
    _okButton.titleLabel.font = kBigFont;
    [self.view addSubview:_okButton];
    {
        [_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.veriCodes.firstObject.mas_bottom).offset(40);
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view).multipliedBy(0.8);
            make.height.mas_equalTo(44);
        }];
    }
    
    UIColor *disableColor = [UIColor colorWithHexString:@"#aaaaaa"];
    _sendVeriButton = [[UIButton alloc] init];
    _sendVeriButton.layer.cornerRadius = 5;
    _sendVeriButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _sendVeriButton.layer.borderWidth = 1;
    [_sendVeriButton setTitleColor:disableColor forState:UIControlStateDisabled];
    [_sendVeriButton addTarget:self action:@selector(onResendVerificationSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendVeriButton];
    {
        [_sendVeriButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_okButton.mas_bottom).offset(40);
            make.left.right.height.equalTo(_okButton);
        }];
    }
    
    [_sendVeriButton aspect_hookSelector:@selector(setEnabled:)
                             withOptions:AspectPositionAfter
                              usingBlock:^(id<AspectInfo> aspectInfo, BOOL enabled)
    {
        UIButton *thisButton = [aspectInfo instance];
        thisButton.layer.borderColor = enabled ? [UIColor whiteColor].CGColor : disableColor.CGColor;
    } error:nil];
    
    @weakify(self);
    [self.view bk_whenTapped:^{
        @strongify(self);
        [self.view endEditing:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self countDownTimerToResendSMS];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.veriCodes.firstObject becomeFirstResponder];
}

- (void)countDownTimerToResendSMS {
    @weakify(self);
    self.resendCountDownTime = 60;
    _sendVeriButton.enabled = NO;
    self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        @strongify(self);
        if (!self) {
            [timer invalidate];
            return ;
        }
        
        if (self.resendCountDownTime < 0) {
            [self.timer invalidate];
            self.timer = nil;
            [self->_sendVeriButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
            self->_sendVeriButton.enabled = YES;
        } else {
            [self->_sendVeriButton setTitle:[NSString stringWithFormat:@"%ld秒后重新发送验证码", (unsigned long)self.resendCountDownTime] forState:UIControlStateNormal];
            --self.resendCountDownTime;
        }
    } repeats:YES];
    [self.timer fire];
}

- (void)onOK {
    [self.view endEditing:YES];
    
    NSMutableString *veriCode = [NSMutableString string];
    __block BOOL veriCodeIsCompleted = YES;
    [self.veriCodes enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.text) {
            *stop = YES;
            veriCodeIsCompleted = NO;
        } else {
            [veriCode appendString:obj.text];
        }
    }];
    if (veriCode.length < 4) {
        veriCodeIsCompleted = NO;
    }
    if (!veriCodeIsCompleted) {
        [[QBSHUDManager sharedManager] showError:@"验证码未输全"];
        return ;
    }
    
    QBSUser *user = [[QBSUser alloc] init];
    user.mobile = self.phoneNum;
    user.userType = kQBSUserTypeNormal;
    user.veriCode = veriCode;
    
    @weakify(self);
    [[QBSHUDManager sharedManager] showLoading];
    [[QBSRESTManager sharedManager] request_loignWithUser:user completionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            user.userId = ((QBSUserLoginResponse *)obj).data;
            user.accessToken = ((QBSUserLoginResponse *)obj).accessToken;
            [user login];
            
            [self dismissViewControllerAnimated:YES completion:^{
                @strongify(self);
                SafelyCallBlock(self.completionHandler, YES);
            }];
        }
    }];
}

- (void)onResendVerificationSMS {
    @weakify(self);
    [[QBSHUDManager sharedManager] showLoading];
    [[QBSRESTManager sharedManager] request_sendSMSToMobile:self.phoneNum withCompletionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            [self countDownTimerToResendSMS];
        }
    }];
}

- (void)onTextChangedNotification:(NSNotification *)notification {
    UITextField *sender = notification.object;
    sender.text = self.replacingString;
    
    if (sender.text.length == 1) {
        [self switchToNextTextFieldWithCurrentTextField:sender repeat:NO];
    }
}

- (UIImage *)backgroundImage {
    return [UIImage QBS_imageWithResourcePath:@"login_background" ofType:@"jpg"];
}

- (BOOL)shouldUseBackgroundMask {
    return YES;
}

- (void)switchToNextTextFieldWithCurrentTextField:(UITextField *)textField repeat:(BOOL)repeat {
    NSUInteger index = [self.veriCodes indexOfObject:textField];
    if (index+1 < self.veriCodes.count) {
        [self.veriCodes[index+1] becomeFirstResponder];
    } else {
        if (repeat) {
            [self.veriCodes.firstObject becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
            
            [self onOK];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate,UITextInputDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self switchToNextTextFieldWithCurrentTextField:textField repeat:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length > 1) {
        string = [string substringWithRange:NSMakeRange(0, 1)];
    }
    
    if (string.length == 1) {
        if (![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
    }
    self.replacingString = string;
    return YES;
}
@end
