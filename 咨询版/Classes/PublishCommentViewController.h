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

@interface PublishCommentViewController : UIViewController {
	UIButton *likeButton;
	UIButton *netralButton;
	UIButton *deslikeButton;
	UIImageView *jiantouImageView;
	UIImageView *weiboTypeImageView;
    UIImageView *sendBackImageView;
    UILabel *sendLabel;
	UITextView *myTextView;
	BOOL checkBoxSelected;
	UIButton *checkBox;
	int moduleType;
	NSNumber *moduleId;
	int moduleTypeId;
	CommandOperation *commandOper;
	int attitude;
	int sync_weibo;
	NSString *productDescUrl;
	NSString *moduleTitle;
	MBProgressHUD *progressHUD;
	UILabel *remainCount;
	NSString *province;
	NSString *city;
	NSString *weiboType;
}
@property(nonatomic,retain) IBOutlet UIButton *likeButton;
@property(nonatomic,retain) IBOutlet UIButton *netralButton;
@property(nonatomic,retain) IBOutlet UIButton *deslikeButton;
@property(nonatomic,retain) IBOutlet UITextView *myTextView;
@property(nonatomic,retain) IBOutlet UIImageView *jiantouImageView;
@property(nonatomic,retain) IBOutlet UIImageView *weiboTypeImageView;
@property(nonatomic,retain) IBOutlet UIImageView *sendBackImageView;
@property(nonatomic,retain) IBOutlet UIButton *checkBox;
@property(nonatomic,retain) IBOutlet UILabel *sendLabel;
@property(nonatomic,retain) NSString *moduleTitle;
@property(nonatomic,retain) CommandOperation *commandOper;
@property(nonatomic,retain) NSString *productDescUrl;
@property(nonatomic,retain) NSString *province;
@property(nonatomic,retain) NSString *city;
@property(nonatomic,retain) NSString *weiboType;
@property(nonatomic,retain) MBProgressHUD *progressHUD;
@property(nonatomic,retain) IBOutlet UILabel *remainCount;
@property(nonatomic) BOOL checkBoxSelected;
@property(nonatomic) int moduleType;
@property(nonatomic,retain) NSNumber *moduleId;
@property(nonatomic) int moduleTypeId;
@property(nonatomic) int attitude;
@property(nonatomic) int sync_weibo;
-(IBAction) likeButtonPress:(id)sender;
-(IBAction) netralButtonPress:(id)sender;
-(IBAction) deslikeButtonPress:(id)sender;
-(IBAction) checkBoxButtonPress:(id)sender;
-(void) handleSendContent:(id)sender;
-(void) doEditing;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
@end
