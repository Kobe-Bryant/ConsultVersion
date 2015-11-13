//
//  aboutUsBody.h
//  AppStrom
//
//  Created by 掌商 on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface aboutUsBody : NSObject {

	int ver;
	int Id;
	NSString *content;
	NSString *logo;
	bool status;
}
@property(nonatomic,assign)int ver;
@property(nonatomic,assign)int Id;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *logo;
@property(nonatomic,assign)bool status;
@end
