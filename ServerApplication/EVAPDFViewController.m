//
//  EVAPDFViewController.m
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/11/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import "EVAPDFViewController.h"

#import "ParentObject.h"

@interface EVAPDFViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *ibWebView;

@end

@implementation EVAPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ibTitle.title = self.titlePDF;

    NSString* path =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,    NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:self.document.name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    NSURL *documentURL;
    
    if (fileExists) {
        documentURL = [NSURL fileURLWithPath:path];
    } else {
        documentURL = self.pdfURL;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:documentURL];
    [self.ibWebView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

@end
