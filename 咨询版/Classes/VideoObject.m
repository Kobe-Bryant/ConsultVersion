//
//  VideoObject.m
//  jvrenye
//
//  Created by MC374 on 11-11-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoObject.h"


@implementation VideoObject

@synthesize name;
@synthesize isLocal;
@synthesize path;
@synthesize desc;
@synthesize pic;
@synthesize videotype;

- (void) dealloc{
	[name release];
	[isLocal release];
	[path release];
	[desc release];
	[pic release];
	[videotype release];
}
@end
