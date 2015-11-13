//
//  ReplyCommentViewController.m
//  szeca
//
//  Created by MC374 on 12-5-8.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ReplyCommentViewController.h"
#import "myImageView.h"
#import "PublishReplyViewController.h"
#import "Common.h"
#import "CommandOperation.h"
#import "FileManager.h"
#import "IconDownLoader.h"
#import "imageDownLoadInWaitingObject.h"
#import "LoginViewController.h"
#import "DBOperate.h"
#import "MBProgressHUD.h"
#import "alertView.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 250.0f
#define CELL_CONTENT_MARGIN 6.0f
#define HEAD_IMAGE_WIDTH 50.0f
#define USER_NAME_HEIGHT 35.0f

@implementation ReplyCommentViewController

@synthesize backImageView;
@synthesize commentHeadImageView;
@synthesize commentAttitudeImageVIew;
@synthesize nameLabel;
@synthesize commentLabel;
@synthesize replyTimeLabel;
@synthesize replyPosition;
@synthesize replyCity;
@synthesize replyCountLabel;
@synthesize replyCountString;
@synthesize myTableView;
@synthesize _reloading;
@synthesize isRefresh;
@synthesize isFromNet;
@synthesize replyItems;
@synthesize commentText;
@synthesize commentHeadImage;
@synthesize commentAttitudeImage;
@synthesize nameText;
@synthesize timeText;
@synthesize positionText;
@synthesize cityText;
@synthesize replyImageView;
@synthesize ver;
@synthesize replyID;
@synthesize commentID;
@synthesize commandOper;
@synthesize imageDic;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize	photoWith;
@synthesize	photoHigh;
@synthesize moreReplyItems;
@synthesize preCommentTotalCount;
@synthesize productDescUrl;
@synthesize operateType;
@synthesize timeString;
@synthesize positionString;
@synthesize cityString;
@synthesize progressHUD;
@synthesize spinner;

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
	
	isRefresh = NO;
	isFromNet = NO;
	
    [super viewDidLoad];
	UIBarButtonItem * commentButton= [[UIBarButtonItem alloc]
									  initWithTitle:@"回复"
									  style:UIBarButtonItemStyleBordered
									  target:self
									  action:@selector(handleReply:)];
	self.navigationItem.rightBarButtonItem = commentButton;
	[commentButton release];
	
	self.title = @"回复";
	
	//设置返回本类按钮
	UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init]; 
	tempButtonItem.title = @"返回";
	self.navigationItem.backBarButtonItem = tempButtonItem ; 
	[tempButtonItem release];
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	self.replyItems = array;
	[array release];
	
	ver = 0;
	replyID = 0;
	if (timeString != nil) {
		self.replyTimeLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
		self.replyTimeLabel.text = timeString;
		//self.commentText = [NSString stringWithFormat:@"%@ ( %@ )",commentText,timeString];
	}
	
	self.replyPosition.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
	self.replyPosition.text = positionString;
	
	self.replyCity.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
	self.replyCity.text = cityString;
	
	self.replyCountLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
	self.replyCountLabel.text = replyCountString;
	
	nameLabel.textColor = [UIColor colorWithRed:0.26 green: 0.35 blue: 0.46 alpha:1.0];
	nameLabel.text = nameText;
	
	commentHeadImageView.image = commentHeadImage;
	commentAttitudeImageVIew.image = commentAttitudeImage;
	
//	[commentLabel setLineBreakMode:UILineBreakModeWordWrap];
//	[commentLabel setMinimumFontSize:FONT_SIZE];
//	[commentLabel setNumberOfLines:0];
//	[commentLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
//	CGSize constraint = CGSizeMake(commentLabel.frame.size.width, 20000.0f);
//	CGSize size = [commentText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//	float fixHeight = size.height;
//	fixHeight = fixHeight == 0 ? 10.f : fixHeight;
//	[commentLabel setText:commentText];
//	[commentLabel setFrame:CGRectMake(commentLabel.frame.origin.x,  commentLabel.frame.origin.y, commentLabel.frame.size.width, fixHeight)];
	
	[commentLabel setMinimumFontSize:FONT_SIZE];
	[commentLabel setNumberOfLines:0];
	[commentLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
	commentLabel.backgroundColor = [UIColor clearColor];
	[commentLabel setText:commentText];
	[commentLabel setFrame:CGRectMake(commentLabel.frame.origin.x,  commentLabel.frame.origin.y, commentLabel.frame.size.width, 40.0f)];
	
	float offset;
	offset = commentLabel.frame.origin.y + 40.0f;
	[replyTimeLabel setFrame:CGRectMake(replyTimeLabel.frame.origin.x, offset+15, replyTimeLabel.frame.size.width, replyTimeLabel.frame.size.height)];
	replyTimeLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	[replyPosition setFrame:CGRectMake(replyPosition.frame.origin.x, offset+15, replyPosition.frame.size.width, replyPosition.frame.size.height)];
	replyPosition.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	[replyCity setFrame:CGRectMake(replyCity.frame.origin.x, offset+15, replyCity.frame.size.width, replyCity.frame.size.height)];
	replyCity.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	[replyImageView setFrame:CGRectMake(replyImageView.frame.origin.x, offset-8, replyImageView.frame.size.width, replyImageView.frame.size.height)];
	
	//绑定点击事件
	replyImageView.userInteractionEnabled = YES;
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleReply:)];
	[replyImageView addGestureRecognizer:singleTap];
	[singleTap release];
	
	[replyCountLabel setFrame:CGRectMake(replyCountLabel.frame.origin.x, offset+6, replyCountLabel.frame.size.width, replyCountLabel.frame.size.height)];
	
	offset = offset + USER_NAME_HEIGHT;
	[backImageView setFrame:CGRectMake(backImageView.frame.origin.x, offset, backImageView.frame.size.width,backImageView.frame.size.height)];
	[myTableView setFrame:CGRectMake(myTableView.frame.origin.x, offset+10, myTableView.frame.size.width, 
									 self.view.frame.size.height - offset - backImageView.frame.size.height + 5)];
	
	photoHigh = 50;
	photoWith = 50;
	NSMutableDictionary *iD = [[NSMutableDictionary alloc]init];
	self.imageDic = iD;
	[iD release];
	
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
        view1.delegate = self;
        [self.myTableView addSubview:view1];
        _refreshHeaderView = view1;
        [view1 release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
	
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"云端同步中...";
	[self.view addSubview:self.progressHUD];
	[self.view bringSubviewToFront:self.progressHUD];
	[self.progressHUD show:YES];
	
	operateType = 0;
	[self accessService];

}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	//是否下拉更新
	if (isRefresh) {
		
		//更新回复数
		int replyCount = [self.replyCountLabel.text intValue] + 1;
		self.replyCountLabel.text = [NSString stringWithFormat:@"%d",replyCount];
		
		//下拉更新
		[self performSelector:@selector(ViewFrashData) withObject:nil afterDelay:NO];
		isRefresh = NO;
	}
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
	self.backImageView = nil;
	self.commentHeadImageView = nil;
	self.commentAttitudeImageVIew = nil;
	self.nameLabel = nil;
	self.commentLabel = nil;
	self.replyTimeLabel = nil;
	self.replyPosition = nil;
	self.replyCity = nil;
	self.replyCountLabel = nil;
	self.replyCountString = nil;
	self.myTableView.delegate = nil;
	self.myTableView = nil;
	self.replyItems = nil;
	self.commentText = nil;
	self.commentHeadImage = nil;
	self.commentAttitudeImage = nil;
	self.nameText = nil;
	self.timeText = nil;
	self.positionText = nil;
	self.cityText = nil;
	self.replyImageView = nil;
	self.imageDic = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.commandOper.delegate = nil;
	self.commandOper = nil;
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.productDescUrl = nil;
	self.progressHUD.delegate = nil;
	self.progressHUD = nil;
	self.spinner = nil;
	[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	self.backImageView = nil;
	self.commentHeadImageView = nil;
	self.commentAttitudeImageVIew = nil;
	self.nameLabel = nil;
	self.commentLabel = nil;
	self.replyTimeLabel = nil;
	self.replyPosition = nil;
	self.replyCity = nil;
	self.replyCountLabel = nil;
	self.replyCountString = nil;
	self.myTableView.delegate = nil;
	self.myTableView = nil;
	self.replyItems = nil;
	self.commentText = nil;
	self.commentHeadImage = nil;
	self.commentAttitudeImage = nil;
	self.nameText = nil;
	self.timeText = nil;
	self.positionText = nil;
	self.cityText = nil;
	self.replyImageView = nil;
	self.imageDic = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.commandOper.delegate = nil;
	self.commandOper = nil;
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.productDescUrl = nil;
	self.progressHUD.delegate = nil;
	self.progressHUD = nil;
	self.spinner = nil;
	[super dealloc];
}

-(void)accessService{

	if (replyItems != nil && [replyItems count] > 0) {
		NSArray *replyArray = [replyItems objectAtIndex:0];
		replyID = [[replyArray objectAtIndex:0] intValue];
	}
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ver],@"ver",
								 [NSNumber numberWithInt: site_id],@"site_id",
								 [NSNumber numberWithInt: commentID],@"comment_id",
								 [NSNumber numberWithInt: replyID],@"reply_id",nil];	
	
	NSLog(@"commentID:%d",commentID);
	NSLog(@"replyID:%d",replyID);
	
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/comment/details.do?param=%@"]];
	NSLog(@"reqstr,,,,,,,,,,,, %@",reqStr);
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:COMMENT_REPLY_LIST delegate:self params:jsontestDic];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}

-(void)accessMoreService{
	NSArray *replyArray = [replyItems objectAtIndex:([replyItems count] - 1)];
	replyID = [[replyArray objectAtIndex:0] intValue];
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-1],@"ver",
								 [NSNumber numberWithInt: site_id],@"site_id",
								 [NSNumber numberWithInt: commentID],@"comment_id",
								 [NSNumber numberWithInt: replyID],@"reply_id",nil];	
	
	NSLog(@"commentID:%d",commentID);
	NSLog(@"replyID:%d",replyID);
	
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/comment/details.do?param=%@"]];
	NSLog(@"reqstr,,,,,,,,,,,, %@",reqStr);
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:COMMENT_REPLY_LIST delegate:self params:jsontestDic];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}

- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	NSLog(@"verrrr... %d",ver);
	
	if (resultArray != nil) {
		if (operateType == 0) {
			self.ver = ver;
			if (self.replyItems == nil) {
				self.replyItems = (NSMutableArray*)resultArray;
			}else {
				NSMutableArray *finalArray = [NSMutableArray arrayWithCapacity:[replyItems count] + [resultArray count]];
				for (int i = 0; i < [resultArray count]; i++) {
					[finalArray addObject:[resultArray objectAtIndex:i]];
				}
				for (int i = 0; i < [replyItems count]; i++) {
					[finalArray addObject:[replyItems objectAtIndex:i]];
				}
				self.replyItems = finalArray;
			}
			[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
		}else if (operateType == 1) {
			if (resultArray != nil && [resultArray count] > 0) {
				self.moreReplyItems = (NSMutableArray*)resultArray;
			}else {
//				self.moreReplyItems = nil;
//				[moreReplyItems release];
//				NSMutableArray* a = [NSMutableArray arrayWithCapacity:0];
//				self.moreReplyItems = a;
//				[a release];
			}

			[self performSelectorOnMainThread:@selector(loadMore:) withObject:nil waitUntilDone:NO];
		}
				
	}else {
		//移除loading图标
		[self performSelectorOnMainThread:@selector(removeprogressHUD) withObject:nil waitUntilDone:NO];
		//下拉缩回
		[self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];
	}
}

-(void)update{
	
	//标识已从网络获取
	self.isFromNet = YES;
	
	//更新列表
	[myTableView reloadData];
	
	//移除loading图标
	[self removeprogressHUD];
	
	//下拉缩回
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:NO];
}

-(void)removeprogressHUD{
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
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
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
	[self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   [self loadImagesForOnscreenRows];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	operateType = 0;
	[self reloadTableViewDataSource];
	[self accessService];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//模拟下拉动作
-(void) ViewFrashData{  
    [myTableView setContentOffset:CGPointMake(0, -70) animated:NO];  
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.0];  
}

//触发更新
-(void)doneManualRefresh{  
    [_refreshHeaderView egoRefreshScrollViewDidScroll:myTableView];  
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:myTableView];  
}

-(void) handleReply:(id)sender
{
	NSMutableArray * array = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"" theColumnValue:@"" withAll:YES];
	if(array != nil && [array count] > 0){
		
		//状态
		NSArray *userInfoArray = [array objectAtIndex:0];
		int user_status = [[userInfoArray objectAtIndex:weibo_status] intValue];
		
		if (user_status == 1) {
			PublishReplyViewController *reply = [[PublishReplyViewController alloc] init];
			reply.productDescUrl = productDescUrl;
			reply.commentID = commentID;
			[self.navigationController pushViewController:reply animated:YES];
			[reply release];
		}else {
			[alertView showAlert:@"您绑定的账号已被屏蔽！"];
		}
		
	}else {
		LoginViewController *login = [[LoginViewController alloc] init];
		login.delegate = self;
		[self.navigationController pushViewController:login animated:YES];
		[login release];	
	}

	
}


#pragma mark -
#pragma mark LoginViewController delegate

-(void)loginSuccess:(NSString*)withLoginType{
	NSMutableArray * array = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"" theColumnValue:@"" withAll:YES];
	if(array != nil && [array count] > 0){
		
		//状态
		NSArray *userInfoArray = [array objectAtIndex:0];
		int user_status = [[userInfoArray objectAtIndex:weibo_status] intValue];
		
		if (user_status == 1) {
			PublishReplyViewController *reply = [[PublishReplyViewController alloc] init];
			reply.productDescUrl = productDescUrl;
			reply.commentID = commentID;
			[self.navigationController pushViewController:reply animated:YES];
			[reply release];
		}else {
			[alertView showAlert:@"您绑定的账号已被屏蔽！"];
		}
		
	}else {
		LoginViewController *login = [[LoginViewController alloc] init];
		login.delegate = self;
		[self.navigationController pushViewController:login animated:YES];
		[login release];	
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (replyItems != nil && [replyItems count] > 0) {
		return [replyItems count] + 1;
	}else {
		return 1;
	}

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (replyItems != nil && [replyItems count] > 0) 
	{
		if ([indexPath row] == [replyItems count]) 
		{
			return 50.0f;
		}
		else
		{
			//NSArray *commentArray = [replyItems objectAtIndex:[indexPath row]];			
			NSArray *replyArray = [replyItems objectAtIndex:[indexPath row]];
			NSString *text = [replyArray objectAtIndex:4];
			CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);		
			CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];		
			CGFloat height = MAX(size.height + USER_NAME_HEIGHT + 10.0f, 60.0f);
			return height + CELL_CONTENT_MARGIN ;
		}
	}
	else
	{
		return 50.0f;
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (replyItems != nil && [replyItems count] > 0) 
	{
		if ([indexPath row] == [replyItems count]) {//查看更多
			NSLog(@"查看更多");
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			if (cell  != nil) {
				UILabel *label = (UILabel*)[cell.contentView viewWithTag:1050];
				label.text = @"读取中...";		
				
				//添加loading图标
				UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
				[tempSpinner setCenter:CGPointMake(cell.frame.size.width / 3, cell.frame.size.height / 2.0)];
				self.spinner = tempSpinner;
				[cell.contentView addSubview:self.spinner];
				[self.spinner startAnimating];
				[tempSpinner release];
				
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
				operateType = 1;
				[self accessMoreService];
			}
		}
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell;
	cell = nil;//[tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
	if (replyItems != nil && [replyItems count] > 0) 
	{
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
			myTableView.separatorColor = [UIColor grayColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if([indexPath row] == [replyItems count]){		
				UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, 30)];
				moreLabel.text = @"查看更多";			
				moreLabel.tag = 1050;
				moreLabel.textAlignment = UITextAlignmentCenter;
				moreLabel.backgroundColor = [UIColor clearColor];
				[cell.contentView addSubview:moreLabel];
				[moreLabel release];
			}else{			//add headimage
				myImageView *headImageView = nil;
				UIImage *headImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"微博默认头像" ofType:@"png"]];
				headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
				headImageView.tag = 1000;
				headImageView.image = headImage;
				[headImage release];
				[cell.contentView addSubview:headImageView];
				[headImageView release];
				
				//add name label
				UILabel *nameLabel = nil;
				nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - CELL_CONTENT_WIDTH + CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN - 3.0f,  120.0f, USER_NAME_HEIGHT )];
				nameLabel.tag = 1003;
				[nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
				nameLabel.textColor = [UIColor colorWithRed:0.26 green: 0.35 blue: 0.46 alpha:1.0];
				nameLabel.text = @"...";
				nameLabel.backgroundColor = [UIColor clearColor];
				[[cell contentView] addSubview:nameLabel];
				[nameLabel release];
				
				//add content label
				UILabel *contentLabel = nil;
				contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
				contentLabel.tag = 1004;
				[contentLabel setLineBreakMode:UILineBreakModeWordWrap];
				[contentLabel setMinimumFontSize:FONT_SIZE];
				[contentLabel setNumberOfLines:0];
				[contentLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
				contentLabel.backgroundColor = [UIColor clearColor];
				
				NSArray *replyArray = [replyItems objectAtIndex:[indexPath row]];
				NSString *text = @"...";
				if (replyArray != nil)
				{
					text = [replyArray objectAtIndex:4];
				}
				CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
				CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
				float fixHeight = size.height;
				fixHeight = fixHeight == 0 ? 10.f : fixHeight;
				[contentLabel setText:text];
				[contentLabel setFrame:CGRectMake(self.view.frame.size.width - CELL_CONTENT_WIDTH + CELL_CONTENT_MARGIN,  USER_NAME_HEIGHT, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), fixHeight)];
				
				[[cell contentView] addSubview:contentLabel];
				
				int offset = contentLabel.frame.size.height;
				//add time Label			
				UILabel *timeLabel  = nil;
				timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - CELL_CONTENT_WIDTH + CELL_CONTENT_MARGIN + 115.0f, CELL_CONTENT_MARGIN - 3.0f,  CELL_CONTENT_WIDTH - 120.0f, USER_NAME_HEIGHT )];
				timeLabel.tag = 1005;
				[timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
				timeLabel.text = @"时间";
				timeLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
				timeLabel.textAlignment = UITextAlignmentCenter;
				timeLabel.backgroundColor = [UIColor clearColor];
				[[cell contentView] addSubview:timeLabel];
				[timeLabel release];
			}
		}
		if ([indexPath row] == [replyItems count]){
			
		}else{
			NSArray *replyArray = [replyItems objectAtIndex:[indexPath row]];
			
			UIImageView *headImageView = [cell.contentView viewWithTag:1000];
			
			NSString *picName = [Common encodeBase64:[[replyArray objectAtIndex:3] dataUsingEncoding: NSUTF8StringEncoding]];
			
			UIImage *cardIcon = [[imageDic objectForKey:picName]fillSize:CGSizeMake(photoWith, photoHigh)];
			if (!cardIcon)
			{
				cardIcon = [[self getPhoto:indexPath]fillSize:CGSizeMake(photoWith, photoHigh)];
				if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
				{
					////////////获取本地图片缓存
					if (cardIcon == nil) {
						NSString *photoURL = [self getPhotoURL:indexPath];
						NSLog(@"no card icon  %@",photoURL);
						[self startIconDownload:photoURL forIndexPath:indexPath];
					}
					else {
						headImageView.image = cardIcon;
						[imageDic setObject:cardIcon forKey:picName];
					}
				}
			}
			else
			{
				headImageView.image = cardIcon;
			}
			
			UILabel *replyNameLabel = [cell.contentView viewWithTag:1003];
			if(replyNameLabel != nil){
				replyNameLabel.text = [replyArray objectAtIndex:2];
			}
			UILabel *replyContentLabel = [cell.contentView viewWithTag:1004];
			if(replyContentLabel != nil){
				replyContentLabel.text = [replyArray objectAtIndex:4];
			}
			UILabel *timeLabel = [cell.contentView viewWithTag:1005];
			if (timeLabel != nil) {
				int createTime =[[replyArray objectAtIndex:9] intValue];
				
				//判断是不是今天
				NSDate* date = [NSDate dateWithTimeIntervalSince1970:createTime];
				NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
				[outputFormat setDateFormat:@"YYYY-MM-dd"];
				NSString *dateString = [outputFormat stringFromDate:date];
				NSString *todayDateString=[outputFormat stringFromDate:[NSDate date]];
				
				[outputFormat setDateFormat:@"MM-dd HH:mm"];
				NSString *dateTimeString = [outputFormat stringFromDate:date];
				NSString *tempTempString = [dateString isEqualToString: todayDateString] ? @"今天" : dateTimeString;
				[outputFormat release];
				
				timeLabel.text = [NSString stringWithFormat:@"%@ %@",tempTempString,[replyArray objectAtIndex:6]];
				
			}
		}
	}
	else 
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
		myTableView.separatorColor = [UIColor grayColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 30)];
		moreLabel.tag = 1011;
		[moreLabel setFont:[UIFont systemFontOfSize:12.0f]];
		moreLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
		moreLabel.text = isFromNet ? @"还没有人说什么哦，赶紧抢先第一个发言吧！" : @"";
		moreLabel.textAlignment = UITextAlignmentCenter;
		moreLabel.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:moreLabel];
		[moreLabel release];
	}
	
    return cell; 
}

//ios7去掉cell的背景色的代理方法
-(void)tableView:(UITableView*)tableView  willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}


-(void)loadMore:(NSIndexPath *)indexPath{
	
	//loading图标移除
	if (self.spinner != nil) {
		[self.spinner stopAnimating];
	}
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow:[replyItems count] inSection:0];
	UITableViewCell *cell = [myTableView cellForRowAtIndexPath:ip];
	if (cell  != nil) {
		UILabel *label = (UILabel*)[cell.contentView viewWithTag:1050];
		label.text = @"查看更多";			
		[myTableView deselectRowAtIndexPath:index animated:YES];
	}

	preCommentTotalCount = [replyItems count];
	
	if (moreReplyItems != nil && [moreReplyItems count] > 0) 
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSUInteger nCount;
		nCount = [moreReplyItems count];
		for (NSUInteger i = 0; i < nCount ; i++) {
			[replyItems addObject:[moreReplyItems objectAtIndex:i]];
		}

		[self performSelectorOnMainThread:@selector(appendTableWith:) withObject:moreReplyItems waitUntilDone:NO];
		[pool release];
	}
	
}

-(void)appendTableWith:(NSMutableArray *)array
{
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[moreReplyItems count]];
	for (int i=0; i<[array count]; i++) {
		//		NSIndexPath *newPath = [NSIndexPath indexPathForRow:[moreReplyItems indexOfObject:[array objectAtIndex:i]] inSection:0];
		NSIndexPath *newPath = [NSIndexPath indexPathForRow:preCommentTotalCount + i inSection:0];
		[insertIndexPaths addObject:newPath];
		NSLog(@"insertIndexPath:%d",[newPath row]);
	}
	[array removeAllObjects];
	[self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}

-(void)updateLastTableCell{
	int count = [replyItems count];
	NSIndexPath *ip = [NSIndexPath indexPathForRow:count inSection:0];
	UITableViewCell *cell = [myTableView cellForRowAtIndexPath:ip];
	if (cell  != nil) {
		UILabel *label = (UILabel*)[cell.contentView viewWithTag:1050];
		label.text = @"查看更多";			
		[myTableView deselectRowAtIndexPath:index animated:YES];
	}
}

- (void)loadImagesForOnscreenRows
{
	NSLog(@"load images for on screen");
	NSArray *visiblePaths = [self.myTableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		int countItems = [replyItems count];
		if (countItems >[indexPath row])
		{
			NSArray *replyArray = [replyItems objectAtIndex:[indexPath row]];
			
			NSString *picName = [Common encodeBase64:[[replyArray objectAtIndex:3] dataUsingEncoding: NSUTF8StringEncoding]];
			
			UIImage *cardIcon = [[imageDic objectForKey:picName]fillSize:CGSizeMake(photoWith, photoHigh)];
			UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
			UIImageView *headImageView = [cell.contentView viewWithTag:1000];
			
			if (!cardIcon)
			{
				////////////获取本地图片缓存
				cardIcon = [[self getPhoto:indexPath]fillSize:CGSizeMake(photoWith, photoHigh)];
				
				if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
				{
					if (cardIcon == nil) {
						NSString *photoURL = [self getPhotoURL:indexPath];
						NSLog(@"no card icon  %@",photoURL);
						[self startIconDownload:photoURL forIndexPath:indexPath];
					}
					else {
						headImageView.image = cardIcon;
						[imageDic setObject:cardIcon forKey:picName];
					}
					
				}
			}
			else
			{
				headImageView.image = cardIcon;
			}
			
		}
		
	}
}

//获取本地缓存的图片
-(UIImage*)getPhoto:(NSIndexPath *)indexPath{
	
	int countItems = [replyItems count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *one = [replyItems objectAtIndex:[indexPath row]];
		NSString *picName = [Common encodeBase64:[[one objectAtIndex:3] dataUsingEncoding: NSUTF8StringEncoding]];
		if (picName.length > 1) {
			return [FileManager getPhoto:picName];
		}
		else {
			return nil;
		}
	}
	else {
		
		return nil;
	}
	
}

//获取图片链接
-(NSString*)getPhotoURL:(NSIndexPath *)indexPath{
	NSArray *one = [replyItems objectAtIndex:[indexPath row]];
	return [one objectAtIndex:3];
}

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath{
	//NSLog(@"savePhoto");
	//NSString *photoname = [callSystemApp getCurrentTime];
	int countItems = [replyItems count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *one = [replyItems objectAtIndex:[indexPath row]];
		NSString *picName = [Common encodeBase64:[[one objectAtIndex:3] dataUsingEncoding: NSUTF8StringEncoding]];
		if([FileManager savePhoto:picName withImage:photo])
		{
			[imageDic setObject:photo forKey:picName];
			NSLog(@"save success");
			/*
			 NSArray *one = [replyItems objectAtIndex:[indexPath row]]; 
			 NSNumber *value = [one objectAtIndex:community_id];
			 [FileManager removeFile:[one objectAtIndex:community_pic_name]];
			 if([DBOperate updateData:T_COMMUNITY tableColumn:@"pic_name" columnValue:photoname conditionColumn:@"id" conditionColumnValue:value])
			 NSLog(@"update data success");
			 */
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

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
		if(iconDownloader.cardIcon.size.width>2.0)
		{ 
			//保存图片
			[self savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
			
			UIImage *photo = [iconDownloader.cardIcon scaleToSize:CGSizeMake(photoWith, photoHigh)];
			UIImageView *headImageView = [cell.contentView viewWithTag:1000];
			headImageView.image = photo;
		}
		
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>1) 
		{
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndexPath:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
}

@end
