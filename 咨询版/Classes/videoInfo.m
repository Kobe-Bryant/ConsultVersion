//
//  videoInfo.m
//  AppStrom
//
//  Created by 掌商 on 11-8-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "videoInfo.h"


@implementation videoInfo
@synthesize picName;
@synthesize videoName;
@synthesize videoDescription;
-(void)dealloc{
	[picName release];
	[videoName release];
	[videoDescription release];
	[super dealloc];
}
@end
