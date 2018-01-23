//
//  QBSUserProfileViewController.m
//  Pods
//
//  Created by Sean Yue on 16/8/4.
//
//

#import "QBSUserProfileViewController.h"
#import "QBSUser.h"

@interface QBSUserProfileViewController ()
{
    UIButton *_avatarButton;
    UILabel *_nameLabel;
    UIButton *_logoutButton;
}
@end

@implementation QBSUserProfileViewController

- (instancetype)initWithLogoutAction:(QBSAction)logoutAction {
    self = [super init];
    if (self) {
        _logoutAction = logoutAction;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    
    _avatarButton = [[UIButton alloc] init];
    _avatarButton.forceRoundCorner = YES;
    [_avatarButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#efefef"]] forState:UIControlStateNormal];
    [_avatarButton sd_setImageWithURL:[NSURL URLWithString:[QBSUser currentUser].logoUrl]
                             forState:UIControlStateNormal
                     placeholderImage:[UIImage QBS_imageWithResourcePath:@"avatar_placeholder"]];
    [self.view addSubview:_avatarButton];
    {
        [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).multipliedBy(0.5);
            make.width.equalTo(self.view).multipliedBy(0.25);
            make.height.equalTo(_avatarButton.mas_width);
        }];
    }
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = [[QBSUser currentUser].userType isEqualToString:kQBSUserTypeNormal] ? [QBSUser currentUser].mobile : [QBSUser currentUser].name;
    _nameLabel.font = kExtraBigFont;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nameLabel];
    {
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarButton.mas_bottom).offset(kScreenHeight*0.03);
            make.left.right.equalTo(self.view);
        }];
    }
    
    _logoutButton = [[UIButton alloc] init];
    _logoutButton.titleLabel.font = kBigFont;
    _logoutButton.layer.cornerRadius = 5;
    _logoutButton.layer.borderWidth = 1;
    _logoutButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [_logoutButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateHighlighted];
    [self.view addSubview:_logoutButton];
    {
        [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(self.view).multipliedBy(0.8);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(self.view.mas_centerY).multipliedBy(1.75);
        }];
    }
    
    @weakify(self);
    [_logoutButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self onLogout];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (UIImage *)backgroundImage {
    return [UIImage QBS_imageWithResourcePath:@"profile_background" ofType:@"jpg"];
}

- (void)onLogout {
    SafelyCallBlock(self.logoutAction, self);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
