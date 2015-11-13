//
//  csInfo.h
//  AppStrom
//
//  Created by 掌商 on 11-8-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface csInfo : NSObject {

	NSString *csPic;
	NSString *csName;
	NSString *csPhone;
	NSString *csAreaCode;
	NSString *csMail;
	NSString *csAddress;
	NSString *csCoordinate;
	int csId;
}
@property(nonatomic,assign)int csId;
@property(nonatomic,retain)NSString *csPic;
@property(nonatomic,retain)NSString *csName;
@property(nonatomic,retain)NSString *csPhone;
@property(nonatomic,retain)NSString *csAreaCode;
@property(nonatomic,retain)NSString *csMail;
@property(nonatomic,retain)NSString *csAddress;
@property(nonatomic,retain)NSString *csCoordinate;
@end
