//
//  CommentListViewController.m
//  szeca
//
//  Created by MC374 on 12-4-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentListViewController.h"
#import "Common.h"
#import "CommandOperation.h"
#import "LoginViewController.h"
#import "AccountSettingViewController.h"
#import "myImageView.h"
#import "MBProgressHUD.h"
#import "DBOperate.h"
#import "PublishCommentViewController.h"
#import "FileManager.h"
#import "imageDownLoadInWaitingObject.h"
#import "IconDownLoader.h"
#import "ReplyCommentViewController.h"
#import "alertView.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 250.0f
#define CELL_CONTENT_MARGIN 6.0f
#define HEAD_IMAGE_WIDTH 50.0f
#define USER_NAME_HEIGHT 25.0f

@implementation CommentListViewController

@synthesize totalCount;
@synthesize likeCount;
@synthesize zhongliCount;
@synthesize hateCount;
@synthesize myTableView;
@synthesize _reloading;
@synthesize isRefresh;
@synthesize isFromNet;
@synthesize commentItems;
@synthesize productID;
@synthesize progressHUD;
@synthesize commandOper;
@synthesize commentID;
@synthesize ver;
@synthesize commentVoteData;
@synthesize productUrl;
@synthesize moduleTitle;
@synthesize imageDic;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize	photoWith;
@synthesize	photoHigh;
@synthesize moreCommentItems;
@synthesize preCommentTotalCount;
@synthesize operateType;
@synthesize spinner;
@synthesize moduleType;
@synthesize versionType;

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
	commentID = 0;
	isRefresh = NO;
	isFromNet = NO;
	UIBarButtonItem * commentButton= [[UIBarButtonItem alloc]
									   initWithTitle:@"评论"
									   style:UIBarButtonItemStyleBordered
									   target:self
									   action:@selector(handleComment:)];
    //评论按钮
	self.navigationItem.rightBarButtonItem = commentButton;
	[commentButton release];
	
	 NSMutableArray *array = [[NSMutableArray alloc] init];
	self.commentItems = array;
	[array release];
	
	//设置返回本类按钮
	UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init]; 
	tempButtonItem.title = @"返回";
	self.navigationItem.backBarButtonItem = tempButtonItem ; 
	[tempButtonItem release];
	
	self.title = [NSString stringWithFormat:@"%@",moduleTitle];
	operateType = 0;
	
	NSMutableArray *moreArray = [[NSMutableArray alloc] init];
	self.moreCommentItems = moreArray;
	[moreArray release];
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
	
	//初始化table列表的高度 否则没有数据为空的时候 列表无法拉动
	[myTableView setFrame:CGRectMake(0.0f,50.0f, myTableView.frame.size.width, myTableView.frame.size.height)];

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
	
	//从数据库中获取投票数据
	NSMutableArray *commentVote = [DBOperate queryData:T_COMMENT_VOTE theColumn:@"module_type_id" equalValue1:[NSNumber numberWithInt:moduleType] theColumn:@"module_id" equalValue:productID];
	if (commentVote != nil && [commentVote count] > 0) {
		
		self.commentVoteData = [commentVote objectAtIndex:0];
		
		int pid = [[commentVoteData objectAtIndex:comment_vote_module_id] intValue];
		int like = [[commentVoteData objectAtIndex:comment_vote_like] intValue];
		int netural = [[commentVoteData objectAtIndex:comment_vote_netural] intValue];
		int deslike = [[commentVoteData objectAtIndex:comment_vote_deslike] intValue];
		
		likeCount.text = [NSString stringWithFormat:@"%d",like];
		zhongliCount.text = [NSString stringWithFormat:@"%d",netural];
		hateCount.text = [NSString stringWithFormat:@"%d",deslike ];
		totalCount.text = [NSString stringWithFormat:@"评论(%d)",deslike + like + netural];
	}
	
	//从数据库中获取评论数据
	self.commentItems = [DBOperate queryData:T_COMMENT_LIST theColumn:@"module_type_id" equalValue1:[NSNumber numberWithInt:moduleType] theColumn:@"module_id" equalValue:productID];
	
	if (commentItems != nil && [commentItems count] > 0)
	{
		if (self.progressHUD) {
			[self.progressHUD removeFromSuperview];
			self.progressHUD = nil;
		}
		
		//获取最大的评论id
		NSArray *commentArray = [commentItems objectAtIndex:0];
		if (commentArray != nil && [commentArray count] > 0) {
			commentID = [[commentArray objectAtIndex:comment_list_id] intValue];
		}
		//获取版本号
		NSArray *ar_version = [DBOperate queryData:T_COMMENT_VERSION theColumn:@"module_type_id" equalValue1:[NSNumber numberWithInt:moduleType] theColumn:@"module_id" equalValue:productID];
		
		if ([ar_version count]>0) 
		{
			NSArray *one_version = [ar_version objectAtIndex:0];
			ver =  [[one_version objectAtIndex:comment_version_ver] intValue];
		}
		else
		{
			ver = 0;
		}
		
		[self.myTableView reloadData];
	}
	else 
	{
		//不存在数据则从服务端获取
		commentID = 0;
		ver = 0;
		[self accessService];
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//是否下拉更新
	if (isRefresh) {
		[self performSelector:@selector(ViewFrashData) withObject:nil afterDelay:NO];
		isRefresh = NO;
	}
	
}

-(void)update{
	
	//标识已从网络获取
	self.isFromNet = YES;
	
	self.commentItems = [DBOperate queryData:T_COMMENT_LIST theColumn:@"module_type_id" equalValue1:[NSNumber numberWithInt:moduleType] theColumn:@"module_id" equalValue:productID];
	
	//获取最大的评论id
	if (commentItems != nil && [commentItems count] > 0) 
	{
		NSArray *commentArray = [commentItems objectAtIndex:0];
		if (commentArray != nil && [commentArray count] > 0) {
			commentID = [[commentArray objectAtIndex:comment_list_id] intValue];
		}
	}
	else
	{
		commentID = 0;
	}
	
	NSMutableArray *commentVote = [DBOperate queryData:T_COMMENT_VOTE theColumn:@"module_type_id" equalValue1:[NSNumber numberWithInt:moduleType] theColumn:@"module_id" equalValue:productID];
	
	if (commentVote != nil && [commentVote count] > 0) {
		
		self.commentVoteData = [commentVote objectAtIndex:0];
		
		int pid = [[commentVoteData objectAtIndex:comment_vote_module_id] intValue];
		int like = [[commentVoteData objectAtIndex:comment_vote_like] intValue];
		int netural = [[commentVoteData objectAtIndex:comment_vote_netural] intValue];
		int deslike = [[commentVoteData objectAtIndex:comment_vote_deslike] intValue];
		
		likeCount.text = [NSString stringWithFormat:@"%d",like];
		zhongliCount.text = [NSString stringWithFormat:@"%d",netural];
		hateCount.text = [NSString stringWithFormat:@"%d",deslike ];
		totalCount.text = [NSString stringWithFormat:@"评论(%d)",deslike + like + netural];
		
	}
	
	[self.myTableView reloadData];
	
	//移除loading图标
	[self removeprogressHUD];
	
	//下拉缩回
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:NO];
}

-(void)accessService{

	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithInt: ver],@"ver",[NSNumber numberWithInt: site_id],@"site_id",
								 [NSNumber numberWithInt: moduleType],@"module_type_id", productID,@"module_id",
								 [NSNumber numberWithInt: commentID],@"comment_id",[NSNumber numberWithInt: 0],@"lng",
								 [NSNumber numberWithInt: 0],@"lat",nil];	
	NSLog(@"ver:%d",ver);
	NSLog(@"commentID:%d",commentID);
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/comment/list.do?param=%@"]];
	NSLog(@"reqstr,,,,,,,,,,,, %@",reqStr);
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:COMMENTLIST delegate:self params:jsontestDic];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
}


-(void)accessMoreService{
	int commentLastId;
	if (commentItems != nil && [commentItems count] > 0) {
		int commentCount = [commentItems count];
		NSArray *commentArray = [commentItems objectAtIndex:commentCount - 1];
		if (commentArray != nil && [commentArray count] > 0) {
			commentLastId = [[commentArray objectAtIndex:comment_list_id] intValue];
		}
	}
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: -1],@"ver",
								 [NSNumber numberWithInt: site_id],@"site_id",[NSNumber numberWithInt: moduleType],
								 @"module_type_id", productID,@"module_id",[NSNumber numberWithInt: commentLastId],
								 @"comment_id",[NSNumber numberWithInt: 0],@"lng",[NSNumber numberWithInt: 0],@"lat",nil];	
	NSString *reqStr = [Common TransformJson:jsontestDic withLinkStr:[ACCESS_SERVICE_LINK stringByAppendingString:@"/comment/list.do?param=%@"]];
	NSLog(@"reqstr,,,,,,,,,,,, %@",reqStr);
	CommandOperation *commandOpertmp = [[CommandOperation alloc]initWithReqStr:reqStr command:COMMENTLIST_MORE delegate:self params:jsontestDic];
	self.commandOper = commandOpertmp;
	[commandOpertmp release];
	[networkQueue addOperation:commandOper];
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
	
	self.totalCount = nil;
	self.likeCount = nil;
	self.hateCount = nil;
	self.myTableView.delegate = nil;
	self.myTableView = nil;
	self.commentItems = nil;
	self.progressHUD.delegate = nil;
	self.progressHUD = nil;
	self.productID = nil;
	self.commentVoteData = nil;
	self.productUrl = nil;
	self.moduleTitle = nil;
	self.imageDic = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.commandOper.delegate = nil;
	self.commandOper = nil;
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.moreCommentItems = nil;
	self.spinner = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.totalCount = nil;
	self.likeCount = nil;
	self.hateCount = nil;
	self.myTableView.delegate = nil;
	self.myTableView = nil;
	self.commentItems = nil;
	self.progressHUD.delegate = nil;
	self.progressHUD = nil;
	self.productID = nil;
	self.commentVoteData = nil;
	self.productUrl = nil;
	self.moduleTitle = nil;
	self.imageDic = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.commandOper.delegate = nil;
	self.commandOper = nil;
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.moreCommentItems = nil;
	self.spinner = nil;
    [super dealloc];
}

-(void) handleComment:(id)sender
{
	NSMutableArray * array = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"" theColumnValue:@"" withAll:YES];
	
	if(array != nil && [array count] > 0){	
		
		//状态
		NSArray *userInfoArray = [array objectAtIndex:0];
		int user_status = [[userInfoArray objectAtIndex:weibo_status] intValue];
		NSString *weiboType = [userInfoArray objectAtIndex:weibo_type];
		
		if (user_status == 1) {
			PublishCommentViewController *publish = [[PublishCommentViewController alloc] init];
			publish.moduleTypeId = moduleType;
			publish.moduleId = productID;
			publish.productDescUrl = productUrl;
			publish.moduleTitle = self.moduleTitle;
			publish.weiboType = weiboType;
			[self.navigationController pushViewController:publish animated:YES];
			[publish release];
		}else {
			[alertView showAlert:@"您绑定的账号已被屏蔽！"];
		}
		
	}else{
		LoginViewController *login = [[LoginViewController alloc] init];
		login.delegate = self;
		[self.navigationController pushViewController:login animated:YES];
		[login release];		
	}
}

-(void)removeprogressHUD{
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}
}



#pragma mark -
#pragma mark LoginViewController delegate

-(void)loginSuccess:(NSString*)withLoginType{
	[self handleComment:nil];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (commentItems != nil && [commentItems count] > 0) {
		return [commentItems count] + 1;
	}else {
		return 1;
	}

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (commentItems != nil && [commentItems count] > 0)
	{
		if ([indexPath row] == [commentItems count]) {
			return 50.0f;
		}else {
			NSArray *commentArray = [commentItems objectAtIndex:[indexPath row]];
			NSString *text = [commentArray objectAtIndex:comment_list_content];		
			CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);		
			CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];		
			CGFloat height = MAX(size.height + USER_NAME_HEIGHT * 2, 60.0f);
			return height + (CELL_CONTENT_MARGIN * 2);
		}
	}
	else 
	{
		return 50.0f;
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
    
	if (commentItems != nil && [commentItems count] > 0)
	{
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
			myTableView.separatorColor = [UIColor grayColor];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			if([indexPath row] == [commentItems count]){		
				UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, 30)];
				moreLabel.text = @"查看更多";			
				moreLabel.tag = 1050;
				moreLabel.textAlignment = UITextAlignmentCenter;
				moreLabel.backgroundColor = [UIColor clearColor];
				[cell.contentView addSubview:moreLabel];
				[moreLabel release];
			}else{
				NSArray *commentArray = [commentItems objectAtIndex:[indexPath row]];
				//add headimage
				myImageView *headImageView = nil;
				UIImage *headImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"微博默认头像" ofType:@"png"]];
				headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
				headImageView.tag = 1000;
				headImageView.image = headImage;
				[headImage release];
				[cell.contentView addSubview:headImageView];
				[headImageView release];
				
				//add attitude ImageView
				myImageView *attitudeImageView = nil;
				UIImage *attitudeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"喜欢" ofType:@"png"]];
				attitudeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 42, 24, 24)];
				attitudeImageView.tag = 1002;
				attitudeImageView.image = attitudeImage;
				[attitudeImage release];
				[cell.contentView addSubview:attitudeImageView];
				[attitudeImageView release];
				
				//add name label
				UILabel *nameLabel = nil;
				nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - CELL_CONTENT_WIDTH + CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN,  CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) , USER_NAME_HEIGHT )];
				nameLabel.tag = 1003;
				[nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
				nameLabel.text = @"...";
				nameLabel.textColor = [UIColor colorWithRed:0.26 green: 0.35 blue: 0.46 alpha:1.0];
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
				
				
				NSString *text = @"...";
				if (commentArray != nil) {
					text = [commentArray objectAtIndex:comment_list_content];
				}
				CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
				CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
				float fixHeight = size.height;
				fixHeight = fixHeight == 0 ? 10.f : fixHeight;
				[contentLabel setText:text];
				[contentLabel setFrame:CGRectMake(self.view.frame.size.width - CELL_CONTENT_WIDTH + CELL_CONTENT_MARGIN,  30.f, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), fixHeight)];
				
				
				//add time Label
				int offset = contentLabel.frame.size.height;//contentLabel.frame.size.height;
				UILabel *timeLabel  = nil;
				timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - CELL_CONTENT_WIDTH + CELL_CONTENT_MARGIN,offset+32, 80 , USER_NAME_HEIGHT )];
				timeLabel.tag = 1005;
				[timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
				timeLabel.text = @"时间";
				timeLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
				timeLabel.backgroundColor = [UIColor clearColor];
				[[cell contentView] addSubview:timeLabel];
				[timeLabel release];
				
				//offset += USER_NAME_HEIGHT;
				//add position
				UILabel *positionLabel = nil;
				positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - CELL_CONTENT_WIDTH + CELL_CONTENT_MARGIN * 2 + 70,offset+32,  100 , USER_NAME_HEIGHT )];
				positionLabel.tag = 1006;
				[positionLabel setFont:[UIFont systemFontOfSize:12.0f]];
				positionLabel.text = @"距离";
				positionLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
				positionLabel.backgroundColor = [UIColor clearColor];
				[[cell contentView] addSubview:positionLabel];
				[positionLabel release];
				
				//add city
				UILabel *cityLabel = nil;
				cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - CELL_CONTENT_WIDTH + CELL_CONTENT_MARGIN * 2 + 125, offset+32,  100 , USER_NAME_HEIGHT )];
				cityLabel.tag = 1007;
				[cityLabel setFont:[UIFont systemFontOfSize:12.0f]];
				cityLabel.text = @"城市";
				cityLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
				cityLabel.backgroundColor = [UIColor clearColor];
				[[cell contentView] addSubview:cityLabel];
				[cityLabel release];
				
				//add reply
				UIImageView *replyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - CELL_CONTENT_WIDTH + CELL_CONTENT_MARGIN * 2 + 170, CELL_CONTENT_MARGIN + offset+25,30, 30)];
				UIImage *replyImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"回复" ofType:@"png"]];
				replyImageView.image = replyImage;
				[replyImage release];
				[cell.contentView addSubview:replyImageView];
				[replyImageView release];
				
				//add replyLabel
				UILabel *replyLabel = nil;
				replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - CELL_CONTENT_WIDTH + CELL_CONTENT_MARGIN * 2 + 205,offset+32,  100 , USER_NAME_HEIGHT )];
				replyLabel.tag = 1008;
				[replyLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
				replyLabel.text = @"...";
				replyLabel.textColor = [UIColor colorWithRed:0.26 green: 0.35 blue: 0.46 alpha:1.0];
				replyLabel.backgroundColor = [UIColor clearColor];
				[[cell contentView] addSubview:replyLabel];
				[replyLabel release];
				
				[[cell contentView] addSubview:contentLabel];
			}
		}
		if ([indexPath row] == [commentItems count]){
			
		}else{
			
			NSArray *commentArray = [commentItems objectAtIndex:[indexPath row]];
			UIImageView *headImageView = [cell.contentView viewWithTag:1000];
			
			NSString *picName = [Common encodeBase64:[[commentArray objectAtIndex:comment_list_profile_image] dataUsingEncoding: NSUTF8StringEncoding]];
			
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
			
	//		NSArray *commentArray = [commentItems objectAtIndex:[indexPath row]];
			UILabel *nameLabel = [cell.contentView viewWithTag:1003];
			if(nameLabel != nil){
				nameLabel.text = [commentArray objectAtIndex:comment_list_weibo_username];
			}
			int attitude = [[commentArray objectAtIndex:comment_list_like] intValue];
			if (attitude == 2) {//不喜欢
				UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"反对" ofType:@"png"]];
				UIImageView *attitudeImageView = [cell.contentView viewWithTag:1002];
				if (attitudeImageView != nil) {
					attitudeImageView.image = image;
				}
				[image release];
			}else if (attitude == 0) {//中立
				UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"中立" ofType:@"png"]];
				UIImageView *attitudeImageView = [cell.contentView viewWithTag:1002];
				if (attitudeImageView != nil) {
					attitudeImageView.image = image;
				}
				[image release];
			}else if(attitude == 1) {//喜欢
				UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"喜欢" ofType:@"png"]];
				UIImageView *attitudeImageView = [cell.contentView viewWithTag:1002];
				if (attitudeImageView != nil) {
					attitudeImageView.image = image;
				}
				[image release];
			}
			UILabel *timeLabel = [cell.contentView viewWithTag:1005];
			if (timeLabel != nil) {
				int createTime = [[commentArray objectAtIndex:comment_list_created] intValue];
				NSDate* date = [NSDate dateWithTimeIntervalSince1970:createTime];
				NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
				[outputFormat setDateFormat:@"MM-dd HH:mm"];
				NSString *dateString = [outputFormat stringFromDate:date];
				timeLabel.text = dateString;
				[outputFormat release];
				
			}
			UILabel *positionLabel = [cell.contentView viewWithTag:1006];
			if (positionLabel != nil) {
				double lat1 = [[commentArray objectAtIndex:comment_list_lat] doubleValue];
				double lng1 = [[commentArray objectAtIndex:comment_list_lng] doubleValue];
				double lng2 = myLocation.longitude;
				double lat2 = myLocation.latitude;
				CLLocation* orig=[[[CLLocation alloc] initWithLatitude:lat1 longitude:lng1] autorelease];  
				CLLocation* dist=[[[CLLocation alloc] initWithLatitude:lat2 longitude:lng2] autorelease];  			
				CLLocationDistance kilometers = [orig distanceFromLocation:dist];  
				int distanct = kilometers;
				if (distanct > 1000) {
					positionLabel.text = [NSString stringWithFormat:@"%d千米",distanct/1000];
				}else {
					positionLabel.text = [NSString stringWithFormat:@"%d米",distanct];
				}
			}
			UILabel *cityLabel = [cell.contentView viewWithTag:1007];
			if (cityLabel != nil) {
				cityLabel.text = [commentArray objectAtIndex:comment_list_city_name];
			}
			UILabel *replyLabel = [cell.contentView viewWithTag:1008];
			if (replyLabel != nil) {
				int reply = [[commentArray objectAtIndex:comment_list_reply_counts] intValue];
				NSString *replycount = [NSString stringWithFormat:@"%d", reply];
				replyLabel.text = replycount;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (commentItems != nil && [commentItems count] > 0)
	{
		if ([indexPath row] == [commentItems count]) {//查看更多
		NSLog(@"查看更多");
		operateType = 1;
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
			
			[self accessMoreService];
		}		
	}else{
		
		NSArray *commentArray = [commentItems objectAtIndex:[indexPath row]];	
		
		NSString *picName = [Common encodeBase64:[[commentArray objectAtIndex:comment_list_profile_image] dataUsingEncoding: NSUTF8StringEncoding]];
		
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		UIImageView *headImageView = [cell.contentView viewWithTag:1000];
		UIImageView *attitudeImageView = [cell.contentView viewWithTag:1002];
		UILabel *nameLabel = [cell.contentView viewWithTag:1003];
		UILabel *timeLabel = [cell.contentView viewWithTag:1005];
		UILabel *positionLabel = [cell.contentView viewWithTag:1006];
		UILabel *cityLabel = [cell.contentView viewWithTag:1007];
		NSString *commentContent = [commentArray objectAtIndex:comment_list_content];
		UIImage *cardIcon = [[imageDic objectForKey:picName]fillSize:CGSizeMake(photoWith, photoHigh)];
		UILabel *replyCount = [cell.contentView viewWithTag:1008];
		ReplyCommentViewController *reply = [[ReplyCommentViewController alloc] init];			
		reply.commentText = commentContent;
		reply.commentHeadImage = cardIcon;
		reply.commentAttitudeImage = attitudeImageView.image;
		reply.nameText = nameLabel.text;
		reply.commentID = [[commentArray objectAtIndex:comment_list_id] intValue];
		reply.productDescUrl = productUrl;
		reply.timeString = timeLabel.text;
		reply.positionString = positionLabel.text;
		reply.cityString = cityLabel.text;
		reply.replyCountString = replyCount.text;
		[self.navigationController pushViewController:reply animated:YES];
		[reply release];
	}
	}

}

-(void)loadMore:(NSIndexPath *)indexPath{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSUInteger nCount = [moreCommentItems count];
	preCommentTotalCount = [commentItems count];
	for (NSUInteger i = 0; i < nCount ; i++) {
		[commentItems addObject:[moreCommentItems objectAtIndex:i]];
	}

    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:moreCommentItems waitUntilDone:NO];
	[pool release];
}

-(void)appendTableWith:(NSMutableArray *)array
{
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[moreCommentItems count]];
	for (int i=0; i<[array count]; i++) {
//		NSIndexPath *newPath = [NSIndexPath indexPathForRow:[moreCommentItems indexOfObject:[array objectAtIndex:i]] inSection:0];
		NSIndexPath *newPath = [NSIndexPath indexPathForRow:preCommentTotalCount + i inSection:0];
		[insertIndexPaths addObject:newPath];
		NSLog(@"insertIndexPath:%d",[newPath row]);
	}
	[array removeAllObjects];
	[self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
	
	//loading图标移除
	if (self.spinner != nil) {
		[self.spinner stopAnimating];
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
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	//[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	[self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self loadPhoneNewsData:CMD_GET_PHONE_NEWS_LIST_REQ];
	operateType = 0;
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

- (void)didFinishCommand:(id)resultArray withVersion:(int)ver{
	NSLog(@"verrrr %d",ver);
	if (operateType == 1) {
		if (resultArray != nil) {
			if ([resultArray count] > 0) {
				//[self performSelectorOnMainThread:@selector(appendTableWith:) withObject:resultArray waitUntilDone:NO];
				self.moreCommentItems = (NSMutableArray*)resultArray;
				[self loadMore:nil];
			}else {
				[self performSelectorOnMainThread:@selector(updateLastTableCell) withObject:nil waitUntilDone:NO];
			}
		}	
	}else if (operateType == 0) {
		
		self.ver = ver;
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];

	}
}

-(void)updateLastTableCell{
	
	//loading图标移除
	if (self.spinner != nil) {
		[self.spinner stopAnimating];
	}
	
	int count = [commentItems count];
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
		int countItems = [commentItems count];
		if (countItems >[indexPath row])
		{
			NSArray *commentArray = [commentItems objectAtIndex:[indexPath row]];
			
			NSString *picName = [Common encodeBase64:[[commentArray objectAtIndex:comment_list_profile_image] dataUsingEncoding: NSUTF8StringEncoding]];

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
	
	int countItems = [commentItems count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *one = [commentItems objectAtIndex:[indexPath row]];
		NSString *picName = [Common encodeBase64:[[one objectAtIndex:comment_list_profile_image] dataUsingEncoding: NSUTF8StringEncoding]];
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
	NSArray *one = [commentItems objectAtIndex:[indexPath row]];
	return [one objectAtIndex:comment_list_profile_image];
}

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath{
	//NSLog(@"savePhoto");
	//NSString *photoname = [callSystemApp getCurrentTime];
	int countItems = [commentItems count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *one = [commentItems objectAtIndex:[indexPath row]];
		NSString *picName = [Common encodeBase64:[[one objectAtIndex:comment_list_profile_image] dataUsingEncoding: NSUTF8StringEncoding]];
		if([FileManager savePhoto:picName withImage:photo])
		{
			[imageDic setObject:photo forKey:picName];
			NSLog(@"save success");
			/*
			 NSArray *one = [commentItems objectAtIndex:[indexPath row]]; 
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
