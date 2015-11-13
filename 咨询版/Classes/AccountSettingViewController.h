//
//  AccountSettingViewController.h
//  szeca
//
//  Created by MC374 on 12-4-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconDownLoader;

@interface AccountSettingViewController : UIViewController {
	NSMutableArray *weiboAccountArray;
	IconDownLoader *iconDownLoad;
	UITableView *myTableView;
}

@property(nonatomic,retain) NSMutableArray *weiboAccountArray;
@property(nonatomic,retain) IconDownLoader *iconDownLoad;
@property(nonatomic,retain) IBOutlet UITableView *myTableView;

-(void)loadHeadImage;

@end
