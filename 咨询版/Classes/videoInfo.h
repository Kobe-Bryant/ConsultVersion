//
//  videoInfo.h
//  AppStrom
//
//  Created by 掌商 on 11-8-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface videoInfo : NSObject {
	NSString *picName;
	NSString *videoName;
	NSString *videoDescription;
}
@property(nonatomic,retain)NSString *picName;
@property(nonatomic,retain)NSString *videoName;
@property(nonatomic,retain)NSString *videoDescription;
@end
