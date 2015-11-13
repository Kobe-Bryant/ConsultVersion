//
//  product.m
//  AppStrom
//
//  Created by 掌商 on 11-9-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "product.h"


@implementation product
@synthesize Id;
@synthesize catid;
@synthesize Name;
@synthesize descb;
@synthesize url;
@synthesize pic;
@synthesize iscover;
@synthesize status;
@synthesize time;
-(void)dealloc{

	self.Name = nil;
	self.descb = nil;
	self.url = nil;
	self.pic = nil;
	[super dealloc];
}
@end
