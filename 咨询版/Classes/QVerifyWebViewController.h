//
//  QVerifyWebViewController.h
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-14.
//   
//

#import <UIKit/UIKit.h>

@protocol QVerifyDelegate

- (void)parseTokenKeyWithResponse:(NSString *)aResponse;

@end


@interface QVerifyWebViewController : UIViewController<UIWebViewDelegate> {
	
	UIWebView *mWebView;
	id<QVerifyDelegate> delegate;
	NSString *appKey;
	NSString *appSecret;
	NSString *tokenKey;
	NSString *tokenSecret;
}

@property(nonatomic,assign)id<QVerifyDelegate> delegate;
@property(nonatomic,retain)NSString *appKey;
@property(nonatomic,retain)NSString *appSecret;
@property(nonatomic,retain)NSString *tokenKey;
@property(nonatomic,retain)NSString *tokenSecret;
@end
