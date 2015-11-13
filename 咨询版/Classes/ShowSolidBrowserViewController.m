//
//  ShowSolidBrowserViewController.m
//  奈莎珠宝
//
//  Created by MC374 on 11-11-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowSolidBrowserViewController.h"
#import "myImageView.h"
#import "SolidViewController.h"
#import "Common.h"
#import "ModuleObject.h"

#define page1 1
#define page2 2

@implementation ShowSolidBrowserViewController

@synthesize scrollView;
@synthesize myNavigationController;
@synthesize pageControl;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void) viewDidLoad{
	[super viewDidLoad];
	
	pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(154.0f, 326.0f, 30.0f, 40.0f)];
	pageControl.numberOfPages = 2;
	pageControl.currentPage = 0;
	[self.view addSubview:pageControl];
	
	scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)] autorelease];
	scrollView.contentSize = CGSizeMake(2 * 320.0f, scrollView.frame.size.height);
	scrollView.pagingEnabled = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.delegate = self;
	
	for (int i = 0; i < [soildListArray count]; i++) {
		ModuleObject *mb = [soildListArray objectAtIndex:i];
		NSString *picName = mb.name;
		NSString *picType = mb.key;
		UIImage *pageImg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1-1" ofType:picType]];
		int width = pageImg.size.width;
		int height = pageImg.size.height;
		NSLog(@"%d",width);
		NSLog(@"%d",height);
		myImageView *pageView = [[myImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f) withImageId:i];
		pageView.image = pageImg;
		pageView.mydelegate = self;
		[scrollView addSubview:pageView];
		[pageView release];
		
	}
	
	[self.view addSubview:scrollView];
}

- (void)viewDidUnload {
	self.myNavigationController = nil;
	self.scrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)imageViewTouchesEnd:(int)picId{
	NSString *imageName = [NSString stringWithFormat:@"%d", picId];
	ModuleObject *mb = [soildListArray objectAtIndex:picId];
	NSString *name = @"-";
	imageName = [imageName stringByAppendingFormat:name];
	NSString *type = mb.key;
	int picCount = mb.num;
	imageName = [name stringByAppendingFormat:type];
	SolidViewController *solidView = [[SolidViewController alloc] init];
	solidView.name = imageName;
	solidView.totalPicNum = picCount;
	[myNavigationController pushViewController:solidView animated:YES];
	[solidView release];
}


- (void)dealloc {
    [super dealloc];
}

- (void) pageTurn: (UIPageControl *) aPageControl{
	
}

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	CGPoint offset = aScrollView.contentOffset;
	pageControl.currentPage = offset.x / 320.0f;
}


@end
