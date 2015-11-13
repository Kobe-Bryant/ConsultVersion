//
//  hotsportViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "hotspotViewController.h"
#import "Common.h"
#import "SBJson.h"
#import "HotRecommended.h"
#import "browserViewController.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
#import "myImageView.h"
#import "NdUncaughtExceptionHandler.h"
#import "UpdateAppAlert.h"
#import "UIImageScale.h"

#define MARGIN 8

@implementation hotspotViewController
@synthesize hotspotlist;
@synthesize commandOper;
@synthesize progressHUD;
@synthesize myNavigationController;
@synthesize bannerScrollView;
@synthesize pageControll;
@synthesize topArray;
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
	self.tableView.separatorColor = [UIColor clearColor];
	self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.frame = CGRectMake(0, 35, 320, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 35 - 49);
    
    //	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc]
									 initWithFrame:CGRectMake(60, 90, 200, 100)];
	self.progressHUD = progressHUDTmp;
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";
	[progressHUDTmp release];
    
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	[self.progressHUD show:YES];
	
	[self accessService];
	
	
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	[_refreshHeaderView refreshLastUpdatedDate];
    
	[self performSelector:@selector(updateNotifice) withObject:nil afterDelay:12];
    
}
-(void)accessService{
    
	NSMutableDictionary *jsontestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[Common getVersion:HOT_RECOMMENDED_ID],@"ver",[NSNumber numberWithInt:shop_id],@"shop-id",[NSNumber numberWithInt: site_id],@"site-id",nil];
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/hot/recommand.do?param=%@"]];
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:HOT_RECOMMENDED delegate:self params:nil];
	[networkQueue addOperation:commandOpertmp];
	
	NSDictionary *ad_jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[Common getVersion:AD_QY_ID],@"ver_qy",
                                    [Common getVersion:AD_PLATFORM_ID],@"ver_platform",
                                    [NSNumber numberWithInt: site_id],@"site_id",nil];
	NSString *ad_reqStr = [Common TransformJson:ad_jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/ad/advertising.do?param=%@"]];
	CommandOperation *advertiseOperate = [[CommandOperation alloc]initWithReqStr:ad_reqStr command:AD_COMMENT delegate:self params:nil];
	[networkQueue addOperation:advertiseOperate];
}
- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
}
-(void)update{
	[self.imageDic removeAllObjects];
	self.hotspotlist = [DBOperate queryData:T_HOT theColumn:nil theColumnValue:nil withAll:YES];
    
	
	[hotspotlist insertObject:@"" atIndex:0];
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
	}
	
	[bannerScrollView release],bannerScrollView = nil;
	self.topArray = [DBOperate queryData:T_ADVERTISE_LIST theColumn:@"adType" theColumnValue:@"top" withAll:NO];
	
	
	self.tableView.separatorColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1.0f];
	[self.tableView reloadData];
	
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"view will appear");
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
	[self update];
	//[self accessService];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
}

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
	if ([hotspotlist count]==0) {
		return 0;
	}
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"hotspotlist count %d",[hotspotlist count]);
	//if ([hotspotlist count]==0) {
	//	return 0;
	//}
    return [hotspotlist count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row == 0){
		return 130.0f;
	}else{
		return 55.0f + 2 * MARGIN;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = nil;
    
	//ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		if (indexPath.row > 0) {
			UIImageView *newsBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN-2.5f,MARGIN-2.5f,80 , 60)];
			UIImage *backImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新闻列表图片背景" ofType:@"png"]];
			newsBackImageView.image = backImage;
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
			detailtitle.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];
			detailtitle.numberOfLines = 0;
			detailtitle.lineBreakMode = UILineBreakModeCharacterWrap;
			[cell.contentView addSubview:detailtitle];
			[detailtitle release];
			UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectZero];
			picView.tag = 103;
			[cell.contentView addSubview:picView];
			[picView release];
			cell.backgroundColor = [UIColor clearColor];
		}else {
			int pageCount = [topArray count];
            if (bannerScrollView == nil && topArray != nil && [topArray count] > 0) {
                UIScrollView *tmpScroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, self.view.frame.size.width, 130)];
                tmpScroll.contentSize = CGSizeMake(pageCount * self.view.frame.size.width, 130);
                tmpScroll.pagingEnabled = YES;
                tmpScroll.delegate = self;
                tmpScroll.showsHorizontalScrollIndicator = NO;
                tmpScroll.showsVerticalScrollIndicator = NO;
                tmpScroll.tag = 500;
                self.bannerScrollView=tmpScroll;
                [tmpScroll release];
                
                for(int i = 0;i < pageCount;i++) {
                    myImageView *myiv = [[myImageView alloc]initWithFrame:
                                         CGRectMake(i * bannerScrollView.frame.size.width,0,
                                                    self.view.frame.size.width, 130) withImageId:i];
                    UIImage *img = [[UIImage alloc]initWithContentsOfFile:
                                    [[NSBundle mainBundle] pathForResource:@"banner默认图片" ofType:@"png"]];
                    myiv.image = img;
                    [img release];
                    myiv.mydelegate = self;
                    myiv.tag = i;
                    
                    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100,self.view.frame.size.width,
                                                                                        30)];
                    textView.scrollEnabled = NO;
                    textView.editable = NO;
                    textView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
                    
                    NSString *bannerText = @"描述";
                    if (topArray != nil && [topArray count] > 0) {
                        NSArray *cc = [topArray objectAtIndex:i];
                        bannerText = [cc objectAtIndex:advertiselist_desc];
                    }
                    textView.text = bannerText;
                    textView.textColor = [UIColor whiteColor];
                    textView.font = [UIFont systemFontOfSize:14];
                    textView.contentOffset = (CGPoint){.x = 0, .y = 4};
                    [myiv addSubview:textView];
                    [bannerScrollView addSubview:myiv];
                    [textView release];
                    [myiv release];
                    
                    if (topArray != nil && [topArray count] > 0 )
                    {
                        NSArray *cc = [topArray objectAtIndex:i];
                        NSString *photoUrl = [cc objectAtIndex:advertiselist_image];
                        NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
                        if (photoUrl.length > 1)
                        {
                            UIImage *photo = [FileManager getPhoto:picName];
                            if (photo.size.width>2)
                            {
                                myiv.image = [photo fillSize:CGSizeMake(320,130)];
                            }
                            else
                            {
                                [myiv startSpinner];
                                [self startIconDownload:photoUrl forIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
                            }
                        }
                    }
                }
            }
            if(pageControll == nil && topArray != nil && [topArray count] > 0)
            {
                UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(232, 107, 80, 16)];
                self.pageControll = pc;
				[pc release];
                pageControll.backgroundColor = [UIColor clearColor];
                pageControll.numberOfPages = pageCount;
                pageControll.currentPage = 0;
                [pageControll addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
                
            }
            [cell.contentView addSubview:bannerScrollView];
            [cell.contentView addSubview:pageControll];
			
		}
        
	}
	if (indexPath.row > 0 && indexPath.row < [hotspotlist count])
    {
		NSArray *hot = [hotspotlist objectAtIndex:[indexPath row]];
		NSString *piclink = [hot objectAtIndex:hot_pic];
		NSNumber *isread = [hot objectAtIndex:hot_isread];
		NSNumber *isrecommend = [hot objectAtIndex:hot_is_recommend];
		UILabel *mainTitle = [cell.contentView viewWithTag:101];
		UILabel *detailTitle = [cell.contentView viewWithTag:102];
		UIImageView *picView = [cell.contentView viewWithTag:103];
		
		
		UIImageView *news;
		UIImage *img;
		if([isrecommend intValue] == 1){
			news = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 22 - MARGIN, 2, 24, 21)];
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
		
		mainTitle.text = [hot objectAtIndex:hot_title];
		detailTitle.text = [hot objectAtIndex:hot_desc];
		
		if (piclink.length > 1)
        {
			mainTitle.frame = CGRectMake(MARGIN * 2 + photoWith, 4, cell.frame.size.width-photoWith-5 * MARGIN, 30);
			
			CGSize constraint = CGSizeMake(cell.frame.size.width-photoWith-5 * MARGIN, 20000.0f);
			CGSize size1 = [[hot objectAtIndex:hot_desc] sizeWithFont:[UIFont systemFontOfSize:12]
                                                    constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
			detailTitle.frame = CGRectMake(MARGIN * 2 + photoWith, 30, cell.frame.size.width-photoWith-5 * MARGIN, 40);
			picView.frame = CGRectMake(MARGIN, MARGIN, photoWith, photoHigh);
            
            
            
            NSString *picName = [Common encodeBase64:(NSMutableData *)[piclink dataUsingEncoding: NSUTF8StringEncoding]];
            UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(photoWith, photoHigh)];
            if (pic.size.width > 2)
            {
                picView.image = pic;
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新闻列表默认图片" ofType:@"png"]];
                picView.image = [defaultPic fillSize:CGSizeMake(photoWith, photoHigh)];
                
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                {
                    [self startIconDownload:piclink forIndexPath:indexPath];
                }
            }
			
		}
		else
        {
			mainTitle.frame = CGRectMake(MARGIN * 2 + photoWith, 4, cell.frame.size.width-photoWith-5 * MARGIN , 30);
			
			CGSize constraint = CGSizeMake(cell.frame.size.width-photoWith-5 * MARGIN - 4, 20000.0f);
			CGSize size1 = [[hot objectAtIndex:hot_desc] sizeWithFont:[UIFont systemFontOfSize:12]
													constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
			
			detailTitle.frame = CGRectMake(MARGIN * 2 + photoWith, 35, cell.frame.size.width-photoWith-5 * MARGIN - 4, 40);
			picView.frame = CGRectZero;
		}
		if ([isread intValue] == 1) {
			mainTitle.textColor = [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1.0f];
			detailTitle.textColor = [UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1.0f];
		}else {
			mainTitle.textColor = [UIColor colorWithRed:0.2 green:0.22 blue:0.28 alpha:1.0f];
			detailTitle.textColor = [UIColor colorWithRed:0.51 green:0.52 blue:0.59 alpha:1.0f];
		}
        
	}else {
		
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
	if (indexPath.row > 0) {
		NSArray *hot = [hotspotlist objectAtIndex:[indexPath row]];
		NSNumber *hotId = [hot objectAtIndex:hot_id];
		[DBOperate updateData:T_HOT tableColumn: @"isread" columnValue: @"1" conditionColumn:@"id" conditionColumnValue:hotId];
		
		UIImage *cardIcon = [[imageDic objectForKey:[NSNumber numberWithInt:[indexPath row]]]fillSize:CGSizeMake(photoWith, photoHigh)];
		if (!cardIcon) {
			cardIcon = [self getPhoto:indexPath];
		}
		
		browserViewController *browser = [[browserViewController alloc]init];
		browser.isHideToolbar = NO;
		browser.isShowCommentButton = YES;
		
		browser.newsImage = cardIcon;
		browser.newsTitle = [hot objectAtIndex:hot_title];
		browser.newsDesc = [hot objectAtIndex:hot_desc];
		
		browser.newsID = hotId;
		NSLog(@"url %@",[hot objectAtIndex:hot_url]);
		browser.linkurl = [hot objectAtIndex:hot_url];
		browser.linktitle = [hot objectAtIndex:hot_title];
		browser.moduleType = [hot objectAtIndex:hot_type];
		browser.commentCount = [[hot objectAtIndex:hot_comment_counts] intValue];
		[self.myNavigationController pushViewController:browser animated:YES];
		[browser release];
	}else {
		
	}
    
	
}

- (void) updateNotifice{
	NSMutableArray *updateArray = [DBOperate queryData:T_APP_INFO
											 theColumn:@"type" theColumnValue:[NSNumber numberWithInt:0] withAll:NO];
	if(updateArray != nil && [updateArray count] > 0){
		NSArray *array = [updateArray objectAtIndex:0];
		int reminde = [[array objectAtIndex:versioninfo_remide] intValue];
		int newUpdateVersion = [[array objectAtIndex:versioninfo_ver] intValue];
		if (CURRENT_APP_VERSION >= newUpdateVersion) {
			return;
		}
		if (reminde == 1) {
			return;
		}else {
			[DBOperate updateData:T_APP_INFO tableColumn:@"remide" columnValue:[NSNumber numberWithInt:1]
				  conditionColumn:@"type" conditionColumnValue:[NSNumber numberWithInt:0]];
			
			NSString *url = [array objectAtIndex:versioninfo_url];
			UpdateAppAlert *alert = [[UpdateAppAlert alloc]
									 initWithContent:@"发现新版本 v2.0.0" content:@" 1、全面适配iPhone 5及ios 6;\n 2、新浪微博授权方式修改成了客户端自动授权;\n 3、消息推送去掉了链接地址;\n 4、解决了部分用户反馈问题。"
									 leftbtn:@"稍后再说" rightbtn:@"立即更新" url:url onViewController:self.navigationController];
			self.updateAlert = alert;
			[updateAlert showAlert];
			[alert release];
		}
		
	}else {
		NSMutableArray *gradeArray = [DBOperate queryData:T_APP_INFO
												theColumn:@"type" theColumnValue:[NSNumber numberWithInt:1] withAll:NO];
		if (gradeArray != nil && [gradeArray count] > 0) {
			NSArray *array = [gradeArray objectAtIndex:0];
			int remind = [[array objectAtIndex:versioninfo_remide] intValue];
			int newGradeVersion = [[array objectAtIndex:versioninfo_ver] intValue];
			NSString *updateGradeUrl = [array objectAtIndex:versioninfo_url];
			if (updateGradeUrl != nil && [updateGradeUrl length] > 0) {
				if (CURRENT_APP_VERSION == newGradeVersion) {
					return;
				}
				if (remind == 1) {
					return;
				}else {
					[DBOperate updateData:T_APP_INFO tableColumn:@"remide" columnValue:[NSNumber numberWithInt:1]
						  conditionColumn:@"type" conditionColumnValue:[NSNumber numberWithInt:1]];
					NSString *url = [array objectAtIndex:versioninfo_url];
					UpdateAppAlert *alert = [[UpdateAppAlert alloc]
											 initWithContent:@"喜欢【云来_YunLai.cn】，就来评分吧！" content:@"用10秒钟鼓励我们做的更好。"
											 leftbtn:@"下次再说" rightbtn:@"鼓励一下" url:url onViewController:self.navigationController];
					self.updateAlert = alert;
					[updateAlert showAlert];
					[alert release];
				}
			}
		}
	}
	
    //	if(CURRENT_APP_VERSION != new_app_version){
    //		NSLog(@"need to update");
    //		//		[alertView showAlert:@"发现新版本，是否更新"];
    //		//		NSURL *url = [NSURL URLWithString:appUpdateUrl];
    //		//		[[UIApplication sharedApplication] openURL:url];
    //		NSString *url = @"http://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
    //		UpdateAppAlert *alert = [[UpdateAppAlert alloc]
    //								 initWithContent:@"发现新版本，要不要更新" url:url onViewController:self.myNavigationController];
    //		self.updateAlert = alert;
    //		[updateAlert showAlert];
    //		[alert release];
    //	}
}

- (void)imageViewTouchesEnd:(int)picId{
	browserViewController *browser = [[browserViewController alloc] init];
	browser.isHideToolbar = NO;
    browser.isFromAd = YES;
	
	int index = picId;
	NSArray *ay = [topArray objectAtIndex:index];
	NSString *url = [ay objectAtIndex:advertiselist_url];
    browser.newsTitle = [ay objectAtIndex:advertiselist_desc];
    browser.newsDesc = url;
	browser.linkurl = url;
    [self.myNavigationController pushViewController:browser animated:YES];
    
	[browser release];
}

- (void) pageTurn: (UIPageControl *) aPageControl
{
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	bannerScrollView.contentOffset = CGPointMake(self.view.frame.size.width * whichPage, 0.0f);
	[UIView commitAnimations];
}

////////////loadImagedelegate
-(UIImage*)getPhoto:(NSIndexPath *)indexPath{
	NSArray *one = [hotspotlist objectAtIndex:[indexPath row]];
	NSString *picName = [one objectAtIndex:hot_pic_name];
	if (picName.length > 1) {
		return [FileManager getPhoto:picName];
	}
	else {
		return nil;
	}
}
-(NSString*)getPhotoURL:(NSIndexPath *)indexPath{
	if (indexPath.row > 0 && indexPath.row < [hotspotlist count]) {
		NSArray *hot = [hotspotlist objectAtIndex:[indexPath row]];
		return [hot objectAtIndex:hot_pic];
	}
    return @"";
}

-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
	NSString *photoname = [callSystemApp getCurrentTime];
	if([FileManager savePhoto:photoname withImage:photo])
	{
		NSArray *one = [hotspotlist objectAtIndex:[indexPath row]];
		NSNumber *value = [one objectAtIndex:hot_id];
		[FileManager removeFile:[one objectAtIndex:hot_pic_name]];
		[DBOperate updateData:T_HOT tableColumn:@"pic_name" columnValue:photoname conditionColumn:@"id" conditionColumnValue:value];
	}
    return YES;
}

- (void)loadImagesForOnscreenRows
{
	NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
        if (indexPath.row > 0 && indexPath.row < [hotspotlist count])
        {
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			UIImageView *picView = (UIImageView *)[cell.contentView viewWithTag:103];
            
            NSArray *hot = [hotspotlist objectAtIndex:[indexPath row]];
            NSString *piclink = [hot objectAtIndex:hot_pic];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[piclink dataUsingEncoding: NSUTF8StringEncoding]];
            
            if (piclink.length > 0)
            {
                UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(photoWith*2, photoHigh*2)];
                if (pic.size.width > 2)
                {
                    picView.image = pic;
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新闻列表默认图片" ofType:@"png"]];
                    picView.image = [defaultPic fillSize:CGSizeMake(photoWith, photoHigh)];
                    
                    if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
                    {
                        [self startIconDownload:piclink forIndexPath:indexPath];
                    }
                }
            }
		}
	}
}

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil && photoURL != nil && photoURL.length > 1)
    {
		if ([imageDownloadsInProgress count]>= 5) {
			imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:photoURL withIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
			[imageDownloadsInWaiting addObject:one];
			[one release];
			return;
		}
        IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
        iconDownloader.downloadURL = photoURL;
        iconDownloader.indexPathInTableView = indexPath;
		iconDownloader.imageType = CUSTOMER_PHOTO;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        if(iconDownloader.cardIcon.size.width>2.0)
        {
            if ([indexPath section] == 0)
            {
                //新闻图片
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
                UIImageView *picView = (UIImageView *)[cell.contentView viewWithTag:103];
                
                //保存图片
                NSArray *hot = [hotspotlist objectAtIndex:[indexPath row]];
                NSString *piclink = [hot objectAtIndex:hot_pic];
                NSString *picName = [Common encodeBase64:(NSMutableData *)[piclink dataUsingEncoding: NSUTF8StringEncoding]];
                [FileManager savePhoto:picName withImage:iconDownloader.cardIcon];
                
                UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(photoWith, photoHigh)];
                picView.image = photo;
            }
            else
            {
                //banner
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
				UIScrollView *scv = (UIScrollView *)[cell.contentView viewWithTag:500];
				myImageView *myiv = (myImageView *)[scv viewWithTag:[indexPath row]];
                
                //保存图片
                NSArray *cc = [topArray objectAtIndex:[indexPath row]];
                NSString *photoUrl = [cc objectAtIndex:advertiselist_image];
                NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
                [FileManager savePhoto:picName withImage:iconDownloader.cardIcon];
                
                UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(320.0f, 130.0f)];
				myiv.image = photo;
				[myiv stopSpinner];
            }
            
        }
        
        [imageDownloadsInProgress removeObjectForKey:indexPath];
        if ([imageDownloadsInWaiting count] > 0)
        {
            imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
            [self startIconDownload:one.imageURL forIndexPath:one.indexPath];
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

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{
	if (aScrollView.tag == 500) {
		CGPoint offset = aScrollView.contentOffset;
		pageControll.currentPage = offset.x / self.view.frame.size.width;
	}
	else {
		[_refreshHeaderView egoRefreshScrollViewDidScroll:aScrollView];
	}
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
	NSLog(@"hotspotview controller unload");
	self.progressHUD = nil;
	self.hotspotlist = nil;
	commandOper.delegate = nil;
	self.commandOper = nil;
	_refreshHeaderView = nil;
	self.bannerScrollView = nil;
	self.pageControll = nil;
	self.topArray = nil;
	self.updateAlert = nil;
	[super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	commandOper.delegate = nil;
	self.commandOper = nil;
	self.hotspotlist = nil;
	self.progressHUD = nil;
	self.myNavigationController = nil;
	_refreshHeaderView = nil;
	self.bannerScrollView = nil;
	self.pageControll = nil;
	self.topArray = nil;
	self.updateAlert = nil;
    [super dealloc];
}


@end

