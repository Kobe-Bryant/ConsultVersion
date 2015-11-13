//
//  LoginViewController.m
//  szeca
//
//  Created by MC374 on 12-3-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <stdint.h>
#import <CommonCrypto/CommonDigest.h> 
#import "LoginViewController.h"
#import "WBEngine.h"
#import "MBProgressHUD.h"
#import "CommandOperation.h"
#import "Common.h"
#import "WBRequest.h"
#import "DBOperate.h"
#import "JSON.h"
#import "AccountSettingViewController.h"
#import "OpenSdkOauth.h"
#import "OpenApi.h"
#import "AppStromAppDelegate.h"
#import "SinaWeibo.h"

#define oauthMode InWebView
/*
 * 获取oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="
#define oauth2OpenidKey @"openid="
#define oauth2OpenkeyKey @"openkey="
#define oauth2ExpireInKey @"expires_in="

@implementation LoginViewController

@synthesize QQtokenKey;
@synthesize QQtokenSecret;
@synthesize weiBoEngine;
@synthesize progressHUD;
@synthesize commandOper;
@synthesize sinaAccessToken;
@synthesize expiresTime;
@synthesize connection;
@synthesize responseData;
@synthesize selectIndex;
@synthesize weiboAccountArray;
@synthesize myTableView;
@synthesize delegate;
@synthesize but1;
@synthesize but2;
@synthesize _webView;

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
	self.title = @"微博设置";
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BG_IMAGE]];
	
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];	
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"登录中...";
	
	myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.backgroundView = nil;
    
	myTableView.delegate = self;
	myTableView.scrollEnabled = NO;
    
    if (IOS_VERSION >= 7.0) {
        myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myTableView.bounds.size.width, 10.f)];
    }
    
    hasOauth = NO;
	
	//检测微博是否已经过期，如果过期的就删除
	NSMutableArray *array = [DBOperate queryData:T_WEIBO_USERINFO theColumn:nil theColumnValue:nil  withAll:YES];
	if(array != nil && [array count] > 0){
		for (int i = 0; i < [array count];i++ ) {
			NSArray *wbArray = [array objectAtIndex:i];
			NSString *type = [wbArray objectAtIndex:weibo_type];
			if ([type isEqualToString:SINA]) {
				int oauthTime = [[wbArray objectAtIndex:weibo_oauth_time] intValue];
				int expiredTime = [[wbArray objectAtIndex:weibo_expires_time] intValue];			
				NSDate *todayDate = [NSDate date]; 
				NSLog(@"Date:%@",todayDate);
				NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
				int time = inter;
				NSLog(@"current time:%d",time);
				NSLog(@"expiresTime:%d",expiredTime);
				NSLog(@"time - oauthTime:%d",time - oauthTime);
				if(expiredTime - (time - oauthTime) <= 0){
					[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:type];
				}
			}else if ([type isEqualToString:TENCENT]) {
				int expiredTime = [[wbArray objectAtIndex:weibo_expires_time] intValue];
				NSDate *todayDate = [NSDate date]; 
				NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiredTime];
				NSLog(@"todayDate:%@",todayDate);
				NSLog(@"expirationDate:%@",expirationDate);
				if([todayDate compare:expirationDate] == NSOrderedSame){
					[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:type];
				}else {
					NSLog(@"not expired");
				}

			}
			
		}
	}
	
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
    [super viewDidUnload];
	self.QQtokenKey = nil;
	self.QQtokenSecret = nil;
	self.weiBoEngine = nil;
	self.progressHUD = nil;
	self.commandOper.delegate = nil;
	self.commandOper = nil;
	self.sinaAccessToken = nil;
	self.connection = nil;
	self.responseData = nil;
	self.myTableView.delegate = nil;
	self.myTableView = nil;
	self.but1 = nil;
	self.but2 = nil;
	_webView.delegate = nil;
	self._webView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	delegate = nil;
	weiBoEngine.delegate = nil;
	[weiBoEngine release];
	[QQtokenKey release];
	[QQtokenSecret release];
	[progressHUD release];
	self.commandOper.delegate = nil;
	self.commandOper = nil;
	[connection release];
	[responseData release];
	self.myTableView.delegate = nil;
	[myTableView release];
	[but1 release];
	[but2 release];
	_webView.delegate = nil;
	self._webView = nil;
	[_titleLabel release];    
	[_OpenSdkOauth release];
	_OpenApi.delegate = nil;
	_OpenApi = nil;
    [sinaWeibo release],sinaWeibo = nil;
//	[_OpenApi release];
    [super dealloc];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	return 1; 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellStyle style =  UITableViewCellStyleDefault;
	UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:@"Cell"];
    
    //ios7新特性,解决分割线短一点
    if ([tView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tView setSeparatorInset:UIEdgeInsetsZero];
    }
    
	if (!cell) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"Cell"] autorelease];
		cell.backgroundColor = [UIColor clearColor];
	}
	//	cell.textLabel.text = [[UIFont familyNames] objectAtIndex:indexPath.row]; 
	if ([indexPath row] == 0) {
		cell.textLabel.text = @"请使用以下方式授权您的微博，分享您的精彩";
		cell.textLabel.font = [UIFont systemFontOfSize:12];
	}else if ([indexPath row] == 1) {
		NSMutableArray *weiboArray = [DBOperate queryData:
									  T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue: SINA withAll:NO];
		if (weiboArray != nil && [weiboArray count] > 0) {
			UIImage *image =  [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新浪" ofType:@"png"]];
			cell.imageView.image = image;
			[image release];
			NSArray *wbay = [weiboArray objectAtIndex:0];
			NSString *name = [wbay objectAtIndex:weibo_user_name];
			cell.textLabel.text = name;
			cell.textLabel.font = [UIFont systemFontOfSize:16];
			if (but1 == nil) {
				UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
				but.tag = 200;
				[but setBackgroundImage:[UIImage imageNamed:@"注销按钮.png"] forState:UIControlStateNormal];
				[but setFrame:CGRectMake(200, 15, 100, 40)];
				[but setAlpha:0.8];
				self.but1 = but;
				[but addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
				[cell.contentView addSubview:but1];
			}			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}else {
			UIImage *image =  [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新浪" ofType:@"png"]];
			cell.imageView.image = image;
			[image release];
			cell.textLabel.text = @"新浪微博设置";
			cell.textLabel.font = [UIFont systemFontOfSize:16];
		}
	}else if ([indexPath row] == 2){
		
		NSMutableArray *weiboArray = [DBOperate queryData:
									  T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue: TENCENT withAll:NO];
		if (weiboArray != nil && [weiboArray count] > 0) {
			UIImage *image =  [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"腾讯" ofType:@"png"]];
			cell.imageView.image = image;
			[image release];
			NSArray *wbay = [weiboArray objectAtIndex:0];
			NSString *name = [wbay objectAtIndex:weibo_user_name];
			cell.textLabel.text = name;
			cell.textLabel.font = [UIFont systemFontOfSize:16];
			if (but2 == nil) {
				UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
				but.tag = 201;
				[but setBackgroundImage:[UIImage imageNamed:@"注销按钮.png"] forState:UIControlStateNormal];
				[but setFrame:CGRectMake(200, 15, 100, 40)];
				[but setAlpha:0.8];
				self.but2 = but;
				[but addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
				[cell.contentView addSubview:but2];
			}			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}else {
			UIImage *image =  [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"腾讯" ofType:@"png"]];
			cell.imageView.image = image;
			[image release];
			cell.textLabel.text = @"腾讯微博设置";
			cell.textLabel.font = [UIFont systemFontOfSize:16];
		}
	}
	
	return cell;
}

-(void)handleButtonPress:(id)sender{
	UIButton *bto = (UIButton*)sender;
	if (bto.tag == 200) {
		[DBOperate deleteData:T_WEIBO_USERINFO tableColumn: @"weiboType" columnValue:SINA];
		[bto removeFromSuperview];
		self.but1 = nil;
		[self.myTableView reloadData];
        
        hasOauth = NO;
	}else if (bto.tag == 201) {
		[DBOperate deleteData:T_WEIBO_USERINFO tableColumn: @"weiboType" columnValue:TENCENT];
		[bto removeFromSuperview];
		self.but2 = nil;
		[self.myTableView reloadData];
        
        _OpenApi = nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath row] == 0) {
		return 45.0f;
	}
	else {
		return 70.0f;
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	selectIndex = [indexPath row];
	
	if ([indexPath row] == 1) {
		NSMutableArray *weiboArray = (NSMutableArray *)[DBOperate queryData:
									  T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue: SINA withAll:NO];
		if (weiboArray != nil && [weiboArray count] > 0) {			
			
		}else{			
//			WBEngine *engine = [[WBEngine alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret];
//			[engine setRootViewController:self];
//			[engine setDelegate:self];
//			[engine setRedirectURI:redirectUrl];
//			[engine setIsUserExclusive:NO];
//			self.weiBoEngine = engine;
//			[engine release];
//			[weiBoEngine logIn:[UIScreen mainScreen].bounds.size.height];
            AppStromAppDelegate *appdelegate =  (AppStromAppDelegate *)[UIApplication sharedApplication].delegate;
            appdelegate.delegate = self;
            sinaWeibo = [[SinaWeibo alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret appRedirectURI:redirectUrl andDelegate:self];
            sinaWeibo.superViewController = self;
            [sinaWeibo logIn];
            // 取消选中状态
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
		}
	}else if ([indexPath row] == 2) {
		NSMutableArray *weiboArray = (NSMutableArray *)[DBOperate queryData:
									  T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue: TENCENT withAll:NO];
		if (weiboArray != nil && [weiboArray count] > 0) {			
			
		}else{	
//			QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
//			NSString *retString = [api getRequestTokenWithConsumerKey:QQAppKey consumerSecret:QQAppSecret];
//			NSLog(@"Get requestToken:%@", retString);
//			
//			[self parseTokenKeyWithResponse:retString];
//			QVerifyWebViewController *verifyController = [[[QVerifyWebViewController alloc] init] autorelease];
//			verifyController.delegate = self;
//			verifyController.appKey = QQAppKey;
//			verifyController.appSecret = QQAppSecret;
//			verifyController.tokenKey = QQtokenKey;
//			verifyController.tokenSecret = QQtokenSecret;
//			[self.navigationController pushViewController:verifyController animated:YES];
//			[verifyController release];
			
			[self loginWithQQMicroblogAccount];
			
		}
	}
}


- (void) handleCallBack:(NSDictionary*)param
{
    NSURL *url = [param objectForKey:@"url"];
    [sinaWeibo handleOpenURL:url];
    NSString *urlString = [url absoluteString];
    NSString *access_token = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"access_token"];
    NSString *expires_in = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"expires_in"];
    //NSString *remind_in = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"remind_in"];
    NSString *uid = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"uid"];
    //NSString *refresh_token = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"refresh_token"];
    if (uid != nil && [uid length] > 0) {
        //授权完成，调用微博接口获取用户资料
        NSTimeInterval expireTime = [[NSDate date] timeIntervalSince1970] + [expires_in doubleValue];
        self.sinaAccessToken = access_token;
        self.expiresTime = expireTime;//(int)expireTime;
        NSLog(@"expiresIn:%f",expiresTime);
        
        //用授权获取到的userID和accessToken，调用新浪微博接口获取用户资料.
        if(progressHUD != nil ){
            [self.view addSubview:self.progressHUD];
            [self.view bringSubviewToFront:self.progressHUD];
            [self.progressHUD show:YES];
        }
        //授权完成，调用微博接口获取新浪微博用户资料数据
        [sinaWeibo requestWithURL:@"users/show.json"
                           params:[NSMutableDictionary dictionaryWithObject:uid forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
    }
    
}


- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    //用授权获取到的userID和accessToken，调用新浪微博接口获取用户资料.
    self.sinaAccessToken = sinaWeibo.accessToken;
    self.expiresTime = [sinaWeibo.expirationDate timeIntervalSince1970];
    if(progressHUD != nil ){
        [self.view addSubview:self.progressHUD];
        [self.view bringSubviewToFront:self.progressHUD];
        [self.progressHUD show:YES];
    }
    //授权完成，调用微博接口获取新浪微博用户资料数据
    [sinaWeibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [self uploadToServerWithResult:result];
    }
}

//获取到用户数据，上传至服务器
- (void)uploadToServerWithResult:(id)result
{
	if ([result isKindOfClass:[NSDictionary class]] && !hasOauth)
    {
		NSDictionary *dic = (NSDictionary*)result;
		NSString *userId = [dic objectForKey:@"id"];
		NSString *screen_name=[dic objectForKey:@"screen_name"];
		//NSString *name=[dic objectForKey:@"name"];
		//NSString *province=[[dic objectForKey:@"province"]intValue];
		//NSString *city=[[dic objectForKey:@"city"]intValue];
		//NSString *location=[dic objectForKey:@"location"];
		//NSString *description=[dic objectForKey:@"description"];
		//NSString *url=[dic objectForKey:@"url"];
		//NSString *domain=[dic objectForKey:@"domain"];
		NSString *profile_image_url=[dic	objectForKey:@"profile_image_url"];
		NSDate *todayDate = [NSDate date];
		NSLog(@"Date:%@",todayDate);
		NSTimeInterval inter = [todayDate timeIntervalSince1970];
		int time = inter;
		NSLog(@"TIME:%d",time);
		
		
		//获取到的用户资料保存至本地数据库
		NSMutableArray *ar_wp = [[NSMutableArray alloc]init];
		[ar_wp addObject:@"sina"];
		[ar_wp addObject:screen_name];
		[ar_wp addObject:userId];
		[ar_wp addObject:profile_image_url];
		[ar_wp addObject:@""];
		[ar_wp addObject:@""];
		[ar_wp addObject:sinaAccessToken];
		[ar_wp addObject:[NSNumber numberWithInt: expiresTime]];
		[ar_wp addObject:[NSNumber numberWithInt: 1]];
		[ar_wp addObject:[NSNumber numberWithInt: time]];
		[ar_wp addObject:@"openid"];
		[ar_wp addObject:@"openkey"];
        //		[DBOperate deleteALLData:T_WEIBO_USERINFO];
		[DBOperate insertDataWithnotAutoID:ar_wp tableName:T_WEIBO_USERINFO];
		[ar_wp release];
		
		NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
									 [NSNumber numberWithInt: site_id],@"site_id",
									 @"sina",@"weibo_type",
									 screen_name,@"weibo_user_name",
									 userId,@"weibo_user_id",
									 profile_image_url,@"profile_image",
									 sinaAccessToken,@"oauth_token",
									 @"",@"oauth_token_secret",
									 [NSNumber numberWithInt: expiresTime],@"expires-in",
									 @"",@"mac_addr",nil];
		
		NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/weibo/authorization.do?param=%@"]];
		NSLog(@"reqstr wall paper %@",reqStr);
		CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:SINAWEIAPI delegate:self params:jsontestDic];
		self.commandOper = commandOpertmp;
		[commandOpertmp release];
		[networkQueue addOperation:commandOper];
        hasOauth = !hasOauth;
	}
}

/*
 * 采用两种不同方式进行登录授权,支持webview和浏览器两种方式
 */
- (void) loginWithQQMicroblogAccount{
	short authorizeType = oauthMode; 
	
    _OpenSdkOauth = [[OpenSdkOauth alloc] initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
    _OpenSdkOauth.oauthType = authorizeType;
    
    BOOL didOpenOtherApp = NO;
    switch (authorizeType) {
        case InSafari:  //浏览器方式登录授权，不建议使用
        {
            didOpenOtherApp = [_OpenSdkOauth doSafariAuthorize:didOpenOtherApp];
            break;
        }
        case InWebView:  //webView方式登录授权，采用oauth2.0授权鉴权方式
        {
            if(!didOpenOtherApp){
                if (([OpenSdkBase getAppKey] == (NSString *)[NSNull null]) || ([OpenSdkBase getAppKey].length == 0)) {
                    NSLog(@"client_id is null");
                    [OpenSdkBase showMessageBox:@"client_id为空，请到OPenSdkBase中填写您应用的appkey"];
                }
                else
                {
                    [self webViewShow];
                }
                
                [_OpenSdkOauth doWebViewAuthorize:_webView];
                
                break;
            }
        }
        default:
            break;
    }
}


/*
 * 初始化titlelabel和webView
 */
- (void) webViewShow {
    
//    CGFloat titleLabelFontSize = 14;
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    _titleLabel.text = @"微博登录";
//    _titleLabel.backgroundColor = [UIColor lightGrayColor];
//    _titleLabel.textColor = [UIColor blackColor];
//    _titleLabel.font = [UIFont boldSystemFontOfSize:titleLabelFontSize];
//    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
//    | UIViewAutoresizingFlexibleBottomMargin;
//    _titleLabel.textAlignment = UITextAlignmentCenter;
	
//	[self.view addSubview:_titleLabel];
    
//    [_titleLabel sizeToFit];
//    CGFloat innerWidth = self.view.frame.size.width;
//    _titleLabel.frame = CGRectMake(
//                                   0,
//                                   0,
//                                   innerWidth,
//                                   _titleLabel.frame.size.height+6);
	
//    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 20 - 44)];
	self._webView = webView;
    
    _webView.scalesPageToFit = YES;
    _webView.userInteractionEnabled = YES;
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_webView];
}


/*
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL* url = request.URL;
	
    NSLog(@"response url is %@", url);
	NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
    
    //如果找到tokenkey,就获取其他key的value值
	if (start.location != NSNotFound)
	{
        NSString *accessToken = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2TokenKey];
        NSString *openid = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenidKey];
        NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenkeyKey];
		NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2ExpireInKey];
		        
		NSDate *expirationDate =nil;
		if (expireIn != nil) {
			int expVal = [expireIn intValue];
			_OpenSdkOauth._expireIn_time = expVal;
			if (expVal == 0) {
				expirationDate = [NSDate distantFuture];
			} else {
				expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
			} 
		} 
        
        NSLog(@"token is %@, openid is %@, expireTime is %@", accessToken, openid, expirationDate);
        
        if ((accessToken == (NSString *) [NSNull null]) || (accessToken.length == 0) 
            || (openid == (NSString *) [NSNull null]) || (openkey.length == 0) 
            || (openkey == (NSString *) [NSNull null]) || (openid.length == 0)) {
            [_OpenSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
        }
        else {
            [_OpenSdkOauth oauthDidSuccess:accessToken accessSecret:nil openid:openid openkey:openkey expireIn:expireIn];
			//授权成功，获取用户信息
			[self performSelectorOnMainThread:@selector(getUserInfo) withObject:nil waitUntilDone:NO];		
        }
        _webView.delegate = nil;
        [_webView setHidden:YES];
        [_titleLabel setHidden:YES];
        
		return NO;
	}
	else
	{
        start = [[url absoluteString] rangeOfString:@"code="];
        if (start.location != NSNotFound) {
            [_OpenSdkOauth refuseOauth:url];
        }
	}
    return YES;
}

- (void) getUserInfo{
	//授权成功，获取用户数据
	if(_OpenApi == nil){
		_OpenApi = [[OpenApi alloc] initForApi:_OpenSdkOauth.appKey 
									 appSecret:_OpenSdkOauth.appSecret 
								   accessToken:_OpenSdkOauth.accessToken
								  accessSecret:_OpenSdkOauth.accessSecret
										openid:_OpenSdkOauth.openid oauthType:_OpenSdkOauth.oauthType];
		_OpenApi.delegate = self;
		//Todo:请填写调用user/info获取用户资料接口所需的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
		[_OpenApi getUserInfo:@"json"];  //获取用户信息
	}			
}

-(void) getUserInfoSuccess:(NSString*)userInfo{
	NSLog(@"tencent weibo userinfo:%@",userInfo);
	
	SBJSON *jsonParser = [[SBJSON alloc]init];
	NSError *parseError = nil;
	id result = [jsonParser objectWithString:userInfo error:&parseError];
	NSDictionary *dic = [result objectForKey:@"data"];
	if (dic != [NSNull null]) {
		NSString *headImage = [dic objectForKey:@"head"];
		NSString *headImageUrl = [NSString stringWithFormat:@"%@%@",headImage,@"/100"];
		NSString *openid=[dic objectForKey:@"openid"];
		NSString *name=[dic objectForKey:@"name"];
		NSLog(@"headImage:%@",headImageUrl);
		NSLog(@"openid:%@",openid);
		NSLog(@"name:%@",name);
		NSLog(@"accessToken:%@",_OpenSdkOauth.accessToken);
		[jsonParser release];
		
		NSDate *todayDate = [NSDate date]; 
		NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
		int time = inter;
		
		//获取到的用户资料保存至本地数据库并上传至服务器
		NSMutableArray *ar_wp = [[NSMutableArray alloc]init];
		[ar_wp addObject:@"tencent"];
		[ar_wp addObject:name];
		[ar_wp addObject:openid];
		[ar_wp addObject:headImageUrl];
		[ar_wp addObject:@"accessToken"];
		[ar_wp addObject:@"accessSecret"];
		[ar_wp addObject:_OpenSdkOauth.accessToken];
		[ar_wp addObject:[NSNumber numberWithInt: _OpenSdkOauth._expireIn_time]];
		[ar_wp addObject:[NSNumber numberWithInt: 1]];
		[ar_wp addObject:[NSNumber numberWithInt: time]];
		[ar_wp addObject:_OpenSdkOauth.openid];
		[ar_wp addObject:_OpenSdkOauth.openkey];
		[DBOperate insertDataWithnotAutoID:ar_wp tableName:T_WEIBO_USERINFO];
		[ar_wp release];
		
		if(progressHUD != nil ){
			[self.view addSubview:self.progressHUD];
			[self.view bringSubviewToFront:self.progressHUD];
			[self.progressHUD show:YES];
		}
		
		NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
									 [NSNumber numberWithInt: site_id],@"site_id",
									 @"tencent",@"weibo_type",
									 name,@"weibo_user_name",
									 openid,@"weibo_user_id",
									 headImageUrl,@"profile_image",
									 _OpenSdkOauth.accessToken,@"oauth_token",
									 @"",@"oauth_token_secret",
									 [NSNumber numberWithInt: expiresTime],@"expires-in",
									 @"",@"mac_addr",nil];
		
		NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/weibo/authorization.do?param=%@"]];
		NSLog(@"reqstr wall paper %@",reqStr);
		CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:SINAWEIAPI delegate:self params:jsontestDic];
		self.commandOper = commandOpertmp;
		[commandOpertmp release];
		[networkQueue addOperation:commandOper];
}
}

#pragma mark - WBEngineDelegate Methods
#pragma mark Authorize

- (void)engineDidLogIn:(WBEngine *)engine didSucceedWithAccessToken:(NSString *)accessToken userID:(NSString *)userID expiresIn:(NSInteger)seconds
{
	//NSTimeInterval expireTime = [[NSDate date] timeIntervalSince1970] + seconds;
	self.sinaAccessToken = accessToken;
	self.expiresTime = seconds;//(int)expireTime;
	NSLog(@"loginViewController");
	NSLog(@"accessToken:%@",accessToken);
	NSLog(@"userID:%@",userID);
	NSLog(@"expiresIn:%d",expiresTime);
	
	//用授权获取到的userID和accessToken，调用新浪微博接口获取用户资料.
	if(progressHUD != nil ){
		[self.view addSubview:self.progressHUD];
		[self.view bringSubviewToFront:self.progressHUD];
		[self.progressHUD show:YES];
	}
	//授权完成，调用微博接口获取新浪微博用户资料数据
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"uid",nil];
	[weiBoEngine loadRequestWithMethodName:@"users/show.json" httpMethod:@"GET" params:params postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
}

#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
	//获取到用户数据，双传至服务器
	NSLog(@"requestDidSucceedWithResult");
	if ([result isKindOfClass:[NSDictionary class]])
    {
		NSDictionary *dic = (NSDictionary*)result;
		NSString *userId = [dic objectForKey:@"id"];
		NSString *screen_name=[dic objectForKey:@"screen_name"];
		NSString *name=[dic objectForKey:@"name"];
		NSString *province=[[dic objectForKey:@"province"]intValue];
		NSString *city=[[dic objectForKey:@"city"]intValue];
		NSString *location=[dic objectForKey:@"location"];
		NSString *description=[dic objectForKey:@"description"];
		NSString *url=[dic objectForKey:@"url"];
		NSString *profile_image_url=[dic	objectForKey:@"profile_image_url"];
		NSString *domain=[dic objectForKey:@"domain"];
		
		NSDate *todayDate = [NSDate date]; 
		NSLog(@"Date:%@",todayDate);
		NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
		int time = inter;
		NSLog(@"TIME:%d",time);
		
		
		//获取到的用户资料保存至本地数据库
		NSMutableArray *ar_wp = [[NSMutableArray alloc]init];
		[ar_wp addObject:@"sina"];
		[ar_wp addObject:screen_name];
		[ar_wp addObject:userId];
		[ar_wp addObject:profile_image_url];
		[ar_wp addObject:@""];
		[ar_wp addObject:@""];
		[ar_wp addObject:sinaAccessToken];
		[ar_wp addObject:[NSNumber numberWithInt: expiresTime]];
		[ar_wp addObject:[NSNumber numberWithInt: 1]];
		[ar_wp addObject:[NSNumber numberWithInt: time]];
		[ar_wp addObject:@"openid"];
		[ar_wp addObject:@"openkey"];
//		[DBOperate deleteALLData:T_WEIBO_USERINFO];
		[DBOperate insertDataWithnotAutoID:ar_wp tableName:T_WEIBO_USERINFO];
		[ar_wp release];
		
		NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
									 [NSNumber numberWithInt: site_id],@"site_id",
									 @"sina",@"weibo_type",
									 screen_name,@"weibo_user_name",
									 userId,@"weibo_user_id",
									 profile_image_url,@"profile_image",
									 sinaAccessToken,@"oauth_token",
									 @"",@"oauth_token_secret", 
									 [NSNumber numberWithInt: expiresTime],@"expires-in",
									 @"",@"mac_addr",nil];
		
		NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/weibo/authorization.do?param=%@"]];
		NSLog(@"reqstr wall paper %@",reqStr);
		CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:SINAWEIAPI delegate:self params:jsontestDic];
		self.commandOper = commandOpertmp;
		[commandOpertmp release];
		[networkQueue addOperation:commandOper];
	}

}

- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	NSLog(@"request finish");
	
	NSMutableArray* array = (NSMutableArray*)resultArray;
	//int isSuccess = [[array objectAtIndex:0] intValue];
	
	if (delegate != nil)
	{
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}
	else 
	{
		[self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
	}
	
}

-(void)update{
//	[self.navigationController popViewControllerAnimated:NO];
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
	}
	if (delegate != nil) {
		if (selectIndex == 1) {
			[delegate  loginSuccess:SINA];
		}else if(selectIndex == 2){
			[delegate loginSuccess:TENCENT];
		}
		
	}
}

-(void)updateTableView
{
	
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
	}
	
	[myTableView reloadData];
}

@end
