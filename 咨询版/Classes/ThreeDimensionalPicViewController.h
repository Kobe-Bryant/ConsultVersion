//
//  ThreeDimensionalPicViewController.h
//  szeca
//
//  Created by MC374 on 12-6-15.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "MBProgressHUD.h"
#import "myImageView.h"
#import "firstLevelScrollView.h"

@class showPagesImage;
@interface ThreeDimensionalPicViewController : UIViewController <MBProgressHUDDelegate>{
	NSArray *picArray;
	NSArray *allSecondLevelPic;
	showPagesImage *pagesImage;
	UINavigationController *myNavigationController;
	//id<pushNextViewController> pushdelegate;
	CommandOperation *commandOper;
	MBProgressHUD *progressHUD;
	NSMutableArray *picLinkArray;
	UIPageControl *pageControl;
	firstLevelScrollView *scrollView;
	NSDictionary *serviceDataDic;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
	float picwidth;
	float picheight;
	//UINavigationController *navigationController;
	////圆型效果
	UIScrollView *backView;
	UIImageView *backOneImgView;
	UIImageView *backTwoImgView;
	myImageView *frontImgView;
	
	NSMutableArray *imgViewArray; //存储所有imageview的数组
	NSMutableArray *imgBacViewArray;
	int currentPage_; //当前页
	int totalPages_; //总图片数量
	
}
//@property(nonatomic,retain)UINavigationController *navigationController;
@property(nonatomic,retain)NSArray *picArray;
@property(nonatomic,retain)showPagesImage *pagesImage;
@property(nonatomic,retain)UINavigationController *myNavigationController;
@property(nonatomic,retain)NSArray *allSecondLevelPic;
@property(nonatomic,retain)CommandOperation *commandOper;
@property(nonatomic,retain)MBProgressHUD *progressHUD;
@property(nonatomic,retain)NSMutableArray *picLinkArray;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,retain)firstLevelScrollView *scrollView;
@property(nonatomic,retain)NSDictionary *serviceDataDic;
@property(nonatomic,retain)NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain)NSMutableArray *imageDownloadsInWaiting;

@property(nonatomic,retain)UIScrollView *backView;
@property(nonatomic,retain)UIImageView *backOneImgView;
@property(nonatomic,retain)UIImageView *backTwoImgView;
@property(nonatomic,retain)myImageView *frontImgView;
@property(nonatomic,retain)NSMutableArray *imgViewArray; //存储所有imageview的数组
@property(nonatomic,retain)NSMutableArray *imgBacViewArray;
@end

