/*
 *  ApplicationUtil.h
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
 * Author: Keyur Patel
 *
 * Created On : May 10, 2014
 *
 */

#import <Foundation/Foundation.h>

@class Logger;
@interface ApplicationUtil : NSObject

/**
 * Returns a class with a given className else returns null
 */
+ (Class) getClassForName:(NSString*)className logger:(Logger *)logger;

/*!
 @description : Finds a resource bundle with given name. (Omit the .bundle extension) else
 falls back to bundle which loaded the class which could be main bundle if it static or framework bundle if it is dynamic framework
 
 !*/
+ (NSBundle *) getResourceBundleWithName:(NSString *)bundleName usingClass:(Class)aClass logger:(Logger *)logger;

/*
+ (NSString *) AUTH_INFO;
+ (NSString *) CUEME_INFO;
+ (NSString *) AUTH_TOKEN;
+ (NSString *) RENDERER;
+ (NSString *) CONFIGURATION;
+ (NSString *) ADDL_INFO;
+ (NSString *) CUSTOM_VIEWS;
+ (NSString *) UI_COMPONENT;
+ (NSString *) APP_CONTEXT;
+ (NSString *) APP_LAUNCH_PARAMS;
+ (NSString *) APP_RESTORE_PARAMS;
 @property (readonly) CUEME_INFO = "cuemeInfo";
 @property (readonly) AUTH_TOKEN = "authToken";
 @property (readonly) RENDERER = "renderer";
 @property (readonly) CONFIGURATION = "configuration";
 @property (readonly) ADDL_INFO = "addlInfo";
 @property (readonly) CUSTOM_VIEWS = "customViews";
 @property (readonly) UI_COMPONENT = "UI-Component";
 @property (readonly) APP_CONTEXT = "appContext";
 @property (readonly) APP_LAUNCH_PARAMS = "appLaunchParams";
 @property (readonly) APP_RESTORE_PARAMS = "appRestoreParams";
 */

@end
