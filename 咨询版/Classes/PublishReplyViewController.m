//
//  PublishReplyViewController.m
//  szeca
//
//  Created by MC374 on 12-5-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "ReplyCommentViewController.h"
#import "PublishReplyViewController.h"
#import "DBOperate.h"
#import "Common.h"
#import "CommandOperation.h"
#import "MBProgressHUD.h"
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MKPlacemark.h> 
#import "alertView.h"

@implementation PublishReplyViewController

@synthesize myTextView;
@synthesize checkBoxSelected;
@synthesize checkBox;
@synthesize commandOper;
@synthesize progressHUD;
@synthesize sync_weibo;
@synthesize productDescUrl;
@synthesize commentID;
@synthesize remainCount;
@synthesize province;
@synthesize city;


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
	[myTextView becomeFirstResponder];
	[myTextView setDelegate:self];
	UIBarButtonItem * sendButton= [[UIBarButtonItem alloc]
								   initWithTitle:@"发送"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(handleSendContent:)];
	self.navigationItem.rightBarButtonItem = sendButton;
	[sendButton release];
	self.title = @"回复评论";
	sync_weibo = 0;
	
	NSString *temp_province = [[NSString alloc] initWithString:@"广东省"];
	self.province = temp_province;
	[temp_province release];
	
	NSString *temp_city = [[NSString alloc] initWithString:@"深圳市"];
	self.city = temp_city;
	[temp_city release];
	
	MKReverseGeocoder *reverseGeocoder =[[[MKReverseGeocoder alloc] initWithCoordinate:myLocation] autorelease];
	reverseGeocoder.delegate = self;
	[reverseGeocoder start];
    
    //注册坚挺系统键盘事件通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	// 键盘高度变化通知，ios5.0新增的  
#ifdef __IPHONE_5_0
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 5.0) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
	}
#endif
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
	self.myTextView = nil;
	self.checkBox = nil;
	self.commandOper = nil;
	self.progressHUD.delegate = nil;
	self.progressHUD = nil;
	self.productDescUrl = nil;
	self.remainCount = nil;
	self.province = nil;
	self.commandOper.delegate = nil;
	self.commandOper = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.myTextView = nil;
	self.checkBox = nil;
	self.commandOper = nil;
	self.progressHUD.delegate = nil;
	self.progressHUD = nil;
	self.productDescUrl = nil;
	self.remainCount = nil;
	self.province = nil;
	self.commandOper.delegate = nil;
	self.commandOper = nil;
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


//然后实现下面两个代理方法即可获得你想要的地理信息
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    NSLog(@"MKReverseGeocoder has failed.");
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
    NSLog(@"当前地理信息为：%@",placemark.locality);
	NSLog(@"省份",placemark.administrativeArea);
	self.province = placemark.locality;
	self.city = placemark.administrativeArea;
}

-(IBAction) checkBoxButtonPress:(id)sender{
	checkBoxSelected = !checkBoxSelected;
    UIButton* check = (UIButton*) sender;
    if (checkBoxSelected == NO){
        [check setImage:[UIImage imageNamed:@"选择1.png"] forState:UIControlStateNormal];	
		sync_weibo = 0;
		}
    else{
        [check setImage:[UIImage imageNamed:@"选择2.png"] forState:UIControlStateNormal];
		sync_weibo = 1;
	}
}

-(void) handleSendContent:(id)sender{
	
	NSString *content = myTextView.text;
	
	//把回车 转化成 空格
	content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
	content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	
	if ([content length] > 0) 
	{
		if ([content length] > 140)
		{
			[alertView showAlert:@"回复内容不能超过140个字符"];
		}
		else 
		{
			NSMutableArray *array = [DBOperate queryData:T_WEIBO_USERINFO theColumn:nil theColumnValue:nil  withAll:YES];
			NSArray *weiboArray = nil;
			if(array != nil && [array count] > 0){
				weiboArray = [array objectAtIndex:0];
			}
			int userID = [[weiboArray objectAtIndex:weibo_user_id] intValue];
			
			double lng = myLocation.longitude;
			double lat = myLocation.latitude;
			NSString *client_ip = shop_link;
			
			MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(20, 30,280,80)];
			self.progressHUD = progressHUDTmp;
			[progressHUDTmp release];
			self.progressHUD.delegate = self;
			self.progressHUD.labelText = @"发送中... ";
			[self.view addSubview:self.progressHUD];
			[self.view bringSubviewToFront:self.progressHUD];
			[self.progressHUD show:YES];
			
			NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: site_id],@"site_id",
										 [NSNumber numberWithInt: userID],@"uid",content,@"content",
										 [NSNumber numberWithInt: commentID],@"comment_id",
										 province,@"province",city,@"city",
										 [NSNumber numberWithDouble:lng],@"lng",[NSNumber numberWithDouble:lat],@"lat",
										 [NSNumber numberWithInt:sync_weibo],@"sync_weibo",client_ip,@"client_ip",
										 productDescUrl,@"desc_url",nil];
			NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/comment/reply.do?param=%@"]];
			NSLog(@"reqstr wall paper %@",reqStr);
			CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:PUBLISH_COMMENT delegate:self params:nil];
			self.commandOper = commandOpertmp;
			[commandOpertmp release];
			[networkQueue addOperation:commandOper];
		}

	}
	else
	{
		[alertView showAlert:@"请输入回复内容！"];
	}

}

//编辑中
-(void) doEditing
{
	int textCount = [myTextView.text length];
	if (textCount > 140) 
	{
		remainCount.textColor = [UIColor colorWithRed:1.0 green: 0.0 blue: 0.0 alpha:1.0];
	}
	else 
	{
		remainCount.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	}
	
	remainCount.text = [NSString stringWithFormat:@"%d",140 - [myTextView.text length]];
}


#pragma mark -

#pragma mark TextView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	//return NO;  //输入无效
	//[text length] == 0  //点击了删除键
	//[self performSelector:@selector(doEditing) withObject:nil afterDelay:NO];
	
	[self performSelectorOnMainThread:@selector(doEditing) withObject:nil waitUntilDone:NO];
	
	return YES;
	
}


- (void)success
{
	if (self.progressHUD) {
		[progressHUD hide:YES afterDelay:1.0f];
	}
}

#pragma mark -
#pragma mark MBProgressHUD
- (void)hudWasHidden:(MBProgressHUD *)hud{
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}
	//[self.navigationController popViewControllerAnimated:YES];
	
	for (UIViewController *currentController in self.navigationController.viewControllers) 
	{
		if ([currentController isKindOfClass:[ReplyCommentViewController class]]) {
			ReplyCommentViewController *backController = currentController;
			backController.isRefresh = YES;
			[self.navigationController popToViewController:backController animated:YES];
		}
	}
}

- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	
	NSMutableArray* array = (NSMutableArray*)resultArray;
	int isSuccess = [[array objectAtIndex:0] intValue];
	if (isSuccess ==1) {
		
		if (self.progressHUD) {
			self.progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示正确图片.png"]] autorelease];
			self.progressHUD.mode = MBProgressHUDModeCustomView;
			self.progressHUD.labelText = @"发送成功";
		}
		
	}else if(isSuccess == -1){
		if (self.progressHUD) {
			self.progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示正确图片.png"]] autorelease];
			self.progressHUD.mode = MBProgressHUDModeDeterminate;
			self.progressHUD.labelText = @"发送失败";
		}
	}else if (isSuccess == 2) {
		if (self.progressHUD) {
			//			self.progressHUD.customView = nil;//[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示正确图片.png"]] autorelease];
			//			self.progressHUD.mode = MBProgressHUDModeDeterminate;
			self.progressHUD.labelText = @"发送成功，但同步到微博失败";
		}
	}else if (isSuccess == 3) {
		if (self.progressHUD) {
			//			self.progressHUD.customView = nil;//[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示正确图片.png"]] autorelease];
			//			self.progressHUD.mode = MBProgressHUDModeDeterminate;
			self.progressHUD.labelText = @"你已经陪屏蔽了，请联系客服";
		}
	}
	[self performSelectorOnMainThread:@selector(success) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification{
	/*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification{
	NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

-(void)moveInputBarWithKeyboardHeight:(float)height withDuration:(NSTimeInterval)animationDuration{    
	NSString *inputType = [[UITextInputMode currentInputMode] primaryLanguage]; 
	if(IOS_VERSION >= 5.0){
		if ([inputType isEqualToString:@"zh-Hans"]) {
			height = 252.0f;
		}else {
			height = 216.0f;
		}
		float viewHeight = self.view.frame.size.height;
		[remainCount setFrame:CGRectMake(remainCount.frame.origin.x,viewHeight - height  - remainCount.frame.size.height, remainCount.frame.size.width, remainCount.frame.size.height)];
		[myTextView setFrame:CGRectMake(myTextView.frame.origin.x,myTextView.frame.origin.y, myTextView.frame.size.width, viewHeight - height - remainCount.frame.size.height - 10)];
	}
}

@end
