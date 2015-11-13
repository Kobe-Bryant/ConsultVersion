//
//  wallPaperViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "MBProgressHUD.h"
@interface wallPaperViewController : UIViewController {

	NSMutableArray *picArray;
	NSMutableArray *piclinkArray;
	UIPageControl *pageControl;
	UIScrollView *scrollView;
	UINavigationController *myNavigationController;
	CommandOperation *commandOper;
	MBProgressHUD *progressHUD;
	UIImage *backgroudPic;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
	float photowith;
	float photoheight;
}
@property(nonatomic,retain)NSMutableArray *picArray;
@property(nonatomic,retain)NSMutableArray *piclinkArray;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)UINavigationController *myNavigationController;
@property(nonatomic,retain)CommandOperation *commandOper;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic,retain)UIImage *backgroudPic;
@property(nonatomic,retain)NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)NSMutableArray *imageDownloadsInWaiting;
@end
