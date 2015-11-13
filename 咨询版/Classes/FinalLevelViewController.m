//
//  FinalLevelViewController.m
//  jvrenye
//
//  Created by MC374 on 11-11-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FinalLevelViewController.h"
#import "myImageView.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "OriginPicViewController.h"
#import "callSystemApp.h"
#import "Common.h"
#import "imageDownLoadInWaitingObject.h"

@implementation FinalLevelViewController

@synthesize scribeLabel;
@synthesize picArray;
@synthesize pageControl;
@synthesize scrollView;
@synthesize placeholdPic;
@synthesize ar_finalCategory;
@synthesize choosePid;
@synthesize ar_scrollPic;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
}

- (void) viewDidLoad{
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BG_IMAGE]];

	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"图片占位" ofType:@"png"]];
	self.ar_finalCategory = [DBOperate queryData:T_CATEGORY_PRETTY_PIC theColumn:@"pid" theColumnValue:[NSNumber numberWithInt:choosePid]  withAll:NO];
	if ([self.ar_finalCategory count]==0) {
		self.ar_finalCategory = [DBOperate queryData:T_CATEGORY_PRETTY_PIC theColumn:@"id" theColumnValue:[NSNumber numberWithInt:choosePid]  withAll:NO];
	}
	self.placeholdPic = img;
	[img release];
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	NSMutableArray* titleArray = [[NSMutableArray alloc]init];
	for (NSArray *one in ar_finalCategory){
		[titleArray addObject:[one objectAtIndex:category_name]];
	}
	if([ar_finalCategory count] > 0)
	{
		self.title = [titleArray objectAtIndex:0];
		NSArray *first = [ar_finalCategory objectAtIndex:0];
		[self showPageOne:[[first objectAtIndex:category_id]intValue] withCoverId:[[first objectAtIndex:category_product_id]intValue]];
	}
	[titleArray release];
	[super viewDidLoad];
}

- (void) viewDidUnLoad{
    [super viewDidUnload];
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.ar_scrollPic = nil;
	self.ar_finalCategory = nil;
	self.picArray = nil;
	self.pageControl = nil;
	self.scrollView = nil;
	self.placeholdPic = nil;
	self.scribeLabel = nil;
}

- (void) dealloc{
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	[ar_scrollPic release];
	self.ar_finalCategory = nil;
	[picArray release];
	[pageControl release];
	//[scrollView release];
	[placeholdPic release];
	[scribeLabel release];
	[super dealloc];
}

- (void) showLabel{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.50f,8.0f,self.view.frame.size.width - 20.0f,25.0f)];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:12];
	label.textColor = [UIColor blackColor];
	
	NSArray *getdescb;
	if([ar_scrollPic count] > 0){
		getdescb= [ar_scrollPic objectAtIndex:0];	
		label.text = [getdescb objectAtIndex:product_name];
		self.scribeLabel = label;
		[self.view addSubview:label];
	}
	[label release];
}

- (void) showScrollView{
	
}

- (void) showPageOne:(int)secondCategoryId withCoverId:(int)coverId{
	
	NSMutableArray *ar_sptmp = [[NSMutableArray alloc]init];
	self.ar_scrollPic = ar_sptmp;
	[ar_sptmp release];
	NSArray *productcarray = [DBOperate queryData:T_PRODUCT_PRETTY_PIC theColumn:@"id" theColumnValue:[NSNumber numberWithInt:coverId] withAll:NO];
	if ([productcarray count]>0) {
		[self.ar_scrollPic addObject:[productcarray objectAtIndex:0]];
	}
	[self.ar_scrollPic addObjectsFromArray:[DBOperate queryData:
											T_PRODUCT_PRETTY_PIC theColumn:@"id" noEqualValue:[NSNumber numberWithInt:coverId] 
													  theColumn:@"catid" equalValue:[NSNumber numberWithInt:secondCategoryId]]]; 
	[self showLabel];
	int picCount = [ar_scrollPic count];
    NSLog(@"picCount====%d",picCount);
	if (picCount <=0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
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
        pageNum = (picCount - 6) / 9 + 1;
        if(((picCount - 6) % 9) > 0)
            pageNum++;
    }else {
        pageNum = (picCount - 9) / 12 + 1;
        if(((picCount - 9) % 12) > 0)
            pageNum++;
    }
	 
	//添加pagecontrol控件
    UIPageControl *pageControltmp= [[UIPageControl alloc] initWithFrame:CGRectMake(120, [UIScreen mainScreen].bounds.size.height - 20 - 44 - 25, 80, 5)];
	self.pageControl = pageControltmp;
	[pageControltmp release];
	pageControl.backgroundColor = [UIColor clearColor];
	pageControl.numberOfPages = pageNum;
	pageControl.currentPage = 0;
	[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:pageControl];

	//添加scrollView控件
	float swidth = self.view.frame.size.width - 20;
	float sheight = [UIScreen mainScreen].bounds.size.height - 20 - 44 - 30;
	scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, sheight)] autorelease];
	scrollView.contentSize = CGSizeMake(pageNum * 320.0f + 1.0f, scrollView.frame.size.height);
	scrollView.pagingEnabled = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.delegate = self;
	[self.view addSubview:scrollView];
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        if (picCount > 6) {
            picCount = 6;
        }
    }else {
        if (picCount > 9) {
            picCount = 9;
        }
    }
	
	float leftMargin = 12.50f;
	float picMargin = 5.0f;
	float perPicWidth = 95.0f;
	float perPicHeight = 95.0f;
	
	//初始化第一页
	for (int i= 0;i < picCount;i++){
		if (i == 0) {
			myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(leftMargin,0.0f,perPicWidth*2+picMargin,perPicHeight*2+picMargin) withImageId: i];
			//iv.backgroundColor = [UIColor grayColor];
			iv.image = [placeholdPic fillSize:iv.frame.size];
			//iv.image = self.placeholdPic;
			iv.tag = 100;
			iv.mydelegate = self;
			[scrollView addSubview:iv];
			[iv release];
			
		}
		else if(i == 1 || i == 2){
			myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(leftMargin+perPicWidth*2+picMargin*2,perPicHeight*(i-1)+picMargin*(i-1),perPicWidth,perPicHeight) withImageId:i];
            //iv.backgroundColor = [UIColor grayColor];
			iv.image = [placeholdPic fillSize:iv.frame.size];
			//iv.image = self.placeholdPic;
			iv.tag = 100+i;
			iv.mydelegate = self;
			[scrollView addSubview:iv];
			[iv release];
			
		}
		else if (i == 3 || i == 4 || i == 5) {
			myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(leftMargin+perPicWidth*(i-3)+picMargin*(i-3),perPicHeight*2+picMargin*2,perPicWidth,perPicHeight) withImageId:i];
            //iv.backgroundColor = [UIColor grayColor];
			iv.image = [placeholdPic fillSize:iv.frame.size];
			//iv.image = self.placeholdPic;
			iv.tag = 100+i;
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
	//如果图片数量多余6张，同时加载第二页
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        if([ar_scrollPic count] > 6){
            [self showOtherPage];
        }
    }else {
        if([ar_scrollPic count] > 9){
            [self showOtherPage];
        }
    }
	
	//加载图片
	for (int i=0;i<[ar_scrollPic count]; i++) {
		NSArray *cc = [ar_scrollPic objectAtIndex:i];
		
		if (((NSString*)[cc objectAtIndex:product_pic_name]).length > 1) {
			myImageView *myIV = (myImageView *)[scrollView viewWithTag:(i+100)];
			UIImage *photo = [FileManager getPhoto:[cc objectAtIndex:product_pic_name]];
			if (photo.size.width>2) {
				myIV.image = [photo fillSize:myIV.frame.size];
			}
			else {
				NSLog(@"iii %d ",i);
				[self startIconDownload: [cc objectAtIndex:product_pic_url] forIndex:[NSIndexPath indexPathWithIndex:i]];
			}
		}
		else {
			NSLog(@"iiiii %d    %@",i,[cc objectAtIndex:product_pic_url]);
			[self startIconDownload: [cc objectAtIndex:product_pic_url] forIndex:[NSIndexPath indexPathWithIndex:i]];
			
		}
	}
}

- (void) showOtherPage{
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
	NSMutableArray *productArray = [DBOperate queryData:T_PIC theColumn:@"pid" theColumnValue:productID withAll:NO];
	
	NSLog(@"productArray %@ %d",productArray,[productArray count]);
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

- (void) pageTurn: (UIPageControl *) aPageControl{
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	scrollView.contentOffset = CGPointMake(320.0f * whichPage, 0.0f);
	[UIView commitAnimations];
	
}

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	CGPoint offset = aScrollView.contentOffset;
	pageControl.currentPage = offset.x / 320.0f;
}

- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
	NSUInteger i;
	[index getIndexes:&i];
	myImageView *myIV = (myImageView *)[scrollView viewWithTag:(i + 100)];
	[myIV startSpinner];
	NSLog(@"startIconDownload index ---------  @%lu",(unsigned long)i);
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
	NSLog(@"appImageDidLoad index ---------  @%lu",(unsigned long)index);
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
@end
