//
//  sns.m
//  AppStrom
//
//  Created by 掌商 on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "sns.h"
@implementation sns
@synthesize Id;
@synthesize Name;
@synthesize url;
@synthesize pic;
@synthesize explain;
-(void)dealloc{
	self.Name = nil;
	self.url = nil;
	self.pic = nil;
	[super dealloc];
}
@end
