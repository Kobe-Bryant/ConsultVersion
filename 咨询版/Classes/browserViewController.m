//
//  browserViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-9-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "browserViewController.h"
#import "manageActionSheet.h"
#import <MessageUI/MessageUI.h>
#import "alertView.h"
#import "callSystemApp.h"
#import "Common.h"
#import "ShareWithQRCodeViewController.h"
#import "CommentListViewController.h"
#import "DBOperate.h"
#import "WBEngine.h"
#import "ShareToBlogViewController.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "SendMsgToWeChat.h"
#import "UpdateAppAlert.h"

#define SHARE_ACTIONSHEET_ID 3001
#define WECHAT_ACTIONSHEET_ID 3002
#define TOOLHEIGHT 44.0f

@implementation browserViewController
@synthesize progressHUD;
@synthesize actionsheet;
@synthesize linkurl;
@synthesize linktitle;
@synthesize ButtonItem;
@synthesize webView;
@synthesize testtb;
@synthesize isHideToolbar;
@synthesize isFirstLoad;
@synthesize isShowCommentButton;
@synthesize newsID;
@synthesize moduleType;
@synthesize commentCount;
@synthesize weChatActionsheet;
@synthesize newsImage;
@synthesize newsTitle;
@synthesize newsDesc;
@synthesize weChatAlert;
@synthesize isFromAd;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewHeight = [UIScreen mainScreen].bounds.size.height - 44.0f - 20.0f;
    
	isFirstLoad = YES;
//	commentCount=9;
	UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init]; 
	self.ButtonItem = tempButtonItem;
	tempButtonItem .title = @"返回";
	self.navigationItem.backBarButtonItem = tempButtonItem ; 
	[tempButtonItem release];

    testtb.tintColor = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:0]; //[UIColor colorWithPatternImage:[UIImage imageNamed:@"23232.png"]];
	
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"向前",@"向后",nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	CGRect rect=CGRectMake(0.0f, 0.0f, 150.0f, 30.0f);
	segmentedControl.frame=rect;
	segmentedControl.momentary = YES; 
	//segmentedControl.tintColor=[UIColor brownColor];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *contactSegment = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
	//segmentedControl.selectedSegmentIndex = 0;
	self.navigationItem.rightBarButtonItem = contactSegment;
	[segmentedControl release];
	[contactSegment release];
	[self setSegmentEnable];
	if(isHideToolbar){
		[self hideToolBar];
	}else {
//		[self showToolBar];
        if (isFromAd == YES) {
            [self showCustomToolbarHideCommentBtn];
        }else {
            [self showCustomToolbar];
        }
	}
    
    UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 320.0f, viewHeight - TOOLHEIGHT)];
	self.webView = tempWebView;
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	[self.view addSubview:webView];
	[tempWebView release];
	if ([self.linkurl length] > 1)
	{
		//开始请求连接
		NSURL *webUrl =[NSURL URLWithString:self.linkurl];
		NSURLRequest *request =[NSURLRequest requestWithURL:webUrl];
		[webView loadRequest:request];
	}
    
	//MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0 ,320 , viewHeight - TOOLHEIGHT)];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";

}

- (void)showToolBar{
	
	UIToolbar *myToolBar = [[UIToolbar alloc] initWithFrame:  
							CGRectMake(0.0f, viewHeight - TOOLHEIGHT, 320.0f, TOOLHEIGHT)];
	myToolBar.tintColor = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:0];
	[self.view addSubview:myToolBar];
	
	NSMutableArray *buttons=[[NSMutableArray  alloc]init];  
	[buttons  autorelease];  
	
	UIBarButtonItem   *SpaceButton1=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];  
	[buttons addObject:SpaceButton1];  
	[SpaceButton1 release];  
	
	UIBarButtonItem   *freshButton=[[UIBarButtonItem alloc]  initWithTitle: @"分享" style: UIBarButtonItemStyleBordered target:self   action:@selector(share:)];  
	[buttons addObject:freshButton];  
	[freshButton release];   
	UIBarButtonItem   *SpaceButton2=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];  
	[buttons addObject:SpaceButton2];  
	[SpaceButton2 release];  
	
	UIBarButtonItem   *searchSelfButton=[[UIBarButtonItem alloc] initWithTitle: @"刷新" style: UIBarButtonItemStyleBordered target:self   action:@selector(reload:)];  
	[buttons addObject:searchSelfButton];  
	[searchSelfButton release];  
	
	UIBarButtonItem   *SpaceButton3=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];  
	[buttons addObject:SpaceButton3];  
	[SpaceButton3 release]; 
	
	if (isShowCommentButton) {
		UIBarButtonItem   *commentButton;
		
		if (self.commentCount > 0) {
			NSString *titleString = [NSString stringWithFormat:@"评论(%d)",commentCount];
			commentButton =[[UIBarButtonItem alloc] initWithTitle:titleString style: UIBarButtonItemStyleBordered target:self action:@selector(comment:)];  
		}else {
			commentButton =[[UIBarButtonItem alloc] initWithTitle: @"评论" style: UIBarButtonItemStyleBordered target:self action:@selector(comment:)];  
		}

		[buttons addObject:commentButton];  
		[commentButton release];  
		
		UIBarButtonItem   *SpaceButton4=[[UIBarButtonItem alloc] 
										 initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil  action:nil];  
		[buttons addObject:SpaceButton4];  
		[SpaceButton4 release]; 
		
	}
	
	UIBarButtonItem   *weChatButton=[[UIBarButtonItem alloc] initWithTitle: @"微信" style: UIBarButtonItemStyleBordered target:self   action:@selector(HandleToWeChat:)];  
	[buttons addObject:weChatButton];  
	[weChatButton release];  
	
	UIBarButtonItem   *SpaceButton5=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil   action:nil];  
	[buttons addObject:SpaceButton5];  
	[SpaceButton5 release];
	
	[myToolBar setItems:buttons animated:YES];  
	[myToolBar  sizeToFit]; 
	[myToolBar release];
    
}


- (void) showCustomToolbar{
	UIImageView *toolBarView = [[UIImageView alloc] initWithFrame:
								CGRectMake(0.0f, viewHeight - TOOLHEIGHT, 320.0f, TOOLHEIGHT)];
	UIImage *image = [[UIImage alloc]initWithContentsOfFile:
					  [[NSBundle mainBundle] pathForResource:@"共用下bar" ofType:@"png"]];
	toolBarView.image = image;
	toolBarView.backgroundColor = [UIColor blackColor];
	toolBarView.tag = 3005;
	toolBarView.userInteractionEnabled = YES;
	[image release];	
	[self.view addSubview:toolBarView];
	
	int buttonMargin;
	if (isShareToWechat) {
		buttonMargin = (320 - 24*4)/5;
	}else {
		buttonMargin = (320 - 24*4)/4;
	}
	int offset;
	
	UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[shareBtn setFrame:CGRectMake(buttonMargin, 4, 24, 24)];
	[shareBtn setImage:[UIImage imageNamed:@"分享icon.png"] forState:UIControlStateNormal];
	[shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *sharelabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin, 28, 30, 14)];
	sharelabel.text = @"分享";
	sharelabel.textColor = [UIColor whiteColor];
	sharelabel.backgroundColor = [UIColor clearColor];
	sharelabel.font = [UIFont systemFontOfSize:12];
	
	[toolBarView addSubview:sharelabel];	
	[toolBarView addSubview:shareBtn];
	[sharelabel release];
	
	offset = buttonMargin*2 + 24;
	
	UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[commentBtn setFrame:CGRectMake(offset, 4, 24, 24)];
	[commentBtn setImage:[UIImage imageNamed:@"评论icon.png"] forState:UIControlStateNormal];
	[commentBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *commentlabel = [[UILabel alloc] initWithFrame:CGRectMake(offset - 10, 28, 80, 14)];
	commentlabel.text = [NSString stringWithFormat:@"评论(%d)",commentCount];
	commentlabel.textColor = [UIColor whiteColor];
	commentlabel.backgroundColor = [UIColor clearColor];
	commentlabel.font = [UIFont systemFontOfSize:12];
	
	[toolBarView addSubview:commentlabel];	
	[toolBarView addSubview:commentBtn];
	[commentlabel release];
	
	offset = buttonMargin*3 + 24*2;
	
	UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[detailBtn setFrame:CGRectMake(offset, 4, 24, 24)];
	[detailBtn setImage:[UIImage imageNamed:@"刷新icon.png"] forState:UIControlStateNormal];
	[detailBtn addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *detaillabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 28, 30, 14)];
	detaillabel.text = @"刷新";
	detaillabel.textColor = [UIColor whiteColor];
	detaillabel.backgroundColor = [UIColor clearColor];
	detaillabel.font = [UIFont systemFontOfSize:12];
	
	[toolBarView addSubview:detaillabel];	
	[toolBarView addSubview:detailBtn];
	[detaillabel release];
	
	if (isShareToWechat) {
		
		offset = buttonMargin*4 + 24*3;
		
		UIButton *wechatbtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[wechatbtn setFrame:CGRectMake(offset, 4, 24, 24)];
		[wechatbtn setImage:[UIImage imageNamed:@"微信icon.png"] forState:UIControlStateNormal];
		[wechatbtn addTarget:self action:@selector(HandleToWeChat:) forControlEvents:UIControlEventTouchUpInside];
		
		UILabel *wechatlabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 28, 30, 14)];
		wechatlabel.text = @"微信";
		wechatlabel.textColor = [UIColor whiteColor];
		wechatlabel.backgroundColor = [UIColor clearColor];
		wechatlabel.font = [UIFont systemFontOfSize:12];
		
		[toolBarView addSubview:wechatlabel];	
		[toolBarView addSubview:wechatbtn];
		[wechatlabel release];
	}
	
	[toolBarView release];
}

- (void) showCustomToolbarHideCommentBtn{
	UIImageView *toolBarView = [[UIImageView alloc] initWithFrame:
								CGRectMake(0.0f, viewHeight - TOOLHEIGHT, 320.0f, TOOLHEIGHT)];
	UIImage *image = [[UIImage alloc]initWithContentsOfFile:
					  [[NSBundle mainBundle] pathForResource:@"共用下bar" ofType:@"png"]];
	toolBarView.image = image;
	toolBarView.backgroundColor = [UIColor blackColor];
	toolBarView.tag = 3005;
	toolBarView.userInteractionEnabled = YES;
	[image release];
	[self.view addSubview:toolBarView];
	
	int buttonMargin;
	if (isShareToWechat) {
		buttonMargin = (320 - 24*3)/4;
	}else {
		buttonMargin = (320 - 24*2)/3;
	}
	int offset;
	
	UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[shareBtn setFrame:CGRectMake(buttonMargin, 4, 24, 24)];
	[shareBtn setImage:[UIImage imageNamed:@"分享icon.png"] forState:UIControlStateNormal];
	[shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *sharelabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin, 28, 30, 14)];
	sharelabel.text = @"分享";
	sharelabel.textColor = [UIColor whiteColor];
	sharelabel.backgroundColor = [UIColor clearColor];
	sharelabel.font = [UIFont systemFontOfSize:12];
	
	[toolBarView addSubview:sharelabel];
	[toolBarView addSubview:shareBtn];
	[sharelabel release];
	
	offset = buttonMargin*2 + 24;
	
	UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[detailBtn setFrame:CGRectMake(offset, 4, 24, 24)];
	[detailBtn setImage:[UIImage imageNamed:@"刷新icon.png"] forState:UIControlStateNormal];
	[detailBtn addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *detaillabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 28, 30, 14)];
	detaillabel.text = @"刷新";
	detaillabel.textColor = [UIColor whiteColor];
	detaillabel.backgroundColor = [UIColor clearColor];
	detaillabel.font = [UIFont systemFontOfSize:12];
	
	[toolBarView addSubview:detaillabel];
	[toolBarView addSubview:detailBtn];
	[detaillabel release];
	
	if (isShareToWechat) {
		
		offset = buttonMargin*3 + 24*2;
		
		UIButton *wechatbtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[wechatbtn setFrame:CGRectMake(offset, 4, 24, 24)];
		[wechatbtn setImage:[UIImage imageNamed:@"微信icon.png"] forState:UIControlStateNormal];
		[wechatbtn addTarget:self action:@selector(HandleToWeChat:) forControlEvents:UIControlEventTouchUpInside];
		
		UILabel *wechatlabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 28, 30, 14)];
		wechatlabel.text = @"微信";
		wechatlabel.textColor = [UIColor whiteColor];
		wechatlabel.backgroundColor = [UIColor clearColor];
		wechatlabel.font = [UIFont systemFontOfSize:12];
		
		[toolBarView addSubview:wechatlabel];
		[toolBarView addSubview:wechatbtn];
		[wechatlabel release];
	}
	
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden=NO;
	self.navigationController.toolbarHidden = YES;
}

-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBarHidden=NO;
}

- (void)hideToolBar{
	UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake( 0, 0, 320, viewHeight)];
	self.webView = webview;
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	[self.view addSubview:webView];
	[webview release];
}


-(void)loadURL:(NSString*)str_URL{

	if (str_URL.length > 0) {
		NSURL *url = [[NSURL alloc] initWithString:str_URL];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
		[self.webView loadRequest: request];
		[request release];
		[url release];
		//[self webViewDidStartLoad : webView];
	}
}
-(IBAction)reload:(id)sender{
	[webView reload];
}
-(IBAction)search:(id)sender{
	[self loadURL:@"http://yy.3g.cn/"];
}
-(IBAction)share:(id)sender{
	NSArray *actionSheetMenu = [NSArray arrayWithObjects:@"分享给手机用户",@"分享给邮箱联系人",@"分享到新浪微博",@"分享到腾讯微博",@"二维码分享",nil];
	manageActionSheet *actionsheet1 = [[manageActionSheet alloc]initActionSheetWithStrings:actionSheetMenu];
	actionsheet1.manageDeleage = self;
	actionsheet1.actionID = SHARE_ACTIONSHEET_ID;
	self.actionsheet = actionsheet1;
	[actionsheet1 release];
	[actionsheet showActionSheet:self.navigationController.navigationBar];	
}

-(IBAction)comment:(id)sender{
	CommentListViewController *commentList = [[CommentListViewController alloc] init];
	commentList.moduleTitle = linktitle;
	commentList.productID = newsID;
	commentList.versionType = NEWS_ID;
	commentList.productUrl = linkurl;
	commentList.moduleType = [moduleType intValue];
	[self.navigationController pushViewController:commentList animated:YES];
	[commentList release];
}

-(IBAction)HandleToWeChat:(id)sender{	
	if(![WXApi isWXAppInstalled]){
		NSString *wechaturl = @"http://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
		UpdateAppAlert *alert = [[UpdateAppAlert alloc]
								 initWithContent:nil content:@"使用微信可以方便、免费的与好友分享图片、新闻" 
								 leftbtn:@"取消" rightbtn:@"下载微信" url:wechaturl onViewController:self.navigationController];
		self.weChatAlert = alert;
		[weChatAlert showAlert];
		[alert release];
	}else {	
		NSArray *actionSheetMenu = [NSArray arrayWithObjects:@"去微信分享给好友",nil];
		manageActionSheet *actionsheet1 = [[manageActionSheet alloc]initActionSheetWithStrings:actionSheetMenu];
		actionsheet1.manageDeleage = self;
		actionsheet1.actionID = WECHAT_ACTIONSHEET_ID;
		self.weChatActionsheet = actionsheet1;
		[actionsheet1 release];
		[weChatActionsheet showActionSheet:self.navigationController.navigationBar];
	}
}

- (void) actionSheetAppear:(int)actionID actionSheet:(UIActionSheet *)actionSheet{
	
}

- (void) sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body
{
	NSString* str = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",to, cc, subject, body];
	str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)getChoosedIndex:(int)actionID chooseIndex:(int)index{
	if (actionID == SHARE_ACTIONSHEET_ID) {
		NSString *param = [NSString stringWithString:SHARE_CONTENT];
		
		NSString *param1 = [NSString stringWithFormat:@"[%@]  %@",linktitle,linkurl];
		param1 = [param stringByAppendingString:param1];
		param = [Common URLEncodedString:param1];
		
		switch (index) {
			case 0:
			{
				[callSystemApp sendMessageTo:@"" inUIViewController:self withContent:param1];
				break;
			}
			case 1:
			{////收件人，cc：抄送  subject：主题   body：内容
				[callSystemApp sendEmail:@"" cc:@"" subject:SHARE_CONTENT body:param1];
				
				break;
			}
			case 2:
			{
				NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:SINA withAll:NO];
				NSArray *array = nil;
				
				if(weiboArray != nil && [weiboArray count] > 0){
					array = [weiboArray objectAtIndex:0];
					int oauthTime = [[array objectAtIndex:weibo_oauth_time] intValue];
					int expiredTime = [[array objectAtIndex:weibo_expires_time] intValue];
					NSString *type = [array objectAtIndex:weibo_type];
					NSDate *todayDate = [NSDate date]; 
					NSLog(@"Date:%@",todayDate);
					NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
					int time = inter;
					NSLog(@"current time:%d",time);
					NSLog(@"expiresTime:%d",expiredTime);
					NSLog(@"time - oauthTime:%d",time - oauthTime);
					if(expiredTime - (time - oauthTime) <= 0){
						[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:type];
						weiboArray = nil;
					}
				}
				
				if (weiboArray != nil && [weiboArray count] > 0) {
					array = [weiboArray objectAtIndex:0];
					NSString *accessToken = [array objectAtIndex:weibo_access_token];
					double expiresTime = [[array objectAtIndex:weibo_expires_time] doubleValue];
					NSString *weibo_uid = [array objectAtIndex:weibo_user_id];
                    
                    //微博分享采用新的接口，使用SinaWeibo类
                    SinaWeibo *weibo = [[SinaWeibo alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret appRedirectURI:redirectUrl andDelegate:nil];
                    weibo.userID = weibo_uid;
                    weibo.accessToken = accessToken;
                    weibo.expirationDate = [NSDate dateWithTimeIntervalSince1970:expiresTime];
                    
//					WBEngine *wbengine = [[WBEngine alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret];
//					wbengine.accessToken = accessToken;
//					wbengine.userID = weibo_uid; 
//					wbengine.expireTime = expiresTime;
                    
					//已经绑定了微博账号，调用新浪微博分享界面
					ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
					share.defaultContent = param1;
//					share.engine = wbengine;
                    share.sinaWeibo = weibo;
					share.weiBoType = 0;
					[self.navigationController pushViewController:share animated:YES];
					[share release];
					
				}else {
					LoginViewController *login = [[LoginViewController alloc] init];
					login.delegate = self;
					[self.navigationController pushViewController:login animated:YES];
					[login release];
				}
				break;
				
				break;
			}
			case 3:
			{
				NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:TENCENT withAll:NO];
				NSArray *array = nil;
				
				if(weiboArray != nil && [weiboArray count] > 0){
					array = [weiboArray objectAtIndex:0];
					int expiredTime = [[array objectAtIndex:weibo_expires_time] intValue];
					NSDate *todayDate = [NSDate date]; 
					NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiredTime];
					NSLog(@"todayDate:%@",todayDate);
					NSLog(@"expirationDate:%@",expirationDate);
					if([todayDate compare:expirationDate] == NSOrderedSame){
						[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:TENCENT];
						weiboArray = nil;
					}else {
						NSLog(@"not expired");
					}
				}
				
				if (weiboArray != nil && [weiboArray count] > 0) {
					array = [weiboArray objectAtIndex:0];
					NSString *accessToken = [array objectAtIndex:weibo_access_token];
					NSString *openid = [array objectAtIndex:weibo_open_id];
					NSString *username = [array objectAtIndex:weibo_user_name];
					
					ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
					share.qAccessToken = accessToken;
					share.qOpenid = openid;
					share.qWeiboUserName = username;
					share.defaultContent = param1;
					share.weiBoType = 1;
					[self.navigationController pushViewController:share animated:YES];
					[share release];
				}else{	
					LoginViewController *login = [[LoginViewController alloc] init];
					login.delegate = self;
					[self.navigationController pushViewController:login animated:YES];
					[login release];
				}
				break;
				
			}
			case 4:			
			{
				ShareWithQRCodeViewController *share = [[ShareWithQRCodeViewController alloc]init];
				share.linkurl = self.linkurl;
				share.linktitle = self.linktitle;
				[self.navigationController pushViewController:share animated:YES];
				[share release];
				break;
			}
			default:
				break;
		}
	}
	else if(actionID == WECHAT_ACTIONSHEET_ID){
		SendMsgToWeChat *sendMsg = [[SendMsgToWeChat alloc] init];	
		if (newsImage == nil) {
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:
					   [[NSBundle mainBundle] pathForResource:@"微信分享默认图" ofType:@"png"]];
			self.newsImage = img;
			[img release];
		}
		self.linkurl = [linkurl stringByAppendingFormat:@"&isFromWeixin=1"];
		if (app_wechat_share_type == app_to_wechat) {
			[sendMsg sendNewsContent:newsTitle newsDescription:newsDesc newsImage:newsImage newUrl:linkurl];
		}else if (app_wechat_share_type == wechat_to_app) {
			[sendMsg RespNewsContent:newsTitle newsDescription:newsDesc newsImage:newsImage newUrl:linkurl];
		}			
		[sendMsg release];
	}
}

#pragma mark -
#pragma mark LoginViewController delegate

-(void)loginSuccess:(NSString*)withLoginType{
	NSString *param = [NSString stringWithString:SHARE_CONTENT];
	
	NSString *param1 = [NSString stringWithFormat:@"[%@]  %@",linktitle,linkurl];
	param1 = [param stringByAppendingString:param1];
	param = [Common URLEncodedString:param1];
	if ([withLoginType isEqualToString:SINA]) {
		NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:SINA withAll:NO];
		NSArray *array = nil;
		if (weiboArray != nil && [weiboArray count] > 0) {
			array = [weiboArray objectAtIndex:0];
			NSString *accessToken = [array objectAtIndex:weibo_access_token];
			double expiresTime = [[array objectAtIndex:weibo_expires_time] doubleValue];
			NSString *weibo_uid = [array objectAtIndex:weibo_user_id];
            
            SinaWeibo *weibo = [[SinaWeibo alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret appRedirectURI:redirectUrl andDelegate:nil];
            weibo.userID = weibo_uid;
            weibo.accessToken = accessToken;
            weibo.expirationDate = [NSDate dateWithTimeIntervalSince1970:expiresTime];
            
//			WBEngine *wbengine = [[WBEngine alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret];
//			wbengine.accessToken = accessToken;
//			wbengine.userID = weibo_uid; 
//			wbengine.expireTime = expiresTime;
			//已经绑定了微博账号，调用新浪微博分享界面
			ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
			share.defaultContent = param1;
//			share.engine = wbengine;
            share.sinaWeibo = weibo;
			share.weiBoType = 0;
			[self.navigationController pushViewController:share animated:YES];
			[share release];
		}
	}else if ([withLoginType isEqualToString:TENCENT]) {
		NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:TENCENT withAll:NO];
		NSArray *array = nil;
		if (weiboArray != nil && [weiboArray count] > 0) {
			array = [weiboArray objectAtIndex:0];
			NSString *accessToken = [array objectAtIndex:weibo_access_token];
			NSString *openid = [array objectAtIndex:weibo_open_id];
			NSString *username = [array objectAtIndex:weibo_user_name];
			
			ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
			share.qAccessToken = accessToken;
			share.qOpenid = openid;
			share.qWeiboUserName = username;
			share.defaultContent = param1;
			share.weiBoType = 1;
			[self.navigationController pushViewController:share animated:YES];
			[share release];
		}
	}
}


- (BOOL)webView:(UIWebView *)webView1 shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	//self.linkurl=[[request URL]absoluteString];
	NSLog(@"linkurl %@",linkurl);
	return YES;
}

-(void)setSegmentEnable{
	UISegmentedControl *contactSegment=self.navigationItem.rightBarButtonItem.customView;
	if ([webView canGoBack]) {
		[contactSegment setEnabled:YES forSegmentAtIndex:0];
	}
	else {
		[contactSegment setEnabled:NO forSegmentAtIndex:0];
	}
	
	if ([webView canGoForward]) {
		[contactSegment setEnabled:YES forSegmentAtIndex:1];
	}
	else {
		[contactSegment setEnabled:NO forSegmentAtIndex:1];
	}
	
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
	}	
	if (isFirstLoad && ![linktitle length] > 0) {
		self.linktitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
		//self.linktitle = @"返回";
	}
	isFirstLoad = NO;
	//ButtonItem.title = linktitle;
	[self setSegmentEnable];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	[self.progressHUD show:YES];
}
-(void)segmentAction:(id)sender{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	switch ([segmentedControl selectedSegmentIndex]) 
	{
		case 0:
		{
			[webView goBack];	
		break;
		}
		case 1:
		{
			[webView goForward];
			break;
		}

	}
	[self setSegmentEnable];

}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.webView = nil;
	self.testtb = nil;
	self.ButtonItem = nil;
	self.progressHUD = nil;
	self.newsID = nil;
	self.moduleType = nil;
	self.weChatActionsheet = nil;
	self.newsImage = nil;
	self.newsTitle = nil;
	self.newsDesc = nil;
	self.weChatAlert = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	webView.delegate = nil;
	self.progressHUD = nil;
	self.actionsheet = nil;
	self.linkurl = nil;
	self.linktitle = nil;
	self.ButtonItem = nil;
	self.webView = nil;
	self.testtb = nil;
	self.newsID = nil;
	self.moduleType = nil;
	self.weChatActionsheet = nil;
	self.newsImage = nil;
	self.newsTitle = nil;
	self.newsDesc = nil;
	self.weChatAlert = nil;
    [super dealloc];
}


@end
