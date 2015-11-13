//
//  CommandOperation.h
//  AppStrom
//
//  Created by 掌商 on 11-9-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol commandOperationDelegate
- (void)didFinishCommand:(id)resultArray withVersion:(int)ver;
@end
@interface CommandOperation : NSOperation {

	NSString *reqStr;
	int command;
	id <commandOperationDelegate> delegate;
	NSDictionary* requestParam;
}
@property(nonatomic,retain)NSString *reqStr;
@property(nonatomic,assign)id <commandOperationDelegate> delegate;
@property(nonatomic,retain) NSDictionary* requestParam;
- (id)initWithReqStr:(NSString*)rstr command:(int)cmd delegate:(id <commandOperationDelegate>)theDelegate params:(NSDictionary*)param;

@end
