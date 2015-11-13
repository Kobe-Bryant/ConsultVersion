//
//  showPagesImage.m
//  AppStrom
//
//  Created by 掌商 on 11-8-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "showPagesImage.h"
#import "UIImageScale.h"
#import "myImageView.h"

@implementation showPagesImage
@synthesize pageControl;
@synthesize imageDelegate;
- (id)initWithPicArray:(NSArray*)picArray withSuperView:(UIView*)theview delegate:(id)thedelegate{

	
	float width = theview.frame.size.width;
	float height = theview.frame.size.height;
	int pageCount = [picArray count];
	
	if ((self = [super initWithFrame:CGRectMake(0.0f, 0.0f, width, height)])) {
		self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(120, height-120, 80, 30)]autorelease];
		pageControl.backgroundColor = [UIColor clearColor];
		pageControl.numberOfPages = pageCount;
		pageControl.currentPage = 0;
		[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
		
		self.contentSize = CGSizeMake(pageCount*width, height-30);
		self.pagingEnabled = YES;
		self.delegate = self;
		for (int i= 0;i < pageCount;i++){
			myImageView *iv = [[myImageView alloc]initWithFrame:CGRectMake(width*i+20,10.0f,width-40,height-130) withImageId:i];
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[picArray objectAtIndex:i] ofType:nil]];
			iv.image = [img scaleToSize:CGSizeMake(width-40, height-130)];
			[img release];
			iv.mydelegate = thedelegate;
			[self addSubview:iv];
			[iv release];
		}
		[theview addSubview:self];
		[theview addSubview:pageControl];
    }
    return self;
}
- (void) pageTurn: (UIPageControl *) aPageControl
{
	NSLog(@"come to pageturn");
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	self.contentOffset = CGPointMake(self.frame.size.width * whichPage, 0.0f);
	[UIView commitAnimations];
	
}
- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	CGPoint offset = aScrollView.contentOffset;
	pageControl.currentPage = offset.x / self.frame.size.width;
}
-(void)dealloc{
	[pageControl release];
	[super dealloc];
}
@end
