//
//  PublishReplyViewController.h
//  szeca
//
//  Created by MC374 on 12-5-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommandOperation;
@class MBProgressHUD;

@interface PublishReplyViewController : UIViewController {
	UITextView *myTextView;
	BOOL checkBoxSelected;
	UIButton *checkBox;
	CommandOperation *commandOper;
	MBProgressHUD *progressHUD;
	int sync_weibo;
	NSString *productDescUrl;
	int commentID;
	UILabel *remainCount;
	NSString *province;
	NSString *city;
}
@property(nonatomic,retain) IBOutlet UITextView *myTextView;
@property(nonatomic,retain) IBOutlet UIButton *checkBox;
@property(nonatomic,retain) CommandOperation *commandOper;
@property(nonatomic,retain) NSString *productDescUrl;
@property(nonatomic) BOOL checkBoxSelected;
@property(nonatomic) int sync_weibo;
@property(nonatomic) int commentID;
@property(nonatomic,retain) MBProgressHUD *progressHUD;
@property(nonatomic,retain) IBOutlet UILabel *remainCount;
@property(nonatomic,retain) NSString *province;
@property(nonatomic,retain) NSString *city;
-(IBAction) checkBoxButtonPress:(id)sender;
-(void) handleSendContent:(id)sender;
-(void) goback;
-(void) doEditing;
@end
