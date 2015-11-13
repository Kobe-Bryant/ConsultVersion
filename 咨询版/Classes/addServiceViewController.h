//
//  addServiceViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-9-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "csInfo.h"
#import "GetPicture.h"
#import "manageActionSheet.h"
#import "BaiduMapViewController.h"
@protocol addDelegate

-(void)add:(csInfo*)addinf;

@end
@interface addServiceViewController : UIViewController <getAddressDelegate>{

	UIImage *photo;
	csInfo *addinfo;
	manageActionSheet *actionsheet;
	id<addDelegate> adddelegate;
	GetPicture *getPic;
	bool isEdit;
	int	currentTextFieldTag;
	bool isShowMap;
	BOOL isEditing;
}
@property(nonatomic,retain)GetPicture *getPic;
@property(nonatomic,assign)id<addDelegate> adddelegate;
@property(nonatomic,retain)csInfo *addinfo;
@property(nonatomic,retain)UIImage *photo;
@property(nonatomic,retain)manageActionSheet *actionsheet;
@property(nonatomic)int currentTextFieldTag;
@property(nonatomic)bool isShowMap;
@property(nonatomic)BOOL isEditing;
-(IBAction)getPic:(id)sender;
-(IBAction)showMap:(id)sender;
-(IBAction)showMapByCoord:(id)sender;
@end
