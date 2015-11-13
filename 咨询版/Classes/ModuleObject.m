//
//  ModuleObject.m
//  jvrenye
//
//  Created by MC374 on 11-11-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleObject.h"


@implementation ModuleObject

@synthesize status;
@synthesize name;
@synthesize key;
@synthesize num;


- (void) dealloc{
	self.status = nil;
	self.name = nil;
	self.key = nil;
	[super dealloc];
}

@end
