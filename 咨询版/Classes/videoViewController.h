//
//  videoViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface videoViewController : UITableViewController {

	UINavigationController *myNavigationController;
	NSArray *videoArray;
}
@property(nonatomic,retain)UINavigationController *myNavigationController;
@property(nonatomic,retain)NSArray *videoArray;
@end
