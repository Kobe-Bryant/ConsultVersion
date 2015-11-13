//
//  version.h
//  AppStrom
//
//  Created by 掌商 on 11-9-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface version : NSObject {

	int Id;//接口ID
	int ver;
	NSString *descb;
	NSString *url;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,assign)int ver;
@property(nonatomic,retain)NSString *descb;
@property(nonatomic,retain)NSString *url;
@end
