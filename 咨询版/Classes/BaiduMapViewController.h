//
//  BaiduMapViewController.h
//  information
//
//  Created by 来 云 on 12-10-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

typedef NS_ENUM(NSInteger, OnlyShowPointType) {
    OnlyShowPoint,      
    includePressPoint
};

@protocol getAddressDelegate

-(void)getMarkAddress:(NSString*)str_addr;

@end

@interface BaiduMapViewController : UIViewController<BMKMapViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView *_mapView;
    //    BMKSearch *_search;
    UITextField *_textField;
    UITextField *_textField1;
    UIButton *_searchBtn;
    
    BMKLocationService *_locService;
    
    double _latitude;
    double _longitude;
    
    id<getAddressDelegate> mapDelegate;
    BMKPointAnnotation *pointAnnotationForRemove;
    BOOL _isEdit;
    BOOL _isChange;
    
    BMKPointAnnotation *_panPoint;
    
    BMKPointAnnotation *_locPoint;
    
    BMKGeoCodeSearch *_geoSearch;
}
@property (retain, nonatomic)  UITextField *textField;
@property (retain, nonatomic)  UITextField *textField1;
@property (retain, nonatomic)  UIButton *searchBtn;
@property (retain, nonatomic)  BMKMapView *mapView;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, assign)id<getAddressDelegate> mapDelegate;
@property (nonatomic, retain) BMKPointAnnotation *pointAnnotationForRemove;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isChange;

@property (nonatomic, assign) OnlyShowPointType showType;
@property (nonatomic ,copy) NSString *searchLocationStr;

- (void)buttonPressed;
-(void)onClickReverseGeocode;
- (void)onClickGeocode:(NSString *)str;
- (void)longPress:(UIGestureRecognizer*)gestureRecognizer;


@end

