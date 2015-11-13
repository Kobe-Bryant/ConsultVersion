//
//  firstLevelScrollView.h
//  appStorm2
//
//  Created by 掌商 on 11-12-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol firstUISCrollViewDelegate

@optional

- (void)touchOnce;

@end

@interface firstLevelScrollView : UIScrollView {

	id<firstUISCrollViewDelegate> myscrolldelegate;
}
@property(nonatomic,assign)id myscrolldelegate;
@end
