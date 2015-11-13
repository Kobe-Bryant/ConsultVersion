//
//  ShareWithQRCodeViewController.h
//  szeca
//
//  Created by 掌商 on 12-3-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShareWithQRCodeViewController : UIViewController {
	NSString* linktitle;
	NSString* linkurl;
}
@property(nonatomic,retain)NSString* linktitle;
@property(nonatomic,retain)NSString* linkurl;
@end
