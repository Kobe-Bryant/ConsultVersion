//
//  detailAboutViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-9-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "detailAboutViewController.h"
#import "DBOperate.h"
#import "callSystemApp.h"
#import "LoadImageTableViewController.h"
#import "downloadParam.h"
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 20.0f

@implementation detailAboutViewController
@synthesize logourl;
@synthesize content;
@synthesize ar_branch;
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
	self.title = @"关于我们";
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	NSArray *ar_about = [DBOperate queryData:T_ABOUT theColumn:nil theColumnValue:nil  withAll:YES];
	NSArray *arr_about = [ar_about objectAtIndex:0];
	self.content = [arr_about objectAtIndex:aboutus_content];
	self.logourl = [arr_about objectAtIndex:aboutus_logo_url];
	[self startIconDownload:logourl forIndex:[NSIndexPath indexPathWithIndex:1]];

	self.ar_branch = [DBOperate queryData:T_SUBBRANCH theColumn:nil theColumnValue:nil withAll:YES];

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	[label setLineBreakMode:UILineBreakModeWordWrap];
	[label setMinimumFontSize:FONT_SIZE];
	[label setNumberOfLines:0];
	[label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	label.backgroundColor = [UIColor clearColor];
	//[label setText:content];
	label.text = content;
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
	[showContent addSubview:label];
	//showContent.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	float yyy = MAX(size.height, 44.0f)+20;
	int i=0;
	for (NSArray *one in ar_branch){
    	UIView *myview = [[UIView alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, i*180+yyy, self.view.frame.size.width-2*CELL_CONTENT_MARGIN, 180)];
		i++;
		UILabel *Boundaries=[[UILabel alloc]initWithFrame:CGRectMake(0, myview.frame.size.height-5, myview.frame.size.width, 5)];
		Boundaries.backgroundColor = [UIColor grayColor];
		[myview addSubview:Boundaries];
		[Boundaries release];
		
		UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, 5, myview.frame.size.width, 30)];
		name.backgroundColor = [UIColor clearColor];
		name.text = [one objectAtIndex:subbranch_name];
		[myview addSubview:name];
		[name release];
		
		UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, 35, 90, 30)];
		phone.backgroundColor = [UIColor clearColor];
		phone.text = @"联系电话：";
		[myview addSubview:phone];
		[phone release];
		
		UIButton *phonebto1 = [UIButton buttonWithType:UIButtonTypeCustom];
		phonebto1.frame = CGRectMake(CELL_CONTENT_MARGIN+90, 35, myview.frame.size.width-90, 30);
		[phonebto1 addTarget:self action:@selector(handleCall:)
		 forControlEvents:UIControlEventTouchUpInside];
		[phonebto1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft]; 
		[phonebto1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		[phonebto1 setTitle:[one objectAtIndex:subbranch_tel] forState:UIControlStateNormal];
		[myview addSubview:phonebto1];
		
		UIButton *phonebto2 = [UIButton buttonWithType:UIButtonTypeCustom];
		phonebto2.frame = CGRectMake(CELL_CONTENT_MARGIN+90, 65, myview.frame.size.width-90, 30);
		[phonebto2 addTarget:self action:@selector(handleCall:)
			forControlEvents:UIControlEventTouchUpInside];
       	[phonebto2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft]; 

		[phonebto2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		[phonebto2 setTitle:[one objectAtIndex:subbranch_mobile] forState:UIControlStateNormal];
		[myview addSubview:phonebto2];
		
		UILabel *myfax = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, 95, myview.frame.size.width, 30)];
		myfax.backgroundColor = [UIColor clearColor];
		myfax.text = [NSString stringWithFormat:@"传真号码： %@",[one objectAtIndex:subbranch_fax]];//[one objectAtIndex:subbranch_fax]];
		[myview addSubview:myfax];
		[myfax release];
		
		UILabel *myaddr = [[UILabel alloc]initWithFrame:CGRectZero];
		myaddr.backgroundColor = [UIColor clearColor];
		NSString *addrText = [NSString stringWithFormat:@"公司地址： %@",[one objectAtIndex:subbranch_addr]];
		[myaddr setLineBreakMode:UILineBreakModeWordWrap];
		[myaddr setNumberOfLines:0];
		CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
		
		CGSize size1 = [addrText sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		
		//label.backgroundColor = [UIColor clearColor];
		[myaddr setText:addrText];
		[myaddr setFrame:CGRectMake(CELL_CONTENT_MARGIN, 125, myview.frame.size.width, MAX(size1.height, 44.0f))];
		//myaddr.text = addrText;//[NSString stringWithFormat:@"公司地址：%@",@"深圳市南山区科技园科苑南路"];//[one objectAtIndex:subbranch_addr]];
		[myview addSubview:myaddr];
		[myaddr release];
		
		[showContent addSubview:myview];
		[myview release];
		
	}
	showContent.contentSize = CGSizeMake(self.view.frame.size.width,i*180+yyy);
	[label release];
	
}
-(void)handleCall:(id)sender{

	UIButton *bto = (UIButton*)sender;
	[callSystemApp makeCall:bto.currentTitle];
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
			
			UIImage *photo = [iconDownloader.cardIcon scaleToSize:iv.frame.size];
			NSUInteger index;
			//iv.frame = CGRectMake(s, 5, <#CGFloat width#>, <#CGFloat height#>)
			[indexPath getIndexes:&index];
			NSLog(@"index...................... %lu",(unsigned long)index);
			//myImageView *myIV = [scrollView viewWithTag:(index+100)];//[picArray objectAtIndex:index];
			//myIV.image = photo;
			iv.image = photo;
		}
		else {
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关于我们2" ofType:@"png"]];
			iv.image = img;
			[img release];
		}

		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.logourl = nil;
	self.content = nil;
	self.ar_branch = nil;
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    [super dealloc];
}


@end
