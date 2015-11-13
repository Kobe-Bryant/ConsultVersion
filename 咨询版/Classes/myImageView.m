//
//  myImageView.m
//  云来
//
//  Created by 掌商 on 11-7-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "myImageView.h"


@implementation myImageView

@synthesize mydelegate;
@synthesize loadingView;
@synthesize imageId;

-(id)initWithFrame:(CGRect)frame withImageId:(int)imageid{

	self = [super initWithFrame:frame];
	if (self != nil) {
		self.userInteractionEnabled = YES;
		imageId = imageid;
	}
	return self;
}
-(id)initWithImage:(UIImage *)image withImageId:(int)imageid{

	self = [super initWithImage:image];
	if (self != nil) {
		self.userInteractionEnabled = YES;
		imageId = imageid;
	}
	return self;
	
}
-(void)dealloc{
	loadingView = nil;
	[super dealloc];
}
#pragma mark -
#pragma mark touch event method

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_delegate && [(NSObject *)_delegate respondsToSelector:@selector(urlTouchesBegan:)]) {
		[_delegate urlTouchesBegan:self];
	}
}*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touch end");
	//UITouch *touch = [touches anyObject];
	
	//if ([touch tapCount] == 1){
		
	if (mydelegate && [(NSObject *)mydelegate respondsToSelector:@selector(imageViewTouchesEnd:)]) {
		NSLog(@"touch11 end");
		
		[mydelegate imageViewTouchesEnd:imageId];
	}
//}
}

-(void)startSpinner{
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	[spinner setCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)];
	self.loadingView = spinner;
	[self addSubview:loadingView];
	[loadingView startAnimating];
	[spinner release];
}
-(void)stopSpinner{
	[loadingView stopAnimating];
	//[loadingView removeFromSuperview];
}
@end
