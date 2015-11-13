//
//  addCommunityViewController.h
//  AppStrom
//
//  Created by 掌商 on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sns.h"
#import "manageActionSheet.h"
#import "GetPicture.h"
@protocol addDelegate
-(void)add:(sns*)addinf;
@end

@interface addCommunityViewController : UIViewController {

	 UIButton *picBto;
	 UITextField *tfName;
	 UITextField *tfwebsite;
     UITextField *tfexplain;
	//UIImage *myphoto;
	sns *addsns;
	id<addDelegate> myDelegate;
	manageActionSheet *actionsheet;
	GetPicture *getPic;
	int currentTextFieldTag;
}
@property(nonatomic,retain)IBOutlet UIButton *picBto;
@property(nonatomic,retain)IBOutlet UITextField *tfName;
@property(nonatomic,retain)IBOutlet UITextField *tfwebsite;
@property(nonatomic,retain)IBOutlet UITextField *tfexplain;
//@property(nonatomic,retain)UIImage *myphoto;
@property(nonatomic,assign)id<addDelegate> myDelegate;
@property(nonatomic,retain)manageActionSheet *actionsheet;
@property(nonatomic,retain)GetPicture *getPic;
@property(nonatomic,retain)sns *addsns;
@property(nonatomic)int currentTextFieldTag;
-(IBAction)getPic:(id)sender;
@end
