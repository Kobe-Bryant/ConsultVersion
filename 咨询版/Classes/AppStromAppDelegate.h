//
//  AppStromAppDelegate.h
//  AppStrom
//
//  Created by 掌商 on 11-8-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "showPushAlert.h"
#import "CommandOperation.h"
#import "WXApi.h"
#import "BMapKit.h" //baiduMap

@class AppStromViewController;
@class UpdateAppAlert;

@protocol APPlicationDelegate <NSObject>

- (void) handleCallBack:(NSDictionary*)info;

@end

@interface AppStromAppDelegate : NSObject <UIApplicationDelegate,WXApiDelegate,CLLocationManagerDelegate> {
    UIWindow *window;
    AppStromViewController *viewController;
	UINavigationController *navController;
	showPushAlert *pushAlert;
	//CLLocationManager *locManager;
	NSString *dtoken;
	CommandOperation *commandOper;
	NSString *province;
	NSString *city;
	NSString *LatitudeAndLongitude;
	UpdateAppAlert *updateAlert;
    
    BMKMapManager * _mapManager;
    id<APPlicationDelegate> delegate;
}
@property (nonatomic, retain) NSString *dtoken;
@property (nonatomic, retain) NSString *province;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *LatitudeAndLongitude;
//@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AppStromViewController *viewController;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) showPushAlert *pushAlert;
@property (nonatomic,retain)CommandOperation *commandOper;
@property (nonatomic,retain) UpdateAppAlert *updateAlert;
@property (nonatomic,assign) id<APPlicationDelegate> delegate;

- (NSString*)getMacAddress;

@end

