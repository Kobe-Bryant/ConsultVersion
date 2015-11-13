//
//  moreViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommandOperation.h"
#import "aboutUsBody.h"

@class UpdateAppAlert;

@interface moreViewController : UITableViewController<MBProgressHUDDelegate> {

	CommandOperation *commandOper;
	MBProgressHUD *progressHUD;
	NSMutableArray *morelist;
	NSMutableArray *branchArray;
	aboutUsBody *abody;
	UpdateAppAlert *updateAlert;
}
@property(nonatomic,retain)NSMutableArray *branchArray;
@property(nonatomic,retain)aboutUsBody *abody;
@property(nonatomic,retain)NSMutableArray *morelist;
@property(nonatomic,retain)CommandOperation *commandOper;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic,retain)UpdateAppAlert *updateAlert;
@end
