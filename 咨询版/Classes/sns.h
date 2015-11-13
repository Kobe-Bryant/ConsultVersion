//
//  sns.h
//  AppStrom
//
//  Created by 掌商 on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface sns : NSObject {

	int Id;
	NSString *Name;
	NSString *url;
	NSString *pic;
	NSString *explain;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,retain)NSString *Name;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)NSString *pic;
@property(nonatomic,retain)NSString *explain;
@end
