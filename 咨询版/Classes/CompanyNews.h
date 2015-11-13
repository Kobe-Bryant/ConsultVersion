//
//  CompanyNews.h
//  AppStrom
//
//  Created by 掌商 on 11-9-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CompanyNews : NSObject {
	int Id;
	NSString *Title;
	NSString *descb;
	NSString *picLink;
	NSString *picLocalPath;
	NSString *url;
	bool status;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,retain)NSString *Title;
@property(nonatomic,retain)NSString *descb;
@property(nonatomic,retain)NSString *picLink;
@property(nonatomic,retain)NSString *picLocalPath;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,assign)bool status;
@end
