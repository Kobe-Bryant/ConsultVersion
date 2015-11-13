//
//  beautyPicViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "beautyPicViewController.h"
#import "showPagesImage.h"
#import "secondLevelViewController.h"
#import "Common.h"
#import "myImageView.h"
#import "cats.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
#import "FinalLevelViewController.h"
@implementation beautyPicViewController
@synthesize picArray;
@synthesize pagesImage;
@synthesize myNavigationController;
@synthesize allSecondLevelPic;
//@synthesize pushdelegate;
@synthesize commandOper;
@synthesize progressHUD;
@synthesize picLinkArray;
@synthesize pageControl;
@synthesize scrollView;
@synthesize serviceDataDic;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
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

	self.view.backgroundColor = [UIColor clearColor];
	
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";
	[self accessService];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//[self accessService];
 }
/*- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	for (UIView *innerview in [self.scrollView subviews]){
		[innerview removeFromSuperview];
	}
	
	[scrollView removeFromSuperview];
	self.scrollView = nil;
	[pageControl removeFromSuperview];
	self.picLinkArray = nil;
}*/
-(void)accessService{
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	[self.progressHUD show:YES];
	
	NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[Common getVersion:PRODUCT_ID],@"ver",[NSNumber numberWithInt: shop_id],@"shop-id",[NSNumber numberWithInt: site_id],@"site-id",nil];
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/products.do?param=%@"]];
	NSLog(@"reqstr,,,,,,,,,,,, %@",reqStr);
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:PRODUCT delegate:self params:nil];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}
- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	NSLog(@"verrrr %d",ver);
	if (ver == NEED_UPDATE || scrollView == nil) {
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}
	
}
-(void)update{
	self.picLinkArray = [DBOperate queryData:T_CATEGORY_PRETTY_PIC theColumn:@"pid" theColumnValue:[NSNumber numberWithInt:0]  withAll:NO];
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}
	for (UIView *innerview in [self.scrollView subviews]){
		[innerview removeFromSuperview];
	}
	
	[scrollView removeFromSuperview];
	[pageControl removeFromSuperview];
	float width = self.view.frame.size.width;
	float height = self.view.frame.size.height;
	
	int pageCount = [picLinkArray count];
    
	UIScrollView *scvtmp = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, (self.view.frame.size.height - 350) * 0.5, width, height-20)];
	scvtmp.contentSize = CGSizeMake(pageCount*width, height-30);
	scvtmp.pagingEnabled = YES;
	scvtmp.delegate = self;
	scvtmp.showsHorizontalScrollIndicator = NO;
	scvtmp.showsVerticalScrollIndicator = NO;
	self.scrollView=scvtmp;
    [self.view addSubview:scrollView];
	[scvtmp release];
    
	UIPageControl *pagectmp = [[UIPageControl alloc] initWithFrame:CGRectMake(120, height-20, 80, 15)];
	self.pageControl = pagectmp;
	[pagectmp release];
	pageControl.backgroundColor = [UIColor clearColor];
	pageControl.numberOfPages = pageCount;
	pageControl.currentPage = 0;
	[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:pageControl];
    
	picwidth = 256;
	picheight = 320;
	NSLog(@"picwidth %f,,picheight %f",picwidth,picheight);
	for (int i= 0;i < pageCount;i++){
		myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(width*i+32,10.0f,picwidth,picheight) withImageId:i];
		NSLog(@"width,%f",iv.frame.size.width);
		NSLog(@"height,%f",iv.frame.size.height);
		if (i<2) {
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"图片占位" ofType:@"png"]];
			iv.image = img;
			[img release];
		}
		else {
			iv.image = nil;
		}
		iv.tag = i+100;
		iv.mydelegate = self;
		[scrollView addSubview:iv];
		[iv release];
	}
	
	for (int i=0;i<[picLinkArray count]; i++) {
		if (i<2) {
     		NSArray *cc = [picLinkArray objectAtIndex:i];
	    	if (((NSString*)[cc objectAtIndex:category_pic_name]).length > 1) {
	    		myImageView *myIV = (myImageView *)[scrollView viewWithTag:(i+100)];
	    		UIImage *photo = [FileManager getPhoto:[cc objectAtIndex:category_pic_name]];
				if(!(photo.size.width == picwidth && photo.size.height == picheight)){
					myIV.image = [photo fillSize:CGSizeMake( myIV.frame.size.width , myIV.frame.size.height)];
				}
//	    		if (photo.size.width>2) {
//		    		myIV.image = [photo fillSize:myIV.frame.size];
//		    	}
		    	else {
		    		[self startIconDownload: [cc objectAtIndex:category_pic_url] forIndex:[NSIndexPath indexPathWithIndex:i]];
		    	}
    		}
	    	else {
		    	[self startIconDownload: [cc objectAtIndex:category_pic_url] forIndex:[NSIndexPath indexPathWithIndex:i]];
	    	}
		}
	}
}
-(void)removePic:(int)picNum{
   myImageView *myIV = (myImageView *)[scrollView viewWithTag:(picNum+100)];
	myIV.image = nil;
	
}
-(void)showOnePic:(int)picNum{
	if (picNum >= [picLinkArray count]||picNum < 0) {
		return;
	}
	NSArray *cc = [picLinkArray objectAtIndex:picNum];
	myImageView *myIV = (myImageView *)[scrollView viewWithTag:(picNum+100)];
	NSLog(@"myIV.size.width:%f",myIV.frame.size.width);
	NSLog(@"myIV.size.height:%f",myIV.frame.size.height);
	if (myIV.image == nil) {
		if (((NSString*)[cc objectAtIndex:category_pic_name]).length > 1) {
			UIImage *photo = [FileManager getPhoto:[cc objectAtIndex:category_pic_name]];
			if (photo!=nil) {
				if (photo.size.width == picwidth && photo.size.height == picheight) {
					myIV.image = photo;
				}else {
					myIV.image = [photo fillSize:CGSizeMake( myIV.frame.size.width , myIV.frame.size.height)];
				}
				//myIV.image = [photo fillSize:myIV.frame.size];
			}
			else {
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"图片占位" ofType:@"png"]];
				myIV.image = img;
				[img release];
				[self startIconDownload: [cc objectAtIndex:category_pic_url] forIndex:[NSIndexPath indexPathWithIndex:picNum]];
			}
		}
		else {
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"图片占位" ofType:@"png"]];
			myIV.image = img;
			[img release];
			[self startIconDownload: [cc objectAtIndex:category_pic_url] forIndex:[NSIndexPath indexPathWithIndex:picNum]];
		}
		
	}
	
}
-(void)managePicsInCurrentPic:(int)picNum{
	if ((picNum-1)>=0) {
		[self showOnePic:(picNum-1)];
	}
	if ((picNum-2)>=0) {
		[self removePic:(picNum-2)];
	}
	if ((picNum+1)<[picLinkArray count]) {
		[self showOnePic:(picNum+1)];
	}
	if ((picNum+2)<[picLinkArray count]) {
		[self removePic:(picNum+2)];
	}
}
- (void) pageTurn: (UIPageControl *) aPageControl
{
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	scrollView.contentOffset = CGPointMake(self.view.frame.size.width * whichPage, 0.0f);
	[UIView commitAnimations];
}
- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	CGPoint offset = aScrollView.contentOffset;
	pageControl.currentPage = offset.x / self.view.frame.size.width;
	[self managePicsInCurrentPic:pageControl.currentPage];
}
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
    if (imageURL != nil && imageURL.length > 1) 
    {
		if ([imageDownloadsInProgress count]>= MAXICONDOWNLOADINGNUM) {
			imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:imageURL withIndexPath:index withImageType:CUSTOMER_PHOTO];
			[imageDownloadsInWaiting addObject:one];
			[one release];
			return;
		}
		if ([imageDownloadsInProgress objectForKey:index]==nil) {
			IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
			iconDownloader.downloadURL = imageURL;
			iconDownloader.indexPathInTableView = index;
			iconDownloader.imageType = CUSTOMER_PHOTO;
			iconDownloader.delegate = self;
			[imageDownloadsInProgress setObject:iconDownloader forKey:index];
			[iconDownloader startDownload];
			[iconDownloader release]; 
		}
         
    }
}
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width>2.0){ 
			NSString *photoname = [callSystemApp getCurrentTime];
			UIImage *photo = iconDownloader.cardIcon;
			if (photo.size.width == picwidth && photo.size.height == picheight) {
				NSLog(@"image no needto fillSize");
			}else {
				photo = [iconDownloader.cardIcon fillSize:CGSizeMake(picwidth , picheight )];
			}
			//UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(picwidth, picheight)];

			if([FileManager savePhoto:photoname withImage:photo])
			{
				NSArray *one = [picLinkArray objectAtIndex:[indexPath indexAtPosition:0]]; 
				NSNumber *value = [one objectAtIndex:category_id];
				[FileManager removeFile:[one objectAtIndex:category_pic_name]];
				[DBOperate updateData:T_CATEGORY_PRETTY_PIC tableColumn:@"pic_name" columnValue:photoname conditionColumn:@"id" conditionColumnValue:value];
			}

			NSUInteger index;
			[indexPath getIndexes:&index];
			NSLog(@"index...................... %lu",(unsigned long)index);
			if ((index == pageControl.currentPage) || (index == (pageControl.currentPage+1))||(index == (pageControl.currentPage-1))) {
				myImageView *myIV = (myImageView *)[scrollView viewWithTag:(index+100)];//[picArray objectAtIndex:index];
				myIV.image = photo;
			}
			
		}
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
	self.picLinkArray = (NSMutableArray *)[DBOperate queryData:T_CATEGORY_PRETTY_PIC theColumn:@"pid" theColumnValue:[NSNumber numberWithInt:0]  withAll:NO];

}

- (void)imageViewTouchesEnd:(int)picId{
    NSLog(@"end here");
	BOOL isfinal = NO;
	NSArray *temp= [picLinkArray objectAtIndex:picId];
	int pid = [[temp objectAtIndex:category_id]intValue];
	NSMutableArray *ar_secondCategory = [DBOperate queryData:T_CATEGORY_PRETTY_PIC theColumn:@"pid" theColumnValue:[NSNumber numberWithInt:pid]  withAll:NO];
	if ([ar_secondCategory count] <= 1) {
		isfinal = YES;
	}
	if(isfinal){
		FinalLevelViewController *finalLevel = [[FinalLevelViewController alloc] init];
		finalLevel.choosePid = [[temp objectAtIndex:category_id]intValue];
		finalLevel.ar_finalCategory = ar_secondCategory;
		[self.navigationController pushViewController:finalLevel animated:YES];
		[finalLevel release];
	}else {
		secondLevelViewController *secondLevel = [[secondLevelViewController alloc]init];
		secondLevel.choosePid = [[temp objectAtIndex:category_id]intValue];
		secondLevel.ar_secondCategory = ar_secondCategory;
		[self.navigationController pushViewController:secondLevel animated:YES];
		[secondLevel release];
	}
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
	NSLog(@"memorywarningiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.progressHUD = nil;
	self.scrollView = nil;
	self.pageControl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
	commandOper.delegate = nil;
	self.picArray = nil;
	self.pagesImage = nil;
	self.myNavigationController = nil; 
	self.allSecondLevelPic = nil;
	self.commandOper = nil;
	self.progressHUD = nil;
	self.picLinkArray = nil;
	self.pageControl = nil;
	for (UIView *innerview in [self.scrollView subviews]){
		[innerview removeFromSuperview];
	}
	self.scrollView = nil;
	self.serviceDataDic = nil;
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    [super dealloc];
}
@end
