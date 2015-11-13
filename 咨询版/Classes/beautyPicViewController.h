//
//  beautyPicViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "MBProgressHUD.h"
#import "IconDownLoader.h"

@protocol pushNextViewController

-(void)pushView:(UIViewController*)vc;

@end

@class showPagesImage;
@interface beautyPicViewController : UIViewController <IconDownloaderDelegate,MBProgressHUDDelegate,commandOperationDelegate,UIScrollViewDelegate>{

	NSArray *picArray;
	NSArray *allSecondLevelPic;
	showPagesImage *pagesImage;
	UINavigationController *myNavigationController;
	//id<pushNextViewController> pushdelegate;
	CommandOperation *commandOper;
	MBProgressHUD *progressHUD;
	NSMutableArray *picLinkArray;
	UIPageControl *pageControl;
	UIScrollView *scrollView;
	NSDictionary *serviceDataDic;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
	float picwidth;
	float picheight;
	
}
//@property(nonatomic,assign)id<pushNextViewController> pushdelegate;
@property(nonatomic,retain)NSArray *picArray;
@property(nonatomic,retain)showPagesImage *pagesImage;
@property(nonatomic,retain)UINavigationController *myNavigationController;
@property(nonatomic,retain)NSArray *allSecondLevelPic;
@property(nonatomic,retain)CommandOperation *commandOper;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic,retain)NSMutableArray *picLinkArray;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)NSDictionary *serviceDataDic;
@property(nonatomic,retain)NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)NSMutableArray *imageDownloadsInWaiting;

@end
