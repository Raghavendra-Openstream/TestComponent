/*
 * DMUtils.h
 *
 * (C) Copyright 2015, Openstream, Inc. NJ, U.S.A.
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
 * Author: Keyur Patel
 *
 * Created On : Jun 04, 2015
 *
 */

#import <Foundation/Foundation.h>
#import "JSONObject.h"
#import "Logger.h"

static NSString* const DMUTILS_AUTH_INFO = @"authInfo";
static NSString* const DMUTILS_CUEME_INFO = @"cuemeInfo";
static NSString* const DMUTILS_AUTH_TOKEN = @"authToken";
static NSString* const DMUTILS_RENDERER = @"renderer";
static NSString* const DMUTILS_CONFIGURATION = @"configuration";
static NSString* const DMUTILS_ADDL_INFO = @"addlInfo";
static NSString* const DMUTILS_CUSTOM_VIEWS = @"customViews";
static NSString* const DMUTILS_UI_COMPONENT = @"UI-Component";
static NSString* const DMUTILS_APP_CONTEXT = @"appContext";
static NSString* const DMUTILS_APP_LAUNCH_PARAMS = @"appLaunchParams";
static NSString* const DMUTILS_APP_RESTORE_PARAMS = @"appRestoreParams";
static NSString* const DMUTILS_CUEME_REFRESH = @"cuemeRefresh";

static NSString* const DMUTILS_CONTAINER_NOTIFICATION_MSG_REQ = @"Notification";
static NSString* const DMUTILS_CONTAINER_TSR_MSG_REQ = @"TSR";
static NSString* const DMUTILS_CONTAINER_SETONLINEMODE_MSG_REQ = @"setOnlineMode";


@interface DMUtils : NSObject
+ (BOOL) isCuemeRefreshRequest:(JSONObject *)config ;
+ (Class) getCustomUIClass:(JSONObject *)config logger:(Logger * )logger;
@end
