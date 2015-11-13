//
//  hotsportViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "LoadImageTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"

@class UpdateAppAlert;

@interface hotspotViewController:LoadImageTableViewController<EGORefreshTableHeaderDelegate,LoadImageTableViewDelegate> {
//@interface hotspotViewController:UITableViewController<EGORefreshTableHeaderDelegate,LoadImageTableViewDelegate> {

	CommandOperation *commandOper;
	NSMutableArray *hotspotlist;
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
	MBProgressHUD *progressHUD;
	UINavigationController *myNavigationController;
	UIScrollView *bannerScrollView;
	UIPageControl *pageControll;
	NSMutableArray *topArray;
	
	UpdateAppAlert *updateAlert;
}
@property(nonatomic,retain)CommandOperation *commandOper;
@property(nonatomic,retain)NSMutableArray *hotspotlist;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic,retain)UINavigationController *myNavigationController;
@property(nonatomic,retain)UIScrollView *bannerScrollView;
@property(nonatomic,retain)UIPageControl *pageControll;
@property(nonatomic,retain)NSMutableArray *topArray;
@property(nonatomic,retain)UpdateAppAlert *updateAlert;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)downloadBannerImage:(NSString*)imageURL forIndex:(NSIndexPath*)index;
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type;
- (void) updateNotifice;
@end
