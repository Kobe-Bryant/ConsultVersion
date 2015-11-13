//
//  MyViewBarcode.h
//  OnBarcodeIPhoneClient
//
//  Created by Wang Qi on 12/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewBarcode : UIView {
	NSString *titleString;
	NSString *url;
}
@property(nonatomic,retain)NSString *titleString;
@property(nonatomic,retain)NSString *url;
@end
