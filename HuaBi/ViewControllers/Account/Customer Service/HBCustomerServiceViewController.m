//
//  HBCustomerServiceViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/12/21.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCustomerServiceViewController.h"

@interface HBCustomerServiceViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation HBCustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocat(@"Customer Service");
    self.webView = [WKWebView new];
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:@"http://kefu.ziyun.com.cn/vclient/chat/?websiteid=142904&wc=225137&hidetitle=1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

#pragma mark - Private

-(void)initProgressView
{
    if (self.progressView) {
        [self.progressView removeFromSuperview];
    }
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, _webView.y, CGRectGetWidth(self.view.frame), 2)];
    self.progressView.progressTintColor = kPurpleColor;
    [self.view addSubview:self.progressView];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Getters

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, _webView.y, CGRectGetWidth(self.view.frame), 2)];
        _progressView.progressTintColor = kPurpleColor;
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    
    return _progressView;
}
@end
