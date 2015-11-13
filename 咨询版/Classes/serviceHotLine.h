//
//  serviceHotLine.h
//  AppStrom
//
//  Created by 掌商 on 11-9-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface serviceHotLine : NSObject {

	int ver;
	NSString *descb;
	NSString *Title;
	NSString *tel;
	NSString *mail;
	bool status;
}
@property(nonatomic,assign)int ver;
@property(nonatomic,retain)NSString *descb;
@property(nonatomic,retain)NSString *Title;
@property(nonatomic,retain)NSString *tel;
@property(nonatomic,retain)NSString *mail;
@property(nonatomic,assign)bool status;
@end
