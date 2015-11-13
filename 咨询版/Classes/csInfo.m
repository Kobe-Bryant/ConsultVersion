//
//  csInfo.m
//  AppStrom
//
//  Created by 掌商 on 11-8-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "csInfo.h"
@implementation csInfo
@synthesize csPic;
@synthesize csName;
@synthesize csPhone;
@synthesize csAreaCode;
@synthesize csMail;
@synthesize csAddress;
@synthesize csCoordinate;
@synthesize csId;
-(void)dealloc{
	self.csPic = nil;
	self.csName = nil;
	self.csPhone = nil;
	self.csAreaCode = nil;
	self.csMail = nil;
	self.csAddress = nil;
	self.csCoordinate = nil;
	[super dealloc];
}
@end
