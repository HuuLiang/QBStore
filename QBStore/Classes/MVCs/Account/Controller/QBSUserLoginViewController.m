//
//  QBSUserLoginViewController.m
//  Pods
//
//  Created by Sean Yue on 16/7/26.
//
//

#import "QBSUserLoginViewController.h"
#import "QBSPhoneTextField.h"
#import "QBSWeChatLoginButton.h"
#import "QBSWeChatHelper.h"
#import "QBSWeChatUser.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "QBSSMSVerificationViewController.h"

#import "QBSNavigationController.h"
#import "QBSWebViewController.h"

static const CGFloat kNumberOfPhoneText = 11;

@interface QBSUserLoginViewController () <UITextFieldDelegate>
{
    TPKeyboardAvoidingScrollView *_scrollView;
    QBSPhoneTextField *_phoneTextField;
    UILabel *_promptLabel;
    UIButton *_agreementButton;
}
@end

@implementation QBSUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登 录";

    _scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    [self.view addSubview:_scrollView];
    {
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    _phoneTextField = [[QBSPhoneTextField alloc] init];
    _phoneTextField.delegate = self;
    _phoneTextField.font = kExtraBigFont;
    [_scrollView addSubview:_phoneTextField];
    {
        [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_scrollView).multipliedBy(0.4);
            make.centerX.equalTo(_scrollView);
            make.width.equalTo(_scrollView).multipliedBy(0.75);
            make.height.mas_equalTo(50);
        }];
    }
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    [_scrollView addSubview:sepView];
    {
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_phoneTextField.mas_bottom);
            make.left.equalTo(_phoneTextField).offset(-15);
            make.right.equalTo(_phoneTextField).offset(15);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    _promptLabel = [[UILabel alloc] init];
    _promptLabel.textColor = [UIColor redColor];
    _promptLabel.font = kMediumFont;
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_promptLabel];
    {
        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(sepView);
            make.top.equalTo(sepView.mas_bottom);
            make.height.mas_equalTo(30);
        }];
    }
    
    _agreementButton = [[UIButton alloc] init];
    _agreementButton.titleLabel.font = kSmallFont;
    _agreementButton.titleLabel.numberOfLines = 2;
    _agreementButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"确认登录即表示您已经同意以下协议\n" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"《勃士生用户协议》" attributes:@{NSUnderlineStyleAttributeName:@1, NSUnderlineColorAttributeName:[UIColor redColor], NSForegroundColorAttributeName:[UIColor redColor]}]];
    
    [_agreementButton setAttributedTitle:attrString forState:UIControlStateNormal];
    [_agreementButton addTarget:self action:@selector(onAgreement) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_agreementButton];
    {
        [_agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_scrollView);
            make.top.equalTo(_promptLabel.mas_bottom);
        }];
    }

    UIButton *okButton = [[UIButton alloc] init];
    [okButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF206F"]] forState:UIControlStateNormal];
    [okButton setTitle:@"确认" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [okButton addTarget:self action:@selector(onOK) forControlEvents:UIControlEventTouchUpInside];
    okButton.layer.cornerRadius = 5;
    okButton.layer.masksToBounds = YES;
    okButton.titleLabel.font = kBigFont;
    [_scrollView addSubview:okButton];
    {
        [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_scrollView);
            make.top.equalTo(_agreementButton.mas_bottom).offset(10);
            make.width.equalTo(_phoneTextField);
            make.height.mas_equalTo(44);
        }];
    }
    
    UILabel *thirdPartyLoginLabel = [[UILabel alloc] init];
    thirdPartyLoginLabel.textColor = [UIColor whiteColor];
    thirdPartyLoginLabel.font = kMediumFont;
    thirdPartyLoginLabel.text = @"或使用微信登录";
    [_scrollView addSubview:thirdPartyLoginLabel];
    {
        [thirdPartyLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_scrollView);
            make.top.equalTo(okButton.mas_bottom).offset(20);
        }];
    }
    
    QBSWeChatLoginButton *wechatLogin = [[QBSWeChatLoginButton alloc] init];
    wechatLogin.layer.cornerRadius = okButton.layer.cornerRadius;
    wechatLogin.layer.masksToBounds = YES;
    [wechatLogin addTarget:self action:@selector(onWeChatLogin) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:wechatLogin];
    {
        [wechatLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(okButton);
            make.top.equalTo(thirdPartyLoginLabel.mas_bottom).offset(20);
        }];
    }
    
    @weakify(self);
    [self.view bk_whenTapped:^{
        @strongify(self);
        [self->_phoneTextField resignFirstResponder];
    }];
}

- (void)onAgreement {
    @weakify(self);
    QBSWebViewController *webVC = [[QBSWebViewController alloc] initWithURL:[NSURL URLWithString:[kQBSRESTBaseURL stringByAppendingString:kQBSUserAgreementURL]]];
    webVC.title = @"用户协议";
    webVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"关闭" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    QBSNavigationController *nav = [[QBSNavigationController alloc] initWithRootViewController:webVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (UIImage *)backgroundImage {
    return [UIImage QBS_imageWithResourcePath:@"login_background" ofType:@"jpg"];
}

- (BOOL)shouldUseBackgroundMask {
    return YES;
}

- (void)onOK {
    if (_phoneTextField.text.length != kNumberOfPhoneText || ![_phoneTextField.text hasPrefix:@"1"]) {
        _promptLabel.text = @"请输入正确的手机号码！";
        [_phoneTextField becomeFirstResponder];
        return ;
    }

    @weakify(self);
    [[QBSHUDManager sharedManager] showLoading];
    [[QBSRESTManager sharedManager] request_sendSMSToMobile:_phoneTextField.text withCompletionHandler:^(id obj, NSError *error) {
        QBSHandleError(error);
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            QBSSMSVerificationViewController *smsVC = [[QBSSMSVerificationViewController alloc] initWithPhoneNum:_phoneTextField.text];
            smsVC.completionHandler = self.completionHandler;
            [self.navigationController pushViewController:smsVC animated:YES];
        }
    }];
}

- (void)onWeChatLogin {
    [[QBSWeChatHelper sharedHelper] registerAppId:kQBSWeChatAppId secrect:kQBSWeChatSecret];

    @weakify(self);
    [[QBSWeChatHelper sharedHelper] loginInViewController:self withCompletionHandler:^(id obj, NSError *error) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        if (obj) {
            QBSUser *user = [QBSUser userFromWeChat:obj];
            [[QBSRESTManager sharedManager] request_loignWithUser:user completionHandler:^(id obj, NSError *error) {
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
                } else {
                    error.qbsErrorMessage = [NSString stringWithFormat:@"微信登录失败：%@", error.qbsErrorMessage];
                    QBSHandleError(error);
                }
            }];
        } else {
            QBSHandleError(error);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_phoneTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _promptLabel.text = nil;
    
    if (textField.text.length - range.length + string.length > kNumberOfPhoneText) {
        return NO;
    }
    return YES;
}

@end
