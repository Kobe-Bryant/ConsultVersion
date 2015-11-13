//
//  wallPaperViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "wallPaperViewController.h"
#import "OriginWallPaperViewController.h"
#import "myImageView.h"
#import "Common.h"
#import "IconDownLoader.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
@implementation wallPaperViewController
@synthesize picArray;  
@synthesize pageControl;
@synthesize scrollView;
@synthesize myNavigationController;
@synthesize commandOper;
@synthesize progressHUD;
@synthesize piclinkArray;
@synthesize backgroudPic;
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
	
	//self.title = @"壁纸";
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picbackgroud" ofType:@"png"]];
	self.backgroudPic = [img stretchableImageWithLeftCapWidth:12 topCapHeight:12];
	[img release];
	

	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];
	
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";
	
	[super viewDidLoad];
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	[self accessService];
	
}
-(void)accessService{
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	[self.progressHUD show:YES];
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[Common getVersion:WALLPAPER_ID],@"ver",[NSNumber numberWithInt: shop_id],@"shop-id",[NSNumber numberWithInt: site_id],@"site-id",nil];
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/download/pic.do?param=%@"]];
	NSLog(@"reqstr wall paper %@",reqStr);
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:WALLPAPER delegate:self params:nil];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}
- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	
	
	[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
}
-(void)update{
	self.piclinkArray = [DBOperate queryData:T_WALLPAPER theColumn:nil theColumnValue:nil  withAll:YES];
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}
	int picCount = [piclinkArray count];
	int pageNum = picCount/9;
	if(picCount%9>0)
		pageNum++;
	float width = self.view.frame.size.width;
	float height = self.view.frame.size.height-12;
	UIPageControl *pagecontroltmp = [[UIPageControl alloc] initWithFrame:CGRectMake(120, height, 80, 10)];
	self.pageControl = pagecontroltmp;
	[pagecontroltmp release];
	pageControl.backgroundColor = [UIColor clearColor];
	pageControl.numberOfPages = pageNum;
	pageControl.currentPage = 0;
	[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];

	UIScrollView *scrollviewtmp = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
	self.scrollView = scrollviewtmp;
	[scrollviewtmp release];
	scrollView.contentSize = CGSizeMake(pageNum*width, height-30);
	scrollView.pagingEnabled = YES;
	scrollView.delegate = self;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:scrollView];
	[self.view addSubview:pageControl];
	[self showBackGroud];
	for (int i=0; i < [piclinkArray count]; i++) {
		NSArray *one = [piclinkArray objectAtIndex:i];
		
		if (((NSString*)[one objectAtIndex:wallpaper_thumb_pic_name]).length > 1) {
			
			myImageView *myIV = [scrollView viewWithTag:(i+100)];
			UIImage *photo = [FileManager getPhoto:[one objectAtIndex:wallpaper_thumb_pic_name]];
			if (photo.size.width>2) {
				myIV.image = [photo fillSize:CGSizeMake(photowith, photoheight)];
			}
			else {
				[self startIconDownload: [one objectAtIndex:wallpaper_thumb_pic_url] forIndex:[NSIndexPath indexPathWithIndex:i]];
			}
		}
		else {
			[self startIconDownload: [one objectAtIndex:wallpaper_thumb_pic_url] forIndex:[NSIndexPath indexPathWithIndex:i]];
			
		}
	}
}

- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
	NSUInteger i;
	[index getIndexes:&i];
	NSLog(@"index...................... %lu",(unsigned long)i);
	myImageView *myIV = [scrollView viewWithTag:(i+100)];
	[myIV startSpinner];
    if (imageURL != nil && imageURL.length > 1) 
    {
		if ([imageDownloadsInProgress count]>= 5) {
			imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:imageURL withIndexPath:index withImageType:CUSTOMER_PHOTO];
			[imageDownloadsInWaiting addObject:one];
			[one release];
			return;
		}
		
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
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width>2.0){ 
			NSString *photoname = [callSystemApp getCurrentTime];
			if([FileManager savePhoto:photoname withImage:iconDownloader.cardIcon])
			{
				NSArray *one = [piclinkArray objectAtIndex:[indexPath indexAtPosition:0]]; 
				NSNumber *value = [one objectAtIndex:wallpaper_id];
				[FileManager removeFile:[one objectAtIndex:wallpaper_thumb_pic_name]];
				[DBOperate updateData:T_WALLPAPER tableColumn:@"thumb_pic_name" columnValue:photoname conditionColumn:@"id" conditionColumnValue:value];
			}
			UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(photowith, photoheight)];
			NSUInteger index;
			
			[indexPath getIndexes:&index];
			NSLog(@"index...................... %lu",(unsigned long)index);
			myImageView *myIV = [scrollView viewWithTag:(index+100)];//[picArray objectAtIndex:index];
			[myIV stopSpinner];
			myIV.image = photo;
		}
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			NSUInteger i;
			[one.indexPath getIndexes:&i];
			myImageView *myIV = [scrollView viewWithTag:(i+100)];
			[myIV stopSpinner];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
}

-(void)showBackGroud{
	int leavePicCount = [piclinkArray count];
	int picIndex = 0;
	int pageNum = leavePicCount/9;
	if (leavePicCount%9>0) {
		pageNum++;
	}
	
	float pageX = 0;
	float leftMargin = 2.0f;
	float picMargin = 2.0f;
	float perPicWidth = 104.0f;
	float perPicHeight = [UIScreen mainScreen].bounds.size.height == 480.0f ? 115.0f : 144.0f;
    NSString *picName = [UIScreen mainScreen].bounds.size.height == 480.0f ? @"壁纸默认ip4" : @"壁纸默认ip5";
	photowith = perPicWidth;
	photoheight = perPicHeight;
	
	for (int i = 0; i < pageNum; i++) {
		for (int j = 0; j < 3; j++) {
			for (int k = 0; k < 3; k++) {
				myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(pageX+leftMargin+perPicWidth*k+picMargin*k,perPicHeight*j+picMargin*(j+1),perPicWidth,perPicHeight) withImageId:picIndex];
				//iv.backgroundColor = [UIColor grayColor];
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:picName ofType:@"png"]];
				iv.image = img;
				[img release];
				iv.tag = picIndex+100;
				picIndex++;
				iv.mydelegate = self;
				[scrollView addSubview:iv];
				[iv release];
				if (picIndex >=[piclinkArray count]) {
					return;
				}
				
			}
			
		}
		pageX +=self.view.frame.size.width;
	}
	
}
- (void)imageViewTouchesEnd:(int)picId{
	NSLog(@"imageViewTouchEndn%d",picId);
	OriginWallPaperViewController *originPic = [[OriginWallPaperViewController alloc]init];
	originPic.picArray = piclinkArray;
	originPic.chooseIndex = picId;
	originPic.showWhichOriginPic = SHOW_WALLPAPER;
	[myNavigationController pushViewController:originPic animated:YES];
	[originPic release];
}

- (void) pageTurn: (UIPageControl *) aPageControl
{
	NSLog(@"come to pageturn");
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
	self.backgroudPic = nil;
	self.progressHUD = nil;
	self.imageDownloadsInWaiting = nil;
	self.imageDownloadsInProgress = nil;
	self.commandOper = nil;
	self.pageControl = nil;
	self.scrollView = nil;
	self.piclinkArray = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	commandOper.delegate = nil;
	self.commandOper = nil;
	self.pageControl = nil;
	self.scrollView = nil;
	self.picArray = nil;
	self.myNavigationController = nil;
	self.progressHUD = nil;
	self.piclinkArray = nil;
	self.backgroudPic = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    [super dealloc];
}


@end
