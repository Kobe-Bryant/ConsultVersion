//
//  serviceBranch.m
//  AppStrom
//
//  Created by 掌商 on 11-9-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "serviceBranch.h"


@implementation serviceBranch
int Id;
NSString *Name;
NSString *tel;
NSString *mobile;
NSString *fax;
NSString *mail;
NSString *addr;
NSString *Location;
NSString *companyName;
bool showlocation;
bool showmail;
bool showfax;
bool showtel;
bool showmobile;
bool showaddr;
bool showname;
bool showcompanyname;
bool status;
-(void)dealloc{

	self.Name = nil;
	self.tel = nil;
	self.mobile = nil;
	self.fax = nil;
	self.mail = nil;
	self.addr = nil;
	self.addr = nil;
	self.Location = nil;
	self.companyName = nil;
	[super dealloc];
}
@end
