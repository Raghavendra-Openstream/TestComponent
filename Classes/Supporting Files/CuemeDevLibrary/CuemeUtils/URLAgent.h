/*
 * URLAgent.h
 *
 * (C) Copyright 2013, Openstream, Inc. NJ, U.S.A.
 * All rights reserved.
 *
 * This software is confidential and proprietary information of
 * Openstream, Inc. ("Confidential Information"). You shall not disclose
 * such Confidential Information and shall use/possess it only in accordance
 * with the terms of the license/usage agreement you entered into with
 * Openstream, Inc.
 *
 * If you any have questions regarding this matter, please contact legal@openstream.com
 *
 *
 * Created On : Sep 18, 2013
 *
 */

#import <Foundation/Foundation.h>

#import "IURLHandler.h"
#import "IUrlCallback.h"

#import "Logger.h"

@protocol IApplicationContext;

@interface URLAgent : NSObject <IURLHandler>

/*
 * Constant Properties
 */
+ (int) GET;
+ (int) POST;
+ (int) PUT;
+ (int) HEAD;
+ (int) DELETE;


- (id) init:(id<IUrlCallback>) callback url:(NSString *)url mode:(int)mode logger:(Logger *)logger appContext:(id <IApplicationContext>)appContext;
- (id) init:(NSString *)url mode:(int)mode logger:(Logger *)logger appContext:(id <IApplicationContext>)appContext;
- (id) init:(NSString *)url logger:(Logger *)logger appContext:(id <IApplicationContext>)appContext;


@end
