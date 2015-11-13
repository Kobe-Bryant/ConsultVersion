//
//  aboutmeBranch.m
//  AppStrom
//
//  Created by 掌商 on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "aboutUsBranch.h"


@implementation aboutUsBranch
@synthesize Id;
@synthesize Name;
@synthesize tel;
@synthesize mobile;
@synthesize fax;
@synthesize mail;
@synthesize addr;
@synthesize Location;
@synthesize companyname;
@synthesize showlocation;
@synthesize showmail;
@synthesize showfax;
@synthesize showtel;
@synthesize showmobile;
@synthesize showaddr;
@synthesize showname;
@synthesize showcompanyname;
@synthesize status;
-(void)dealloc{

	self.Name = nil;
	self.tel = nil;
	self.mobile = nil;
	self.fax = nil;
	self.mail = nil;
	self.addr = nil;
	self.Location = nil;
	self.companyname = nil;
	[super dealloc];
}
@end
