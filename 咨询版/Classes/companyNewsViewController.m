//
//  companyNewsViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-9-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "companyNewsViewController.h"
#import "Common.h"
#import "SBJson.h"
#import "CompanyNews.h"
#import "browserViewController.h"
#import "DBOperate.h"
#import "callSystemApp.h"
#import "FileManager.h"
#define MARGIN 8
@implementation companyNewsViewController
@synthesize companyNewsList;
@synthesize commandOper;
@synthesize progressHUD;
@synthesize myNavigationController;

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
	[self.view setFrame:CGRectMake(0, 35, 320, self.view.frame.size.height - 128)];
	self.tableView.separatorColor = [UIColor clearColor];
	self.tableView.backgroundColor = [UIColor clearColor];
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";
	[self.progressHUD show:YES];
	if (isComNewsFirstLoad) {
		[self accessService];
		isComNewsFirstLoad = false;
	}else {
		[self update];
	}

	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	[_refreshHeaderView refreshLastUpdatedDate];	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)accessService{
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[Common getVersion:COMPANY_NEWS_ID],@"ver",[NSNumber numberWithInt: shop_id],@"shop-id",[NSNumber numberWithInt: site_id],@"site-id",nil];
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/hot/dynamic.do?param=%@"]];
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:COMPANY_NEWS delegate:self params:nil];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}
- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
}
-(void)update{
	[self.imageDic removeAllObjects];
	self.companyNewsList = [DBOperate queryData:T_COMPANYNEWS theColumn:nil theColumnValue:nil withAll:YES];
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}	
	self.tableView.separatorColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1.0f];
	[self.tableView reloadData];
	//[self doneLoadingTableViewData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self update];
	//[self accessService];
}

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
	if ([companyNewsList count]==0) {
		return 0;
	}
    return 1;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
     return [companyNewsList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55.0f + 2 * MARGIN;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
	NSArray *com = [companyNewsList objectAtIndex:[indexPath row]];
	NSNumber *isread = [com objectAtIndex:companynews_isread];
	NSNumber *isrecommend = [com objectAtIndex:companynews_is_recommend];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		UIImageView *news;
		UIImage *img;
		if([isrecommend intValue] == 1){
			news  = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 22 - MARGIN, 2, 24, 21)];
			img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"推送" ofType:@"png"]];
			news.image = img;
			[img release];
			[cell.contentView addSubview:news];			
			[news release];
		}
		
		UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 16 - MARGIN, 30, 16, 11)];
		UIImage *rimg;
		rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"右箭头" ofType:@"png"]];
		rightImage.image = rimg;
		[rimg release];
		[cell.contentView addSubview:rightImage];
		[rightImage release];
		
		UIImageView *newsBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN-2.5f,MARGIN-2.5f,80 , 60)];
		UIImage *backImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新闻列表图片背景" ofType:@"png"]];
		newsBackImageView.image = backImage;
		newsBackImageView.tag = 104;
		[backImage release];
		[cell.contentView addSubview:newsBackImageView];
		[newsBackImageView release];
		
		UILabel *mtitle = [[UILabel alloc]initWithFrame:CGRectZero];
		mtitle.backgroundColor = [UIColor clearColor];
		mtitle.tag = 101;
		mtitle.font = [UIFont systemFontOfSize:16];
		mtitle.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

		[cell.contentView addSubview:mtitle];
		[mtitle release];
		UILabel *detailtitle = [[UILabel alloc]initWithFrame:CGRectZero];
		detailtitle.backgroundColor = [UIColor clearColor];
		detailtitle.tag = 102;
		detailtitle.font = [UIFont systemFontOfSize:12];
		detailtitle.numberOfLines = 0; 
		detailtitle.lineBreakMode = UILineBreakModeCharacterWrap;
		detailtitle.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

		[cell.contentView addSubview:detailtitle];
		[detailtitle release];
		UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectZero];
		picView.tag = 103;
		[cell.contentView addSubview:picView];
		[picView release];
		cell.backgroundColor = [UIColor clearColor];
	}
	
	
	UILabel *mainTitle = [cell.contentView viewWithTag:101];
	UILabel *detailTitle = [cell.contentView viewWithTag:102];
	UIImageView *picView = [cell.contentView viewWithTag:103];
	UIImageView *newsBackView = [cell.contentView viewWithTag:104];
	
	NSString *piclink = [com objectAtIndex:hot_pic];
	
	if (piclink.length > 1) {
		mainTitle.frame = CGRectMake(MARGIN * 2 + photoWith, 4, cell.frame.size.width-photoWith-5 * MARGIN, 30);
		
		CGSize constraint = CGSizeMake(cell.frame.size.width-photoWith-5 * MARGIN, 20000.0f);
		CGSize size1 = [[com objectAtIndex:companynews_desc] sizeWithFont:[UIFont systemFontOfSize:12] 
												constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
		detailTitle.frame = CGRectMake(MARGIN * 2 + photoWith, 25, cell.frame.size.width-photoWith-5 * MARGIN, 40);
		picView.frame = CGRectMake(MARGIN, MARGIN, photoWith, photoHigh);
		UIImage *cardIcon = [[imageDic objectForKey:[NSNumber numberWithInt:[indexPath row]]]fillSize:CGSizeMake(photoWith, photoHigh)];
		if (!cardIcon) {
			cardIcon = [self getPhoto:indexPath];
		}
		if (!cardIcon)
		{
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新闻列表默认图片" ofType:@"png"]];
			picView.image = [img fillSize:CGSizeMake(photoWith, photoHigh)];
			[img release];
			if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
			{
				//cardIcon = [self getPhoto:indexPath];
				if (cardIcon!=nil) {
					picView.image = [cardIcon fillSize:CGSizeMake(photoWith, photoHigh)];
				}
				else {
					NSString *photoURL = [self getPhotoURL:indexPath];
					NSLog(@"no card icon  %@",photoURL);
					[self startIconDownload:photoURL forIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
				}
			}
		}
		else
		{
			picView.image = cardIcon;
		}
		
	}
	else {
		[newsBackView removeFromSuperview];
		mainTitle.frame = CGRectMake(MARGIN * 2, 4, cell.frame.size.width-5 * MARGIN, 30);
		
		CGSize constraint = CGSizeMake(cell.frame.size.width-photoWith-5 * MARGIN, 20000.0f);
		CGSize size1 = [[com objectAtIndex:companynews_desc] sizeWithFont:[UIFont systemFontOfSize:12] 
												constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
		detailTitle.frame = CGRectMake(MARGIN * 2, 25, cell.frame.size.width-5 * MARGIN, 40);
		picView.frame = CGRectZero;
	}
	mainTitle.text = [com objectAtIndex:companynews_title];
	detailTitle.text = [com objectAtIndex:companynews_desc];
	if ([isread intValue] == 1) {
		mainTitle.textColor = [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1.0f];
		detailTitle.textColor = [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1.0f];
	}else {
		mainTitle.textColor = [UIColor colorWithRed:0.2 green:0.22 blue:0.28 alpha:1.0f];
		detailTitle.textColor = [UIColor colorWithRed:0.51 green:0.52 blue:0.59 alpha:1.0f];
	}
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
	NSArray *companynews = [companyNewsList objectAtIndex:[indexPath row]];
	NSNumber *companynewsId = [companynews objectAtIndex:companynews_id];
	[DBOperate updateData:T_COMPANYNEWS tableColumn: @"isread" columnValue: @"1" conditionColumn:@"id" conditionColumnValue:companynewsId];
	
	UIImage *cardIcon = [[imageDic objectForKey:[NSNumber numberWithInt:[indexPath row]]]fillSize:CGSizeMake(photoWith, photoHigh)];
	if (!cardIcon) {
		cardIcon = [self getPhoto:indexPath];
	}
	
	browserViewController *browser = [[browserViewController alloc]init];
	browser.isHideToolbar = NO;
	browser.isShowCommentButton = YES;
	
	browser.newsImage = cardIcon;
	browser.newsTitle = [companynews objectAtIndex:companynews_title];
	browser.newsDesc = [companynews objectAtIndex:companynews_desc];
	
	browser.newsID = companynewsId;
	browser.linkurl = [companynews objectAtIndex:companynews_url];
	browser.linktitle = [companynews objectAtIndex:companynews_title];
	browser.moduleType = [companynews objectAtIndex:hot_type];
	browser.commentCount = [[companynews objectAtIndex:companynews_comment_counts] intValue];
	[self.myNavigationController pushViewController:browser animated:YES];
    
	[browser release];
}

-(UIImage*)getPhoto:(NSIndexPath *)indexPath{
	NSLog(@"getPhoto");
	 NSArray *one = [companyNewsList objectAtIndex:[indexPath row]];
	 NSString *picName = [one objectAtIndex:companynews_pic_name];
	 if (picName.length > 1) {
	 return [FileManager getPhoto:picName];
	 }
	 else {
		 return nil;
	}
}
-(NSString*)getPhotoURL:(NSIndexPath *)indexPath{
	NSArray *hot = [companyNewsList objectAtIndex:[indexPath row]];
	return [hot objectAtIndex:companynews_pic];
}
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath{
	NSLog(@"savePhoto");
	NSString *photoname = [callSystemApp getCurrentTime];
	 if([FileManager savePhoto:photoname withImage:photo])
	 {
	 NSArray *one = [companyNewsList objectAtIndex:[indexPath row]]; 
	 NSNumber *value = [one objectAtIndex:companynews_id];
	 [FileManager removeFile:[one objectAtIndex:companynews_pic_name]];
	 [DBOperate updateData:T_COMPANYNEWS tableColumn:@"pic_name" columnValue:photoname conditionColumn:@"id" conditionColumnValue:value];
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
		//GroupInfo *cardRecord = [self.entries objectAtIndex:indexPath.row];
		UIImage *cardIcon = [[imageDic objectForKey:[NSNumber numberWithInt:indexPath.row]]fillSize:CGSizeMake(photoWith, photoHigh)];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		UIImageView *picView = [cell.contentView viewWithTag:103];
		if (!cardIcon) // avoid the app icon download if the app already has an icon
		{
			////////////获取本地图片缓存
			if (loadImageDelegate != nil) {
				NSLog(@"load image delegate != nil or not1");
				cardIcon = [[loadImageDelegate getPhoto:indexPath]fillSize:CGSizeMake(photoWith, photoHigh)];
			}
			
			if (cardIcon == nil) {
				if (loadImageDelegate != nil) {
					UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新闻列表默认图片" ofType:@"png"]];
					picView.image = [img fillSize:CGSizeMake(photoWith, photoHigh)];
					[img release];
					NSLog(@"load image delegate != nil or not2");
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

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        UIImageView *picView = [cell.contentView viewWithTag:103];
        // Display the newly loaded image
		NSLog(@"card icon %f",iconDownloader.cardIcon.size.width);
		if(iconDownloader.cardIcon.size.width>2.0){ 
			UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(photoWith, photoHigh)];
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
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	//[self reloadTableViewDataSource];
	//[self loadPhoneNewsData:CMD_GET_PHONE_NEWS_LIST_REQ];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	[self accessService];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.companyNewsList = nil;
	self.progressHUD = nil;
	commandOper.delegate = nil;
	self.commandOper = nil;
	_refreshHeaderView = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	commandOper.delegate = nil;
	self.commandOper = nil;
	self.companyNewsList = nil;
	self.progressHUD = nil;
	self.myNavigationController = nil;
	_refreshHeaderView = nil;
    [super dealloc];
}


@end

