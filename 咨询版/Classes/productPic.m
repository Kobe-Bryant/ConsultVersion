//
//  productPic.m
//  AppStrom
//
//  Created by 掌商 on 11-9-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "productPic.h"


@implementation productPic
@synthesize Id;
@synthesize pic1;
@synthesize pic2;
-(void)dealloc{

	self.pic1 = nil;
	self.pic2 = nil;
	[super dealloc];
}
@end
