//
//  detailAboutUsViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-9-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface detailAboutUsViewController : UITableViewController {

	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
	bool showAboutUs;
	NSString *logourl;
	NSString *content;
	NSArray *ar_branch;
	float firstHeight;
	float otherHeight;
}
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain)NSString *logourl;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSArray *ar_branch;
@end
