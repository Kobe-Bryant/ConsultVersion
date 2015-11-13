//
//  ProductDetailBrowserViewController.h
//  szeca
//
//  Created by MC374 on 12-4-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductDetailBrowserViewController : UIViewController {
	UIWebView *webView;
	BOOL isChangrToFit;
}

@property(nonatomic,retain)IBOutlet UIWebView *webView;
@property(nonatomic,assign)BOOL isChangrToFit;
- (void) loadHtmlString:(NSString*)htmlString;
@end
