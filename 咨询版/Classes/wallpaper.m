//
//  wallpaper.m
//  AppStrom
//
//  Created by 掌商 on 11-9-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "wallpaper.h"


@implementation wallpaper
@synthesize Id;
@synthesize Title;
@synthesize descb;
@synthesize pic;
@synthesize pic2;
@synthesize status;
-(void)dealloc{

	self.Title = nil;
	self.descb = nil;
	self.pic = nil;
	self.pic2 = nil;
	[super dealloc];
}
@end
