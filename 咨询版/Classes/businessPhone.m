//
//  businessPhone.m
//  AppStrom
//
//  Created by 掌商 on 11-9-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "businessPhone.h"


@implementation businessPhone
@synthesize ver;
@synthesize tel;
@synthesize status;
-(void)dealloc{

	self.tel = nil;
	[super dealloc];
}
@end
