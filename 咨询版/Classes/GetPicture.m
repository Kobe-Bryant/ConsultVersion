//
//  GetPicture.m
//  飞飞Q信
//
//  Created by Eamon.Lin on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GetPicture.h"
//#import "LocalFileManage.h"

@implementation GetPicture
@synthesize viewController;
@synthesize contentDelegate;
-(id)initWith:(id)controller delegate:(id)delegate
{
	if (self = [super init]) {
		self.contentDelegate = delegate;
		self.viewController = controller;
		
	}
	return self;
}
- (void)getCameraPicture:(id) sender{
	if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *picker =
		[[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsImageEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[viewController presentModalViewController:picker animated:YES];
		[picker release];
	}
    
}
- (void)selectExistingPicture:(id) sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsImageEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [viewController presentModalViewController:picker animated:YES];
        [picker release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error accessing photo library" 
                              message:@"Device does not support a photo library" 
                              delegate:nil 
                              cancelButtonTitle:@"Drat!" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
#pragma mark  -
- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
	NSLog(@"has get piture %@",image);
	UIImage *picForSend = image;[editingInfo objectForKey:UIImagePickerControllerOriginalImage];
	[contentDelegate getPicture:picForSend];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
    
    [picker dismissModalViewControllerAnimated:YES];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	// self.image1 = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] intValue]>=7) {
        [navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    }
}
-(void)dealloc{

	self.viewController = nil;
	[super dealloc];
}

@end
