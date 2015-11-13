//
//  serviceViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "MBProgressHUD.h"

@class manageActionSheet;
@interface serviceViewController : UITableViewController {
	NSMutableArray *serviceList;
	NSMutableArray *myServiceList;
	manageActionSheet *actionsheet;
	CommandOperation *commandOper; 
	NSMutableArray *actionSheetMenu;
	NSIndexPath *indexPathChoosed;
	bool showhotline;
	bool showhotlinemail;
	bool showbusiness;
	bool isShowAddtional;
	MBProgressHUD *progressHUD;
	NSString *telNum;
	NSString *phoneNum;
	NSString *maddress;
	NSString *mailAddr;
	NSString *coord;
	NSMutableArray *ar_showControl;
	NSString *telCallString;
	NSString *mobileCallString;
	NSString *sendMsgString;
	int shortCount;
}
@property(nonatomic,retain)NSMutableArray *ar_showControl;
@property(nonatomic,retain)NSString *phoneNum;
@property(nonatomic,retain)NSString *telNum;
@property(nonatomic,retain)NSString *telCallString;
@property(nonatomic,retain)NSString *mobileCallString;
@property(nonatomic,retain)NSString *sendMsgString;
@property(nonatomic,retain)NSString *maddress;
@property(nonatomic,retain)NSString *coord;
@property(nonatomic,retain)NSString *mailAddr;
@property(nonatomic,retain)NSIndexPath *indexPathChoosed;
@property(nonatomic,retain)NSMutableArray *actionSheetMenu;
@property(nonatomic,retain)NSMutableArray *serviceList;
@property(nonatomic,retain)NSMutableArray *myServiceList;
@property(nonatomic,retain)manageActionSheet *actionsheet;
@property(nonatomic,retain)CommandOperation *commandOper;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic)int shortCount;
@end
