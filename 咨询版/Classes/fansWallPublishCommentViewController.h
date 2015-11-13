//
//  PublishCommentViewController.h
//  szeca
//
//  Created by MC374 on 12-4-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommandOperation;
@class MBProgressHUD;

@interface fansWallPublishCommentViewController : UIViewController {
	UITextView *myTextView;
	BOOL checkBoxSelected;
	UIButton *checkBox;
	UILabel *sendLabel;
	UIImageView *sendBackImageView;
	int moduleId;
	int moduleTypeId;
	NSString *moduleTitle;
	CommandOperation *commandOper;
	MBProgressHUD *progressHUD;
	UILabel *remainCount;
	NSString *province;
	NSString *city;
	int attitude;
	UIImageView *jiantouImageView;
	UIImageView *weiboTypeImageView;
	NSString *weiboType;
}

@property(nonatomic,retain) IBOutlet UITextView *myTextView;
@property(nonatomic,retain) IBOutlet UIButton *checkBox;
@property(nonatomic,retain) IBOutlet UILabel *remainCount;
@property(nonatomic,retain) IBOutlet UIImageView *jiantouImageView;
@property(nonatomic,retain) IBOutlet UIImageView *weiboTypeImageView;
@property(nonatomic,retain) IBOutlet UIImageView *sendBackImageView;
@property(nonatomic,retain) IBOutlet UILabel *sendLabel;
@property(nonatomic,retain) IBOutlet UIImageView *barImageView;
@property(nonatomic,retain) NSString *moduleTitle;
@property(nonatomic,retain) CommandOperation *commandOper;
@property(nonatomic) BOOL checkBoxSelected;
@property(nonatomic) int moduleId;
@property(nonatomic) int moduleTypeId;
@property(nonatomic) int attitude;
@property(nonatomic,retain) MBProgressHUD *progressHUD;
@property(nonatomic,retain) NSString *province;
@property(nonatomic,retain) NSString *city;
@property(nonatomic,retain) NSString *weiboType;
-(IBAction) checkBoxButtonPress:(id)sender;
-(IBAction) attitudeButtonPress:(id)sender;
-(void) handleSendContent:(id)sender;
@end
