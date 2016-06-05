//
//  ViewController.m
//  WebViewExample
//
//  Created by Brokmeier, Pascal on 5/21/16.
//  Copyright © 2016 uts. All rights reserved.
//

#import "ViewController.h"
#import "WatchConnectivity/WatchConnectivity.h"

@interface ViewController ()<WCSessionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = _webViewContainer.frame;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"messageQueueToNative"];
    _webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];

    _webView.navigationDelegate = self;

    //configure a request URL to load
    NSString *startUrl = @"http://www.google.com";
    [self webViewTo:startUrl];
    [self urlChangedTo:startUrl];
    [_webViewContainer addSubview:_webView];
    
    //Start WCSession
    if([WCSession isSupported]){
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)webViewTo:(NSString *)url {
    NSURL *nsurl= [NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_webView loadRequest:nsrequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [_webView setBounds:_webViewContainer.bounds];
    [_webView setFrame:CGRectMake(0,0,_webView.bounds.size.width, _webView.bounds.size.height)];
    [_webView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//call to change the textField URL
- (void) urlChangedTo:(NSString *)newUrl{
    [_urlField setText:newUrl];
}

- (IBAction)urlFieldEditingDidEnd:(id)sender {
    UITextField *textField = sender;
    [self navigateToUrl:textField.text];
}

- (IBAction)navigateToUrl:(id)sender {
    [self webViewTo:_urlField.text];
}


- (IBAction)navigateBack:(id)sender {
    [_webView goBack];
}

- (IBAction)navigateForward:(id)sender{
    [_webView goForward];
}

- (IBAction)savetoFavourite:(id)sender{
    NSString *favouriteURL = _urlField.text;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:favouriteURL forKey:@"favouriteURL"];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

/**
 * takes messages from the webview
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    NSString * msgString = [NSString stringWithFormat:@"%@", message.body];
    
    //create a controller for the alert box
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msgString preferredStyle:UIAlertControllerStyleAlert];
    //add an ok action to it
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];

    //show the modal
    [self presentViewController:alert animated:NO completion:nil];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSString *url = _webView.URL.absoluteString;
    [_urlField setText:url];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self sendCurrentURL:_urlField.text];
}

/**
 * get command from watch
 */
- (void)session:(nonnull WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * __nonnull))replyHandler {
    NSString *cmdValue = [message objectForKey:@"cmdValue"];
    if([cmdValue isEqualToString:@"Back"]){
        [_webView goBack];
    }
    else if([cmdValue isEqualToString:@"Forward"]){
        [_webView goForward];
    }
    else if([cmdValue isEqualToString:@"Refresh"]){
        [_webView reload];
    }
    else if([cmdValue isEqualToString:@"Favourite"]){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *favouriteURL = [prefs stringForKey:@"favouriteURL"];
        [self webViewTo:favouriteURL];
    }
    else{
    }
}

/**
 * send url to watch
 */
- (void)sendCurrentURL: (NSString*)url{
    NSString *urlString = url;
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[urlString] forKeys:@[@"url"]];
    
    [[WCSession defaultSession] sendMessage:applicationData
                               replyHandler:^(NSDictionary *reply) {
                                   //handle reply from iPhone app here
                               }
                               errorHandler:^(NSError *error) {
                                   //catch any errors here
                               }
     ];
}


@end
