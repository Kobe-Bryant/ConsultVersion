//
//  ReplyCommentViewController.h
//  szeca
//
//  Created by MC374 on 12-5-8.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h" 
@class MBProgressHUD;
@class CommandOperation;
@interface ReplyCommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate> {
	EGORefreshTableHeaderView *_refreshHeaderView;
	UIImageView *backImageView;
	UIImageView *commentHeadImageView;
	UIImageView *commentAttitudeImageVIew;
	UIImageView *replyImageView;
	UILabel *nameLabel;
	UILabel *commentLabel;
	UILabel *replyTimeLabel;
	UILabel *replyPosition;
	UILabel *replyCity;
	UILabel *replyCountLabel;
	NSString *commentText;
	UIImage *commentHeadImage;
	UIImage *commentAttitudeImage;
	NSString *nameText;
	NSString *timeText;
	NSString *positionText;
	NSString *cityText;
	UITableView *myTableView;
	NSMutableArray *replyItems;
	NSMutableArray *moreReplyItems;
	CommandOperation *commandOper;
	BOOL _reloading;
	BOOL isRefresh;
	BOOL isFromNet;
	int ver;
	int replyID;
	int commentID;
	NSMutableDictionary *imageDic;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;	
	int photoWith;
	int photoHigh;
	int preCommentTotalCount;
	NSString *productDescUrl;
	NSString *timeString;
	NSString *positionString;
	NSString *cityString;
	NSString *replyCountString;
	int operateType;  //刷新 0 更多 1
	MBProgressHUD *progressHUD;
	UIActivityIndicatorView *spinner;
}
@property(nonatomic,retain) IBOutlet UITableView *myTableView;
@property(nonatomic,retain) IBOutlet UIImageView *backImageView;
@property(nonatomic,retain) IBOutlet UIImageView *commentHeadImageView;
@property(nonatomic,retain) IBOutlet UIImageView *commentAttitudeImageVIew;
@property(nonatomic,retain) IBOutlet UIImageView *replyImageView;
@property(nonatomic,retain) IBOutlet UILabel *nameLabel;
@property(nonatomic,retain) IBOutlet UILabel *commentLabel;
@property(nonatomic,retain) IBOutlet UILabel *replyTimeLabel;
@property(nonatomic,retain) IBOutlet UILabel *replyPosition;
@property(nonatomic,retain) IBOutlet UILabel *replyCity;
@property(nonatomic,retain) IBOutlet UILabel *replyCountLabel;
@property(nonatomic,retain) NSString *timeString;
@property(nonatomic,retain) NSString *positionString;
@property(nonatomic,retain) NSString *cityString;
@property(nonatomic,retain) NSString *replyCountString;
@property(nonatomic,retain) CommandOperation *commandOper;
@property(nonatomic) BOOL _reloading;
@property(nonatomic,assign) BOOL isRefresh;
@property(nonatomic,assign) BOOL isFromNet;
@property(nonatomic) int ver;
@property(nonatomic) int replyID;
@property(nonatomic) int commentID;
@property(nonatomic,retain) NSMutableArray *replyItems;
@property(nonatomic,retain) NSMutableArray *moreReplyItems;
@property(nonatomic,retain) NSString *commentText;
@property(nonatomic,retain) UIImage *commentHeadImage;
@property(nonatomic,retain) UIImage *commentAttitudeImage;
@property(nonatomic,retain) NSString *nameText;
@property(nonatomic,retain) NSString *timeText;
@property(nonatomic,retain) NSString *positionText;
@property(nonatomic,retain) NSString *cityText;
@property(nonatomic,retain) NSString *productDescUrl;
@property(nonatomic,assign)int photoWith;
@property(nonatomic,assign)int photoHigh;
@property(nonatomic,assign)int preCommentTotalCount;
@property(nonatomic,assign)int operateType;
@property(nonatomic,retain)NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain)NSMutableDictionary *imageDic;
@property(nonatomic,retain)NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain) MBProgressHUD *progressHUD;
@property(nonatomic,retain)UIActivityIndicatorView *spinner;

-(void) handleReply:(id)sender;
-(void)accessService;
-(void)accessMoreService;
-(void)update;
-(void)removeprogressHUD;
@end
