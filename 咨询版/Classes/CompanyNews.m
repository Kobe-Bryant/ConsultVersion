//
//  CompanyNews.m
//  AppStrom
//
//  Created by 掌商 on 11-9-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CompanyNews.h"


@implementation CompanyNews
@synthesize Id;
@synthesize Title;
@synthesize descb;
@synthesize picLink;
@synthesize picLocalPath;
@synthesize url;
@synthesize status;
-(void)dealloc{
	
	self.Title = nil;
	self.descb = nil;
	self.picLink = nil;
	self.picLocalPath = nil;
	self.url = nil;
	[super dealloc];
}


@end
