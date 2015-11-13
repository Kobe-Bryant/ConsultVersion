//
//  communityViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "communityViewController.h"
#import "sns.h"
#import "Common.h"
#import "browserViewController.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
#import "alertView.h"
#import "fansWallCommentViewController.h"
@implementation communityViewController
@synthesize communityList;
@synthesize commandOper;
@synthesize progressHUD;
@synthesize myCommunityList;
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
	
	photoHigh = 55;
	photoWith = 55;
	
	//MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, -44 ,320 , 460)];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";
	
	self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor colorWithRed:0.53 green:0.48 blue:0.44 alpha:1.0f];
    if (IOS_VERSION >= 7.0) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10.0f)];
    }
    
	self.communityList=nil;
	//[self accessService];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self accessService];
	
}
-(void)accessService{
	
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	
	[self.progressHUD show:YES];
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[Common getVersion:SNS_ID],@"ver",[NSNumber numberWithInt: shop_id],@"shop-id",[NSNumber numberWithInt: site_id],@"site-id",nil];
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/community/link.do?param=%@"]];
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:COMMUNITY delegate:self params:nil];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}
- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	if (ver == NEED_UPDATE || communityList == nil) {
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}	
}
-(void)update{
	[self.imageDic removeAllObjects];
	self.communityList = [DBOperate queryData:T_COMMUNITY theColumn:nil theColumnValue:nil withAll:YES];
	
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}
    self.myCommunityList = [NSMutableArray array];
	NSArray *ar_mycommunity = [DBOperate queryData:T_MYSNS theColumn:nil theColumnValue:nil withAll:YES];
	for (NSArray *one in ar_mycommunity){
		sns *snsinf = [[sns alloc]init];
		snsinf.Id = [[one objectAtIndex:mysns_id]intValue];
		snsinf.Name = [one objectAtIndex:mysns_name];
		snsinf.url= [one objectAtIndex:mysns_url];
		snsinf.pic = [one objectAtIndex:mysns_pic];
		snsinf.explain = [one objectAtIndex:mysns_explain];
		[myCommunityList addObject:snsinf];
		[snsinf release];
	}
	[self.tableView reloadData];
}
-(void)add:(sns*)addinf{
	
	[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	
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
	int section = 1;
	if ([communityList count]>0) {
		section++;
	}
	return ++section;
	
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}
	if (section == 1) {
		if ([communityList count]==0) {
			return [myCommunityList count];
		}
		return [communityList count];
	}
	if (section == 2) {
		return [myCommunityList count];
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
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
		UILabel *name = [[UILabel alloc] initWithFrame:
						 CGRectMake(70,4,200,20)];
		name.tag = 1;
		name.backgroundColor = [UIColor clearColor];
		name.adjustsFontSizeToFitWidth = YES;
		name.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];
		
		[cell.contentView addSubview:name];
		[name release];
		UILabel *scrib = [[UILabel alloc] initWithFrame:CGRectMake(70,25,180,17)];
		scrib.tag = 2;
		scrib.backgroundColor = [UIColor clearColor];
		scrib.font = [UIFont systemFontOfSize:12];
		scrib.adjustsFontSizeToFitWidth = YES;
		scrib.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];
		
		[cell.contentView addSubview:scrib];
		[scrib release];
		UILabel *link = [[UILabel alloc] initWithFrame:CGRectMake(70,42,200,17)];
		link.tag = 3;
		link.backgroundColor = [UIColor clearColor];
		link.font = [UIFont systemFontOfSize:12];
		link.adjustsFontSizeToFitWidth = YES;
		link.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];
		
		[cell.contentView addSubview:link];
		[link release];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, photoWith, photoHigh)];
		picView.tag = 4;
		[cell.contentView addSubview:picView];
		[picView release];
		
	}
	UILabel *name = [cell.contentView viewWithTag:1];
	UILabel *scrib = [cell.contentView viewWithTag:2];
	UILabel *link = [cell.contentView viewWithTag:3];
	UIImageView *picView = [cell.contentView viewWithTag:4];
	cell.imageView.image = nil;
	if ([indexPath section] == 0 ){
		name.text = @"圈子";
    	scrib.text = @"评分、留言、查看自己的圈子";
    	link.text = @"";
		UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"圈子" ofType:@"png"]];
		picView.image = [img fillSize:CGSizeMake(photoWith, photoHigh)];
		[img release];
	}
	if ([indexPath section] == 1) 
	{		
		if ([communityList count] == 0) 
		{
			if ([myCommunityList count]>0) 
			{
				sns *s = [myCommunityList objectAtIndex:[indexPath row]]; 
				name.text = s.Name;
				scrib.text = s.explain;
				link.text = s.url;
				UIImage *pic = [[FileManager getPhoto:s.pic]fillSize:CGSizeMake(photoWith, photoHigh)];
				if (pic != nil) {
					picView.image = [pic fillSize:CGSizeMake(photoWith, photoHigh)];
				}
				else {
					UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"社区占位" ofType:@"png"]];
					picView.image = [img fillSize:CGSizeMake(photoWith, photoHigh)];
					[img release];
				}
			}
		}
		else 
		{
			NSArray *s = [communityList objectAtIndex:[indexPath row]]; 
			name.text = [s objectAtIndex:community_name];
			scrib.text = [s objectAtIndex:community_desc];
			link.text = [s objectAtIndex:community_url];
			UIImage *cardIcon = [[imageDic objectForKey:[NSNumber numberWithInt:[indexPath row]]]fillSize:CGSizeMake(photoWith, photoHigh)];
			if (!cardIcon)
			{
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"社区占位" ofType:@"png"]];
				picView.image = [img fillSize:CGSizeMake(photoWith, photoHigh)];
				[img release];
				cardIcon = [[self getPhoto:indexPath]fillSize:CGSizeMake(photoWith, photoHigh)];
				NSLog(@"%d",photoWith);
				NSLog(@"%d",photoHigh);
				
				if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
				{
					////////////获取本地图片缓存
					
					if (cardIcon == nil) {
						
						NSString *photoURL = [self getPhotoURL:indexPath];
						NSLog(@"no card icon  %@",photoURL);
						[self startIconDownload:photoURL forIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
					}
					else {
						picView.image = cardIcon;
						[imageDic setObject:cardIcon forKey:[NSNumber numberWithInt:indexPath.row]];
					}
				}
				/*else {
				 //cardIcon = [[self getPhoto:indexPath]scaleToSize:CGSizeMake(photoWith, photoHigh)];
				 if (cardIcon != nil) {
				 picView.image = cardIcon;
				 [imageDic setObject:cardIcon forKey:[NSNumber numberWithInt:indexPath.row]];
				 }
				 }*/
			}
			else
			{
				//NSLog(@"hellllllllllllllllll");
				picView.image = cardIcon;
			}
		}
		
	}
	if ([indexPath section] == 2 && [myCommunityList count]>0) 
	{
		sns *s = [myCommunityList objectAtIndex:[indexPath row]]; 
		name.text = s.Name;
		scrib.text = s.explain;
		link.text = s.url;
		UIImage *pic = [[FileManager getPhoto:s.pic]fillSize:CGSizeMake(photoWith, photoHigh)];
		if (pic != nil) {
			picView.image = [pic fillSize:CGSizeMake(photoWith, photoHigh)];
		}
		else {
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"社区占位" ofType:@"png"]];
			picView.image = [img fillSize:CGSizeMake(photoWith, photoHigh)];
			[img release];
		}
	}
	
    return cell;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
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
 		sns*deleteOne = [myCommunityList objectAtIndex:[indexPath row]];
		[DBOperate deleteData:T_MYSNS tableColumn:@"id" columnValue:[NSNumber numberWithInt:deleteOne.Id]];
		[myCommunityList removeObjectAtIndex:[indexPath row]];
		NSLog(@"inder section %d, row %d",[indexPath section],[indexPath row]);
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] == 0 || ([indexPath section] == 1 && [communityList count]>0)) {
		return NO;
    }
	else {
		return YES;
	}
	
	
} 
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if ([indexPath section] == 0 || ([indexPath section] == 1 && [communityList count]>0)) {
		return UITableViewCellEditingStyleNone;
    }
	else {
		return UITableViewCellEditingStyleDelete;
		
	}
}


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
	if ([indexPath section] == 0) {
		//粉丝墙
		fansWallCommentViewController *commentList = [[fansWallCommentViewController alloc] initWithNibName:@"fansWallCommentViewControlle" bundle:nil];
		//commentList.productID = [[NSNumber alloc] initWithInt: 56306 ];
		[self.navigationController pushViewController:commentList animated:YES];
		[commentList release];
	} 
	else
	{
		NSString *browserurl;
		if ([indexPath section] == 1) {
			if ([communityList count] ==0) {
				sns *s1 = [myCommunityList objectAtIndex:[indexPath row]];
				browserurl = s1.url;
			}else {
				NSArray *one = [communityList objectAtIndex:[indexPath row]];
				browserurl = [one objectAtIndex:community_url];
			}
			
		}
		
		if ([indexPath section] == 2) {
			sns *s1 = [myCommunityList objectAtIndex:[indexPath row]];
			browserurl = s1.url;
		}
		
		if([browserurl rangeOfString:@"http"].length > 0){
			
		}else {
			browserurl = [NSString stringWithFormat:@"%@%@",@"http://",browserurl];
		}
		
		browserViewController *browser = [[browserViewController alloc]init];
		browser.isHideToolbar = YES;
		browser.linkurl = browserurl;
		[self.navigationController pushViewController:browser animated:YES];
        
		[browser release];
	}
}
////////////loadImagedelegate
-(UIImage*)getPhoto:(NSIndexPath *)indexPath{
	if ([communityList count] > [indexPath row]) 
	{
		NSArray *one = [communityList objectAtIndex:[indexPath row]];
		NSString *picName = [one objectAtIndex:community_pic_name];
		if (picName.length > 1) {
			return [FileManager getPhoto:picName];
		}
		else {
			return nil;
		}
	}
	else {
		
		return nil;
	}
	
}
-(NSString*)getPhotoURL:(NSIndexPath *)indexPath{
	if ([indexPath section] != 0) 
	{
		sns *s1;
		if ([indexPath section] == 1) {
			if ([communityList count] == 0) {
				if ([myCommunityList count] > [indexPath row]) {
					s1 = [myCommunityList objectAtIndex:[indexPath row]];
					return s1.pic;
				}
			}
			else {
				NSArray *one = [communityList objectAtIndex:[indexPath row]];
				return [one objectAtIndex:community_pic_url];
			}
		}
		if ([indexPath section] == 2) {
			if ([myCommunityList count] > [indexPath row]) {
				s1 = [myCommunityList objectAtIndex:[indexPath row]];
				return s1.pic;
			}
		}
		NSLog(@"piclink %@",s1.pic);
	}
}
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath{
	NSLog(@"savePhoto");
	NSString *photoname = [callSystemApp getCurrentTime];
	if([FileManager savePhoto:photoname withImage:photo])
	{
		NSLog(@"save success");
		NSArray *one = [communityList objectAtIndex:[indexPath row]]; 
		NSNumber *value = [one objectAtIndex:community_id];
		[FileManager removeFile:[one objectAtIndex:community_pic_name]];
		if([DBOperate updateData:T_COMMUNITY tableColumn:@"pic_name" columnValue:photoname conditionColumn:@"id" conditionColumnValue:value])
			NSLog(@"update data success");
	}
}

- (void)loadImagesForOnscreenRows
{
	NSLog(@"load images for on screen");
    //if ([self.entries count] > 0)
    //{
	NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		if ([indexPath section] == 1 && [communityList count]>[indexPath row])
		{
			//GroupInfo *cardRecord = [self.entries objectAtIndex:indexPath.row];
			UIImage *cardIcon = [[imageDic objectForKey:[NSNumber numberWithInt:indexPath.row]]fillSize:CGSizeMake(photoWith, photoHigh)];
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			UIImageView *picView = [cell.contentView viewWithTag:4];
			if (!cardIcon) // avoid the app icon download if the app already has an icon
			{
				////////////获取本地图片缓存
				
				if (loadImageDelegate != nil) {
					NSLog(@"load image delegate != nil or not1");
					cardIcon = [[loadImageDelegate getPhoto:indexPath]fillSize:CGSizeMake(photoWith, photoHigh)];
				}
				
				if (cardIcon == nil) {
					if (loadImageDelegate != nil) {
						NSLog(@"load image delegate != nil or not2");
						UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"社区占位" ofType:@"png"]];
						picView.image = [img fillSize:CGSizeMake(photoWith, photoHigh)];
						[img release];
						NSString *photoURL = [loadImageDelegate getPhotoURL:indexPath];
						[self startIconDownload:photoURL forIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
					}
					
				}
				else {
					picView.image = cardIcon;
					[imageDic setObject:cardIcon forKey:[NSNumber numberWithInt:indexPath.row]];
				}
			}
			else {
				picView.image = cardIcon;
			}
		}
		
	}
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        UIImageView *picView = [cell.contentView viewWithTag:4];
        // Display the newly loaded image
		if(iconDownloader.cardIcon.size.width>2.0){ 
			UIImage *photo = [iconDownloader.cardIcon scaleToSize:CGSizeMake(photoWith, photoHigh)];
			if (loadImageDelegate != nil) {
				[loadImageDelegate savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
			}
			picView.image = photo;
			[self.tableView reloadData];
			[imageDic setObject:photo forKey:[NSNumber numberWithInt:[indexPath row]]];
		}
		
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		NSLog(@"after remove object");
		if ([imageDownloadsInWaiting count]>1) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndexPath:one.indexPath withImageType:CUSTOMER_PHOTO];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
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
	self.commandOper = nil;
	self.communityList = nil;
	self.imageDic = nil;
	self.myCommunityList = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	commandOper.delegate = nil;
	self.commandOper = nil;
	self.communityList = nil;
	self.progressHUD = nil;
	self.myCommunityList = nil;
    [super dealloc];
}


@end

