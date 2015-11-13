//
//  product.h
//  AppStrom
//
//  Created by 掌商 on 11-9-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface product : NSObject {

	int Id;
	int catid;
	NSString *Name;
	NSString *descb;
	NSString *url;
	NSString *pic;
	bool iscover;
	bool status;
	long long time;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,assign)int catid;
@property(nonatomic,retain)NSString *Name;
@property(nonatomic,retain)NSString *descb;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)NSString *pic;
@property(nonatomic,assign)bool iscover;
@property(nonatomic,assign)bool status;
@property(nonatomic,assign)long long time;
@end
