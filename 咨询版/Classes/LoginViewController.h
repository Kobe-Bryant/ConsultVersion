//
//  LoginViewController.h
//  szeca
//
//  Created by MC374 on 12-3-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "AppStromAppDelegate.h"
#import "MBProgressHUD.h"
#import "SinaWeibo.h"

@class CommandOperation;
@class OpenSdkOauth;
@class OpenApi;

@protocol LoginResultDelegate <NSObject>

-(void)loginSuccess:(NSString*)withLoginType;

@end

@interface LoginViewController : UIViewController <MBProgressHUDDelegate,SinaWeiboDelegate,APPlicationDelegate,SinaWeiboRequestDelegate>{
	WBEngine *weiBoEngine;
	NSString *QQtokenKey;
	NSString *QQtokenSecret;
	MBProgressHUD *progressHUD;
	CommandOperation *commandOper;
	int enpiresTime;
	NSString *sinaAccessToken;
	NSURLConnection *connection;
	NSMutableData *responseData;
	int selectIndex;
	NSMutableArray *weiboAccountArray;
	UITableView *myTableView;
	id<LoginResultDelegate> delegate;
	UIButton *but1;
	UIButton *but2;
	
	IBOutlet UIWebView *_webView;
    UILabel *_titleLabel;    
    OpenSdkOauth *_OpenSdkOauth;
	OpenApi *_OpenApi;
    SinaWeibo *sinaWeibo;
    BOOL hasOauth;
 }
@property (nonatomic, retain) NSString *QQtokenKey;
@property (nonatomic, retain) NSString *QQtokenSecret;
@property (nonatomic, retain) WBEngine *weiBoEngine;
@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic, retain) CommandOperation *commandOper;
@property (nonatomic) int expiresTime;
@property (nonatomic,retain) NSString *sinaAccessToken;
@property (nonatomic,retain) NSURLConnection *connection;
@property (nonatomic,retain) NSMutableData *responseData;
@property (nonatomic,retain) NSMutableArray *weiboAccountArray;
@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (nonatomic,retain) IBOutlet UIWebView *_webView;
@property (nonatomic) int selectIndex;
@property(nonatomic,assign)id<LoginResultDelegate> delegate;
@property (nonatomic,retain) UIButton *but1;
@property (nonatomic,retain)UIButton *but2;

-(void)update;
-(void)updateTableView;

@end
