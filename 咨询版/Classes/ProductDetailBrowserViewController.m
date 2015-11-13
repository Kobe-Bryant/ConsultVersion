//
//  ProductDetailBrowserViewController.m
//  szeca
//
//  Created by MC374 on 12-4-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailBrowserViewController.h"


@implementation ProductDetailBrowserViewController

@synthesize webView;
@synthesize isChangrToFit;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"详情";
	UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake( 0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20 - 44)];
	self.webView = webview;
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	[self.view addSubview:webView];
	[webview release];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.webView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[webView release];
    [super dealloc];
}

- (void) loadHtmlString:(NSString*)htmlString{
	[webView loadHTMLString:htmlString baseURL:nil];  

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (isChangrToFit) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"];
    }else{
		[self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    }
    isChangrToFit = NO;
}

@end
