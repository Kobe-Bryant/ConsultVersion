//
//  moreViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "moreViewController.h"
#import "Common.h"
#import "browserViewController.h"
#import <MessageUI/MessageUI.h>
#import "alertView.h"
#import "DBOperate.h"
#import "callSystemApp.h"
#import "detailAboutUsViewController.h"
#import "XMLParser.h"
#import "LoginViewController.h"
#import "AccountSettingViewController.h"
#import "UpdateAppAlert.h"

@interface moreObject : NSObject
{
	NSString *Title;
	NSString *link;
	NSString *content;
}
@property(nonatomic,retain)NSString *Title;
@property(nonatomic,retain)NSString *link;
@property(nonatomic,retain)NSString *content;
@end

@implementation moreObject
@synthesize Title;
@synthesize link;
@synthesize content;

-(void)dealloc{
	self.Title = nil;
	self.link = nil;
	self.content = nil;
	[super dealloc];
}

@end


@implementation moreViewController
@synthesize morelist;
@synthesize commandOper;
@synthesize progressHUD;
@synthesize branchArray;
@synthesize abody;
@synthesize updateAlert;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    if (IOS_VERSION >= 7.0) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10.0f)];
    }
	
	//MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, -44 ,320 , 460)];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";
	
	self.title = @"更多";
	morelist = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 20.0f - 44.0f - 49.0f)];
    
	[self accessService];
}
-(void)accessService{
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	[self.progressHUD show:YES];	
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[Common getVersion:ABOUTUS_ID],@"body-ver",[Common getVersion:BRANCH_ID],@"branch-ver",[NSNumber numberWithInt: shop_id],@"shop-id",[NSNumber numberWithInt: site_id],@"site-id",nil];
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/service/about.do?param=%@"]];
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:ABOUTUS delegate:self params:nil];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}
- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	NSLog(@"verrr ");
	if (ver==NEED_UPDATE || morelist == nil) {
		NSLog(@"verrdddd ");
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}

}
-(void)update{
	self.morelist = [NSMutableArray array];	
	NSArray *ar_about = [DBOperate queryData:T_ABOUT theColumn:nil theColumnValue:nil  withAll:YES];
	if ([ar_about count]>0) {
		NSArray *arr_about = [ar_about objectAtIndex:0];
		moreObject *mo1 = [[moreObject alloc]init];
		mo1.Title = @"关于我们";
		mo1.link = nil;
		if ([arr_about count]>0) {
			mo1.content = [arr_about objectAtIndex:aboutus_content];
		}
		[morelist addObject:mo1];
		[mo1 release];
	}
	
	moreObject *mo5 = [[moreObject alloc]init];
	mo5.Title = @"微博设置";
	mo5.link = nil;
	mo5.content = @"设置您的微博，分享您的精彩";
	[morelist addObject:mo5];
	[mo5 release];
	
	moreObject *mo2 = [[moreObject alloc]init];
	mo2.Title = @"会员注册";
	mo2.link = App_Registration;
	NSLog(@"mo2 %@",mo2.link);
	mo2.content = @"免费注册成为我们的会员";
	[morelist addObject:mo2];
	[mo2 release];
	
	moreObject *mo3 = [[moreObject alloc]init];
	mo3.Title = @"在线反馈";
	mo3.link = [NSString stringWithFormat:Feedback,shop];
	
	mo3.content = @"在线提交您的意见和建议";
	[morelist addObject:mo3];
	[mo3 release];
	moreObject *mo4 = [[moreObject alloc]init];
	mo4.Title = @"邀请好友";
	mo4.link = nil;
	mo4.content = invite_content;
	[morelist addObject:mo4];
	[mo4 release];
		
	
	NSMutableArray *gradeArray = [DBOperate queryData:T_APP_INFO 
											theColumn:@"type" theColumnValue:[NSNumber numberWithInt:1] withAll:NO];
	if (gradeArray != nil && [gradeArray count] > 0) {
		NSArray *array = [gradeArray objectAtIndex:0];
		NSString *updateGradeUrl = [array objectAtIndex:versioninfo_url];
		if (updateGradeUrl != nil && [updateGradeUrl length] > 0) {
			moreObject *mo6 = [[moreObject alloc]init];
			mo6.Title = @"去给资讯版评个分";
			mo6.link = nil;
			mo6.content = @"去给资讯版打个分，评价一把";
			[morelist addObject:mo6];
			[mo6 release];
		}		
	}


//	NSMutableArray *updateArray = [DBOperate queryData:T_APP_INFO 
//											theColumn:@"type" theColumnValue:[NSNumber numberWithInt:0] withAll:NO];
//	if (updateArray != nil && [updateArray count] > 0) {
//		NSArray *array = [updateArray objectAtIndex:0];
//		NSString *updateurl = [array objectAtIndex:versioninfo_url];
//		if (updateurl != nil && [updateurl length] > 0) {
			moreObject *mo7 = [[moreObject alloc]init];
			mo7.Title = @"检测新版本";
			mo7.link = nil;
			mo7.content = @"查看是否有版本更新，下载最新版本";
			[morelist addObject:mo7];
			[mo7 release];
//		}
//	}
		
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}	
	
	[self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 65.0f;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [morelist count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
		cell.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];
		cell.detailTextLabel.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];
	}
	moreObject *mo = [morelist objectAtIndex:[indexPath row]];
	cell.textLabel.text = mo.Title;
	cell.detailTextLabel.text =  mo.content;
	NSString *picname = [NSString stringWithFormat:@"%@%@",mo.Title,@".png"];
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:picname ofType:nil]];
	cell.imageView.image = img;
    [img release];
	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	moreObject *mo = [morelist objectAtIndex:[indexPath row]];
	if ([mo.Title isEqualToString:@"关于我们"]) {
		detailAboutUsViewController *detail = [[detailAboutUsViewController alloc]initWithStyle:UITableViewStyleGrouped];
		[self.navigationController pushViewController:detail animated:YES];
		[detail release];
		return;
	}
	
	if ([mo.Title isEqualToString:@"邀请好友"]) {
		NSString *link = [NSString stringWithFormat:shop_link];
		NSString *linkApp = [link stringByAppendingFormat:@"/app"];
		NSLog([mo.content stringByAppendingFormat:linkApp]);
		[callSystemApp sendMessageTo:@"" inUIViewController:self withContent:[mo.content stringByAppendingFormat:linkApp]];
		//[callSystemApp sendMessageTo:@"" inUIViewController:self withContent:[mo.content ]];
		//[callSystemApp sendMessage:mo.content];
	}
	if ([mo.Title isEqualToString:@"微博设置"]) {
		LoginViewController *login = [[LoginViewController alloc] init];
		[self.navigationController pushViewController:login animated:YES];
		[login release];
	}
	if ([mo.Title isEqualToString:@"去给资讯版评个分"]) {
		
		NSMutableArray *gradeArray = [DBOperate queryData:T_APP_INFO 
												theColumn:@"type" theColumnValue:[NSNumber numberWithInt:1] withAll:NO];
		if (gradeArray != nil && [gradeArray count] > 0) {
			NSArray *array = [gradeArray objectAtIndex:0];
			NSString *appGradeUrl = [array objectAtIndex:versioninfo_url];
			NSURL *url = [NSURL URLWithString:appGradeUrl];
			[[UIApplication sharedApplication] openURL:url];
		}

	}
	if ([mo.Title isEqualToString:@"检测新版本"]) {
		MBProgressHUD *progress = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0 ,320 , 460)];
		progress.delegate = self;
		progress.labelText = @"新版本检测中...";		
		[self.view addSubview:progress];
		[self.view bringSubviewToFront:progress];
		[progress show:YES];
		[progress hide:YES afterDelay:3.0f];
	}
	if(mo.link != nil)
	{
		browserViewController *browser = [[browserViewController alloc]init];
		browser.isHideToolbar = YES;
        NSString *url = [mo.link stringByAppendingFormat:@"?fromapp=1"];
		browser.linkurl = url;
		[self.navigationController pushViewController:browser animated:YES];
		[browser release];
	}
	
}


#pragma mark -
#pragma mark MBProgressHUD
- (void)hudWasHidden:(MBProgressHUD *)hud{
	[hud removeFromSuperview];
	
	NSMutableArray *updateArray = [DBOperate queryData:T_APP_INFO 
											 theColumn:@"type" theColumnValue:[NSNumber numberWithInt:0] withAll:NO];
	if (updateArray != nil && [updateArray count] > 0) {
		NSArray *array = [updateArray objectAtIndex:0];
		int newVersion = [[array objectAtIndex:versioninfo_ver] intValue];
		NSString *updateUrl = [array objectAtIndex:versioninfo_url];
		if (newVersion <= CURRENT_APP_VERSION) {
			[alertView showAlert:@"当前已经是最新版本了"];
		}else {
			//NSURL *url = [NSURL URLWithString:updateUrl];
			//[[UIApplication sharedApplication] openURL:url];
			UpdateAppAlert *alert = [[UpdateAppAlert alloc]
									 initWithContent:@"检测到新版本" content:@"资讯版有新版本了！是否马上更新升级到新版本？" 
									 leftbtn:@"稍后再说" rightbtn:@"立即更新" url:updateUrl onViewController:self.navigationController];
			self.updateAlert = alert;
			[updateAlert showAlert];
			[alert release];
			
		}
		
	}else {
		[alertView showAlert:@"当前已经是最新版本了" withCancelTitle:nil andOKTitle:@"确定"];
	}

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.progressHUD = nil;
	self.morelist = nil;
	self.updateAlert = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	commandOper.delegate = nil;
	self.morelist = nil;
	self.commandOper = nil;
	self.progressHUD = nil;
	self.branchArray = nil;
	self.abody = nil;
	self.updateAlert = nil;
    [super dealloc];
}


@end

