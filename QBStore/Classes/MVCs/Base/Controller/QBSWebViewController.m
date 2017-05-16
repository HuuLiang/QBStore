//
//  QBSWebViewController.m
//  Pods
//
//  Created by Sean Yue on 2016/10/21.
//
//

#import "QBSWebViewController.h"
#import "MBProgressHUD.h"
@import WebKit;

@interface QBSWebViewController ()
@property (nonatomic,retain) NSURL *url;
@end

@implementation QBSWebViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL useWKWebView = NSClassFromString(@"WKWebView") != nil;
    UIView *webView;
    
    if (useWKWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        webView = wkWebView;
        
    } else {
        UIWebView *uiWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        uiWebView.scalesPageToFit = YES;
        webView = uiWebView;
    }
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:webView];
    
    if ([webView respondsToSelector:@selector(loadRequest:)]) {
        [webView performSelector:@selector(loadRequest:) withObject:[NSURLRequest requestWithURL:self.url]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
