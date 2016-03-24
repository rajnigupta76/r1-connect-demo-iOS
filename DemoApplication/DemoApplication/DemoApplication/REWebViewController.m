#import "REWebViewController.h"
#import "R1WebViewHelper.h"

@interface REWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation REWebViewController

- (id) initViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.navigationItem.title = @"Web View";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (![R1WebViewHelper webView:webView shouldStartLoadWithRequest:request navigationType:navigationType])
        return NO;
    
    // Your code here
    
    return YES;
}

@end
