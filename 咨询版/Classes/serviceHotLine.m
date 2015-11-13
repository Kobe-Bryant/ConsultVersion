//
//  serviceHotLine.m
//  AppStrom
//
//  Created by 掌商 on 11-9-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "serviceHotLine.h"


@implementation serviceHotLine
@synthesize ver;
@synthesize descb;
@synthesize Title;
@synthesize tel;
@synthesize status;
@synthesize mail;
-(void)dealloc{
	self.descb = nil;
	self.Title = nil;
	self.tel = nil;
	self.mail = nil;
	[super dealloc];
}
@end
