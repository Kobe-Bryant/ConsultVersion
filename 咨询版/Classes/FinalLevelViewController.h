//
//  FinalLevelViewController.h
//  jvrenye
//
//  Created by MC374 on 11-11-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IconDownLoader.h"

@interface FinalLevelViewController : UIViewController <UIScrollViewDelegate,IconDownloaderDelegate>{
	UILabel *scribeLabel;
	
	NSArray *picArray;
	UIPageControl *pageControl;
	UIScrollView *scrollView;
	UIImage *placeholdPic;
	NSMutableArray *ar_finalCategory;
	int choosePid;
	NSMutableArray *ar_scrollPic;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
}
@property(nonatomic,retain) UILabel *scribeLabel;
@property(nonatomic,retain) NSArray *picArray;
@property(nonatomic,retain) UIPageControl *pageControl;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIImage *placeholdPic;
@property(nonatomic,retain) NSMutableArray *ar_finalCategory;
@property(nonatomic,retain) NSMutableArray *ar_scrollPic;
@property(nonatomic,assign) int choosePid;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;


- (void) showLabel;
- (void) showScrollView;
- (void) pageTurn: (UIPageControl *) aPageControl;
- (void) showPageOne;
- (void) showOtherPage;

@end
