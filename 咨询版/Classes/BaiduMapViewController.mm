//
//  BaiduMapViewController.m
//  information
//
//  Created by 来 云 on 12-10-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaiduMapViewController.h"
#import "Common.h"
#import <MapKit/MapKit.h>

#define MYBUNDLE_NAME @"mapapi.bundle"

#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]

#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface BaiduMapViewController ()

@end

@implementation BaiduMapViewController
@synthesize mapView = _mapView;
@synthesize textField = _textField;
@synthesize textField1 = _textField1;
@synthesize searchBtn = _searchBtn;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize mapDelegate;
@synthesize pointAnnotationForRemove;
@synthesize isEdit = _isEdit;
@synthesize isChange = _isChange;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"百度地图";
    
    if (_isEdit == NO) {
        UIBarButtonItem *mrightbto = [[UIBarButtonItem alloc]
                                      initWithTitle:@"系统地图导航"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(handleSystemMap:)];
        self.navigationItem.rightBarButtonItem = mrightbto;
        [mrightbto release];
    }
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.tintColor = [UIColor grayColor];
    [self.view addSubview:toolbar];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(7, 7, 66, 31)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.placeholder = @"城市";
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    [toolbar addSubview:_textField];
    
    _textField1 = [[UITextField alloc] initWithFrame:CGRectMake(22+55, 7, 223-66, 31)];
    _textField1.borderStyle = UITextBorderStyleRoundedRect;
    _textField1.placeholder = @"输入具体地址";
    _textField1.delegate = self;
    _textField1.returnKeyType = UIReturnKeyDone;
    [toolbar addSubview:_textField1];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _searchBtn.frame = CGRectMake(245, 7, 66, 30);
    _searchBtn.titleLabel.textColor = [UIColor blackColor];
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"地图搜索按钮.png"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:_searchBtn];
    
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height)];
    [self.view addSubview:_mapView];
    
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    _locService.delegate = self;
    
    _geoSearch = [[BMKGeoCodeSearch alloc] init];
    
    if (_isChange == YES) {
        UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
        lpress.allowableMovement = 10.0;
        [_mapView addGestureRecognizer:lpress];//m_mapView是MKMapView的实例
        [lpress release];
    }
    
    if (self.longitude == 0 || self.latitude == 0) {
        self.latitude = myLocation.latitude;
        self.longitude = myLocation.longitude;
    }
    
//    [self onClickReverseGeocode];
    
    if (self.showType == OnlyShowPoint) {
        _panPoint = [[BMKPointAnnotation alloc]init];
        [_mapView addAnnotation:_panPoint];
        
        [self onClickGeocode:self.searchLocationStr];
    }
    
}

//新的百度地图在这里释放内存。
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    _mapView.delegate = self;
    _geoSearch.delegate =self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    _mapView.delegate = nil;
    _geoSearch.delegate = nil;
}

- (void)handleSystemMap:(id)sender{
    NSLog(@"systmemap.......");
    
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
    //                                                [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
    //                                                 myLocation.latitude,myLocation.longitude ,self.latitude,self.longitude]]];
    
    //调用自带地图（定位）
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    //显示目的地坐标。画路线
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[[MKPlacemark alloc] initWithCoordinate:_panPoint.coordinate addressDictionary:nil] autorelease]];
    toLocation.name = self.searchLocationStr;
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                   launchOptions:[NSDictionary dictionaryWithObjects:
                                  [NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                             forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    
    [toLocation release];
    
    
}

-(void)buttonPressed{
    [self.textField resignFirstResponder];
    [self.textField1 resignFirstResponder];
    
    if (self.textField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"城市名不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    self.searchLocationStr = [NSString stringWithFormat:@"%@%@",self.textField.text,self.textField1.text];
    
    [self onClickGeocode:self.searchLocationStr];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)onClickReverseGeocode
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    
    pt = (CLLocationCoordinate2D){self.latitude, self.longitude};
    
    //	BOOL flag = [_search reverseGeocode:pt];
    //	if (!flag) {
    //		NSLog(@"search failed!");
    //	}
    
    //    BMKCoordinateRegion region = BMKCoordinateRegionMake(pt, BMKCoordinateSpanMake(0.01, 0.01));
    //    [_mapView setRegion:region animated:YES];
}

-(void)onClickGeocode:(NSString *)str
{//devin
    //    if (str.length == 0) {
    //        BOOL flag = [_search geocode:self.textField1.text withCity:self.textField.text];
    //        if (!flag) {
    //            NSLog(@"search>> failed!");
    //        }else {
    //            NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    //            [_mapView removeAnnotations:array];
    //            array = [NSArray arrayWithArray:_mapView.overlays];
    //            [_mapView removeOverlays:array];
    //        }
    //    }else {
    //        BOOL flag = [_search geocode:str withCity:nil];
    //        if (!flag) {
    //            NSLog(@"search>> failed!");
    //        }else {
    //            NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    //            [_mapView removeAnnotations:array];
    //            array = [NSArray arrayWithArray:_mapView.overlays];
    //            [_mapView removeOverlays:array];
    //        }
    //    }
    if (str.length == 0) {
        
//        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){22.509143, 113.929212};
//        BMKCoordinateRegion region = BMKCoordinateRegionMake(pt,BMKCoordinateSpanMake(0.05,0.05));
//        [_mapView setRegion:region animated:YES];
        
        return;
    } else {
        BMKGeoCodeSearchOption *geoOption = [[BMKGeoCodeSearchOption alloc]init];
        geoOption.address = str;
        BOOL flag = [_geoSearch geoCode:geoOption];
        if (!flag) {
            NSLog(@"search>> failed!");
        }
        [geoOption release];
    }
}

//搜索位置回调
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    NSLog(@"搜索回调的信息纬度 = %f 经度 = %f 地理位置 = %@",result.location.latitude,result.location.longitude,result.address);
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){result.location.latitude, result.location.longitude};
    BMKCoordinateRegion region = BMKCoordinateRegionMake(pt,BMKCoordinateSpanMake(0.05,0.05));
    [_mapView setRegion:region animated:YES];
    
    if (self.showType == OnlyShowPoint) {
        [_mapView deselectAnnotation:_panPoint animated:NO];
        _panPoint.title = result.address;;
        _panPoint.coordinate = pt;
        [_mapView addAnnotation:_panPoint];
    } else {
        
        if (mapDelegate) {
            [mapDelegate getMarkAddress:result.address];
        }
        
        [_mapView deselectAnnotation:_panPoint animated:NO];
        _panPoint.coordinate = pt;
        _panPoint.title = result.address;
        [_mapView addAnnotation:_panPoint];
    }
}

//devin
//- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
//{
//	if (error == 0) {
//		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//		item.coordinate = result.geoPt;
//		item.title = result.strAddr;
//		[_mapView addAnnotation:item];
//		[item release];
//
//		if (mapDelegate != nil) {
//            [mapDelegate getMarkAddress:result.strAddr];
//        }
//
//        BMKCoordinateRegion region = BMKCoordinateRegionMake(result.geoPt, BMKCoordinateSpanMake(0.01, 0.01));
//        [_mapView setRegion:region animated:YES];
//	}
//}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"开始更新位置");
    [_locService stopUserLocationService];
    [_mapView updateLocationData:userLocation];
    
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    
    if (_isChange == YES) {
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.latitude, self.longitude};
        
        BMKCoordinateRegion region = BMKCoordinateRegionMake(pt,BMKCoordinateSpanMake(0.05,0.05));
        [_mapView setRegion:region animated:YES];
        
        _panPoint = [[BMKPointAnnotation alloc]init];
        _panPoint.title = @"自己的位置";
        _panPoint.coordinate = pt;
        [_mapView addAnnotation:_panPoint];
    }
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//反编译回调
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    //气泡消失
    [_mapView deselectAnnotation:_panPoint animated:NO];
    _panPoint.title = result.address;
    [_mapView addAnnotation:_panPoint];
    
    if (mapDelegate) {
        [mapDelegate getMarkAddress:result.address];
    }
}

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        return;
    }
    
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
    _panPoint.coordinate = touchMapCoordinate;
    
    BMKReverseGeoCodeOption *revOption = [[BMKReverseGeoCodeOption alloc]init];
    revOption.reverseGeoPoint = touchMapCoordinate;
    [_geoSearch reverseGeoCode:revOption];
    [revOption release];
    
    //#ifdef IOS4
    //	BMKPointAnnotation *pointAnnotation1 = nil;
    //	pointAnnotation1 = [[BMKPointAnnotation alloc] init];
    //    pointAnnotation1.coordinate = touchMapCoordinate;
    //#endif
    ////	[_search reverseGeocode:touchMapCoordinate];
    //
    //#ifdef IOS4
    //
    //    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    //	[_mapView removeAnnotations:array];
    //	array = [NSArray arrayWithArray:_mapView.overlays];
    //	[_mapView removeOverlays:array];
    //	[_mapView addAnnotation:pointAnnotation1];
    //	[pointAnnotation1 release];
    //#endif
}

- (void)dealloc {
    
    self.searchLocationStr = nil;
    [_geoSearch release];
    [_locService release];
    [_panPoint release];
    [_mapView release];
    //    [_search release];
    [_textField1 release];
    [_textField release];
    [_searchBtn release];
    [pointAnnotationForRemove release];
    [super dealloc];
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.navigationItem.title = @"百度地图";
//    
//    if (_isEdit == NO) {
//        UIBarButtonItem *mrightbto = [[UIBarButtonItem alloc]
//                                      initWithTitle:@"系统地图导航"
//                                      style:UIBarButtonItemStyleBordered
//                                      target:self
//                                      action:@selector(handleSystemMap:)];
//        self.navigationItem.rightBarButtonItem = mrightbto;
//        [mrightbto release];
//    }
//    
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    toolbar.tintColor = [UIColor grayColor];
//    [self.view addSubview:toolbar];
//    
//    _textField = [[UITextField alloc] initWithFrame:CGRectMake(7, 7, 66, 31)];
//    _textField.borderStyle = UITextBorderStyleRoundedRect;
//    _textField.placeholder = @"城市";
//    _textField.delegate = self;
//    _textField.returnKeyType = UIReturnKeyDone;
//    [toolbar addSubview:_textField];
//    
//    _textField1 = [[UITextField alloc] initWithFrame:CGRectMake(22+55, 7, 223-66, 31)];
//    _textField1.borderStyle = UITextBorderStyleRoundedRect;
//    _textField1.placeholder = @"输入具体地址";
//    _textField1.delegate = self;
//    _textField1.returnKeyType = UIReturnKeyDone;
//    [toolbar addSubview:_textField1];
//    
//    _searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _searchBtn.frame = CGRectMake(245, 7, 66, 30);
//    _searchBtn.titleLabel.textColor = [UIColor blackColor];
//    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"地图搜索按钮.png"] forState:UIControlStateNormal];
//    [_searchBtn addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [toolbar addSubview:_searchBtn];
//    
//    
//    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height)];
//    [self.view addSubview:_mapView];
//    
//    _locService = [[BMKLocationService alloc]init];
//    [_locService startUserLocationService];
//    _locService.delegate = self;
//    
//    _geoSearch = [[BMKGeoCodeSearch alloc] init];
//    
//    if (_isChange == YES) {
//        UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//        lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
//        lpress.allowableMovement = 10.0;
//        [_mapView addGestureRecognizer:lpress];//m_mapView是MKMapView的实例
//        [lpress release];
//    }
//    
//    if (self.longitude == 0 || self.latitude == 0) {
//        self.latitude = myLocation.latitude;
//        self.longitude = myLocation.longitude;
//    }
//    
////    [self onClickReverseGeocode];
//    
//
//    
//    if (self.showType == includePressPoint) {
//        _panPoint = [[BMKPointAnnotation alloc]init];
//        [_mapView addAnnotation:_panPoint];
//      
//    } else if (self.showType == OnlyShowPoint){
//        if (self.latitude > 0 && self.latitude > 0) {
//            NSLog(@"目标");
//        }else {
//            NSLog(@"自定义");
//            self.latitude = 22.548604;
//            self.longitude = 114.064515;
//        }
//        CLLocationCoordinate2D location = (CLLocationCoordinate2D){self.latitude, self.longitude};
//        BMKCoordinateRegion region = BMKCoordinateRegionMake(location,BMKCoordinateSpanMake(0.05,0.05));
//        [_mapView setRegion:region animated:YES];
//        
//        _locPoint = [[BMKPointAnnotation alloc]init];
//        _locPoint.title = self.searchLocationStr;
//        _locPoint.coordinate = location;
//        [_mapView addAnnotation:_locPoint];
//        
////        if (self.searchLocationStr.length == 0) {
////            self.searchLocationStr = @"深圳";
////        }
////        [self onClickGeocode:self.searchLocationStr];
//    }
//}
//
////新的百度地图在这里释放内存。
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    _mapView.delegate = self;
//    _geoSearch.delegate =self;
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:YES];
//    _mapView.delegate = nil;
//    _geoSearch.delegate = nil;
//}
//
//- (void)handleSystemMap:(id)sender{
//    NSLog(@"systmemap.......");
//    
////    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
////                                                [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
////                                                 myLocation.latitude,myLocation.longitude ,self.latitude,self.longitude]]];
//    //调用自带地图（定位）
//    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//    //显示目的地坐标。画路线
//    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[[MKPlacemark alloc] initWithCoordinate:_panPoint.coordinate addressDictionary:nil] autorelease]];
//    toLocation.name = self.searchLocationStr;
//    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
//                   launchOptions:[NSDictionary dictionaryWithObjects:
//                                  [NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
//                                                             forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
//    
//    [toLocation release];
//}
//
//-(void)buttonPressed{
//    [self.textField resignFirstResponder];
//    [self.textField1 resignFirstResponder];
//    
//    if (self.textField.text.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"城市名不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        return;
//    }
//    
//    self.searchLocationStr = [NSString stringWithFormat:@"%@%@",self.textField.text,self.textField1.text];
//    
//    [self onClickGeocode:self.searchLocationStr];
//    
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
//
//-(void)onClickReverseGeocode
//{
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    array = [NSArray arrayWithArray:_mapView.overlays];
//    [_mapView removeOverlays:array];
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
//    
//    pt = (CLLocationCoordinate2D){self.latitude, self.longitude};
//    
//    //	BOOL flag = [_search reverseGeocode:pt];
//    //	if (!flag) {
//    //		NSLog(@"search failed!");
//    //	}
//    
////    BMKCoordinateRegion region = BMKCoordinateRegionMake(pt, BMKCoordinateSpanMake(0.05, 0.05));
////    [_mapView setRegion:region animated:YES];
//}
//
//-(void)onClickGeocode:(NSString *)str
//{
//    NSLog(@"str ============ %@",str);
//    
//    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    NSLog(@"_textField1 = %@,textField = %@",_textField1.text,_textField.text);
//    
//    geoCodeSearchOption.city= _textField.text;
//    geoCodeSearchOption.address = _textField1.text;
//    BOOL flag = [_geoSearch geoCode:geoCodeSearchOption];
//    if(flag)
//    {
//        NSLog(@"geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"geo检索发送失败");
//    }
//    [geoCodeSearchOption release];
//
//}
//
////搜索位置回调
//- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
//
//    NSLog(@"arror = %d",error);
//    
//    NSLog(@"搜索回调的信息纬度 = %f 经度 = %f 地理位置 = %@",result.location.latitude,result.location.longitude,result.address);
//    
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){result.location.latitude, result.location.longitude};
//    BMKCoordinateRegion region = BMKCoordinateRegionMake(pt,BMKCoordinateSpanMake(0.05,0.05));
//    [_mapView setRegion:region animated:YES];
//    
//    if (self.showType == OnlyShowPoint) {
////        [_mapView deselectAnnotation:_panPoint animated:NO];
////        _panPoint.title = result.address;;
////        _panPoint.coordinate = pt;
////        [_mapView addAnnotation:_panPoint];
//        
//        [_mapView deselectAnnotation:_locPoint animated:NO];
//        _locPoint.title = result.address;
//        _locPoint.coordinate = pt;
//        [_mapView addAnnotation:_locPoint];
//    } else {
//        if (mapDelegate) {
//            [mapDelegate getMarkAddress:result.address];
//        }
//        
//        [_mapView deselectAnnotation:_panPoint animated:NO];
//        _panPoint.coordinate = pt;
//        _panPoint.title = result.address;
//        [_mapView addAnnotation:_panPoint];
//    }
//}
//
////devin
////- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
////{
////	if (error == 0) {
////		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
////		item.coordinate = result.geoPt;
////		item.title = result.strAddr;
////		[_mapView addAnnotation:item];
////		[item release];
////
////		if (mapDelegate != nil) {
////            [mapDelegate getMarkAddress:result.strAddr];
////        }
////
////        BMKCoordinateRegion region = BMKCoordinateRegionMake(result.geoPt, BMKCoordinateSpanMake(0.01, 0.01));
////        [_mapView setRegion:region animated:YES];
////	}
////}
//
//- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation {
//    NSLog(@"开始更新位置");
//    [_locService stopUserLocationService];
//    [_mapView updateLocationData:userLocation];
//    
//    NSLog(@"=== %f===%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    
//    self.latitude = userLocation.location.coordinate.latitude;
//    self.longitude = userLocation.location.coordinate.longitude;
//   
//    if (self.showType == includePressPoint) {
//        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.latitude, self.longitude};
//        
//        BMKCoordinateRegion region = BMKCoordinateRegionMake(pt,BMKCoordinateSpanMake(0.05,0.05));
//        [_mapView setRegion:region animated:YES];
//        _panPoint = [[BMKPointAnnotation alloc]init];
//        _panPoint.title = @"自己的位置";
//        _panPoint.coordinate = pt;
//        [_mapView addAnnotation:_panPoint];
//    }
//    
//}
//
//- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    static NSString *AnnotationViewID = @"annotationViewID";
//    
//    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//    if (annotationView == nil) {
//        annotationView = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
//        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
//        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
//    }
//    
//    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
//    annotationView.annotation = annotation;
//    annotationView.canShowCallout = TRUE;
//    return annotationView;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
////反编译回调
//- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
//    //气泡消失
//    [_mapView deselectAnnotation:_panPoint animated:NO];
//    _panPoint.title = result.address;
//    [_mapView addAnnotation:_panPoint];
//    
//    if (mapDelegate) {
//        [mapDelegate getMarkAddress:result.address];
//    }
//}
//
//- (void)longPress:(UIGestureRecognizer*)gestureRecognizer{
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
//        return;
//    }
//    
//    //坐标转换
//    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
//    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
//    
//    _panPoint.coordinate = touchMapCoordinate;
//    
//    BMKReverseGeoCodeOption *revOption = [[BMKReverseGeoCodeOption alloc]init];
//    revOption.reverseGeoPoint = touchMapCoordinate;
//    [_geoSearch reverseGeoCode:revOption];
//    [revOption release];
//    
//    //#ifdef IOS4
//    //	BMKPointAnnotation *pointAnnotation1 = nil;
//    //	pointAnnotation1 = [[BMKPointAnnotation alloc] init];
//    //    pointAnnotation1.coordinate = touchMapCoordinate;
//    //#endif
//    ////	[_search reverseGeocode:touchMapCoordinate];
//    //
//    //#ifdef IOS4
//    //
//    //    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    //	[_mapView removeAnnotations:array];
//    //	array = [NSArray arrayWithArray:_mapView.overlays];
//    //	[_mapView removeOverlays:array];
//    //	[_mapView addAnnotation:pointAnnotation1];
//    //	[pointAnnotation1 release];
//    //#endif
//}
//
//- (void)dealloc {
//    
//    self.searchLocationStr = nil;
//    [_geoSearch release];
//    [_locService release];
//    [_locPoint release];
//    [_panPoint release];
//    [_mapView release];
//    //    [_search release];
//    [_textField1 release];
//    [_textField release];
//    [_searchBtn release];
//    [pointAnnotationForRemove release];
//    [super dealloc];
//}


@end
