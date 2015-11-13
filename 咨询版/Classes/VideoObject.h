//
//  VideoObject.h
//  jvrenye
//
//  Created by MC374 on 11-11-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoObject : NSObject {
	NSString *name;
	NSString *isLocal;
	NSString *path;
	NSString *desc;
	NSString *pic;
	NSString *videotype;
}

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *isLocal;
@property(nonatomic,retain) NSString *path;
@property(nonatomic,retain) NSString *desc;
@property(nonatomic,retain) NSString *pic;
@property(nonatomic,retain) NSString *videotype;
@end
