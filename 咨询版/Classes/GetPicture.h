//
//  GetPicture.h
//  飞飞Q信
//
//  Created by Eamon.Lin on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "getPictureProtocol.h"
#import "UIImageScale.h"
@interface GetPicture : NSObject {
  UIViewController *viewController;
	id<getPictureProtocol>contentDelegate;
}
@property(nonatomic,retain)UIViewController *viewController;
@property(nonatomic,assign)id<getPictureProtocol>contentDelegate;
-(id)initWith:(id)controller delegate:(id)delegate;
-(void)getCameraPicture:(id) sender;
-(void)selectExistingPicture:(id) sender;
@end
