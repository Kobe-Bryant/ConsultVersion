//
//  cats.m
//  AppStrom
//
//  Created by 掌商 on 11-9-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cats.h"


@implementation cats
@synthesize Id;
@synthesize pid;
@synthesize shopid;
@synthesize Name;
@synthesize pic;
@synthesize status;
@synthesize time;
-(void)dealloc{

	self.Name = nil;
	self.pic = nil;
	[super dealloc];
}
@end
