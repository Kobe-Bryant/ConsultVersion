//
//  cats.h
//  AppStrom
//
//  Created by 掌商 on 11-9-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface cats : NSObject {

	int Id;
	int pid;
	int shopid;
	NSString *Name;
	NSString *pic;
	bool status;
	long long time;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,assign)int pid;
@property(nonatomic,assign)int shopid;
@property(nonatomic,retain)NSString *Name;
@property(nonatomic,retain)NSString *pic;
@property(nonatomic,assign)bool status;
@property(nonatomic,assign)long long time;
@end
