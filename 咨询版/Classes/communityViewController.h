//
//  communityViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "MBProgressHUD.h"
#import "LoadImageTableViewController.h"
@interface communityViewController : LoadImageTableViewController {

	NSMutableArray *communityList;
	NSMutableArray *myCommunityList;
	CommandOperation *commandOper;
	MBProgressHUD *progressHUD;
}
@property(nonatomic,retain)NSMutableArray *communityList;
@property(nonatomic,retain)CommandOperation *commandOper;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic,retain)NSMutableArray *myCommunityList;
@end
