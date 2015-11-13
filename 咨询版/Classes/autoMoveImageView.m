//
//  autoMoveImageView.m
//  moveAuto
//
//  Created by 掌商 on 11-8-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "autoMoveImageView.h"


@implementation autoMoveImageView
@synthesize timer;
- (id)initWithImage:(UIImage*)myImage moveLeft:(bool)direction withSuperviewSize:(CGSize)superviewSize {
    if ((self = [super initWithImage:myImage])) {
		
        direct = direction;
		self.timer = nil;
		moveXLength = self.frame.size.width - superviewSize.width;
		moveYLength = self.frame.size.height - superviewSize.height;
		if (direction) {
			moveXPerTime = 0.3;
		}
		else {
			self.center = CGPointMake(-(self.center.x-superviewSize.width), -(self.center.y-superviewSize.height));
			moveXPerTime = -0.3;
		}
		moveYPerTime=moveXPerTime*moveYLength/moveXLength;		
    }
    return self;
}
-(void)startMove{

	self.timer=[NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(updatePic:) userInfo:nil repeats:YES];

}
-(void)updatePic:(id)sender{
	CGPoint theCenter=self.center;
	if (direct) {
		moveXLength = moveXLength - moveXPerTime;
	}
	else {
		moveXLength = moveXLength + moveXPerTime;
	}

	
	if (moveXLength < 0.0f ) {
		[timer invalidate];
	}
	
	self.center = CGPointMake(theCenter.x-moveXPerTime, theCenter.y-moveYPerTime);
}
-(void)dealloc{

	self.timer = nil;
	[super dealloc];
}
@end
