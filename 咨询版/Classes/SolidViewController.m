//
//  SolidViewController.m
//  奈莎珠宝
//
//  Created by MC374 on 11-11-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SolidViewController.h"


@implementation SolidViewController

@synthesize name;
@synthesize totalPicNum;

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

- (void) viewDidLoad{
	[super viewDidLoad];
	
	myScrollImageView *firstScrollView = [[myScrollImageView alloc] initWithFrame:CGRectMake(0.0f, 36.0f, 320.0f, 320.0f) imageName:@"%d" totalPic:totalPicNum];
	[self.view addSubview:firstScrollView];
	[firstScrollView release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.name = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
