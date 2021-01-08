/*
 * IContainerSplash
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

@protocol IContainerSplash <NSObject>

/*
 * This method is called only once. 
 * It is recommended the implementation class save the instance of the logger to log other calls
 */
- (void) initializeViewWithFrame:(CGRect)frame logger:(Logger *) logger;

/*
 * Return a UIView that needs to be shown as fullscreen splash screen
 */
- (UIView *) getSplashViewInstance;

/*
 * This is called when the instance needs to be freed due to memory constraints
 */
- (void) cleanupSplashViewInstance;

@optional

/**
 * A callback raised when application requests start of splash
 */
- (void) startSplash;

/**
 * A callback raised when application requests stop of splash
 */
- (void) stopSplash;

@end
