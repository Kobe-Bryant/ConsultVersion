//
//  aboutUsBody.m
//  AppStrom
//
//  Created by 掌商 on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "aboutUsBody.h"


@implementation aboutUsBody
@synthesize ver;
@synthesize Id;
@synthesize content;
@synthesize logo;
@synthesize status;
-(void)dealloc{

	self.content = nil;
	self.logo = nil;
	[super dealloc];
}
@end
