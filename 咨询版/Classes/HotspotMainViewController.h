//
//  HotspotMainViewController.h
//  szeca
//
//  Created by MC374 on 12-5-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class hotspotViewController;
@class promotionsViewController;
@class companyNewsViewController;
@class AutoScrollView;
@class CommandOperation;
@class MBProgressHUD;

@interface HotspotMainViewController : UIViewController {
	NSArray *buttonTitle;
	UIButton *preSelectBtn;
	hotspotViewController *hotspot;
	promotionsViewController *promotion;
	companyNewsViewController *companyNews;
	UINavigationController *navigationController;
	NSMutableArray *adPicArray;
	NSMutableArray *footArray;
	NSMutableArray *footPicArray;
	AutoScrollView *adScrollView;
	CommandOperation *commandOper;
	NSMutableDictionary *imageDic;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;	
	int currentIndex;
	int photoWith;
	int photoHigh;
	MBProgressHUD *progressHUD;
}

@property(nonatomic,retain) NSArray *buttonTitle;
@property(nonatomic,retain) UIButton *preSelectBtn;
@property(nonatomic,retain) hotspotViewController *hotspot;
@property(nonatomic,retain) promotionsViewController *promotion;
@property(nonatomic,retain) companyNewsViewController *companyNews;
@property(nonatomic,retain) UINavigationController *navigationController;
@property(nonatomic,retain) NSMutableArray *adPicArray;
@property(nonatomic,retain) NSMutableArray *footArray;
@property(nonatomic,retain) NSMutableArray *footPicArray;
@property(nonatomic,retain) AutoScrollView *adScrollView;
@property(nonatomic,retain) CommandOperation *commandOper;
@property(nonatomic,assign)int currentIndex;
@property(nonatomic,assign)int photoWith;
@property(nonatomic,assign)int photoHigh;
@property(nonatomic,retain)NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain)NSMutableDictionary *imageDic;
@property(nonatomic,retain)NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)MBProgressHUD *progressHUD;

-(void) createButton;
- (void) HandleSegment:(id)sender;
-(void) accessService;
-(void) update;
@end
