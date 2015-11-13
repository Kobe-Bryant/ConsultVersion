//
//  aboutmeBranch.h
//  AppStrom
//
//  Created by 掌商 on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface aboutUsBranch : NSObject {

	int Id;
	NSString *Name;
	NSString *tel;
	NSString *mobile;
	NSString *fax;
	NSString *mail;
	NSString *addr;
	NSString *Location;
	NSString *companyname;
	bool showlocation;
	bool showmail;
	bool showfax;
	bool showtel;
	bool showmobile;
	bool showaddr;
	bool showname;
	bool showcompanyname;
	bool status;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,retain)NSString *Name;
@property(nonatomic,retain)NSString *tel;
@property(nonatomic,retain)NSString *mobile;
@property(nonatomic,retain)NSString *fax;
@property(nonatomic,retain)NSString *mail;
@property(nonatomic,retain)NSString *addr;
@property(nonatomic,retain)NSString *Location;
@property(nonatomic,retain)NSString *companyname;
@property(nonatomic,assign)bool showlocation;
@property(nonatomic,assign)bool showmail;
@property(nonatomic,assign)bool showfax;
@property(nonatomic,assign)bool showtel;
@property(nonatomic,assign)bool showmobile;
@property(nonatomic,assign)bool showaddr;
@property(nonatomic,assign)bool showname;
@property(nonatomic,assign)bool showcompanyname;
@property(nonatomic,assign)bool status;
@end
