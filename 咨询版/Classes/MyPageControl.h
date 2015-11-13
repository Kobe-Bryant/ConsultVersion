//
//  MyPageControl.h
//  AppStrom
//
//  Created by 掌商 on 11-8-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyPageControl : UIPageControl
{
	UIImage *imagePageStateNormal;
	UIImage *imagePageStateHighlighted;
}
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;
@end