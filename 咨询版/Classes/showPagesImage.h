//
//  showPagesImage.h
//  AppStrom
//
//  Created by 掌商 on 11-8-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class MyPageControl;
@interface showPagesImage : UIScrollView {

	UIPageControl *pageControl;
	id imageDelegate;
}
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,assign)id imageDelegate;
- (id)initWithPicArray:(NSArray*)picArray withSuperView:(UIView*)theview delegate:(id)thedelegate;
@end
