# WebKit for iOS

WebKit allows developers to **display web content within their apps** without forcing the user to navigate between apps or switching to the browser. It can be considered a frameless inline version of Safari, which can be displayed at any point of the UI and renders HTML websites just like a normal browser. The framework also implements a navigation history and exposes it to the API. It offers several ways of customising the WebView, restricting a users navigation possibilities, the content that will be displayed, the local storage amount and so on. 

Using this framework, applications can reuse existing web technology already developed by an organisation and therefore save developing cost. Sometimes it may also be beneficial to use HTML, e.g. when displaying documents or style sensitive graphics for which the web and CSS3 was built for. This way, a company can also reuse its existing skillset of frontend developers as well as hire professional design agencies who usually possess lots of skills in the web stack.


## Technical introduction

### Core objects

Starting with iOS 8, the `UIWebView` is being replaced by `WKWebView`. This is the core object the application code interacts with. Since it is a child of UIViewController it is able to be added to any existing view as a subview. The change to WKWebView is especially important, because it offers significant performance boosts for  websites using WebGL, WebWorkers or other complex logic. This allows hybrid based application development using frameworks such as **cordova** or **ionic** to use more complex animations and graphics to deliver the user a native-like experience while maintaining the ability to reuse code across devices. Mainly it further closes the performance gap between native and web based applications.

The `WKBackForwardList` class manages the list of webpage previously visited by the user.

The `WKNavigation` class contains information that can be used to give the user visual feedback of the loading process of the WebView during the loading process.

### Core Protocolls

#### WKNavigationDelegate

The `WKNavigationDelegate` implements callback methods that hook into the navigation activities of the WebView. This can be used to track changes in the location or perform in app navigations in response to a navigation change in the WebView.

The most important methods to implement are:

Callbacks that are called when the webview wants to navigate. Can programatically be allowed or cancelled using the decisionHandlers

```objectivec
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
```

Callbacks that inform the application about the navigation activities of the webView. 
```objectivec
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
```

Callback that is called in case the website requires authentication (e.g. in the form of basic authentication for REST endpoints or older home router interfaces)
```objectivec
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler;
```

#### WKScriptMessageHandler

The `WKScriptMessageHandler` is used to receive messages from a running website. The website can send messages to the native code using the `webkit` object on the `window` object in JavaScript. 

The only required method to implement for this protocol is the `didReceiveScriptMessage`. This method is called when the JavaScript runtime calls one of the `messageHandlers` defined in the configuration of the webView. The JavaScript object is automatically translated into an Objective-C object and passed to this method. 
```objectivec
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
```


### Message handlers
When a `UIWebView` is instantiated, the javascript within this view has the ability to easily send messages to the backing Objective-C code. All passed JavaScript objects are autmatically serialized and converted into native Objective-C or Swift objects. 

```javascript
window.webkit.messageHandlers.{NAME}.postMessage()
```

<!-- http://stackoverflow.com/questions/32631184/the-resource-could-not-be-loaded-because-the-app-transport-security-policy-requi -->
### NSAppTransportSecurity for http 

In order to load all websites (not only https as allowed by default), one must add the following key to the info.plist

```
Dictionary NSAppTransportSecurity
//and this as an entry
boolean NSAllowsArbitraryLoads = YES
```

### Displaying a WebView 

To display a WebView, very little code is needed. Using a standard one page template in XCode, the following code can be run in the first `[UIViewControllers viewDidLoad]` method:

```objectivec
//define (empty/default) settings and size
CGRect frame = _webViewContainer.frame;
WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//add message handler to be exposed to javascript
[configuration.userContentController addScriptMessageHandler:self name:@"messageQueueToNative"];
//init
_webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
//set self as delegate for the webview
_webView.navigationDelegate = self;

//configure a request URL to load
NSString *startUrl = @"http://localhost:8100"; //for demo only. links to locally hosted mobile webapp
//set navigation url and load
[self webViewTo:startUrl];
[_webViewContainer addSubview:_webView];

//local helper function for url textField
[self urlChangedTo:startUrl];

```

## Use cases and relevance to market

The WebView element is the core requirement for hybrid web applications. Without this element, a hybrid application could not run in a native environment, since there would be no way to display web content in the native app. Frameworks such as **Cordova (PhoneGap)** use this to create an app, that wrapps a website and displays it as a full screen application. The user then doesn't know, he's looking at a web based application, unless the UX makes it obvious. Frameworks such as **ionic** aim to ensuring the app experience of a user is equivalent to the experience in a truely native application. Adapters enable the use of more advanced features such as the Gyroscope, Location access, Camera access and other APIs exposed to normal iOS applications. 

Hybrid applications are an essential part of the app ecosystem. The Ionic framework was created in 2014 and this was their retrospective after 1 year: 

>Over 320,000 apps have been created this year, and some particularly impressive ones were featured by both Apple and Google in their respective app stores. Ionic is being used by freelancers, startups, and Fortune 50 companies alike, and in more countries than we can even count.

>Our forum has seen over 45,000 posts this year, reaching over 100,000 unique developers a month.

This is **just one framework** after the first year (2014-15). They now have over 24k stars and 4700+ forks on Github.

There are also many plugins and adapters for hybrid applications to make use of native technologies from within the web environment. Some examples are:

- [Beacon](https://github.com/petermetz/cordova-plugin-ibeacon)
- [Bluetooth Low Energy](https://github.com/don/cordova-plugin-ble-central)
- [Clipboard](https://github.com/VersoSolutions/CordovaClipboard)
- [Contacts](https://github.com/apache/cordova-plugin-contacts)
- [HealthKit for iOS](https://github.com/Telerik-Verified-Plugins/HealthKit)
- [Keychain](https://github.com/shazron/KeychainPlugin)
- [Native Audio](https://github.com/SidneyS/cordova-plugin-nativeaudio)
- [Preferences](https://github.com/apla/me.apla.cordova.app-preferences)
- [Push Notifications - V5] (https://github.com/phonegap/phonegap-plugin-push)
- [SMS](https://github.com/aharris88/phonegap-sms-plugin)
- [Splashscreen](https://github.com/apache/cordova-plugin-splashscreen) 
- [SQLite](https://github.com/litehelpers/Cordova-sqlite-storage)
- [Touchid](https://github.com/leecrossley/cordova-plugin-touchid)
- [Vibration](https://github.com/apache/cordova-plugin-vibration) 

Technically one could write an application purely based on Javascript, that uses a small adapter to access an Apple Watch using the WatchKit. Even more helpful would be a home automation app, that accesses the home's devices through HomeKit using native objective-c code. All the logic for displaying and managing the assets however would be written in web technologies. This way, the application can also run on an Android, where it would then use the Nest APIs, Weave or Brillo, the pendants to Apples HomeKit
