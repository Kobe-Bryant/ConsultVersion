//
//  version.m
//  AppStrom
//
//  Created by 掌商 on 11-9-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "version.h"


@implementation version
@synthesize Id;//接口ID
@synthesize ver;
@synthesize descb;
@synthesize url;
-(void)dealloc{

	self.descb = nil;
	self.url = nil;
	[super dealloc];
}
@end
