//
//  mapViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-9-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#define SHOW_MAP_TYPE 1
#define EDITE_MAP_TYPE 2
@protocol getAddressString

-(void)getMarkAddress:(NSString*)str_addr;
-(void)getMarkCoordinate:(NSString*)str_coordinate;

@end

@interface mapViewController : UIViewController {

	//CLLocationManager *locManager;
	CLLocationCoordinate2D daddrLocation;
	CLLocation *current;
	MKMapView *mapView;
	UITextField *searchFiled;
	id<getAddressString> addressDelegate;
	int mymapType;
	NSString *strAddress;
	MapAnnotation* pointAnnotationForRemove;
	NSString *curAddress;
}
@property(nonatomic,retain)IBOutlet MKMapView *mapView;
@property(nonatomic,retain)IBOutlet UITextField *searchFiled;
@property(nonatomic,retain)NSString *strAddress;
@property(nonatomic,retain)NSString *curAddress;
@property(nonatomic,assign)int mymapType;
//@property (retain) CLLocationManager *locManager;
@property (nonatomic,retain) CLLocation *current;
@property(nonatomic,assign)id<getAddressString> addressDelegate;
@property (nonatomic,retain)MapAnnotation* pointAnnotationForRemove;
@property (nonatomic) CLLocationCoordinate2D daddrLocation;
-(void)LocateAddress:(NSString*)addre;
- (void)LocateAddrByCoord : (NSString*)coordString;
-(IBAction)HandleSearch:(id)sender;

@end
