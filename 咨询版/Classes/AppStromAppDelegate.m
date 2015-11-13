//
//  AppStromAppDelegate.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppStromAppDelegate.h"
#import "AppStromViewController.h"
#import "tabEntranceViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "alertView.h"
#import "XMLParser.h"  
#import "CustomTabBar.h"
#import "NdUncaughtExceptionHandler.h"
#import "UpdateAppAlert.h"
#import "FileManager.h"
#import "SvUDIDTools.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>  
#include <net/if.h>
#include <net/if_dl.h>

@implementation AppStromAppDelegate
@synthesize navController;
@synthesize window;
@synthesize viewController;
@synthesize pushAlert;
@synthesize province;
@synthesize city;
//@synthesize locManager;
@synthesize dtoken;
@synthesize commandOper;
@synthesize LatitudeAndLongitude;
@synthesize updateAlert;
@synthesize delegate;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    //	[NdUncaughtExceptionHandler setDefaultHandler];
    //	NSArray *array = [NSArray arrayWithObject:@"there is only one objective in this arary,call index one, app will crash and throw an exception!"];
    //	NSLog(@"%@", [array objectAtIndex:1]);
    //	return YES;
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:@"aD99cXbvKRLUfBoeKUAILHCG" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
	
	int soft_ver = [[Common getVersion:APP_SOFTWARE_VER_ID] intValue];
	if(soft_ver != CURRENT_APP_VERSION)
	{
		[FileManager removeFile:dataBaseFile];
		NSString *filepath = [FileManager getFilePath:@""];
		//获取所有下个目录下的文件名列表
		NSArray *fileList = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: filepath error:nil];
		for(int i=0;i < [fileList count]; i++)
		{
			[FileManager removeFile:[fileList objectAtIndex:i]];
		}
	}
	//创建数据库表
	[DBOperate createTable];
	//写入当前软件版本号
	NSArray *ar_ver = [NSArray arrayWithObjects:[NSNumber numberWithInt:APP_SOFTWARE_VER_ID],
					   [NSNumber numberWithInt:CURRENT_APP_VERSION],@"软件版本号",nil];
	[DBOperate deleteData:T_VERSION tableColumn:@"id" columnValue:[NSNumber numberWithInt:APP_SOFTWARE_VER_ID]];
	[DBOperate insertDataWithnotAutoID:ar_ver tableName:T_VERSION];
    
	
	commonSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	XMLParser *parser = [XMLParser sharedInstance];
 	NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:CONFIG_FILE_NAME ofType:CONFIG_FILE_TYPE];
	[parser parserXMLFromFile:xmlFilePath];
	tabArray = parser.tabArray;
	produceModuleArray = parser.moduelArrar;
	hotTabArrar = parser.hotTabArrar;
	urlDictionary = parser.urlDictionary;
	videoListArray = parser.videoArray;
	soildListArray = parser.solidArray;
	productShowType = parser.productType;
	shop = parser.shopName;
	shop_id = parser.shopId;
	site_id = parser.siteId;
	ACCESS_SERVICE_LINK = [urlDictionary objectForKey:ACCESS_SERVICE_LINK_KEY];
	SHARE_TO_SINA = [urlDictionary objectForKey:SHARE_TO_SINA_KEY];
	SHARE_TO_QQ = [urlDictionary objectForKey:SHARE_TO_QQ_KEY];
	App_Registration = [urlDictionary objectForKey:App_Registration_KEY];
	NSLog(App_Registration);
	Feedback = [urlDictionary objectForKey:Feedback_KEY];
	shop_link = [urlDictionary objectForKey:shop_link_KEY];
	SHARE_CONTENT = [urlDictionary objectForKey:SHARE_CONTENT_KEY];
	invite_content = [urlDictionary objectForKey:invite_content_KEY];
	emailSubject = [urlDictionary objectForKey:emailSubject_KEY];
	emailContent  = [urlDictionary objectForKey:emailContent_KEY];
	BTO_COLOR_RED = parser.red_color;
	BTO_COLOR_GREEN = parser.green_color;
	BTO_COLOR_BLUE =  parser.blue_color;
	FONT_COLOR_RED = parser.font_red_color;
	FONT_COLOR_GREEN = parser.font_green_color;
	FONT_COLOR_BLUE = parser.font_blue_color;
	isPromotionFirstLoad = true;
	isComNewsFirstLoad = true;
	isShareToWechat = parser.wechatShare;
	app_wechat_share_type = app_to_wechat;
	networkQueue = [[NSOperationQueue alloc]init];
	[networkQueue setMaxConcurrentOperationCount:2];
	myLocation.longitude = 114.064515;
	myLocation.latitude = 22.548604;
    
	//测试用
	//[self accessService];
	
	//向微信注册，使程序启动后微信终端能响应应用程序
	if(isShareToWechat){
		[WXApi registerApp:WEICHATID];
	}
    
    //	tabEntranceViewController *tabViewController = [[tabEntranceViewController alloc]init];
    
	CustomTabBar *tabViewController = [[CustomTabBar alloc]init];
    //默认选中第一个 如果是使用tabEntranceViewController 非自定义的 需要把该代码也注释
    [tabViewController selectedTab:[tabViewController.buttons objectAtIndex:0]];
    
	UINavigationController *tabNavigation = [[UINavigationController alloc] initWithRootViewController:tabViewController];
	[tabViewController release];
    
    //上bar 自定义
    UINavigationBar *navBar = [tabNavigation navigationBar];
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        // set globablly for all UINavBars
        UIImage *img = nil;
        if (IOS_VERSION >= 7.0) {
            img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IOS7_NAV_BG_PIC ofType:nil]];
        }else{
            img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NAV_BG_PIC ofType:nil]];
        }
        [navBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        [img release];
    }

    
	tabNavigation.navigationBar.tintColor = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:1];//[UIColor colorWithRed:0.54296875 green:0.7890625 blue:0.796875 alpha:1];//[UIColor colorWithRed:0.4765625 green:0.77734375 blue:0.88671875 alpha:1];
	
	self.navController = tabNavigation;
    
    if (IOS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
        
        tabViewController.edgesForExtendedLayout = UIRectEdgeNone;
        tabViewController.extendedLayoutIncludesOpaqueBars = NO;
        tabViewController.modalPresentationCapturesStatusBarAppearance = NO;
        tabViewController.navigationController.navigationBar.translucent = NO;
        tabViewController.tabBarController.tabBar.translucent = NO;
    }
    
    ////////////test naigation bar
	
    /*  UIImage *navigationBarBackgroundImage =[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"aaaaaaa" ofType:@"jpg"]];
     UINavigationBar *customNavigationBar = [Common createNavigationBarWithBackgroundImage:navigationBarBackgroundImage title:@"main"];
     self.navController.navigationBar = customNavigationBar;*/
	
    
    //设置背景
    //float width = [UIScreen mainScreen].bounds.size.width;
	float height = [UIScreen mainScreen].bounds.size.height;
    CGFloat fixHeight = height < 548 ? -44.0f + 20.0f : 20.0f;
    UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:BG_IMAGE ofType:nil]];
	UIImageView *backiv = [[UIImageView alloc]initWithFrame:CGRectMake(0, fixHeight , img.size.width, img.size.height)];
	backiv.image = img;
	[img release];
    [window addSubview:backiv];
	[backiv release];
    
    
	//[window addSubview:customNavigationBar];
	[window addSubview:tabNavigation.view];
	[tabNavigation release];
    
    //推送通知注册
    NSArray *ar_token = [DBOperate queryData:T_DEVTOKEN theColumn:nil theColumnValue:nil  withAll:YES];
    if ([ar_token count]>0)
    {
		NSArray *arr_token = [ar_token objectAtIndex:0];
		self.dtoken = [arr_token objectAtIndex:devtoken_token];
        
        //获取位置
        [self getLocation];
	}
	else
    {
        //注册消息通知 获取token号
        if (IOS_VERSION >=8) {
            NSLog(@"这是ios8通知新的api");
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            NSLog(@"这是老的通知的api");
            
            [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
        }

	}
    
    //监听消息推送
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(launchNotification:)name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
    
    //线程延迟 2 秒执行
    [NSThread sleepForTimeInterval:2];
	application.applicationIconBadgeNumber = 0;
    
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    
    //获取位置
    [self getLocation];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	if(![Common connectedToNetwork])
	{
		[alertView showAlert:@"无法连接网络，请检查设置"];
	}
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

//获取地理位置
- (void)getLocation
{
//    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
//    {
//        locManager = [[CLLocationManager alloc] init];
//        locManager.desiredAccuracy = kCLLocationAccuracyBest;
//        locManager.delegate = self;
//        [locManager startUpdatingLocation];
//    }
//    else
//    {
//        //定位没打开 默认地址发送 
//        [self accessService];
//    }
    
    locManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [locManager requestWhenInUseAuthorization];
        //定位没打开 默认地址发送
        [self accessService];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        locManager.delegate = self;
        [locManager startUpdatingLocation];
        
    }
}

-(void)accessService{
	dtoken = dtoken == nil ? @"" : dtoken;
	//NSLog(@"token %@",dtoken);
	//[alertView showAlert:dtoken];
	NSString *macAdd = [self getMacAddress];
	if(province == nil){
		province = @"广东省";
	}
	if(city == nil){
		city = @"深圳市";
	}
	if(LatitudeAndLongitude == nil){
		LatitudeAndLongitude = @"114.064515,22.548604";
	}
	NSLog(macAdd);
	NSMutableArray *array = [DBOperate queryData:T_WEIBO_USERINFO theColumn:nil theColumnValue:nil  withAll:YES];
	NSArray *weiboArray = nil;
	if(array != nil && [array count] > 0){
		weiboArray = [array objectAtIndex:0];
		for (int i = 0; i < [array count];i++ ) {
			NSArray *wbArray = [array objectAtIndex:i];
			int oauthTime = [[wbArray objectAtIndex:weibo_oauth_time] intValue];
			int expiresTime = [[wbArray objectAtIndex:weibo_expires_time] intValue];
			NSString *type = [wbArray objectAtIndex:weibo_type];
			NSDate *todayDate = [NSDate date];
			NSLog(@"Date:%@",todayDate);
			NSTimeInterval inter = [todayDate timeIntervalSince1970];
			int time = inter;
			NSLog(@"current time:%d",time);
			NSLog(@"expiresTime:%d",expiresTime);
			NSLog(@"time - oauthTime:%d",time - oauthTime);
			if(expiresTime - (time - oauthTime) <= 0){
				[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:type];
			}
		}
	}
	int userID = [[weiboArray objectAtIndex:weibo_user_id] intValue];
	uid = userID;
	
	NSMutableArray *appinfoArray = [DBOperate queryData:T_APP_INFO theColumn:nil theColumnValue:nil  withAll:YES];
	NSNumber *versoft = [NSNumber numberWithInt:0];
	NSNumber *vergrade = [NSNumber numberWithInt:0];
	if(appinfoArray != nil && [appinfoArray count] > 0){
		for (int i = 0; i < [appinfoArray count];i++ ) {
			NSArray *ay = [appinfoArray objectAtIndex:i];
			int type = [[ay objectAtIndex:versioninfo_type] intValue];
			if(type == 0){
				versoft = [ay objectAtIndex:versioninfo_ver];
			}else if(type == 1){
				vergrade = [ay objectAtIndex:versioninfo_ver];
			}
		}
	}
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 dtoken,@"token",
								 province,@"pro",
								 city,@"city",
								 [NSNumber numberWithInt: site_id],@"site-id",
								 macAdd,@"mac-addr",
								 [NSNumber numberWithInt: userID],@"uid",
								 [NSNumber numberWithBool:YES],@"isnew",
								 LatitudeAndLongitude,@"lat-and-long",
								 @"0",@"platform",versoft,@"ver_soft",vergrade,@"ver_grade",nil];
	
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/apns.do?param=%@"]];
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:APNS delegate:self params:nil];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}
- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	
}
- (NSString*)getMacAddress{
    return [SvUDIDTools UDID];
}


#pragma mark -
#pragma mark Application lifecycle
// Handle an actual notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	[self showString:userInfo];	
}

-(void)showString:(NSDictionary*)userInfo
{	
//	NSDictionary *content = [userInfo objectForKey:@"aps"];
//	showPushAlert *pusha = [[showPushAlert alloc]initWithContent:[content objectForKey:@"alert"] onViewController:navController];
//	self.pushAlert = pusha;
//	[pusha release];
//	[pushAlert showAlert];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSDictionary *titleDic = [userInfo objectForKey:@"aps"];
    NSString *title = [titleDic objectForKey:@"alert"];
    NSString *url = [userInfo objectForKey:@"url"];
    
    showPushAlert *pusha = [[showPushAlert alloc]initWithTitle:title url:url onViewController:navController];
	self.pushAlert = pusha;
	[pusha release];
	[pushAlert showAlert];
    
}

-(void)launchNotification:(NSNotification*)notification{
	
	[self showString:[[notification userInfo]objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
	//NSString *status = [NSString stringWithFormat:@"%@\nRegistration failed.\n\nError: %@", pushStatus(), [error localizedDescription]];
	//[self showString:status];
	//NSLog(@"status %@",status);
    NSLog(@"Error in registration. Error: %@", error);
    
    //获取位置
    [self getLocation];
}

//ios 8 通知需要多一层代理代理
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    NSLog(@"这是ios8通知新代理方法");
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSString *mydevicetoken = [[[NSMutableString stringWithFormat:@"%@",deviceToken]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""];
	//NSLog(@"deviceToken: %@", mydevicetoken);
	//[alertView showAlert:[NSString stringWithFormat:@"deviceToken: %@",mydevicetoken]];
	NSArray *ar_token = [NSArray arrayWithObject:mydevicetoken];
	[DBOperate deleteALLData:T_DEVTOKEN];
	[DBOperate insertData:ar_token tableName:T_DEVTOKEN];
	self.dtoken = mydevicetoken;
	
    //获取位置
    [self getLocation];
    
}

#pragma mark -
#pragma mark locationManager
-(NSString*)coordToString:(CLLocationCoordinate2D)coord{
	NSString *key = @"ABQIAAAAi0wvL4p1DYOdJ0iL-v2_sxR-h6gSv-DalIHlg2rPU6QFhO9KcRRTQ8IhBeqcKLxlL3lMxiK9r4f7Ug";
	NSString *urlStr = [NSString stringWithFormat:@"http://ditu.google.cn/maps/geo?output=csv&key=%@&q=%lf,%lf&hl=zh-CN",key,coord.latitude,coord.longitude];
	//NSString *urlStr = [NSString stringWithFormat:@"http://maps.google.cn/maps/geo?output=csv&key=%@&q=%lf,%lf&hl=zh-CN",key,coord.latitude,coord.longitude];
	NSURL *url = [NSURL URLWithString:urlStr];
    NSString *retstr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSArray *resultArray = [retstr componentsSeparatedByString:@","];
	NSLog(@"result %@",resultArray);
	return [resultArray objectAtIndex:2];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[locManager stopUpdatingLocation];
	locManager.delegate = nil;
	//self.locManager = nil;
	@try {
		double latitude = newLocation.coordinate.latitude;
		double longitude = newLocation.coordinate.longitude;
		myLocation.latitude = latitude;
		myLocation.longitude = longitude;
		LatitudeAndLongitude = [NSString stringWithFormat:@"%f,%f",longitude,latitude];
        NSString *address = [self coordToString:newLocation.coordinate];
        NSRange range1 = [address rangeOfString:@"国"];
        NSRange range2 = [address rangeOfString:@"省"];
        NSRange range3 = [address rangeOfString:@"市"];
        if (range2.location == NSNotFound)
        {
            NSRange rangepro = NSMakeRange(range1.location +1, range3.location-range1.location);
            self.province = [address substringWithRange:rangepro];
            self.city = province;
            
        }
        else
        {
           NSRange rangepro = NSMakeRange(range1.location +1, range2.location-range1.location);
           self.province = [address substringWithRange:rangepro];
           NSRange rangecity = NSMakeRange(range2.location +1, range3.location-range2.location);
           self.city = [address substringWithRange:rangecity];		
        }
        NSLog(@"province %@ city %@ ",province,city);
        
        //请求设备令牌接口
        [self accessService];
        
	}
	@catch (NSException *exception)
    {
		//请求设备令牌接口
        [self accessService];
        NSLog(@"========获取位置======失败");
		return;
	}
	
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locManager stopUpdatingLocation];
	locManager.delegate = nil;
    
    //请求设备令牌接口
    [self accessService];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

//重写AppDelegate的handleOpenURL和openURL方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSDictionary *param;
    NSLog(@"url:%@",[url absoluteString]);
    if (url != nil) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                 url,@"url", nil];
    }
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        if (delegate != nil && [delegate respondsToSelector:@selector(handleCallBack:)]) {
            [delegate handleCallBack:param];
        }
        delegate = nil;
        return YES;
    }else{
        return  [WXApi handleOpenURL:url delegate:self];
    }
}
//
//-(void) onReq:(BaseReq*)req
//{
//    if([req isKindOfClass:[GetMessageFromWXReq class]])
//    {
//        [self onRequestAppMessage];
//    }
//    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
//    {
//        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
//        [self onShowMediaMessage:temp.message]; 
//    }
//    
//}
//
//-(void) onRequestAppMessage
//{
//    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回    	
//	app_wechat_share_type = wechat_to_app;
//}
//
//-(void) onResp:(BaseResp*)resp
//{
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////        [alert show];
//        [alert release];
//    }
//    else if([resp isKindOfClass:[SendAuthResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////        [alert show];
//        [alert release];
//    }
//}

- (void)dealloc {
    [viewController release];
    [window release];
	[navController release];
	[networkQueue release];
	[tabArray release];
	[produceModuleArray release];
	[hotTabArrar release];
	[locManager release];
	[commonSpinner release];
	self.pushAlert = nil;
	self.province = nil;
	self.city = nil;
	//self.locManager = nil;
	self.dtoken = nil;
	self.commandOper = nil;
	[[XMLParser sharedInstance] release];
	tabArray = nil;	
	produceModuleArray = nil;
	hotTabArrar = nil;
	urlDictionary = nil;
	videoListArray = nil;
	ACCESS_SERVICE_LINK = nil;
	SHARE_TO_SINA = nil;
	SHARE_TO_QQ = nil;
	App_Registration = nil;
	Feedback = nil;
	shop_link;
	SHARE_CONTENT = nil;
	invite_content = nil;
	emailSubject = nil;
	emailContent = nil;
	soildListArray = nil;
	[updateAlert release];
	updateAlert = nil;
    [super dealloc];
}


@end
