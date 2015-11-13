//
//  wallpaper.h
//  AppStrom
//
//  Created by 掌商 on 11-9-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface wallpaper : NSObject {

	int Id;
	NSString *Title;
	NSString *descb;
	NSString *pic;
	NSString *pic2;
	bool status;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,retain)NSString *Title;
@property(nonatomic,retain)NSString *descb;
@property(nonatomic,retain)NSString *pic;
@property(nonatomic,retain)NSString *pic2;
@property(nonatomic,assign)bool status;
@end
