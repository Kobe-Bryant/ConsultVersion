//
//  ShowSolidBrowserViewController.h
//  奈莎珠宝
//
//  Created by MC374 on 11-11-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowSolidBrowserViewController : UIViewController {
	UIScrollView *scrollView;
	UINavigationController *myNavigationController;
	UIPageControl *pageControl;
}

@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UINavigationController *myNavigationController;
@property(nonatomic,retain) UIPageControl *pageControl;

@end
