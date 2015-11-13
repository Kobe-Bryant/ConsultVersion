//
//  showRotationPicViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "showRotationPicViewController.h"
#import "myScrollImageView.h"

#define BASEHEIGHT	367.0f
#define NPAGES		2

@implementation showRotationPicViewController
//@synthesize iv;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

//	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"动图" ofType:@"jpg"]];
//	autoMoveImageView *picView = [[autoMoveImageView alloc]initWithImage:img moveLeft:YES withSuperviewSize:self.view.frame.size];
//	[img release];
//	self.iv = picView;
//	[self.view addSubview:picView];
//	[picView release];
//	[iv startMove];
	
//	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"背景" ofType:@"png"]];
//	self.view.backgroundColor = [UIColor colorWithPatternImage:[img fillSize:self.view.frame.size]];
//    [img release];
//	myScrollImageView *myScrollView = [[myScrollImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
//	self.imageScrollView = myScrollView;
//	[self.view addSubview:myScrollView];
//	[myScrollView release];
	
//	// Load in all the pages

    self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
	CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - 20 - 44 - 49;
    CGFloat fixHeight = (viewHeight - BASEHEIGHT) * 0.5;
    
	myScrollImageView *firstScrollView = [[myScrollImageView alloc] initWithFrame:CGRectMake(0.0f, fixHeight, 320.0f, BASEHEIGHT) imageName:@"%d.png" totalPic:36];
	firstScrollView.frame = CGRectMake(0.0f, fixHeight, 320.0f,  BASEHEIGHT);
	[self.view addSubview:firstScrollView];
	[firstScrollView release];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	CGPoint offset = aScrollView.contentOffset;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
