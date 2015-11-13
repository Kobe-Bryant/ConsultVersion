//
//  addCommunityViewController.m
//  AppStrom
//
//  Created by 掌商 on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "addCommunityViewController.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "callSystemApp.h"
#import "AppStromAppDelegate.h"
#import "Common.h"

@implementation addCommunityViewController
@synthesize myDelegate;
@synthesize actionsheet;
@synthesize getPic;
@synthesize addsns;
@synthesize picBto;
@synthesize tfName;
@synthesize tfwebsite;
@synthesize tfexplain;
@synthesize currentTextFieldTag;
//@synthesize myphoto;
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
	
	UIBarButtonItem *mrightbto = [[UIBarButtonItem alloc]
								  initWithTitle:@"确定"
								  style:UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(handleAdd:)];
	self.navigationItem.rightBarButtonItem = mrightbto;
	[mrightbto release];
    
	sns *addsnstmp = [[sns alloc]init];
	self.addsns = addsnstmp;
	[addsnstmp release];
	//self.addsns = [[sns alloc]init];
}
-(void)getPicture:(UIImage*)image{
	image = [image fillSize:CGSizeMake(80, 80)];
	NSLog(@"getpicture11111111 %@ %f height %f",image,image.size.width,image.size.height);
	//self.myphoto = image;
	NSString *photoname = [callSystemApp getCurrentTime];
	if([FileManager savePhoto:photoname withImage:image])
	{
		//[FileManager removeFile:addinfo.csPic];
		addsns.pic = photoname;
		//[DBOperate updateData:T_MYSERVICE tableColumn:@"pic_name" columnValue:photoname conditionColumn:@"id" conditionColumnValue:value];
	}
    
	
	//self.myphoto = [myphoto fillSize:CGSizeMake(80, 80)];
	[picBto setImage:image forState:UIControlStateNormal];
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
    //	for (int i = 1; i < 4; i++) {
    //		UITextField *one = [self.view viewWithTag:i];
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
-(void)handleAdd:(id)sender{
    
	bool addit = NO;
	if (tfName.text.length>0) {
		addsns.Name = tfName.text;
		addit = YES;
	}
	else {
		addsns.Name = @"";
	}
	if (tfwebsite.text.length>0) {
		addsns.url = tfwebsite.text;
		addit = YES;
	}
	else {
		addsns.url = @"";
	}
	if (tfexplain.text.length>0) {
		addsns.explain = tfexplain.text;
		addit = YES;
	}
	else {
		addsns.explain = @"";
	}
    if (addsns.pic == nil) {
		addsns.pic = @"";
	}
	else {
		addit = YES;
	}
	if (addit) {
		NSArray *ar_addinf = [[NSArray alloc]initWithObjects:addsns.Name,addsns.url,addsns.pic,addsns.explain,nil];
		[DBOperate insertData:ar_addinf tableName:T_MYSNS];
		[ar_addinf release];
		[myDelegate add:addsns];
	}
	[self.navigationController popViewControllerAnimated:YES];
	
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
	
	if (tempTextField.tag == 3) {
		tempTextField = (UITextField *)[self.view viewWithTag:1];
	}
	else {
		tempTextField = (UITextField *)[self.view viewWithTag:(tempTextField.tag+1)];
	}
    [tempTextField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    float viewup;
    currentTextFieldTag = textField.tag;
    switch (textField.tag) {
        case 1:
        {
            if (IOS_VERSION >= 7.0){
                viewup = -70+64;
            }else{
                viewup = -70;
            }
        }
            
            break;
        case 2:
        {
            
        }
        case 3:
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
	if(textField.tag == 3){
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
	UITextField *textField = (UITextField *)[self.view viewWithTag:currentTextFieldTag];
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
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.picBto = nil;
	self.tfName = nil;
	self.tfwebsite = nil;
	self.tfexplain = nil;
	self.addsns= nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.actionsheet = nil;
	self.getPic = nil;
	self.addsns = nil;
	self.picBto = nil;
	self.tfName = nil;
	self.tfwebsite = nil;
	self.tfexplain = nil;
	//self.myphoto = nil;
    [super dealloc];
}


@end