//
//  SolidViewController.h
//  奈莎珠宝
//
//  Created by MC374 on 11-11-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class myScrollImageView;

@interface SolidViewController : UIViewController {
	NSString *name;
	int totalPicNum;
}

@property(nonatomic,retain) NSString *name;
@property(nonatomic) int totalPicNum;
@end
