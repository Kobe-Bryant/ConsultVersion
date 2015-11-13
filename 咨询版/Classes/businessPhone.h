//
//  businessPhone.h
//  AppStrom
//
//  Created by 掌商 on 11-9-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface businessPhone : NSObject {

	int ver;
	NSString *tel;
	bool status;
}
@property(nonatomic,assign)int ver;
@property(nonatomic,retain)NSString *tel;
@property(nonatomic,assign)bool status;
@end
