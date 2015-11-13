//
//  ThreeDimensionalPicViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThreeDimensionalPicViewController.h"
#import "showPagesImage.h"
#import "secondLevelViewController.h"
#import "Common.h"
#import "IconDownLoader.h"
#import "myImageView.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
#import "FinalLevelViewController.h"
@implementation ThreeDimensionalPicViewController

@synthesize picArray;
@synthesize pagesImage;
@synthesize myNavigationController;
@synthesize allSecondLevelPic;
@synthesize commandOper;
@synthesize progressHUD;
@synthesize picLinkArray;
@synthesize pageControl;
@synthesize scrollView;
@synthesize serviceDataDic;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
//@synthesize navigationController;
@synthesize backView;
@synthesize backOneImgView;
@synthesize backTwoImgView;
@synthesize frontImgView;

@synthesize imgViewArray; //存储所有imageview的数组
@synthesize imgBacViewArray;
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
//	[self accessService];
    [self.navigationController.navigationBar setTranslucent:NO];
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
	self.imgViewArray = [NSMutableArray array];
	self.imgBacViewArray = [NSMutableArray array];
	[backView removeFromSuperview];
	[scrollView removeFromSuperview];
	[pageControl removeFromSuperview];
	//[self.view removeFromSuperview];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 20 - 44 - 49 - 370) * 0.5, 320, self.view.frame.size.height)];
    mainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainView];
    
	///////////圆形效果
	UIScrollView *backscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height)];
	backscrollview.contentSize = CGSizeMake(3*self.view.frame.size.width, mainView.frame.size.height);
	backscrollview.tag = 1001;
	backscrollview.delegate = nil;
	self.backView = backscrollview;
	[backscrollview release];
	[mainView addSubview:backView];
	
    if (backOneImgView == nil) {
        UIImageView *backOneImgView1= [[UIImageView alloc]initWithFrame:CGRectMake(180, 90, 120, 150)];
        self.backOneImgView = backOneImgView1;
        [backOneImgView1 release];
        [mainView addSubview:backOneImgView];
    }
	if (backTwoImgView == nil) {
        UIImageView *backTwoImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 90, 120, 150)];
        self.backTwoImgView = backTwoImgView1;
        [backTwoImgView1 release];
        [mainView addSubview:backTwoImgView];
    }
	
	
	float width = self.view.frame.size.width;
	float height = self.view.frame.size.height;
	NSLog(@"width:%f",width);
	NSLog(@"height:%f",height);
	
	int pageCount = [picLinkArray count];
	totalPages_ = pageCount;
	firstLevelScrollView *scvtmp = [[firstLevelScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
	scvtmp.contentSize = CGSizeMake(3*width, height);
	scvtmp.pagingEnabled = YES;
	scvtmp.delegate = self;
	scvtmp.myscrolldelegate = self;
	scvtmp.showsHorizontalScrollIndicator = NO;
	scvtmp.showsVerticalScrollIndicator = NO;
	scvtmp.tag = 1002;
	self.scrollView=scvtmp;
	[scvtmp release];
    
    int y = 0;
    if (IOS_VERSION >= 7.0) {
        y = 80;
    }else
    {
        y = 30;
    }
	UIPageControl *pagectmp = [[UIPageControl alloc] initWithFrame:CGRectMake(120, height-y, 80, 15)];
	self.pageControl = pagectmp;
	[pagectmp release];
	pageControl.backgroundColor = [UIColor clearColor];
	pageControl.numberOfPages = pageCount;
	pageControl.currentPage = 0;
	
	//[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
	picwidth = 240;//width-40;
	picheight = 300;//scrollView.frame.size.height-25;
	NSLog(@"picwidth %f,,picheight %f",picwidth,picheight);
	for (int i= 0;i < pageCount;i++){
		myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(0,0,picwidth,picheight) withImageId:i];
		UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"图片占位" ofType:@"png"]];
		iv.image = img;
		[img release];
		iv.tag = i+100;
		iv.mydelegate = self;
		[imgViewArray addObject:iv];
		//[scrollView addSubview:iv];
		[iv release];
	}
	for (int i= 0;i < pageCount;i++){
		myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(0,0,120,150) withImageId:i];
	    UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"图片占位" ofType:@"png"]];
		iv.image = img;
		[img release];
		iv.tag = i+100;
		iv.mydelegate = self;
		[imgBacViewArray addObject:iv];
		[iv release];
	}
	myImageView *mImgView = [[myImageView alloc] initWithFrame:CGRectMake(360, 26, 240, 300) withImageId:0];
	mImgView.mydelegate = self;
	mImgView.tag = 1024;
	self.frontImgView = mImgView;
	[mImgView release];
	
	[self.scrollView addSubview:frontImgView];
	[mainView addSubview:scrollView];
	[self.view addSubview:pageControl];
	
	
	for (int i=0;i<[picLinkArray count]; i++) {
		NSArray *cc = [picLinkArray objectAtIndex:i];
		if (((NSString*)[cc objectAtIndex:category_pic_name]).length > 1) {
			myImageView *myIV = [imgViewArray objectAtIndex:i];
			myImageView *myIVBack = [imgBacViewArray objectAtIndex:i];
			UIImage *photo = [FileManager getPhoto:[cc objectAtIndex:category_pic_name]];
			if (photo.size.width>2) {
				myIV.image = [photo fillSize:myIV.frame.size];
				myIVBack.image = [photo fillSize:myIVBack.frame.size];
			}
			else {
				[self startIconDownload: [cc objectAtIndex:category_pic_url] forIndex:[NSIndexPath indexPathWithIndex:i]];
			}
		}
		else {
			[self startIconDownload: [cc objectAtIndex:category_pic_url] forIndex:[NSIndexPath indexPathWithIndex:i]];
		}
	}
	int index = 0;
	currentPage_ = 0;
	frontImgView.image = [[imgViewArray objectAtIndex:index] image];
	index = (index == (totalPages_ - 1) ? 0 : (index + 1));
	NSLog(@"1 %d   %@",index,imgViewArray);
	backOneImgView.image = [[imgBacViewArray objectAtIndex:index]image];
	index = (index == (totalPages_ - 1) ? 0 : (index + 1));
	NSLog(@"2 %d",index);
	backTwoImgView.image = [[imgBacViewArray objectAtIndex:index]image];
	[self.scrollView setContentOffset:CGPointMake(320.0, 0.0)];
	[self.backView setContentOffset:CGPointMake(320.0, 0.0)];
}
- (void)touchOnce{
	
	BOOL isfinal = NO;
	NSArray *temp= [picLinkArray objectAtIndex:currentPage_];
	int pid = [[temp objectAtIndex:category_id]intValue];
	NSMutableArray *ar_secondCategory = (NSMutableArray *)[DBOperate queryData:T_CATEGORY_PRETTY_PIC theColumn:@"pid" theColumnValue:[NSNumber numberWithInt:pid]  withAll:NO];
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
	
	
	/*secondLevelViewController *secondLevel = [[secondLevelViewController alloc]initWithNibName:@"secondLevelViewController" bundle:nil];
	 
	 NSArray *one= [picLinkArray objectAtIndex:currentPage_];
	 secondLevel.choosePid = [[one objectAtIndex:category_id]intValue];
	 //secondLevel.navigationController = self.navigationController;
	 
	 [self.navigationController pushViewController:secondLevel animated:YES];
	 
	 [secondLevel release];*/
}
-(void)removePic:(int)picNum{
	myImageView *myIV = [scrollView viewWithTag:(picNum+100)];
	myIV.image = nil;
	
}
-(void)showOnePic:(int)picNum{
	if (picNum >= [picLinkArray count]||picNum < 0) {
		return;
	}
	NSArray *cc = [picLinkArray objectAtIndex:picNum];
	myImageView *myIV = [scrollView viewWithTag:(picNum+100)];
	myIV.backgroundColor = [UIColor whiteColor];
	if (myIV.image == nil) {
		if (((NSString*)[cc objectAtIndex:category_pic_name]).length > 1) {
			UIImage *photo = [FileManager getPhoto:[cc objectAtIndex:category_pic_name]];
			if (photo!=nil) {
				myIV.image = [photo fillSize:myIV.frame.size];				
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
	/*int whichPage = aPageControl.currentPage;
	 [UIView beginAnimations:nil context:NULL];
	 [UIView setAnimationDuration:0.3f];
	 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	 scrollView.contentOffset = CGPointMake(self.view.frame.size.width * whichPage, 0.0f);
	 [UIView commitAnimations];*/
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
	//开始滑动时，主imageview图片置空
	backOneImgView.image = nil;
	backTwoImgView.image = nil;
	frontImgView.image = nil;
	NSLog(@"begin dragging");
	//scrollview上添加三个imageview
	//第一个imageview的图片为当前图片的前一张图片（如果当前图片为第一张则显示最后一张图片）
	//第二个imageview的图片为当前图片
	//第三个imageview的图片为当前图片的后一张图片（如果当前图片为最后一张则显示第一张图片）
	UIImageView *imView1 = [imgViewArray objectAtIndex:(currentPage_ == 0 ? (totalPages_ - 1) : (currentPage_ - 1))];
	UIImageView *imView2 = [imgViewArray objectAtIndex:currentPage_];
	UIImageView *imView3 = [imgViewArray objectAtIndex:(currentPage_ == (totalPages_ - 1) ? 0 : (currentPage_ + 1))];
	[imView1 setFrame:CGRectMake(40, 26, 240, 300)];
	[imView2 setFrame:CGRectMake(360.0, 26, 240, 300)];
	[imView3 setFrame:CGRectMake(680.0, 26, 240, 300)];
	[self.scrollView addSubview:imView1];
	[self.scrollView addSubview:imView2];	
	[self.scrollView addSubview:imView3];
	int index = currentPage_;
	NSLog(@"4 %d",index);
	UIImageView *imView11 = [imgBacViewArray objectAtIndex:index];
	index = (index == (totalPages_ - 1) ? 0 : (index + 1));
	NSLog(@"5 %d",index);
	UIImageView *imView12 = [imgBacViewArray objectAtIndex:index];
	index = (index == (totalPages_ - 1) ? 0 : (index + 1));
	NSLog(@"6 %d",index);
	UIImageView *imView13 = [imgBacViewArray objectAtIndex:index];
	index = (index == (totalPages_ - 1) ? 0 : (index + 1));
	NSLog(@"7 %d",index);
	UIImageView *imView14 = [imgBacViewArray objectAtIndex:index];
	
	[imView11 setFrame:CGRectMake(660, 90, 120, 150)];
	NSLog(@"imview12 %@",imView12);
	[imView12 setFrame:CGRectMake(500, 90, 120, 150)];
	[imView13 setFrame:CGRectMake(340, 90, 120, 150)];
	[imView14 setFrame:CGRectMake(180, 90, 120, 150)];
	[self.backView addSubview:imView11];
	[self.backView addSubview:imView12];	
	[self.backView addSubview:imView13];
	[self.backView addSubview:imView14];
}

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	
	if (aScrollView.tag == 1002) {
		float offsetx = 960.0f-aScrollView.contentOffset.x;
		CGPoint p= CGPointMake(offsetx/2, aScrollView.contentOffset.y);
		[backView setContentOffset:p animated:NO];
	}
	/*CGPoint offset = aScrollView.contentOffset;
	 NSLog(@"offset %f",offset.x);
	 if (offset.x > 320.0*(pageControl.currentPage+1)) {
	 if (pageControl.currentPage < (pageControl.numberOfPages -1)) {
	 pageControl.currentPage = offset.x / self.view.frame.size.width;
	 }
	 else {
	 pageControl.currentPage = 0;
	 }
	 
	 }
	 else if(offset.x < -320.0){
	 if (pageControl.currentPage > 0) {
	 pageControl.currentPage = offset.x / self.view.frame.size.width;
	 }
	 else {
	 pageControl.currentPage = pageControl.numberOfPages-1;
	 }
	 
	 
	 }
	 else {
	 pageControl.currentPage = offset.x / self.view.frame.size.width;
	 }
	 NSLog(@"currentpage %d",pageControl.currentPage);
	 [self managePicsInCurrentPic:pageControl.currentPage];*/
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)ascrollView {
	NSLog(@"end decelerating %f",ascrollView.contentOffset.x);
	//scrollview结束滚动时判断是否已经换页
	if (ascrollView.contentOffset.x > self.view.frame.size.width) {
		
		//如果是最后一张图片，则将主imageview内容置为第一张图片
		//如果不是最后一张图片，则将主imageview内容置为下一张图片
		if (currentPage_ < (totalPages_ - 1)) {
			currentPage_ ++;
			
			int index = currentPage_;
			
			frontImgView.image = ((UIImageView *)[imgViewArray objectAtIndex:index]).image;
			myImageView *imageView = [imgViewArray objectAtIndex:index];
			if (imageView != nil) {
				frontImgView.imageId = imageView.imageId;
			}
			index = (index == (totalPages_ - 1) ? 0 : (index + 1));
			
			backOneImgView.image = ((UIImageView *)[imgBacViewArray objectAtIndex:index]).image;
			index = (index == (totalPages_ - 1) ? 0 : (index + 1));
			
			backTwoImgView.image = ((UIImageView *)[imgBacViewArray objectAtIndex:index]).image;
		} else {
			currentPage_ = 0;
			int index = currentPage_;
			frontImgView.image = ((UIImageView *)[imgViewArray objectAtIndex:index]).image;
			myImageView *imageView = [imgViewArray objectAtIndex:index];
			if (imageView != nil) {
				frontImgView.imageId = imageView.imageId;
			}
			index = (index == (totalPages_ - 1) ? 0 : (index + 1));
			
			backOneImgView.image = ((UIImageView *)[imgBacViewArray objectAtIndex:index]).image;
			index = (index == (totalPages_ - 1) ? 0 : (index + 1));
			
			backTwoImgView.image = ((UIImageView *)[imgBacViewArray objectAtIndex:index]).image;
			
		}
		
	} else if (ascrollView.contentOffset.x < self.view.frame.size.width) {
		
		//如果是第一张图片，则将主imageview内容置为最后一张图片
		//如果不是第一张图片，则将主imageview内容置为上一张图片
		if (currentPage_ > 0) {
			currentPage_ --;
			int index = currentPage_;
			NSLog(@"index 0 %d",index);
			frontImgView.image = ((UIImageView *)[imgViewArray objectAtIndex:index]).image;
			frontImgView.imageId = ((myImageView *)[imgViewArray objectAtIndex:index]).imageId;
			index = (index == (totalPages_ - 1) ? 0 : (index + 1));
			NSLog(@"index 1 %d",index);
			backOneImgView.image = ((UIImageView *)[imgBacViewArray objectAtIndex:index]).image;
			index = (index == (totalPages_ - 1) ? 0 : (index + 1));
			NSLog(@"index 2 %d",index);
			backTwoImgView.image = ((UIImageView *)[imgBacViewArray objectAtIndex:index]).image;
			
		} else {
			currentPage_ = totalPages_ - 1;
			int index = currentPage_;
			NSLog(@"INDEX %d",index);
			frontImgView.image = ((UIImageView *)[imgViewArray objectAtIndex:index]).image;
			frontImgView.imageId = ((myImageView *)[imgViewArray objectAtIndex:index]).imageId;
			index = (index == (totalPages_ - 1) ? 0 : (index + 1));
			NSLog(@"index 3 %d",index);
			backOneImgView.image = ((UIImageView *)[imgBacViewArray objectAtIndex:index]).image;
			index = (index == (totalPages_ - 1) ? 0 : (index + 1));
			NSLog(@"index 4 %d",index);
			backTwoImgView.image = ((UIImageView *)[imgBacViewArray objectAtIndex:index]).image;
			
		}
		
	} else {
		
		//没有换页，则主imageview仍然为之前的图片
		int index = currentPage_;
		frontImgView.image = ((UIImageView *)[imgViewArray objectAtIndex:currentPage_]).image;
		frontImgView.imageId = ((myImageView *)[imgViewArray objectAtIndex:index]).imageId;
		NSLog(@"current offset :%f", self.scrollView.contentOffset.x);
		
		index = (index == (totalPages_ - 1) ? 0 : (index + 1));
		NSLog(@"eee index %d %@",index,[imgViewArray objectAtIndex:index]);
		backOneImgView.image = ((UIImageView *)[imgBacViewArray objectAtIndex:index]).image;
		index = (index == (totalPages_ - 1) ? 0 : (index + 1));
		NSLog(@"eee index %d",index);
		backTwoImgView.image = ((UIImageView *)[imgBacViewArray objectAtIndex:index]).image;
		
	}
	
	//始终将scrollview置为第2页
	[self.scrollView setContentOffset:CGPointMake(320.0, 0.0)];
	[self.backView setContentOffset:CGPointMake(320.0, 0.0)];
	//移除scrollview上的图片
	for (UIImageView *theView in [self.scrollView subviews]) {
		if (theView.tag != 1024) {
			[theView removeFromSuperview];
		}
		
	}
	for (UIImageView *theView in [self.backView subviews]) {
		//if (theView.tag != 111 && theView.tag != 112) {
		[theView removeFromSuperview];
		//}
		
	}
	
	self.pageControl.currentPage = currentPage_;
	//[self managePicsInCurrentPic:pageControl.currentPage];
}
/*
 - (void) scrollViewDidScroll: (UIScrollView *) aScrollView
 {
 CGPoint offset = aScrollView.contentOffset;
 pageControl.currentPage = offset.x / self.view.frame.size.width;
 [self managePicsInCurrentPic:pageControl.currentPage];
 }*/
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
			UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(picwidth, picheight)];
			
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
			//if ((index == pageControl.currentPage) || (index == (pageControl.currentPage+1))||(index == (pageControl.currentPage-1))) {
			myImageView *myIV = [imgViewArray objectAtIndex:index];
			myIV.image = photo;
			myImageView *myIV1 = [imgBacViewArray objectAtIndex:index];
			myIV1.image = photo;
			//}
			
		}
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
	self.picLinkArray = [DBOperate queryData:T_CATEGORY_PRETTY_PIC theColumn:@"pid" theColumnValue:[NSNumber numberWithInt:0]  withAll:NO];
	
}

- (void)imageViewTouchesEnd:(int)picId{
    NSLog(@"end here");
	/*BOOL isfinal = NO;
	 NSArray *temp= [picLinkArray objectAtIndex:picId];
	 int pid = [[temp objectAtIndex:category_id]intValue];
	 NSMutableArray *ar_secondCategory = [DBOperate queryData:T_CATEGORY_PRETTY_PIC theColumn:@"pid" theColumnValue:[NSNumber numberWithInt:pid]  withAll:NO];
	 if ([ar_secondCategory count] <= 1) {
	 isfinal = YES;
	 }
	 if(isfinal){
	 FinalLevelViewController *finalLevel = [[FinalLevelViewController alloc] initWithNibName:@"FinalLevelViewController" bundle:nil];
	 finalLevel.choosePid = [[temp objectAtIndex:category_id]intValue];
	 finalLevel.ar_finalCategory = ar_secondCategory;
	 [self.navigationController pushViewController:finalLevel animated:YES];
	 [finalLevel release];
	 }else {
	 secondLevelViewController *secondLevel = [[secondLevelViewController alloc]initWithNibName:@"secondLevelViewController" bundle:nil];
	 //secondLevel.picArray
	 secondLevel.choosePid = [[temp objectAtIndex:category_id]intValue];
	 secondLevel.ar_secondCategory = ar_secondCategory;
	 //[myNavigationController pushViewController:secondLevel animated:YES];
	 [self.navigationController pushViewController:secondLevel animated:YES];
	 //[pushdelegate pushView:secondLevel];
	 [secondLevel release];
	 //[pool release];		
	 }*/
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
	//self.navigationController = nil;
	self.backView = nil;
	self.backOneImgView = nil;
	self.backTwoImgView = nil;
	self.frontImgView = nil;
	self.imgViewArray = nil; //存储所有imageview的数组
	self.imgBacViewArray = nil;
    [super dealloc];
}
@end
