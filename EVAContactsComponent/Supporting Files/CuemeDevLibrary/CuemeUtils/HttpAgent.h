/*
 *
 * (C) Copyright 2014, Openstream, Inc. NJ, U.S.A.
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
 * Author: Openstream Inc
 *
 */

#import <Foundation/Foundation.h>

#import "IURLHandler.h"
#include "IUrlCallback.h"

@protocol IApplicationContext;

@interface HttpAgent : NSObject <IURLHandler>


/*
 * Constant Properties
 */
+ (int) GET;
+ (int) POST;

- (id) initWithUrl:(NSString*)url logger:(Logger *)logger appContext:(id <IApplicationContext>)appContext;
- (id) initWithUrl:(NSString*)url mode:(NSUInteger)mode logger:(Logger *)logger appContext:(id <IApplicationContext>)appContext;
- (id) initWithUrl:(NSString*)url mode:(NSUInteger)mode callback:(id<IUrlCallback>)callback logger:(Logger *)logger appContext:(id <IApplicationContext>)appContext;

/*
 * Set Request content using stream. 
 * If 
 */
//- (void) setRequestStream:(NSInputStream *)requestStream;

/*
 * Cancels a HTTP request. It must be invoked only when setProce
 */
- (void) cancel;


@end
