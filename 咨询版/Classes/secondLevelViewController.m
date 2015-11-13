//
//  secondLevelViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "secondLevelViewController.h"
#import "myImageView.h"
#import "OriginPicViewController.h"
#import "Common.h"
#import "IconDownLoader.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
#import "spinnerView.h"
@implementation secondLevelViewController
@synthesize detailPicArray;
@synthesize pageControl;
@synthesize scrollView;
@synthesize picArray;
@synthesize productDic;
@synthesize choosePid;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize ar_secondCategory;
@synthesize ar_scrollPic;
@synthesize lastChooseBto;
@synthesize scribeLabel;
@synthesize placeholdPic;
@synthesize bar;
@synthesize left;
@synthesize right;
@synthesize sc;
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BG_IMAGE]];
	
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"图片占位" ofType:@"png"]];
	self.placeholdPic = img;
	[img release];
//	self.ar_secondCategory = [DBOperate queryData:T_CATEGORY_PRETTY_PIC theColumn:@"pid" theColumnValue:[NSNumber numberWithInt:choosePid]  withAll:NO];
//	if ([self.ar_secondCategory count]==0) {
//		self.ar_secondCategory = [DBOperate queryData:T_CATEGORY_PRETTY_PIC theColumn:@"id" theColumnValue:[NSNumber numberWithInt:choosePid]  withAll:NO];
//	}
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	NSMutableArray* titleArray = [[NSMutableArray alloc]init];
	for (NSArray *one in ar_secondCategory){
		[titleArray addObject:[one objectAtIndex:category_name]];
	}
    
    UIImage *image = [UIImage imageNamed:@"产品分类背景.png"];
    bar = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44 - 20 - image.size.height, self.view.frame.size.width, image.size.height)];
    bar.image = image;
    bar.userInteractionEnabled = YES;
    [self.view addSubview:bar];
    
    UIImage *leftImage = [UIImage imageNamed:@"产品分类向左.png"];
    left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0,  (bar.frame.size.height - leftImage.size.height) * 0.5, leftImage.size.width,leftImage.size.height);
    [left addTarget:self action:@selector(HandleLeft) forControlEvents:UIControlEventTouchUpInside];
    [left setImage:leftImage forState:UIControlStateNormal];
    [bar addSubview:left];
    
    UIImage *rightImage = [UIImage imageNamed:@"产品分类向右.png"];
    right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(bar.frame.size.width - rightImage.size.width, (bar.frame.size.height - rightImage.size.height) * 0.5, rightImage.size.width, rightImage.size.height);
    [right addTarget:self action:@selector(HandleRight) forControlEvents:UIControlEventTouchUpInside];
    [right setImage:rightImage forState:UIControlStateNormal];
    [bar addSubview:right];
    
    if ([titleArray count]<4) {
		left.hidden = YES;
		right.hidden = YES;
	}
    
    sc = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(left.frame), 0, bar.frame.size.width - leftImage.size.width * 2, bar.frame.size.height)];
    [bar addSubview:sc];
    
	[self showTypeBto:titleArray];
    
	if([ar_secondCategory count]>0)
	{
	self.title = [titleArray objectAtIndex:0];
	NSArray *first = [ar_secondCategory objectAtIndex:0];
	[self showScrollView:[[first objectAtIndex:category_id]intValue] withCoverId:[[first objectAtIndex:category_product_id]intValue]];
	}
	[titleArray release];
	
	//
//	[spinnerView startSpinner:self.view];
}

/*- (void)viewWillDisappear:(BOOL)animated 
{
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	[imageDownloadsInProgress removeAllObjects];
	[imageDownloadsInWaiting removeAllObjects];
	[pageControl removeFromSuperview];
	
	[scribeLabel removeFromSuperview];
	for (UIView *innerview in [self.scrollView subviews]){
		[innerview removeFromSuperview];
	}
	
	[scrollView removeFromSuperview];
	self.ar_scrollPic = nil;
	self.scrollView = nil;
}*/
-(void)showScrollView:(int)secondCategoryId withCoverId:(int)coverId{
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	[imageDownloadsInProgress removeAllObjects];
	[imageDownloadsInWaiting removeAllObjects];
	[pageControl removeFromSuperview];
	
	[scribeLabel removeFromSuperview];
	for (UIView *innerview in [self.scrollView subviews]){
		[innerview removeFromSuperview];
	}
	
	[scrollView removeFromSuperview];
	if (secondCategoryId<0) {
		return;
	}
	NSMutableArray *ar_sptmp = [[NSMutableArray alloc]init];
	self.ar_scrollPic = ar_sptmp;
	[ar_sptmp release];
	NSArray *productcarray = [DBOperate queryData:T_PRODUCT_PRETTY_PIC
										theColumn:@"id" theColumnValue:[NSNumber numberWithInt:coverId] withAll:NO];
	if ([productcarray count]>0) {
		[self.ar_scrollPic addObject:[productcarray objectAtIndex:0]];
	}
	
	[self.ar_scrollPic addObjectsFromArray:[DBOperate queryData:
											T_PRODUCT_PRETTY_PIC theColumn:@"id" noEqualValue:[NSNumber numberWithInt:coverId]
													  theColumn:@"catid" equalValue:[NSNumber numberWithInt:secondCategoryId]]]; 
	int picCount = [ar_scrollPic count];
    UILabel *lab = (UILabel *)[self.view viewWithTag:111];
    if (lab != nil) {
        [lab removeFromSuperview];
    }
    
	if (picCount <=0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        label.tag = 111;
        label.text = @"当前分类暂无产品信息";
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:label];
        [label release];
        
		return;
	}
    
    int pageNum = 0;
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        pageNum = (picCount-6)/9+1;
        if(((picCount-6)%9)>0)
            pageNum++;
    }else {
        pageNum = (picCount-9)/12+1;
        if(((picCount-9)%12)>0)
            pageNum++;
    }
	
	float width = self.view.frame.size.width;
	float height = [UIScreen mainScreen].bounds.size.height - 20 - 44 - 100;

	UILabel* descb = [[UILabel alloc]initWithFrame:CGRectMake(12.5f, 8.0f, self.view.frame.size.width-20.0f, 25.0f)];
	descb.backgroundColor = [UIColor clearColor];
	descb.font = [UIFont systemFontOfSize:12];
	descb.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

	NSArray *getdescb = [ar_scrollPic objectAtIndex:0];
	descb.text = [getdescb objectAtIndex:product_name];
	self.scribeLabel = descb;
	[self.view addSubview:descb];
	[descb release];
	
	UIScrollView *scvtmp = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 40.0f, width, height)];
	scvtmp.contentSize = CGSizeMake(pageNum*width+1, height);
	scvtmp.pagingEnabled = YES;
	scvtmp.delegate = self;
	scvtmp.showsHorizontalScrollIndicator = NO;
	scvtmp.showsVerticalScrollIndicator = NO;
	self.scrollView = scvtmp;
	[scvtmp release];
	[self.view addSubview:scrollView];
    
    UIPageControl *pageControltmp= [[UIPageControl alloc] initWithFrame:CGRectMake(120, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 47 - 15, 80, 5)];
	self.pageControl = pageControltmp;
	[pageControltmp release];
	pageControl.backgroundColor = [UIColor clearColor];
	pageControl.numberOfPages = pageNum;
	pageControl.currentPage = 0;
	[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:pageControl];
    
	[self showPage1];
	[self showOtherPage];
    
	for (int i=0;i<[ar_scrollPic count]; i++) {
		NSArray *cc = [ar_scrollPic objectAtIndex:i];
		
		if (((NSString*)[cc objectAtIndex:product_pic_name]).length > 1) {
			myImageView *myIV = (myImageView *)[scrollView viewWithTag:(i+100)];
			UIImage *photo = [FileManager getPhoto:[cc objectAtIndex:product_pic_name]];
			if (photo.size.width>2) {
				myIV.image = [photo fillSize:myIV.frame.size];
			}
			else {
				//NSLog(@"iii %d ",i);
				[self startIconDownload: [cc objectAtIndex:product_pic_url] forIndex:[NSIndexPath indexPathWithIndex:i]];
			}
		}
		else {
			//NSLog(@"iiiii %d    %@",i,[cc objectAtIndex:product_pic_url]);
			[self startIconDownload: [cc objectAtIndex:product_pic_url] forIndex:[NSIndexPath indexPathWithIndex:i]];
			
		}
	}
}

-(void)showPage1{
	int picCount = [ar_scrollPic count];
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        if (picCount > 6) {
            picCount = 6;
        }
    }else {
        if (picCount > 9) {
            picCount = 9;
        }
    }
	
	//	float width = self.view.frame.size.width;
	//	float height = self.view.frame.size.height-100;
	float leftMargin = 12.50f;
	float picMargin = 5.0f;
	float perPicWidth = 95.0f;
	float perPicHeight = 95.0f;
	
	for (int i= 0;i < picCount;i++){
		if (i == 0) {
			myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(leftMargin,0.0f,perPicWidth*2+picMargin,perPicHeight*2+picMargin) withImageId: i];
			//iv.backgroundColor = [UIColor grayColor];
			iv.image = [placeholdPic fillSize:iv.frame.size];
			iv.tag = 100;
			iv.mydelegate = self;
			[scrollView addSubview:iv];
			[iv release];
			
		}
		else if(i == 1 || i == 2){
			myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(leftMargin+perPicWidth*2+picMargin*2,perPicHeight*(i-1)+picMargin*(i-1),perPicWidth,perPicHeight) withImageId:i];
            //iv.backgroundColor = [UIColor grayColor];
			iv.image = [placeholdPic fillSize:iv.frame.size];
			iv.tag = 100 + i;
			iv.mydelegate = self;
			[scrollView addSubview:iv];
			[iv release];
			
		}
		else if (i == 3 || i == 4 || i == 5) {
			myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(leftMargin+perPicWidth*(i-3)+picMargin*(i-3),perPicHeight*2+picMargin*2,perPicWidth,perPicHeight) withImageId:i];
            //iv.backgroundColor = [UIColor grayColor];
			iv.image = [placeholdPic fillSize:iv.frame.size];
			iv.tag = 100 +i;
			iv.mydelegate = self;
			[scrollView addSubview:iv];
			[iv release];
		}else {
            myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(leftMargin+perPicWidth*(i-6)+picMargin*(i-6),perPicHeight*3+picMargin*3,perPicWidth,perPicHeight) withImageId:i];
            //iv.backgroundColor = [UIColor grayColor];
			iv.image = [placeholdPic fillSize:iv.frame.size];
			iv.tag = 100 +i;
			iv.mydelegate = self;
			[scrollView addSubview:iv];
			[iv release];
        }
	}	
}

-(void)showOtherPage{
    int leavePicCount = 0 ;
    int picIndex = 0;
    int pageNum = 0;
	if ([UIScreen mainScreen].bounds.size.height == 480) {
        leavePicCount = [ar_scrollPic count] - 6;
        picIndex = 6;
        
        pageNum = leavePicCount/9;
        if (leavePicCount%9>0) {
            pageNum++;
        }
    }else {
        leavePicCount = [ar_scrollPic count] - 9 ;
        picIndex = 9;
        
        pageNum = leavePicCount/12;
        if (leavePicCount%12>0) {
            pageNum++;
        }
    }
	
	float pageX = self.view.frame.size.width;
	float leftMargin = 12.50f;
	float picMargin = 5.0f;
	float perPicWidth = 95.0f;
	float perPicHeight = 95.0f;
	//	float perPicHeight = scrollView.frame.size.height/3-7;
	//	float perPicWidth = self.view.frame.size.width/3-5;
    int total = 0;
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        total = 3;
    }else {
        total = 4;
    }
    
    for (int i = 0; i < pageNum; i++) {
        for (int j = 0; j < total; j++) {
            for (int k = 0; k < 3; k++) {
                myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(pageX+leftMargin+perPicWidth*k+picMargin*k,perPicHeight*j+picMargin*j,perPicWidth,perPicHeight) withImageId:picIndex];
                iv.image = [placeholdPic fillSize:iv.frame.size];
                iv.tag = 100+picIndex;
                picIndex++;
                iv.mydelegate = self;
                [scrollView addSubview:iv];
                [iv release];
                if (picIndex >=[ar_scrollPic count]) {
                    return;
                }
            }
        }
        pageX +=self.view.frame.size.width;
    }
}

- (void)imageViewTouchesEnd:(int)picId{
	NSLog(@"imageViewTouchEndn%d",picId);
	NSArray* ar_product = [ar_scrollPic objectAtIndex:picId];
	NSNumber *productID = [ar_product objectAtIndex:product_id];
	NSArray *productArray = [DBOperate queryData:T_PIC theColumn:@"pid" theColumnValue:productID withAll:NO];

	//NSLog(@"productArray %@ %d",productArray,[productArray count]);
	OriginPicViewController *originPic = [[OriginPicViewController alloc]init];
	originPic.picArray = productArray;
	originPic.chooseIndex = 0;
	originPic.productId = productID;
	originPic.showWhichOriginPic = SHOW_PRODUCT_PIC;
	originPic.ar_product = ar_product;
	originPic.titleString = [ar_product objectAtIndex:product_name];
	[self.navigationController pushViewController:originPic animated:YES];
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
	if (aScrollView.tag == 1000) {
		
	}
	else {
		CGPoint offset = aScrollView.contentOffset;
		pageControl.currentPage = offset.x / self.view.frame.size.width;
	}

}

-(IBAction)turnBack:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}
-(void)HandleLeft{
	float btoWidth = sc.frame.size.width/3;
	float nowOffset = sc.contentOffset.x;
	if ((nowOffset+btoWidth*3)<sc.contentSize.width) {
		nowOffset = nowOffset+btoWidth;
	}
	sc.contentOffset = CGPointMake(nowOffset, 0.0f);
	
}
-(void)HandleRight{
	float btoWidth = sc.frame.size.width/3;
	float nowOffset = sc.contentOffset.x;
	if ((nowOffset-btoWidth)>=0) {
		nowOffset = nowOffset-btoWidth;
	}
	sc.contentOffset = CGPointMake(nowOffset, 0.0f);
	
}
-(void)chooseState:(UIButton*)bto{
	[lastChooseBto setImage:nil forState:UIControlStateNormal];
	self.lastChooseBto = bto;
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"产品分类选中" ofType:@"png"]];
	[bto setImage:img forState:UIControlStateNormal];
	[img release];
	NSArray *first = [ar_secondCategory objectAtIndex:(bto.tag-100)];
	self.title = [first objectAtIndex:category_name];
	[self showScrollView:[[first objectAtIndex:category_id]intValue] withCoverId:[[first objectAtIndex:category_product_id]intValue]];
}
-(void)HandleTypeBto:(id)sender{
	UIButton *bto = sender;
	[self chooseState:bto];
	switch (bto.tag-100) {
		case 0:
			
			break;
		default:
			break;
	}
	
}
-(void)showTypeBto:(NSMutableArray*)titleArray{
	int pageNum = [titleArray count]/3;
	if ([titleArray count]%3 > 0) {
		pageNum++;
	}
	sc.showsHorizontalScrollIndicator = NO;
	sc.contentSize = CGSizeMake(pageNum*sc.frame.size.width, sc.frame.size.height);
	float btoWidth;
	if([titleArray count] == 1){
		btoWidth = sc.frame.size.width;
	}else if([titleArray count]== 2){
		btoWidth = sc.frame.size.width/2;
	}else {
	 	btoWidth = sc.frame.size.width/3;
	}
	for (int i = 0; i < [titleArray count]; i++) {
		UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
		if (i == 0) {
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"产品分类选中" ofType:@"png"]];
			[button1 setImage:img forState:UIControlStateNormal];	
			[img release];
		}
		//[button1 setImage:nil forState:UIControlStateNormal];
		[button1 setFrame:CGRectMake(i*btoWidth, 0, btoWidth, sc.frame.size.height)];
		[button1 addTarget:self action:@selector(HandleTypeBto:) forControlEvents:UIControlEventTouchUpInside];
		button1.tag = i+100;
		//[button1 setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
		UILabel *btitle = [[UILabel alloc]initWithFrame:CGRectMake(6, 2, btoWidth-12, sc.frame.size.height-4)];
		//btitle.adjustsFontSizeToFitWidth = YES;
		[btitle setFont:[UIFont fontWithName: @"Helvetica" size:14]];
		btitle.textColor = [UIColor whiteColor];
		btitle.backgroundColor = [UIColor clearColor];
		btitle.text = [titleArray objectAtIndex:i];
		btitle.textAlignment = UITextAlignmentCenter;
		btitle.tag = 99;
		[button1 addSubview:btitle];
		[btitle release];
		if (i == 0) {
			self.lastChooseBto = button1;
		}
		[sc addSubview:button1];
	}
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
	NSUInteger i;
	[index getIndexes:&i];
	myImageView *myIV = (myImageView *)[scrollView viewWithTag:(i + 100)];
	NSLog(@"startIconDownload index ---------  @%lu",(unsigned long)i);
	[myIV startSpinner];
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
	myImageView *myIV = (myImageView *)[scrollView viewWithTag:(index + 100)];
	NSLog(@"appImageDidLoad index ---------  @%d",index);
	[myIV stopSpinner];
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width>2.0){
			NSUInteger index;
			[indexPath getIndexes:&index];
			myImageView *myIV = (myImageView *)[scrollView viewWithTag:(index+100)];
			NSString *photoname = [callSystemApp getCurrentTime];
			UIImage *photo = [iconDownloader.cardIcon fillSize:myIV.frame.size];
			if([FileManager savePhoto:photoname withImage:photo])
			{
				NSLog(@"ar scrollpic %d  index %d",[ar_scrollPic count],[indexPath indexAtPosition:0]);
				NSArray *one = [ar_scrollPic objectAtIndex:[indexPath indexAtPosition:0]]; 
				NSLog(@"one %lu ",(unsigned long)[one count]);
				NSNumber *value = [one objectAtIndex:product_id];
				NSLog(@"productid %d  productpicname %d",product_id,product_pic_name);
				[FileManager removeFile:[one objectAtIndex:product_pic_name]];
				[DBOperate updateData:T_PRODUCT_PRETTY_PIC tableColumn:@"pic_name" columnValue:photoname conditionColumn:@"id" conditionColumnValue:value];
			}
			
			
			NSLog(@"index...................... %lu",(unsigned long)index);
			NSLog(@".........cardicon %@,,,photoname %@",iconDownloader.cardIcon,photoname);
			//[picArray objectAtIndex:index];
			
			myIV.image = photo;
		}
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			NSUInteger i;
			[one.indexPath getIndexes: & i];
			myImageView *myIV = (myImageView *)[scrollView viewWithTag:(i + 100)];
			[myIV stopSpinner];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.left = nil;
	self.right = nil;
	for (UIView *innerview in [self.sc subviews]){
		[innerview removeFromSuperview];
	}
	self.sc = nil;
	self.bar = nil;
	self.picArray = nil;
	for (UIView *innerview in [self.scrollView subviews]){
		[innerview removeFromSuperview];
	}
	self.scrollView = nil;
	self.pageControl = nil;
	self.detailPicArray = nil;
	self.productDic = nil;
	self.ar_secondCategory = nil;
	self.ar_scrollPic = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.lastChooseBto = nil;
	self.scribeLabel = nil;
	self.placeholdPic = nil;
}
- (void)dealloc {
	//NSLog(@"seconde release .....");
	
	[self.left release];
	[self.right release];
	for (UIView *innerview in [self.sc subviews]){
		[innerview removeFromSuperview];
	}
	[self.sc release];
	//[self.bar release];
	[self.picArray release];
	for (UIView *innerview in [self.scrollView subviews]){
		[innerview removeFromSuperview];
	}
	[self.scrollView release];
	[self.pageControl release];
	[self.detailPicArray release];
	[self.productDic release];
	[self.ar_secondCategory release];
	[self.ar_scrollPic release];
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	[self.imageDownloadsInProgress release];
	[self.imageDownloadsInWaiting release];
	[self.lastChooseBto release];
	[scribeLabel release];
	[self.placeholdPic release];
    [super dealloc];
}
@end
