    //
//  ShareWithQRCodeViewController.m
//  szeca
//
//  Created by 掌商 on 12-3-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareWithQRCodeViewController.h"
#import "MyViewBarcode.h"

@implementation ShareWithQRCodeViewController

@synthesize linktitle;
@synthesize linkurl;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"二维码分享";
	
	MyViewBarcode *cgv = [[MyViewBarcode alloc] initWithFrame: self.view.frame title:self.linktitle url:self.linkurl];
	self.view = cgv;
	[cgv release];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	linkurl = nil;
	linktitle = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[linktitle release];
	[linkurl release];
}


@end
