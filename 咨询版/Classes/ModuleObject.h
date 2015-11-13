//
//  ModuleObject.h
//  jvrenye
//
//  Created by MC374 on 11-11-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModuleObject : NSObject {
	NSString *status;
	NSString *name;
	NSString *key;
	int num;
}
@property (nonatomic) int num;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *key;

@end
