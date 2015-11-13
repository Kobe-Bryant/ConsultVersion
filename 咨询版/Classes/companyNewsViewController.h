//
//  companyNewsViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-9-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "LoadImageTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"

@interface companyNewsViewController : LoadImageTableViewController<EGORefreshTableHeaderDelegate,LoadImageTableViewDelegate> {
//@interface companyNewsViewController : UITableViewController<EGORefreshTableHeaderDelegate,LoadImageTableViewDelegate> {

	CommandOperation *commandOper;
	NSMutableArray *companyNewsList;
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
	MBProgressHUD *progressHUD;
	UINavigationController *myNavigationController;
}
@property(nonatomic,retain)CommandOperation *commandOper;
@property(nonatomic,retain)NSMutableArray *companyNewsList;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic,retain)UINavigationController *myNavigationController;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
