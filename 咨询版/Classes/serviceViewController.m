//
//  serviceViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "serviceViewController.h"
#import "csInfo.h"
#import "manageActionSheet.h"
#import "serviceBranch.h"
#import "serviceHotLine.h"
#import "Common.h"
#import <MessageUI/MessageUI.h>
#import "alertView.h"
#import "addServiceViewController.h"
#import "DBOperate.h"
#import "callSystemApp.h"
#import "mapViewController.h"
#import "FileManager.h"
#import "BaiduMapViewController.h"

#define CALL_PHONE @"拨打"
#define SEND_MESSAGE @"发信息至"
#define SHOW_MAP @"显示位置"
#define SEND_EMAIL @"发邮件"
#define MODIFY @"编辑"
#define SERVICE_HOTLINE 1
#define SERVICE_MAIL 2
#define SERVICE_BUSINESS 3
#define SERVICE_BRANCH 4
@implementation serviceViewController
@synthesize serviceList;
@synthesize actionsheet;
@synthesize commandOper;
@synthesize actionSheetMenu;
@synthesize myServiceList;
@synthesize indexPathChoosed;
@synthesize progressHUD;
@synthesize phoneNum;
@synthesize maddress;
@synthesize mailAddr;
@synthesize ar_showControl;
@synthesize coord;
@synthesize telCallString;
@synthesize mobileCallString;
@synthesize sendMsgString;
@synthesize telNum;
@synthesize shortCount;
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
    self.tableView.separatorColor = [UIColor colorWithRed:0.53 green:0.48 blue:0.44 alpha:1.0f];
    if (IOS_VERSION >= 7.0) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10.0f)];
    }
    
	showhotline = NO;
	showbusiness = NO;
	showhotlinemail = NO;
	isShowAddtional = NO;
	
	//MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, -44 ,320 , 460)];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";
	
	shortCount = 0;
	self.ar_showControl = nil;
	NSLog(@"view did load");
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 20.0f - 44.0f - 49.0f)];

	NSLog(@"view will appear");
	[self accessService];

}

-(void)accessService{
	
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	[self.progressHUD show:YES];	
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[Common getVersion:HOTLINE_ID],@"custom-ver",[Common getVersion:BRANCH_ID],@"branch-ver",[Common getVersion:BUSINESS_ID],@"business-ver",[NSNumber numberWithInt: shop_id],@"shop-id",[NSNumber numberWithInt: site_id],@"site-id",nil];
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/service/custom.do?param=%@"]];
	NSLog(@"service reqStr %@",reqStr);
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:SERVICE delegate:self params:nil];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}
- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	if (ver == NEED_UPDATE ||self.ar_showControl==nil) {
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}
}
-(void)update{
	NSLog(@"update now ......");
	self.ar_showControl = [NSMutableArray array];
	NSArray* ar_hotline = [DBOperate queryData:T_HOTLINE theColumn:nil theColumnValue:nil withAll:YES];
	NSMutableArray* ar_mail = [NSMutableArray array];
	NSArray* ar_business;
	NSArray* ar_subbranch;
	if ([ar_hotline count]>0) {
		NSArray *arr_hotline = [ar_hotline objectAtIndex:0];
		NSString *hotlinetel = [arr_hotline objectAtIndex:hotline_tel];
		if ([hotlinetel length] > 0) {
			showhotline = YES;
		}
		if([[arr_hotline objectAtIndex:hotline_mail] length] > 0)
		{
			showhotlinemail = YES;
			[ar_mail addObject:[arr_hotline objectAtIndex:hotline_mail]];
		}
	}
	ar_business = [DBOperate queryData:T_BUSINESS theColumn:nil theColumnValue:nil withAll:YES];
	if (ar_business != nil && [ar_business count] > 0) {
		NSArray *arr_business = [ar_business objectAtIndex:0];
		if ([[arr_business objectAtIndex:business_tel] length] > 0) {
			showbusiness = YES;
		}
	}
	
	
	ar_subbranch = [DBOperate queryData:T_SUBBRANCH theColumn:nil theColumnValue:nil withAll:YES];
	
	self.serviceList = [NSMutableArray array];
	if (showhotline) {
		[ar_showControl addObject:[NSNumber numberWithInt:SERVICE_HOTLINE]];
		[serviceList addObjectsFromArray:ar_hotline];
	}
	if (showbusiness) {
		[ar_showControl addObject:[NSNumber numberWithInt:SERVICE_BUSINESS]];
		[serviceList addObjectsFromArray:ar_business];
	}
	if (showhotlinemail) {
		[ar_showControl addObject:[NSNumber numberWithInt:SERVICE_MAIL]];
		[serviceList addObjectsFromArray:[NSArray arrayWithObject:ar_mail]];
	}
	[serviceList addObjectsFromArray:ar_subbranch];
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}
	NSMutableArray *mytmp = [[NSMutableArray alloc]init];
	self.myServiceList = mytmp;
	[mytmp release];
	NSArray *ar_mycommunity = [DBOperate queryData:T_MYSERVICE theColumn:nil theColumnValue:nil withAll:YES];
	for (NSArray *one in ar_mycommunity){
		csInfo *serviceinf = [[csInfo alloc]init];
		serviceinf.csId = [[one objectAtIndex:myservice_id]intValue];
		serviceinf.csPic = [one objectAtIndex:myservice_csPic];
		serviceinf.csName = [one objectAtIndex:myservice_csName];
		serviceinf.csPhone = [one objectAtIndex:myservice_csPhone];
		serviceinf.csAreaCode = [one objectAtIndex:myservice_csAreaCode];
		serviceinf.csMail = [one objectAtIndex:myservice_csMail];
		serviceinf.csAddress = [one objectAtIndex:myservice_csAddress];
		serviceinf.csCoordinate = [one objectAtIndex:myservice_csAddCoordinate];
		[myServiceList addObject:serviceinf];
		[serviceinf release];
	}
	[self.tableView reloadData];
}
-(void)add:(csInfo*)addinf{
	[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[self.tableView setEditing:NO animated:NO];
}

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
	//return 2;
	int section = 0;
	if ([serviceList count]>0) {
		section++;
	}
    return ++section;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		if ([serviceList count]==0) {
			return [myServiceList count];
		}
		NSLog(@"number of row %d",[serviceList count]);
		return [serviceList count];
	}
	if (section == 1) {
		return [myServiceList count];
	}
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  
		cell.backgroundColor = [UIColor clearColor];
		UILabel *name = [[UILabel alloc] initWithFrame:
						 CGRectMake(70,4,200,20)];
		name.tag = 1;
		name.backgroundColor = [UIColor clearColor];
		name.adjustsFontSizeToFitWidth = YES;
		name.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

		[cell.contentView addSubview:name];
		[name release];
		UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(70,25,180,17)];
		phone.tag = 2;
		phone.backgroundColor = [UIColor clearColor];
		phone.font = [UIFont systemFontOfSize:12];
		phone.adjustsFontSizeToFitWidth = YES;
		phone.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

		[cell.contentView addSubview:phone];
		[phone release];
		UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(70,42,200,17)];
		address.tag = 3;
		address.backgroundColor = [UIColor clearColor];
		address.font = [UIFont systemFontOfSize:12];
		address.adjustsFontSizeToFitWidth = YES;
		address.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

		[cell.contentView addSubview:address];     
		[address release];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
		UIImageView *picViewTemp = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 55, 55)];
		picViewTemp.tag = 4;
		[cell.contentView addSubview:picViewTemp];
		[picViewTemp release];
		
	//}
	//UILabel *name = [cell.contentView viewWithTag:1];
	//UILabel *phone = [cell.contentView viewWithTag:2];
	//UILabel *address = [cell.contentView viewWithTag:3];
	
	UIImageView *picView = [cell.contentView viewWithTag:4];
	
	if ([indexPath section] == 0 && [serviceList count]>[indexPath row]) {
		NSArray *one = [serviceList objectAtIndex:[indexPath row]];
    	if ([ar_showControl count]> [indexPath row]) {
    		if([[ar_showControl objectAtIndex:[indexPath row]]intValue]==SERVICE_HOTLINE)
	    	{
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"客服热线" ofType:@"png"]];
	     		picView.image = img;
	    		[img release];
				
				name.text = [one objectAtIndex:hotline_title];
		    	phone.text = [one objectAtIndex:hotline_tel];
		    	//address.text = [one objectAtIndex:hotline_desc];
				address.text = @"欢迎您的来电";
			
	     	}
    		else if([[ar_showControl objectAtIndex:[indexPath row]]intValue]==SERVICE_MAIL) {
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"发送邮件" ofType:@"png"]];
	     		picView.image = img;
	    		[img release];
				name.text = @"发送邮件";
		    	phone.text = [one objectAtIndex:0];
		    	address.text = @"欢迎您的来信";
			
	    	}
	    	else if([[ar_showControl objectAtIndex:[indexPath row]]intValue]==SERVICE_BUSINESS) {
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商务洽谈" ofType:@"png"]];
	     		picView.image = img;
	    		[img release];
				
		    //	picView.image = [[UIImage imageNamed:@"商务洽谈.png"]fillSize:CGSizeMake(60, 60)];
		    	name.text = @"商务洽谈";
		    	phone.text = [one objectAtIndex:business_tel];
			    address.text = @"欢迎您的来电";
    		}
    	}
    	else {
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"深圳分店" ofType:@"png"]];
			picView.image = img;
			[img release];
			
	    	name.text = [one objectAtIndex:subbranch_companyname];
	    	phone.text = [one objectAtIndex:subbranch_tel];
	    	//address.text = [one objectAtIndex:subbranch_addr];
			NSLog([one objectAtIndex:subbranch_location]);
			float x;
			if ([phone.text length] > 0) {
				x = 180;
			}else {
				x = 70;
			}

			UILabel *mobilePhone = [[UILabel alloc] initWithFrame:CGRectMake(x,25,220,17)];
			mobilePhone.tag = 4;
			mobilePhone.backgroundColor = [UIColor clearColor];
			mobilePhone.font = [UIFont systemFontOfSize:12];
			mobilePhone.adjustsFontSizeToFitWidth = YES;
			mobilePhone.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];			
			[cell.contentView addSubview:mobilePhone];
			[mobilePhone release];
			mobilePhone.text = [one objectAtIndex:subbranch_mobile];
			
			CGSize labelSize = [[one objectAtIndex:subbranch_addr] sizeWithFont:[UIFont systemFontOfSize:12]							
										 constrainedToSize:CGSizeMake(200, 34) 							
											 lineBreakMode:UILineBreakModeCharacterWrap];
			UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(70,59,labelSize.width, labelSize.height)];
			email.text = [one objectAtIndex:subbranch_addr];
			email.tag = 4;
			email.backgroundColor = [UIColor clearColor];
			email.font = [UIFont systemFontOfSize:12];
			email.numberOfLines = 0;     // 不可少Label属性之一
			email.lineBreakMode = UILineBreakModeCharacterWrap;    // 不可少Label属性之二
			email.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];			
			[cell.contentView addSubview:email];
			[email release];
			
			NSLog([one objectAtIndex:subbranch_mail]);
			address.text = [one objectAtIndex:subbranch_mail];
			
    	}
		
	}
	
	else {
		csInfo *one = [myServiceList objectAtIndex:[indexPath row]];
		name.text = one.csName;
		phone.text = one.csAreaCode;
		address.text = one.csMail;
		
		float x;
		if ([phone.text length] > 0) {
			x = 180;
		}else {
			x = 70;
		}
		UILabel *mobilePhone = [[UILabel alloc] initWithFrame:CGRectMake(x,25,220,17)];
		mobilePhone.tag = 5;
		mobilePhone.backgroundColor = [UIColor clearColor];
		mobilePhone.font = [UIFont systemFontOfSize:12];
		mobilePhone.adjustsFontSizeToFitWidth = YES;
		mobilePhone.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];			
		[cell.contentView addSubview:mobilePhone];
		[mobilePhone release];
		mobilePhone.text = one.csPhone;
		
		
		CGSize labelSize = [one.csAddress sizeWithFont:[UIFont systemFontOfSize:12]							
									 constrainedToSize:CGSizeMake(200, 34) 							
										 lineBreakMode:UILineBreakModeCharacterWrap];
		UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(70,59, labelSize.width, labelSize.height)];
		email.text = one.csAddress;
		email.tag = 6;
		email.backgroundColor = [UIColor clearColor];
		email.font = [UIFont systemFontOfSize:12];
		email.numberOfLines = 0;     // 不可少Label属性之一
		email.lineBreakMode = UILineBreakModeCharacterWrap;    // 不可少Label属性之二
		email.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];			
		[cell.contentView addSubview:email];
		
		[email release];
		
		UIImage *pic = [FileManager getPhoto:one.csPic];
		if(pic == nil)
		{
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"服务占位" ofType:@"png"]];
			picView.image = img;
			[img release];
		}
		else {
			picView.image = [pic fillSize:CGSizeMake(55, 55)];
		}
		
	}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && [indexPath row] < [ar_showControl count]) {
		return 65.0f;
	}
	else {
		return 90.0f;
	}

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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source

		csInfo *deleteOne = [myServiceList objectAtIndex:[indexPath row]];
		[DBOperate deleteData:T_MYSERVICE tableColumn:@"id" columnValue:[NSNumber numberWithInt:deleteOne.csId]];

		[myServiceList removeObjectAtIndex:[indexPath row]];
		NSLog(@"inder section %d, row %d",[indexPath section],[indexPath row]);
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
       // [self.tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] == 0 && [serviceList count]>0) {
		 return NO;
    }
	else {
		return YES;
	}

   
} 
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([indexPath section] == 0 && [serviceList count]>0) {
		return UITableViewCellEditingStyleNone;
    }
	else {
		return UITableViewCellEditingStyleDelete;
		
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	self.indexPathChoosed = indexPath;
	if ([indexPath section] == 0 && [serviceList count]> [indexPath row]) {
		NSArray *one1 = [serviceList objectAtIndex:[indexPath row]];
		if ([ar_showControl count]> [indexPath row]) {
			
		if([[ar_showControl objectAtIndex:[indexPath row]]intValue]==SERVICE_HOTLINE)
		{
			self.phoneNum = [one1 objectAtIndex:hotline_tel];
			if (phoneNum.length > 1) {
				[callSystemApp makeCall:phoneNum];
			}
			return;
		}
		else if([[ar_showControl objectAtIndex:[indexPath row]]intValue]==SERVICE_MAIL)
		{
			self.mailAddr = [one1 objectAtIndex:0];
			if (mailAddr.length > 1) {
				[callSystemApp sendEmail:mailAddr cc:@"" subject:@"" body:@""];
			}
			return;
		}
		else if([[ar_showControl objectAtIndex:[indexPath row]]intValue]==SERVICE_BUSINESS)
		{
			self.phoneNum = [one1 objectAtIndex:business_tel];
			if (phoneNum.length > 1) {
				[callSystemApp makeCall:phoneNum];
			}
			return;
			
		}
		}
		else {
			NSMutableArray *menuarray = [[NSMutableArray alloc]init];
			if (((NSString*)[one1 objectAtIndex:subbranch_tel]).length > 0) {
				self.telNum = [one1 objectAtIndex:subbranch_tel];
				self.telCallString = [CALL_PHONE stringByAppendingFormat:self.telNum];
				[menuarray addObject:telCallString];
			}
			if (((NSString*)[one1 objectAtIndex:subbranch_mobile]).length > 0) {
				self.phoneNum = [one1 objectAtIndex:subbranch_mobile];
				self.mobileCallString = [CALL_PHONE stringByAppendingFormat:self.phoneNum];
				sendMsgString = [SEND_MESSAGE stringByAppendingFormat:self.phoneNum];
				[menuarray addObject:mobileCallString];
				[menuarray addObject:sendMsgString];
			}
			if (((NSString*)[one1 objectAtIndex:subbranch_mail]).length > 1) {
				self.mailAddr = [one1 objectAtIndex:subbranch_mail];
				[menuarray addObject:SEND_EMAIL];
			}
			if (((NSString*)[one1 objectAtIndex:subbranch_addr]).length > 1) {
				self.maddress = [one1 objectAtIndex:subbranch_addr];
				self.coord = [one1 objectAtIndex:subbranch_location];
				[menuarray addObject:SHOW_MAP];
			}
			self.actionSheetMenu = menuarray;
			[menuarray release];
		}
		
		
	}
	else {
		isShowAddtional = YES;
		NSMutableArray *menuarray = [[NSMutableArray alloc]init];
		csInfo *one = [myServiceList objectAtIndex:[indexPath row]];
		if (one.csAreaCode.length > 1) {
			self.telNum = one.csAreaCode;
			self.telCallString = [CALL_PHONE stringByAppendingFormat:self.telNum];
			[menuarray addObject:telCallString];
		}
		
		if (one.csPhone.length > 1) {
			self.phoneNum = one.csPhone;
			self.mobileCallString = [CALL_PHONE stringByAppendingFormat:self.phoneNum];
			sendMsgString = [SEND_MESSAGE stringByAppendingFormat:self.phoneNum];
			[menuarray addObject:mobileCallString];
			[menuarray addObject:sendMsgString];
		}
		if (one.csMail.length > 1) {
			self.mailAddr = one.csMail;
			[menuarray addObject:SEND_EMAIL];
		}
		if (one.csAddress.length > 1) {
			self.maddress = one.csAddress;
			self.coord = one.csCoordinate;
			[menuarray addObject:SHOW_MAP];
		}
		[menuarray addObject:MODIFY];
		self.actionSheetMenu = menuarray;
		[menuarray release];
		
	}
	manageActionSheet *actionsheet1 = [[manageActionSheet alloc]initActionSheetWithStrings:actionSheetMenu];
	actionsheet1.manageDeleage = self;
	self.actionsheet = actionsheet1;
	[actionsheet1 release];
	[actionsheet showActionSheet:self.navigationController.navigationBar];		
}

- (void) actionSheetAppear:(int)actionID actionSheet:(UIActionSheet *)actionSheet{
	
}


- (void)getChoosedIndex:(int)actionID chooseIndex:(int)index{
	NSString *chooseMenu = @"";
	if ([actionSheetMenu count] > 0) {
		chooseMenu = [actionSheetMenu objectAtIndex:index];
	}
		if ([chooseMenu isEqualToString:mobileCallString] ) {
		[callSystemApp makeCall:phoneNum];
	}
	else if ([chooseMenu isEqualToString:telCallString]) {
		[callSystemApp makeCall:telNum];
	}
	else if([chooseMenu isEqualToString:sendMsgString]) {
		[callSystemApp sendMessageTo:phoneNum inUIViewController:self withContent:nil];
	}
	else if([chooseMenu isEqualToString:SHOW_MAP]){
		if ([coord rangeOfString:@","].length > 0 && [indexPathChoosed section] == 0) {
			[self showMapByCoord:coord adress:maddress];
		}else {
			[self showMap:maddress];
		}
	}
	else if([chooseMenu isEqualToString:SEND_EMAIL]) {
		[callSystemApp sendEmail:mailAddr cc:nil subject:nil body:nil];
	}
	else if([chooseMenu isEqualToString:MODIFY]){
		csInfo *one = [myServiceList objectAtIndex:[indexPathChoosed row]];
		addServiceViewController *add = [[addServiceViewController alloc]init];
		add.addinfo = one;
		add.adddelegate = self;
		add.isEditing = YES;
		[self.navigationController pushViewController:add animated:YES];
		[add release];
	}
}

-(void)showMapByCoord:(NSString*)coordStr adress:adress{
	NSLog(@"%@",coordStr);
//	mapViewController *map = [[mapViewController alloc]initWithNibName:@"mapViewController" bundle:nil];
//	map.mymapType = SHOW_MAP_TYPE;
//	map.addressDelegate = nil;
//	[self.navigationController pushViewController:map animated:YES];
//	[map LocateAddrByCoord:coord];
//	[map release];
    
    NSArray *arr = [coordStr componentsSeparatedByString:@","];
    //NSLog(@"arr===%@",arr);
    double lon = [[arr objectAtIndex:0] doubleValue];
    double lat = [[arr objectAtIndex:1] doubleValue];
    NSLog(@"arr=== %f  %f",lat,lon);
    BaiduMapViewController *baiduMap = [[BaiduMapViewController alloc] init];
    baiduMap.latitude = lat;
    baiduMap.longitude = lon;
    baiduMap.isEdit = NO;
    baiduMap.isChange = NO;
    baiduMap.searchLocationStr = adress;
    baiduMap.showType = OnlyShowPoint;
    [self.navigationController pushViewController:baiduMap animated:YES];
}

-(void)showMap:(NSString*)paddress{
//	mapViewController *map = [[mapViewController alloc]initWithNibName:@"mapViewController" bundle:nil];
//	map.mymapType = SHOW_MAP_TYPE;
//	map.addressDelegate = nil;
//	[self.navigationController pushViewController:map animated:YES];
//
//	[map LocateAddress:paddress];
//
//	[map release];
    
    BaiduMapViewController *baiduMap = [[BaiduMapViewController alloc] init];
    baiduMap.isEdit = NO;
    baiduMap.isChange = NO;
    baiduMap.showType = OnlyShowPoint;
    baiduMap.searchLocationStr = paddress;
    [self.navigationController pushViewController:baiduMap animated:YES];
//    [baiduMap onClickGeocode:paddress];
}
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	NSLog(@"view did unload..........");
	self.progressHUD = nil;
	self.ar_showControl = nil;
	self.commandOper = nil;
	self.serviceList = nil;
	self.myServiceList = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}
- (void)dealloc {
	commandOper.delegate = nil;
	self.serviceList = nil;
	self.actionsheet = nil;
	self.commandOper = nil;
	self.actionSheetMenu = nil;
	self.myServiceList = nil;
	self.indexPathChoosed = nil;
	self.progressHUD = nil;
	self.phoneNum = nil;
	self.maddress = nil;
	self.mailAddr = nil;
	self.ar_showControl = nil;
    [super dealloc];
}
@end

