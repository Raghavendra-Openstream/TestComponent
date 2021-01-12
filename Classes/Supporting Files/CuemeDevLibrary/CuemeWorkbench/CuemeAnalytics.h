/*
 * CuemeAnalytics
 *
 * (C) Copyright 2017, Openstream, Inc. NJ, U.S.A.
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

#import "Logger.h" 

@protocol CuemeAnalytics <NSObject>

/*!
 @method setLogger:
 @abstract Provides the logger in case the plugin needs to log messages
 @discussion The application must save the logger if it needs to logs to cueme log files
 @param logger Logger object provided by container
 */
- (void) setLogger:(Logger *)logger;

/*!
 @method onAppEvent
 @abstract onAppEvent is called when an app event is raised by the container.
 @param name Name of the app event
 @param data Data passed in the app event
 */
- (void) onAppEvent:(NSString *)name data:(NSString *)data;

@end
