//
//  detailAboutUsViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-9-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "detailAboutUsViewController.h"
#import "DBOperate.h"
#import "callSystemApp.h"
#import "imageDownLoadInWaitingObject.h"
#import "downloadParam.h"
#import "IconDownLoader.h"
#import "Common.h"
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 20.0f

@implementation detailAboutUsViewController
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize logourl;
@synthesize content;
@synthesize ar_branch;
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
	self.title = @"关于我们";
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BG_IMAGE]];
    self.tableView.backgroundView = nil;
    
	NSArray *ar_about = [DBOperate queryData:T_ABOUT theColumn:nil theColumnValue:nil  withAll:YES];
	showAboutUs = NO;
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	if ([ar_about count]>0) {
		showAboutUs = YES;
		NSArray *arr_about = [ar_about objectAtIndex:0];
		self.content = [arr_about objectAtIndex:aboutus_content];
		self.logourl = [arr_about objectAtIndex:aboutus_logo_url];
		CGSize constraint = CGSizeMake(self.view.frame.size.width- (CELL_CONTENT_MARGIN * 2), 20000.0f);
		CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

		
		firstHeight = 50+CELL_CONTENT_MARGIN+size.height+25;
	}
	self.ar_branch = [DBOperate queryData:T_SUBBRANCH theColumn:nil theColumnValue:nil withAll:YES];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	int rows = [ar_branch count];
	if (showAboutUs) {
		rows++;
	}
    return rows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (showAboutUs && [indexPath row]==0) 
	{
		
		return firstHeight;
	}
	else
	{
		NSArray *one;
		if (showAboutUs) {
			one = [ar_branch objectAtIndex:[indexPath row]-1];
		}
		else {
			one = [ar_branch objectAtIndex:[indexPath row]];
		}
		NSString *addrText = [NSString stringWithFormat:@"公司地址： %@",[one objectAtIndex:subbranch_addr]];
		CGSize constraint = CGSizeMake(320.0f - (CELL_CONTENT_MARGIN * 2), 20000.0f);
		CGSize size = [addrText sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		return size.height+140.0f;
	}
}
-(void)handleCall:(id)sender{
	
	UIButton *bto = (UIButton*)sender;
	[callSystemApp makeCall:bto.currentTitle];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (showAboutUs && [indexPath row]==0) {
		static NSString *CellIdentifier = @"Cell";
		
        //ios7新特性,解决分割线短一点
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			UIImageView *logoIV = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-180)/2, 10, 180, 50)];
			logoIV.tag = 100;
			[cell.contentView addSubview:logoIV];
			[logoIV release];
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			[label setLineBreakMode:UILineBreakModeWordWrap];
			[label setMinimumFontSize:FONT_SIZE];
			[label setNumberOfLines:0];
			label.tag = 101;
			[label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
			label.backgroundColor = [UIColor clearColor];
			CGSize constraint = CGSizeMake(cell.contentView.frame.size.width - (CELL_CONTENT_MARGIN * 2), 20000.0f);
			CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
			label.text = content;
			[label setFrame:CGRectMake(CELL_CONTENT_MARGIN, 50+CELL_CONTENT_MARGIN, cell.contentView.frame.size.width - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
			label.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

			[cell.contentView addSubview:label];
			[label release];
			cell.backgroundColor = [UIColor clearColor];
			
			UIImageView *iv = [cell.contentView viewWithTag:100];
			//UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关于我们2" ofType:@"png"]];
			//iv.image = img;
			//[img release];
			[self startIconDownload:logourl forIndex:indexPath];
		}

		return cell;
	}
	else {
		static NSString *CellIdentifierBranch = @"CellBranch";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierBranch];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierBranch] autorelease];
		
			UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, 5, cell.contentView.frame.size.width, 30)];
			name.backgroundColor = [UIColor clearColor];
			name.tag = 200;
			name.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

			[cell.contentView addSubview:name];
			[name release];
			
			UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, 35, 90, 30)];
			phone.backgroundColor = [UIColor clearColor];
			phone.tag = 201;
			phone.text = @"联系电话：";
			phone.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

			[cell.contentView addSubview:phone];
			[phone release];
			
			UIButton *phonebto1 = [UIButton buttonWithType:UIButtonTypeCustom];
			phonebto1.frame = CGRectMake(CELL_CONTENT_MARGIN+90, 35, cell.contentView.frame.size.width-90, 30);
			[phonebto1 addTarget:self action:@selector(handleCall:)
				forControlEvents:UIControlEventTouchUpInside];
			[phonebto1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft]; 
			[phonebto1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
			phonebto1.tag = 202;
			[cell.contentView addSubview:phonebto1];
			
			UIButton *phonebto2 = [UIButton buttonWithType:UIButtonTypeCustom];
			phonebto2.frame = CGRectMake(CELL_CONTENT_MARGIN+90, 65, cell.contentView.frame.size.width-90, 30);
			[phonebto2 addTarget:self action:@selector(handleCall:)
				forControlEvents:UIControlEventTouchUpInside];
			[phonebto2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft]; 
			[phonebto2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
			phonebto2.tag = 203;
			[cell.contentView addSubview:phonebto2];
			
			UILabel *myfax = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, 95, cell.contentView.frame.size.width, 30)];
			myfax.backgroundColor = [UIColor clearColor];
			myfax.tag = 204;
			myfax.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

			[cell.contentView addSubview:myfax];
			[myfax release];

			UILabel *myaddr = [[UILabel alloc]initWithFrame:CGRectZero];
			myaddr.backgroundColor = [UIColor clearColor];
			[myaddr setLineBreakMode:UILineBreakModeWordWrap];
			[myaddr setNumberOfLines:0];
			myaddr.tag = 205;
			myaddr.textColor = [UIColor colorWithRed:FONT_COLOR_RED green:FONT_COLOR_GREEN blue:FONT_COLOR_BLUE alpha:1];

			[cell.contentView addSubview:myaddr];
			[myaddr release];
			cell.backgroundColor = [UIColor clearColor];
		}
		NSArray *one;
		if (showAboutUs) {
			one = [ar_branch objectAtIndex:[indexPath row]-1];
		}
		else {
			one = [ar_branch objectAtIndex:[indexPath row]];
		}

		
		UILabel *name = [cell.contentView viewWithTag:200];
		name.text = [one objectAtIndex:subbranch_name];
		
		UIButton *phonebto1 = [cell.contentView viewWithTag:202];
		[phonebto1 setTitle:[one objectAtIndex:subbranch_tel] forState:UIControlStateNormal];
		UIButton *phonebto2 = [cell.contentView viewWithTag:203];
		[phonebto2 setTitle:[one objectAtIndex:subbranch_mobile] forState:UIControlStateNormal];
		UILabel *myfax = [cell.contentView viewWithTag:204];
		myfax.text = [NSString stringWithFormat:@"传真号码： %@",[one objectAtIndex:subbranch_fax]];//[one objectAtIndex:subbranch_fax]];
		
		UILabel *myaddr = [cell.contentView viewWithTag:205];
		NSString *addrText = [NSString stringWithFormat:@"公司地址： %@",[one objectAtIndex:subbranch_addr]];
		CGSize constraint = CGSizeMake(cell.contentView.frame.size.width - (CELL_CONTENT_MARGIN * 2), 20000.0f);
		CGSize size1 = [addrText sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		[myaddr setText:addrText];
		[myaddr setFrame:CGRectMake(CELL_CONTENT_MARGIN, 125, cell.contentView.frame.size.width-CELL_CONTENT_MARGIN*2, MAX(size1.height, 44.0f))];
		otherHeight = 180;
		return cell;
	}
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
}
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
		  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
	      UIImageView *iv = [cell.contentView viewWithTag:100];
		if(iconDownloader.cardIcon.size.width>2.0){
			
			UIImage *photo = [iconDownloader.cardIcon scaleToSize:iv.frame.size];
			NSUInteger index;
			[indexPath getIndexes:&index];
			NSLog(@"index...................... %lu",(unsigned long)index);
			iv.image = iconDownloader.cardIcon;
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


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.content = nil;
	self.ar_branch = nil;
	self.logourl = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"delegate != nil count %d",[imageDownloadsInProgress count]);
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		NSLog(@"delegate = nil");
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.logourl = nil;
	self.content = nil;
	self.ar_branch = nil;
    [super dealloc];
}


@end

