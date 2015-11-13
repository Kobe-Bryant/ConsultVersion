//
//  NdUncaughtExceptionHandler.h
//  szeca
//
//  Created by MC374 on 12-6-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NdUncaughtExceptionHandler : NSObject {

}

+ (void)setDefaultHandler;

+ (NdUncaughtExceptionHandler*)getHandler;

+(void)printException:(NSException*)exception;
@end
