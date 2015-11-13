//
//  addServiceViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-9-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "addServiceViewController.h"
#import "mapViewController.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
#import "Common.h"
#import "alertView.h"
#import "RegexKitLite.h"
#import "BaiduMapViewController.h"
#import "AppStromAppDelegate.h"

#define FIRST_TEXTFIELD_TAG 101
#define LAST_TEXTFIELD_TAG 105
#define GETPIC_TAG 100
#define SHOWMAP_TAG 99
@implementation addServiceViewController
@synthesize photo;
@synthesize actionsheet;
@synthesize addinfo;
@synthesize adddelegate;
@synthesize getPic;
@synthesize currentTextFieldTag;
@synthesize isShowMap;
@synthesize isEditing;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
	self.title = @"编辑信息";
	isEdit = NO;
	UIBarButtonItem *mrightbto = [[UIBarButtonItem alloc]
								  initWithTitle:@"确定"
								  style:UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(handleAdd:)];
	self.navigationItem.rightBarButtonItem = mrightbto;
	[mrightbto release];
	if (addinfo != nil && addinfo.csPic.length > 1) {
		UIImage *image = [FileManager getPhoto:addinfo.csPic];
		self.photo = [image fillSize:CGSizeMake(80, 80)];
		UIButton *bto = (UIButton*)[self.view viewWithTag:GETPIC_TAG];
		[bto setImage:photo forState:UIControlStateNormal];
	}
	for (int tag = FIRST_TEXTFIELD_TAG; tag <= LAST_TEXTFIELD_TAG; tag++) {
		UITextField *tempTextField = [self.view viewWithTag:tag];
		if (addinfo != nil) {
			isEdit = YES;
			switch (tag) {
				case 101:
					tempTextField.text = addinfo.csName;
					break;
				case 102:
					tempTextField.text = addinfo.csPhone;
					break;
				case 103:
					tempTextField.text = addinfo.csAreaCode;
					break;
				case 104:
					tempTextField.text = addinfo.csMail;
					break;
				case 105:
					tempTextField.text = addinfo.csAddress;
					break;
				default:
					break;
			}
			
		}
		[tempTextField addTarget:self 
						  action:@selector(textFieldDone:) 
				forControlEvents:UIControlEventEditingDidEndOnExit]; 
	}
	if (self.addinfo == nil) {
		csInfo *inf = [[csInfo alloc]init];
		self.addinfo = inf;
		[inf release];
	}
	UIButton *showMapBto = [self.view viewWithTag:SHOWMAP_TAG];
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"标准地图" ofType:@"png"]];
	[showMapBto setImage:img forState:UIControlStateNormal];
	[img release];
	
	UIImage *img1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"标准地图选中" ofType:@"png"]];
	[showMapBto setImage:img1 forState:UIControlStateSelected];
	[img1 release];
}
-(void)handleAdd:(id)sender{
	bool addit = NO;
	bool mobileAlert  = NO;
	bool phoneAlert  = NO;
	bool nameAlert = NO;
	if (addinfo.csPic.length > 1) {
		addit = YES;
	}
	else {
		addinfo.csPic = @"";
	}

	for (int tag = FIRST_TEXTFIELD_TAG; tag <= LAST_TEXTFIELD_TAG; tag++) {
		UITextField *tempTextField = [self.view viewWithTag:tag];
		switch (tag) {
			case 101:
				addinfo.csName = tempTextField.text;
				if ([addinfo.csName length] != 0) {
					addit = YES;
					
				}else {
					[alertView showAlert:@"名称不能为空"];
					nameAlert = YES;
					[tempTextField becomeFirstResponder];
					addit = NO;
				}
				
				break;
			case 102:
				addinfo.csPhone = tempTextField.text;
				if ([addinfo.csPhone length] > 0) {
					if ([addinfo.csPhone length] > 4 && [addinfo.csPhone length] < 12) {
						
					}else {
						addit = NO;
						if (!nameAlert) {
							[alertView showAlert:@"请输入正确的手机号码"];
							[tempTextField becomeFirstResponder];
						}
						mobileAlert = YES;
					}
				}
				break;
			case 103:
				addinfo.csAreaCode = tempTextField.text;
				if ([addinfo.csAreaCode length] > 0) {
					if ([addinfo.csAreaCode length] > 4 && [addinfo.csAreaCode length] < 13) {
						
					}else {
						addit = NO;
						if (!mobileAlert) {
							[alertView showAlert:@"请输入正确的电话号码"];
							[tempTextField becomeFirstResponder];
						}
						phoneAlert = YES;
						
					}
				}
				break;
			case 104:
				addinfo.csMail = tempTextField.text;
				if ([addinfo.csMail length] > 0) {
					if ([addinfo.csMail isMatchedByRegex:EMAILMATCHSTRING]) {
						NSLog(@"right email string");
					}else{
						if (!mobileAlert && !nameAlert && !phoneAlert) {
							[alertView showAlert:@"邮箱格式错误"];
							[tempTextField becomeFirstResponder];
							addit = NO;
						}
					}
				}
				break;
			case 105:
				addinfo.csAddress = tempTextField.text;
				if ([addinfo.csAddress length] > 0) {
					if (!isShowMap && !isEditing) {
						[alertView showAlert:@"请标注位置"];
						addit = NO;
					}
				}else{
					
				}
				break;
			default:
				break;
				
		}
	}
	if (addit) {
		if (isEdit) {
			[DBOperate deleteData:T_MYSERVICE tableColumn:@"id" columnValue:[NSNumber numberWithInt:addinfo.csId]];
		}
		if (addinfo.csCoordinate == nil || addinfo.csCoordinate.length < 0) {
			NSLog(@"addinfo.csCoordinate is nil");
			addinfo.csCoordinate = @"";
			[self findme];
		}

		NSArray *ar_addinf = [[NSArray alloc]initWithObjects:addinfo.csPic,addinfo.csName,addinfo.csPhone,addinfo.csAreaCode,addinfo.csMail,addinfo.csAddress,addinfo.csCoordinate,nil];
		NSLog(@"%d",[ar_addinf count]);
		[DBOperate insertData:ar_addinf tableName:T_MYSERVICE];
		[ar_addinf release];
		[adddelegate add:addinfo];
		[self.navigationController popViewControllerAnimated:YES];
	}
	
}

- (void) actionSheetAppear:(int)actionID actionSheet:(UIActionSheet *)actionSheet{
	
}

- (void)getChoosedIndex:(int)actionID chooseIndex:(int)index{
	GetPicture *getp = [[GetPicture alloc]initWith:self.navigationController delegate:self];
	self.getPic = getp;
	[getp release];
	if (index == 0) {
		[getPic getCameraPicture:self.view];
		
	}
	else {
		[getPic selectExistingPicture:self.view];
	}
	
}
-(IBAction)getPic:(id)sender{
//	for (int i = 101; i < 106; i++) {
//		UITextField *one = (UITextField *)[self.view viewWithTag:i];
//		[self textFieldShouldReturn:one];
//	}
	[self hideKeyboard];
    
	if (self.actionsheet== nil) {
		manageActionSheet *action = [[manageActionSheet alloc]initActionSheetWithStrings:[NSArray arrayWithObjects:@"拍摄照片",@"选择照片",nil]];
		action.manageDeleage = self;
		self.actionsheet = action;
		[action release];
	}
    
    AppStromAppDelegate *delegate = (AppStromAppDelegate *)[[UIApplication sharedApplication] delegate];
	[actionsheet showActionSheet:delegate.window];
}
-(IBAction)showMap:(id)sender{
//	isShowMap = YES;
//	mapViewController *map = [[mapViewController alloc]initWithNibName:@"mapViewController" bundle:nil];
//	map.addressDelegate = self;
//	map.mymapType = EDITE_MAP_TYPE;
//	[self.navigationController pushViewController:map animated:YES];
//	if(addinfo.csCoordinate.length > 1){
//		[map LocateAddrByCoord:addinfo.csCoordinate];
//	}else {
//		UITextField *addrTf = [self.view viewWithTag:105];
//		NSLog(addrTf.text);
//		[map LocateAddress:addrTf.text];
//	}
//	[map release];
    
//    isShowMap = YES;
//    
//    BaiduMapViewController *baiduMap = [[BaiduMapViewController alloc] init];
//    baiduMap.isEdit = YES;
//    baiduMap.isChange = YES;
//    baiduMap.mapDelegate = self;
//    baiduMap.showType = includePressPoint;
////    baiduMap.showSelf = 999;
//    [self.navigationController pushViewController:baiduMap animated:YES];
//    if(addinfo.csCoordinate.length > 1){
//		[baiduMap onClickGeocode:addinfo.csCoordinate];
//	}else {
//		UITextField *addrTf = (UITextField *)[self.view viewWithTag:105];
//		[baiduMap onClickGeocode:addrTf.text];
//	}
    
    isShowMap = YES;
    
    BaiduMapViewController *baiduMap = [[BaiduMapViewController alloc] init];
    baiduMap.isEdit = YES;
    baiduMap.isChange = YES;
    baiduMap.mapDelegate = self;
    [self.navigationController pushViewController:baiduMap animated:YES];
    if(addinfo.csCoordinate.length > 1){
        [baiduMap onClickGeocode:addinfo.csCoordinate];
    }else {
        UITextField *addrTf = (UITextField *)[self.view viewWithTag:105];
        [baiduMap onClickGeocode:addrTf.text];
    }

}

-(IBAction)showMapByCoord:(id)sender{
	mapViewController *map = [[mapViewController alloc]initWithNibName:@"mapViewController" bundle:nil];
	map.mymapType = SHOW_MAP_TYPE;
	map.addressDelegate = nil;
	[self.navigationController pushViewController:map animated:YES];
	if(addinfo.csCoordinate.length > 1){
		[map LocateAddrByCoord:addinfo.csCoordinate];
	}else{
		[self findme];
	}

	[map release];
}


- (void) findme
{
	//CLLocationManager *locM = [[CLLocationManager alloc]init];
	//self.locManager = locM;
	//[locM release];
	if(locManager == nil){
		locManager = [[CLLocationManager alloc] init];
	}
	if (!locManager.locationServicesEnabled)
	{
		NSLog(@"User has opted out of location services");
		return;
	}
	else 
	{
		locManager.desiredAccuracy = kCLLocationAccuracyBest;
		locManager.delegate = self;
		[locManager startUpdatingLocation];
	}
	
	
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSString *coordinateString = [NSString stringWithFormat:@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
	addinfo.csCoordinate = coordinateString;
	locManager.delegate = nil;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{		
	
	[manager stopUpdatingLocation]; 
	manager.delegate = nil; 
	[manager release]; 
	manager = nil;
	addinfo.csCoordinate = @"";
}

-(void)getMarkAddress:(NSString*)str_addr{

	UITextField *addrTf = (UITextField *)[self.view viewWithTag:105];
	addrTf.text = str_addr;
}

-(void)getMarkCoordinate:(NSString*)str_coordinate{
	NSLog(str_coordinate);
	addinfo.csCoordinate = str_coordinate;
}

-(void)getPicture:(UIImage*)image{
	NSLog(@"getpicture");
	self.photo = [image fillSize:CGSizeMake(80, 80)];
	NSString *photoname = [callSystemApp getCurrentTime];
	if([FileManager savePhoto:photoname withImage:photo])
	{
		[FileManager removeFile:addinfo.csPic];
		addinfo.csPic = photoname;
	}	
	
	UIButton *bto = (UIButton*)[self.view viewWithTag:GETPIC_TAG];
	[bto setImage:photo forState:UIControlStateNormal];
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark Text Field Delegate Methods
-(IBAction)textFieldDone:(id)sender {
	UITextField *tempTextField = sender;
	
	if (tempTextField.tag == LAST_TEXTFIELD_TAG) {
		tempTextField = [self.view viewWithTag:FIRST_TEXTFIELD_TAG];
	}
	else {
		tempTextField = [self.view viewWithTag:(tempTextField.tag+1)];
	}
	
    [tempTextField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
	float viewup = 0;
	currentTextFieldTag = textField.tag;
	switch (textField.tag) {
		case 101:
			break;
		case 102:
		case 103:
        {
            if (IOS_VERSION >= 7.0){
                viewup = -70+64;
            }else{
                viewup = -70;
            }
        }
			break;
		case 104:
		case 105:
        {
            if (IOS_VERSION >= 7.0){
                viewup = -140+64;
            }else{
                viewup = -140;
            }
        }
			break;
		default:
			break;
	}
	NSTimeInterval animationDuration = 0.30f;
	[UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
	
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationDelegate:self];
	float width = self.view.frame.size.width;		
	float height = self.view.frame.size.height;
	CGRect rect = CGRectMake(0.0f, viewup,width,height);
	self.view.frame = rect;
	[UIView commitAnimations];
	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if(textField.tag == LAST_TEXTFIELD_TAG){
		[textField resignFirstResponder];
		
		NSTimeInterval animationDuration = 0.30f;
		[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
		[UIView setAnimationDuration:animationDuration];
		CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
		self.view.frame = rect;
		[UIView commitAnimations];
		return YES;
	}
	else{
		NSInteger nextTag = textField.tag + 1;
		UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
		if (nextResponder) {
			[nextResponder becomeFirstResponder];
		} else {
			[textField resignFirstResponder];
		}
		return NO; // We do not want UITextField to insert line-breaks.
	}
	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self hideKeyboard];
}

-(void)hideKeyboard

{
	UITextField *textField = [self.view viewWithTag:currentTextFieldTag];
	[textField resignFirstResponder];
	NSTimeInterval animationDuration = 0.30f;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    if (IOS_VERSION >= 7.0){
        rect = CGRectMake(0.0f, 64, self.view.frame.size.width, self.view.frame.size.height);
    }
	self.view.frame = rect;
	[UIView commitAnimations];
	
	//return YES;
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.addinfo = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.photo = nil;
	self.actionsheet = nil;
	self.addinfo = nil;
	self.getPic = nil;
	//locManager.delegate = nil;
    [super dealloc];
}


@end
