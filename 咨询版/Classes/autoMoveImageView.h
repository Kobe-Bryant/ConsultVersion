//
//  autoMoveImageView.h
//  moveAuto
//
//  Created by 掌商 on 11-8-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface autoMoveImageView : UIImageView {

	float moveXLength;
	float moveYLength;
	float moveXPerTime;
	float moveYPerTime;
	NSTimer *timer;
	bool direct;
}
@property(nonatomic,retain)NSTimer *timer;
- (id)initWithImage:(UIImage*)myImage moveLeft:(bool)direction withSuperviewSize:(CGSize)superviewSize;
-(void)startMove;
@end
