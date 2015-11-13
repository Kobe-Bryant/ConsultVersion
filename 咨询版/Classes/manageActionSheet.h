//
//  manageActionSheet.h
//  AppStrom
//
//  Created by 掌商 on 11-8-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DismissBlock) ();

@protocol commandOperationDelegate
- (void)getChoosedIndex:(int)actionID chooseIndex:(int)index;
- (void) actionSheetAppear:(int)actionID actionSheet:(UIActionSheet *)actionSheet;
@end

@interface manageActionSheet : NSObject {
	NSArray *arr_menu;
	id<commandOperationDelegate> manageDeleage;
	int actionID;
}
@property(nonatomic,retain)NSArray *arr_menu;
@property(nonatomic,assign)id<commandOperationDelegate> manageDeleage;
@property(nonatomic)int actionID;

@property (nonatomic,copy) DismissBlock block;


-(id)initActionSheetWithStrings:(NSArray*)strArray;
-(void)showActionSheet:(id)sender;
@end
