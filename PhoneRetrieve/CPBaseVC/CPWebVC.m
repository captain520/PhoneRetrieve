//
//  CPWebVC.m
//  PhoneRetrieve
//
//  Created by wangzhangchuan on 2018/2/6.
//  Copyright © 2018年 Captain. All rights reserved.
//

#import "CPWebVC.h"

@interface CPWebVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIProgressView *progress;

@end

@implementation CPWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.hidesBottomBarWhenPushed = YES;
    [self.view addSubview:self.progress];
    
    if (self.shouldHomeItem == NO) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIProgressView *)progress {
    
    if (nil == _progress) {
        _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREENWIDTH, 100)];
        _progress.trackTintColor = UIColor.clearColor;
    }
    
    return _progress;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        _webView.backgroundColor = UIColor.whiteColor;
        _webView.scalesPageToFit   = YES;

        _webView.delegate = self;
        
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)setUrlStr:(NSString *)urlStr {
    
    _urlStr = urlStr;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:CPUrl(urlStr)];
    
    [self.webView loadRequest:request];
}

- (void)setContentStr:(NSString *)contentStr {
    
    _contentStr = [self webImageFitToDeviceSize:contentStr.mutableCopy];

//    _contentStr = contentStr;
    
    [self.webView loadHTMLString:_contentStr baseURL:nil];
}

- (NSMutableString *)webImageFitToDeviceSize:(NSMutableString *)strContent
{
    [strContent appendString:@"<html>"];
    [strContent appendString:@"<head>"];
    [strContent appendString:@"<meta charset=\"utf-8\">"];
    [strContent appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width*0.9,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />"];
    [strContent appendString:@"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />"];
    [strContent appendString:@"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />"];
    [strContent appendString:@"<style>img{width:100%;}</style>"];
    [strContent appendString:@"<style>table{width:100%;}</style>"];
    [strContent appendString:@"<title>webview</title>"];
    return strContent;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.view bringSubviewToFront:self.progress];
    [self.progress setProgress:0.6 animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.progress setProgress:1 animated:YES];
    
//    获取网页title
    
//        NSString *htmlTitle = @"document.title";
//        NSString *titleHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:htmlTitle];
//        [self setTitle:titleHtmlInfo];
//    if (titleHtmlInfo && titleHtmlInfo.length > 0) {
//        self.navigationItem.title = titleHtmlInfo;
//    }

    [self performSelector:@selector(hideProgress) withObject:nil afterDelay:1.0f];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.progress setProgress:1 animated:YES];
    [self performSelector:@selector(hideProgress) withObject:nil afterDelay:1.0f];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)hideProgress {
    [self.progress removeFromSuperview];
}

@end
