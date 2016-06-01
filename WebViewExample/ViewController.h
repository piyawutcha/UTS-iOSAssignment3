//
//  ViewController.h
//  WebViewExample
//
//  Created by Brokmeier, Pascal on 5/21/16.
//  Copyright © 2016 uts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic)  WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
- (IBAction)urlFieldEditingDidEnd:(id)sender;
- (IBAction)navigateToUrl:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;


@end

