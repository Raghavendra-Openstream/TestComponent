#import <Foundation/Foundation.h>

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


/**
 * The IM manages the Interaction Manager
 *
 */
@protocol IApplicationContext;
@protocol IIMComponent;

@class JSONArray ;

@interface IM : NSObject {
}

- (id) init:(NSString *)appName startupEvents:(JSONArray*) startupEvents appContext:(id<IApplicationContext>) appContext ;
- (void) raiseEventToComponent:(NSObject*) authToken source:(NSString *)source eventName:(NSString *)eventName target:(NSString *)target data:(NSObject *)data secure:(BOOL)secure;
- (void) addEvent:(NSString *)src typestr:(NSString *)typestr target:(NSString *)target data:(NSObject *)data;
- (void) addEvent:(NSString *)src typestr:(NSString *)typestr target:(NSString *)target data:(NSObject *)data secure:(BOOL)secure ;
- (void) addListener:(NSString *)source target:(NSString *)target event:(NSString *)event;
- (void) removeListener:(NSString *)source target:(NSString *)target event:(NSString *)event;
- (void) processSCXML:(NSString *)scxmlURL state:(NSString *)state;
- (void) processState:(NSString *)state;
- (void) registerComponent:(id<IIMComponent>)component;
- (void) exit;
- (void) start;
- (NSString *) getAppName;

@end
