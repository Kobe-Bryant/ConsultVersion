//
//  firstLevelScrollView.m
//  appStorm2
//
//  Created by 掌商 on 11-12-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "firstLevelScrollView.h"


@implementation firstLevelScrollView
@synthesize myscrolldelegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view{

	NSLog(@"hellll");
	UITouch *touch = [touches anyObject];
	if(touch.tapCount == 1) {
		[myscrolldelegate touchOnce];
	}
			
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
