//
//  QBSUserViewController.m
//  Pods
//
//  Created by Sean Yue on 16/8/4.
//
//

#import "QBSUserViewController.h"

@interface QBSUserViewController ()

@end

@implementation QBSUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[self backgroundImage]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.frame = self.view.bounds;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backgroundImageView];
    {
//        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
    }
    
    if ([self shouldUseBackgroundMask]) {
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:maskView];
        {
            [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
    }
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage QBS_imageWithResourcePath:@"close"]
                                                                                 style:UIBarButtonItemStylePlain
                                                                               handler:^(id sender)
    {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            [self onCloseCompleted];
        }];
    }];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)onCloseCompleted {
    SafelyCallBlock(self.completionHandler, NO);
}

- (UIImage *)backgroundImage {
    return nil;
}

- (BOOL)shouldUseBackgroundMask {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
