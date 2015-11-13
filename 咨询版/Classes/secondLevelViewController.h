//
//  secondLevelViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-8-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface secondLevelViewController : UIViewController <UIScrollViewDelegate>{

	NSArray *picArray;
	UIPageControl *pageControl;
	UIScrollView *scrollView;
	NSArray *detailPicArray;
	NSDictionary *productDic;
	int choosePid;
	//UITextView *tv;
	UIImageView *bar;
	UIButton *left;
	UIButton *right;
	UIScrollView *sc;
	
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
	NSMutableArray *ar_secondCategory;
	NSMutableArray *ar_scrollPic;
	UIButton *lastChooseBto;
	UILabel *scribeLabel;
	UIImage *placeholdPic;
}
//@property(nonatomic,retain)IBOutlet UITextView *tv;
@property(nonatomic,retain) UIImageView *bar;
@property(nonatomic,retain) UIButton *left;
@property(nonatomic,retain) UIButton *right;
@property(nonatomic,retain) UIScrollView *sc;
@property(nonatomic,retain) UIImage *placeholdPic;
@property(nonatomic,retain) UILabel *scribeLabel;
@property(nonatomic,retain) UIButton *lastChooseBto;
@property(nonatomic,retain) NSMutableArray *ar_scrollPic;
@property(nonatomic,retain) NSMutableArray *ar_secondCategory;
@property(nonatomic,retain) NSDictionary *productDic;
@property(nonatomic,retain) UIPageControl *pageControl;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) NSArray *picArray;
@property(nonatomic,retain) NSArray *detailPicArray;
@property(nonatomic,assign) int choosePid;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
-(IBAction)turnBack:(id)sender;
-(IBAction)HandleLeft:(id)sender;
-(IBAction)HandleRight:(id)sender;
@end
