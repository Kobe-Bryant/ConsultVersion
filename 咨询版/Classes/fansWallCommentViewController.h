//
//  fansWallCommentViewController.h
//  szeca
//
//  Created by MC374 on 12-4-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h" 

@class MBProgressHUD;
@class CommandOperation;

@interface fansWallCommentViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>{
	EGORefreshTableHeaderView *_refreshHeaderView;
	UITableView *myTableView;
	BOOL _reloading;
	BOOL isRefresh;
	BOOL isFromNet;
	NSMutableArray *commentItems;
	NSMutableArray *commentRecentlyItems;
	int cellHeight;
	MBProgressHUD *progressHUD;
	CommandOperation *commandOper;
	int commentID;
	NSMutableDictionary *imageDic;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;	
	int photoWith;
	int photoHigh;
	int fansWallSegmentValue;
	int operateType;
	UIActivityIndicatorView *spinner;
}
@property(nonatomic,retain) IBOutlet UITableView *myTableView;
@property(nonatomic,assign) BOOL _reloading;
@property(nonatomic,assign) BOOL isRefresh;
@property(nonatomic,assign) BOOL isFromNet;
@property(nonatomic,assign) int commentID;
@property(nonatomic,retain) NSMutableArray *commentItems;
@property(nonatomic,retain) NSMutableArray *commentRecentlyItems;
@property(nonatomic,retain) MBProgressHUD *progressHUD;
@property(nonatomic,retain) CommandOperation *commandOper;
@property(nonatomic,assign)int photoWith;
@property(nonatomic,assign)int photoHigh;
@property(nonatomic,assign)int fansWallSegmentValue;
@property(nonatomic,assign)int operateType;
@property(nonatomic,retain)NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain)NSMutableDictionary *imageDic;
@property(nonatomic,retain)NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)UIActivityIndicatorView *spinner;
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData; 
-(void)handleComment:(id)sender;
-(void)accessService;
-(void)accessRecentlyService;
-(void)accessMoreService;
-(void)update;
-(void)appendTableWith:(NSMutableArray *)data;
-(void)fansWallSegmentAction:(id)sender;
-(void)removeprogressHUD;
-(void)doEditing;
@end

