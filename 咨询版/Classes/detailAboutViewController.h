//
//  detailAboutViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-9-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface detailAboutViewController : UIViewController {
	NSString *logourl;
	NSString *content;
	NSArray *ar_branch;
	IBOutlet UIScrollView *showContent;
	IBOutlet UIImageView *iv;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
}
@property(nonatomic,retain)NSString *logourl;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSArray *ar_branch;
@property(nonatomic,retain)NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)NSMutableArray *imageDownloadsInWaiting;
@end
