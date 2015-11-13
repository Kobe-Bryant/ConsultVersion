//
//  HotspotMainViewController.m
//  szeca
//
//  Created by MC374 on 12-5-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HotspotMainViewController.h"
#import "hotspotViewController.h"
#import "promotionsViewController.h"
#import "companyNewsViewController.h"
#import "AutoScrollView.h"
#import "browserViewController.h"
#import "CommandOperation.h"
#import "Common.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
#import "MBProgressHUD.h"

@implementation HotspotMainViewController

@synthesize buttonTitle;
@synthesize preSelectBtn;
@synthesize hotspot;
@synthesize promotion;
@synthesize companyNews;
@synthesize navigationController;
@synthesize adPicArray;
@synthesize adScrollView;
@synthesize commandOper;
@synthesize footArray;
@synthesize footPicArray;
@synthesize imageDic;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize	photoWith;
@synthesize	photoHigh;
@synthesize currentIndex;
@synthesize progressHUD;

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
//	UIImageView *navBarBack = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,320 ,44)];
//	UIImage *navBarBackImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar" ofType:@"png"]];
//	navBarBack.image = navBarBackImg;
//	[navBarBackImg release];
//	[self.view addSubview:navBarBack];
//	[navBarBack release];
	
	UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,0 ,0)];
	UIImage *logoImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
	int imgWidth = logoImage.size.width;
	int imgHeight = logoImage.size.height;
	int x = (self.view.frame.size.width - imgWidth) / 2;
	int y = (44 - logoImage.size.height)/2;
	[logoView setFrame:CGRectMake(x,y ,imgWidth ,imgHeight)];
	logoView.image = logoImage;
	self.navigationItem.titleView = logoView;
	[logoImage release];	
	[logoView release];
	
	
	NSMutableDictionary *iD = [[NSMutableDictionary alloc]init];
	self.imageDic = iD;
	[iD release];
	
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	NSArray *a = [[NSArray alloc]initWithObjects:@"热点推荐",@"资讯新闻",@"公司动态",nil];//arrayWithObjects:@"热点推荐",@"资讯新闻",@"新闻动态",nil];
	self.buttonTitle = a;
	[a release];
	
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];
	
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";
	[self.progressHUD show:YES];
	[self accessService];

}

-(void) accessService{
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[Common getVersion:AD_QY_ID],@"ver_qy",
								 [Common getVersion:AD_PLATFORM_ID],@"ver_platform",
								 [NSNumber numberWithInt: site_id],@"site_id",nil];
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/ad/advertising.do?param=%@"]];
	
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:AD_COMMENT delegate:self params:nil];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];	
}

- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
}

-(void) update{
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}	
	UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认ad" ofType:@"png"]];
	self.footArray = (NSMutableArray *)[DBOperate queryData:T_ADVERTISE_LIST theColumn:@"adType" theColumnValue:@"foot" withAll:NO];
	NSMutableArray *footpa = [NSMutableArray array];
	self.footPicArray = footpa;
	if ([footArray count] > 0) {
		if (hotspot != nil) {
			[hotspot.view setFrame:CGRectMake(0, 35, 320, self.view.frame.size.height)];
		}
		for (int i = 0; i < [footArray count];i++ ) {
			[footPicArray addObject:image];
		}
		AutoScrollView *asv = [[AutoScrollView alloc] initWithFrame:
							   CGRectMake(0,self.view.frame.size.height - 40.0f, self.view.frame.size.width, 40) picArray:footPicArray];
		asv.delegate = self;
		self.adScrollView = asv;
		[asv release];
		[self.view addSubview:adScrollView];
	}	
	
	for (int i=0;i<[footArray count]; i++) {
		NSArray *cc = [footArray objectAtIndex:i];
		
		if (((NSString*)[cc objectAtIndex:advertiselist_image]).length > 1) {
			UIImage *photo = [FileManager getPhoto:[cc objectAtIndex:advertiselist_image_name]];
			if (photo.size.width>2) {
				[adScrollView updateImage:photo picArrayIndex:i];
			}
			else {
				NSLog(@"iii %d ",i);
				[self startIconDownload: [cc objectAtIndex:advertiselist_image] forIndex:[NSIndexPath indexPathWithIndex:i]];
			}
		}
		else {
			NSLog(@"iiiii %d    %@",i,[cc objectAtIndex:advertiselist_image]);
			[self startIconDownload: [cc objectAtIndex:advertiselist_image] forIndex:[NSIndexPath indexPathWithIndex:i]];
			
		}
	}
	
	[self createButton];
	[self HandleSegment:[self.view viewWithTag:100]];
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];	
	self.navigationController.navigationBarHidden = NO;

	switch (currentIndex) {
		case 100:
		{
			if (hotspot != nil) {
				[hotspot viewWillAppear:animated];
				hotspot.myNavigationController = self.navigationController;
			}
			break;
		}
		case 101:
		{
			if (promotion != nil) {
				[promotion viewWillAppear:animated];
			}
			break;
		}
		case 102:
		{
			if (companyNews != nil) {
				[companyNews viewWillAppear:animated];
			}
			break;
		}
		default:
			break;
	}
}

-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBarHidden = NO;
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
    [super viewDidUnload];
	self.buttonTitle = nil;
	self.hotspot = nil;
	self.promotion = nil;
	self.companyNews = nil;
	self.navigationController = nil;
	self.adPicArray = nil;
	self.adScrollView = nil;
	self.commandOper = nil;
	self.footArray = nil;
	self.footPicArray = nil;
	self.imageDic = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.progressHUD = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	self.buttonTitle = nil;
	self.hotspot = nil;
	self.promotion = nil;
	self.companyNews = nil;
	self.navigationController = nil;
	self.adPicArray = nil;
	self.adScrollView = nil;
	self.commandOper = nil;
	self.footArray = nil;
	self.footPicArray = nil;
	self.imageDic = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.progressHUD = nil;
}

-(void) createButton{
	UIImageView *navBack = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,0 ,0)];
	UIImage *navBackImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"资讯导航条背景" ofType:@"png"]];
	navBack.image = navBackImg;
	[navBack setFrame:CGRectMake(0, 0, 320, 35)];
	[navBackImg release];
	[self.view addSubview:navBack];
	[navBack release];
	
	float buttonWidth = self.view.frame.size.width/[buttonTitle count];
	float buttonHeight = 35;
	float buttonX = 0;
	float buttonY = 0;
	int btag = 100;
	int i = 5;
	
	
	for (NSString *btitle in buttonTitle) {
		
		UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
		[button1 setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
		[button1 addTarget:self action:@selector(HandleSegment:) forControlEvents:UIControlEventTouchDown];
		buttonX += (buttonWidth);
		button1.tag = btag++; 
		NSLog(@"button1.tag %d",button1.tag);
		UILabel *Ltitle = [[UILabel alloc]initWithFrame:CGRectMake(4, 4, buttonWidth-8, buttonHeight-8)];
		Ltitle.font = [UIFont boldSystemFontOfSize:14.0];
		Ltitle.textAlignment = UITextAlignmentCenter;
		Ltitle.backgroundColor = [UIColor clearColor];
		Ltitle.textColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
		Ltitle.text = btitle;
		Ltitle.tag = i++;
		NSLog(@"Ltitle.tag %d",Ltitle.tag);
		[button1 addSubview:Ltitle];
		[Ltitle release];
		
		UIImage *turnbackImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"热点导航未选中" ofType:@"png"]];
		[button1 setImage:turnbackImg forState:UIControlStateNormal];
		[turnbackImg release];
		UIImage *turnbackImg1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"热点导航选中" ofType:@"png"]];
		[button1 setImage:turnbackImg1 forState:UIControlStateSelected ];
		[turnbackImg1 release];
		[self.view addSubview:button1];
		
	}
	
}

- (void) HandleSegment:(id)sender{
	if (preSelectBtn != nil) {
		preSelectBtn.selected = NO;
	}
	UILabel *prelabel = (UILabel*)[preSelectBtn viewWithTag:(preSelectBtn.tag - 95)];
	prelabel.textColor = [UIColor colorWithRed:0.26 green:0.26 blue:0.26 alpha:1.0];
	UIButton *bto = (UIButton*)sender;
	bto.selected = YES;
	preSelectBtn = bto;
	UILabel *label = (UILabel*)[bto viewWithTag:(bto.tag - 95)];
	label.textColor = [UIColor blackColor];
	[hotspot.view removeFromSuperview];
	[promotion.view removeFromSuperview];
	[companyNews.view removeFromSuperview];
	currentIndex = bto.tag;
	switch (bto.tag) {
		case 100:
		{
			if (hotspot == nil) {
				hotspotViewController *hv = [[hotspotViewController alloc] init];				
				hv.myNavigationController = self.navigationController;
				self.hotspot = hv;
				[hv release];
			}			
			[self.view addSubview:hotspot.view];
			if (adScrollView != nil) {
				[self.view addSubview:adScrollView];
			}			
			break;
		}
		case 101:
		{
			if (promotion == nil) {
				promotionsViewController *pv = [[promotionsViewController alloc] init];				
				pv.myNavigationController = self.navigationController;
				self.promotion = pv;
				[pv release];
			}			
			[adScrollView removeFromSuperview];
			[self.view addSubview:promotion.view];
			break;
		}
		case 102:
		{
			if (companyNews == nil) {
				companyNewsViewController *cv = [[companyNewsViewController alloc] init];				
				cv.myNavigationController = self.navigationController;
				self.companyNews = cv;
				[cv release];
			}			
			[adScrollView removeFromSuperview];
			[self.view addSubview:companyNews.view];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark Table view data source

-(void) onCloseButtonClick{
	NSLog(@"hotspotmain close");
	if (adScrollView != nil) {
		[adScrollView removeFromSuperview];
		adScrollView = nil;
	}	
	if (hotspot != nil) {
		[hotspot.view setFrame:CGRectMake(0, 35, 320, self.view.frame.size.height - 35)];
	}
}

-(void) onAdClick:(int)imageId{
	if (imageId < [footArray count]) {
		browserViewController *browser = [[browserViewController alloc] init];
        browser.isHideToolbar = NO;
        browser.isFromAd = YES;
		[self.navigationController pushViewController:browser animated:YES];
		NSArray *cc = [footArray objectAtIndex:imageId];
		NSString *url = [cc objectAtIndex:advertiselist_url];
		
		NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];			
		// app名称		
		NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
		
        browser.newsTitle = app_Name;
		NSLog(@"shop:%@:",app_Name);
        browser.newsDesc = url;
		browser.linkurl = url;
		[browser loadURL:url];
		NSLog(@"imahgeID:%d",imageId);
		NSLog(@"adurl%@",url);
		[browser release];
	}		
}

- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
	NSLog(@"hotdownpic %@",imageURL);
    if (imageURL != nil && imageURL.length > 1) 
    {
		if ([imageDownloadsInProgress count]>= MAXICONDOWNLOADINGNUM) {
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
	NSUInteger index;
	[indexPath getIndexes:&index];
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width>2.0){
			NSString *photoname = [callSystemApp getCurrentTime];
			UIImage *photo = iconDownloader.cardIcon;
			if([FileManager savePhoto:photoname withImage:photo])
			{
				NSArray *one = [footArray objectAtIndex:index]; 
				NSLog(@"one %d ",[one count]);
				NSNumber *value = [one objectAtIndex:advertiselist_imageid];
				[FileManager removeFile:[one objectAtIndex:advertiselist_image_name]];
				[DBOperate updateData:T_ADVERTISE_LIST 
						  tableColumn:@"imageName" columnValue:photoname conditionColumn:@"imageid" conditionColumnValue:value];				
				self.footArray = [DBOperate queryData:T_ADVERTISE_LIST theColumn:@"adType" theColumnValue:@"foot" withAll:NO];
				[adScrollView updateImage:photo picArrayIndex:index];
			}			
		}
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
}


@end
