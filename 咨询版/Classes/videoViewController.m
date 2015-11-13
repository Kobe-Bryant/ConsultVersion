//
//  videoViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "videoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "secondLevelViewController.h"
#import "videoInfo.h"
#import "Common.h"
#import "VideoObject.h"

@implementation videoViewController
@synthesize myNavigationController;
@synthesize videoArray;
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

	self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
	self.videoArray = videoListArray;
//	videoInfo *one = [[videoInfo alloc]init];
//	one.picName = @"p1.png";
//	one.videoName = @"v1";
//	one.videoDescription = first_video_des;
//	videoInfo *two = [[videoInfo alloc]init];
//	two.picName = @"p2.png";
//	two.videoName = @"v2";
//	two.videoDescription = second_video_des;
//	self.videoArray = [NSArray arrayWithObjects:one,two,nil];
//	[one release];
//	[two release];
	
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
    return [videoArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 7, self.view.frame.size.width-70, 185)];
		UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"视频大背景" ofType:@"png"]];
		backView.image = img;
	    [img release];
		[cell.contentView addSubview:backView];
		[backView release];
		
		UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45, 7, 230,150)];
		imageview.tag = 101;
		[cell.contentView addSubview:imageview];
		[imageview release];
		UIImageView *playBto = [[UIImageView alloc]initWithFrame:CGRectMake(85, 45, 60, 60)];
		UIImage *img1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"播放按钮" ofType:@"png"]];
		playBto.image = img1;
		[img1 release];
		[imageview addSubview:playBto];
		[playBto release];
		UILabel *descript = [[UILabel alloc]initWithFrame:CGRectMake(45, 157, self.view.frame.size.width-90, 30)];
		descript.tag = 102;
		descript.backgroundColor = [UIColor clearColor];
		descript.textAlignment = UITextAlignmentCenter;
		[cell.contentView addSubview:descript];
		[descript release];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
	}
    UIImageView *imageview = [cell.contentView viewWithTag:101];
	UILabel *descript = [cell.contentView viewWithTag:102];
	VideoObject *one = [videoArray objectAtIndex:[indexPath row]];
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:one.pic ofType:nil]];
	imageview.image = [img scaleToSize:imageview.frame.size];
	[img release];
	descript.text = one.desc;
    return cell;
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
	//secondLevelViewController *secondLevel = [[secondLevelViewController alloc]initWithNibName:@"secondLevelViewController" bundle:nil];
	//[self.myNavigationController pushViewController:secondLevel animated:YES];
	//[pagesImage scrollRectToVisible:self.view.frame animated:NO];

	//NSString* s = [[NSBundle mainBundle] pathForResource:@"IMG_0790" ofType:@"MOV"];
	
	VideoObject *one = [videoArray objectAtIndex:[indexPath row]];
	
	NSURL *url;
	
	//播放本地视频
	if([one.isLocal isEqualToString:@"1"])
	{
		NSString *s;
		//判断是播放视频还是音乐
		if ([one.videotype isEqualToString:@"1"]) 
		{
			s = [[NSBundle mainBundle] pathForResource:one.name ofType:@"mp4"];
		}
		else 
		{
			s = [[NSBundle mainBundle] pathForResource:one.name ofType:@"mp3"];
		}
		
		url = [NSURL fileURLWithPath:s];
		
	}
	else 
	{
		//播放远程视频
		NSString* s = one.path;
		//url = [NSURL fileURLWithPath:s];
		url = [NSURL URLWithString:s];
		
	}
	
	[self playVideo:url videoType:one.videotype];
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 200.0f;
}
///////////////play video
- (void) playVideo: (NSURL*)videoURL videoType:(NSString*)type
{
	@try {
        
        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        
        MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc] init];
        theMovie.view.frame = CGRectMake(0, 0, myNavigationController.view.frame.size.height, myNavigationController.view.frame.size.width);
        
        theMovie.view.center = CGPointMake(myNavigationController.view.frame.size.width/2, myNavigationController.view.frame.size.height/2);
        theMovie.moviePlayer.contentURL = videoURL;
        
        //设置横屏
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
        [theMovie.view setTransform:transform];
        [myNavigationController.view addSubview:theMovie.view];
        
        if ([type isEqualToString:@"1"])
        {
            //播放完毕后退出
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(myMovieFinishedCallback:)
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:theMovie.moviePlayer];
        }
        else
        {
            //播放完毕后退出
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(myMovieFinishedCallback:)
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:theMovie.moviePlayer];
            if (IOS_VERSION < 7.0) {
                //按暂停退出
                [[NSNotificationCenter defaultCenter]addObserver:self
                                                        selector:@selector(musicPlayerPressStop:)
                                                            name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                          object:theMovie.moviePlayer];
            }
        }
//		CGFloat height = [UIScreen mainScreen].bounds.size.height;
//		MPMoviePlayerController* theMovie=[[MPMoviePlayerController alloc] initWithContentURL:videoURL];
//		[[theMovie view] setFrame:CGRectMake(myNavigationController.view.bounds.origin.x, myNavigationController.view.bounds.origin.y, height,self.view.bounds.size.width)];
//		//theMovie.movieControlMode = MPMovieControlModeDefault;
//		theMovie.scalingMode = MPMovieScalingModeAspectFit;
//		theMovie.controlStyle = MPMovieControlStyleFullscreen;
//		
//		//隐藏状态栏
//		[[UIApplication sharedApplication] setStatusBarHidden:YES  withAnimation:UIStatusBarAnimationNone];
//		//设置横屏
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
//		
//		[myNavigationController.view addSubview:theMovie.view];
//		
//        CGFloat fixSize = height == 480.0f ? 80.0f : 124.0f;
//		CGAffineTransform landscapeTransform;
//		landscapeTransform = CGAffineTransformMakeRotation(90 * M_PI / 180);
//		landscapeTransform = CGAffineTransformTranslate(landscapeTransform, fixSize, fixSize);
//		[theMovie.view setTransform:landscapeTransform];
//		
//		
//		if ([type isEqualToString:@"1"])
//		{
//			//播放完毕后退出
//			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
//		}
//		else 
//		{
//			//播放完毕后退出
//			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
//			if (IOS_VERSION < 7.0) {
//                //按暂停退出
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerPressStop:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:theMovie];
//            }
//		}
//		
//		[theMovie play];
	}
	@catch (NSException * e) {
		NSLog(@"player video error==>%@",e);
	}
	@finally {
		
	}
	
}

/*-(void)myMovieFinishedExit:(id*)sender{
	UIBarButtonItem *bitem=(UIBarButtonItem*)sender;
	MPMoviePlayerController* theMovie=(MPMoviePlayerController*)bitem.tag;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:theMovie];
	[theMovie.view removeFromSuperview];
	[theMovie stop];
	myNavigationController.navigationItem.rightBarButtonItem = nil;
}*/

-(void)musicPlayerPressStop:(NSNotification*)aNotification
{
//	MPMoviePlayerController* theMovie=[aNotification object];
//	if (theMovie.playbackState == 2) 
//	{
//		[self myMovieFinishedCallback:aNotification];
//	}
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    
    MPMoviePlayerController *player = [aNotification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
    
    [player stop];
    
    [player.view removeFromSuperview];
}

-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
	NSLog(@"finishcallback");
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    
    MPMoviePlayerController *player = [aNotification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    [player stop];
    
    [player.view removeFromSuperview];
	
	//设置正常屏
//	[[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
//	
//    MPMoviePlayerController* theMovie=[aNotification object];
//	
//	CFShow([aNotification userInfo]);
//	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
//	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
//	
//	//设置回默认播放模式 否则会程序多20的高度
//	//theMovie.controlStyle = MPMovieControlStyleDefault;
//	
//    [theMovie.view removeFromSuperview];
//	[theMovie release];
	
}
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.videoArray = nil;
	[super viewDidUnload]; 
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[myNavigationController release];
	[videoArray release];
    [super dealloc];
}


@end

