//
//  myScrollImageView.h
//  imageDemo
//
//  Created by 掌商 on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface myScrollImageView : UIImageView {
	float my_x;
	float tmp_x;
	float xPerPic;
	int picNum;
	bool turnLeft;
	int pic_total;
	NSString *pic_name;
}
- (id)initWithFrame:(CGRect)frame imageName:(NSString*)name;
@end
