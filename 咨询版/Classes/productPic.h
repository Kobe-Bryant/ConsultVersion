//
//  productPic.h
//  AppStrom
//
//  Created by 掌商 on 11-9-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface productPic : NSObject {

	int Id;
	NSString *pic1;
	NSString *pic2;
}
@property(nonatomic,assign)int Id;
@property(nonatomic,retain)NSString *pic1;
@property(nonatomic,retain)NSString *pic2;
@end
