//
//  CommentListViewController.h
//  szeca
//
//  Created by MC374 on 12-4-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h" 

@class MBProgressHUD;
@class CommandOperation;

@interface CommentListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>{
	EGORefreshTableHeaderView *_refreshHeaderView;
	UILabel *totalCount;
	UILabel *likeCount;
	UILabel *zhongliCount;
	UILabel *hateCount;
	UITableView *myTableView;
	BOOL _reloading;
	BOOL isRefresh;
	BOOL isFromNet;
	NSMutableArray *commentItems;
	NSMutableArray *moreCommentItems;
	NSArray *commentVoteData;
	int cellHeight;
	MBProgressHUD *progressHUD;
	CommandOperation *commandOper;
	NSNumber *productID;
	int commentID;
	int ver;
	NSString *productUrl;
	int moduleType;
	NSString *moduleTitle;
	NSMutableDictionary *imageDic;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;	
	int photoWith;
	int photoHigh;
	int preCommentTotalCount;
	int operateType;  //刷新 0 更多 1
	int versionType;
	UIActivityIndicatorView *spinner;
}
@property(nonatomic,retain) IBOutlet UILabel *totalCount;
@property(nonatomic,retain) IBOutlet UILabel *likeCount;
@property(nonatomic,retain) IBOutlet UILabel *zhongliCount;
@property(nonatomic,retain) IBOutlet UILabel *hateCount;
@property(nonatomic,retain) IBOutlet UITableView *myTableView;
@property(nonatomic) BOOL _reloading;
@property(nonatomic,assign) BOOL isRefresh;
@property(nonatomic,assign) BOOL isFromNet;
@property(nonatomic,retain) NSNumber *productID;
@property(nonatomic) int commentID;
@property(nonatomic) int ver;
@property(nonatomic,retain) NSMutableArray *commentItems;
@property(nonatomic,retain) NSMutableArray *moreCommentItems;
@property(nonatomic,retain) MBProgressHUD *progressHUD;
@property(nonatomic,retain) CommandOperation *commandOper;
@property(nonatomic,retain) NSArray *commentVoteData;
@property(nonatomic,retain) NSString *productUrl;
@property(nonatomic,retain) NSString *moduleTitle;
@property(nonatomic,assign)int photoWith;
@property(nonatomic,assign)int photoHigh;
@property(nonatomic,assign)int preCommentTotalCount;
@property(nonatomic,assign)int operateType;
@property(nonatomic,assign)int moduleType;
@property(nonatomic,assign)int versionType;
@property(nonatomic,retain)NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain)NSMutableDictionary *imageDic;
@property(nonatomic,retain)NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)UIActivityIndicatorView *spinner;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData; 
-(void) handleComment:(id)sender;
-(void)accessService;
-(void)accessMoreService;
-(void)update;
-(void)updateLastTableCell;
-(void)loadMore:(NSIndexPath *)indexPath;
-(void)removeprogressHUD;
@end

