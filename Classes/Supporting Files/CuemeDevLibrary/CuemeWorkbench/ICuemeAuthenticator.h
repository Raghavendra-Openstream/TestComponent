/*
 * IContainerPlugin.h
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
 * Author: Openstream Inc
 *
 * Created On : May 11, 2016
 *
 */
#import <Foundation/Foundation.h>
#import "Logger.h"

@protocol ICuemeAuthenticator <NSObject>

/**
 * Pre-Login callback method.
 * @param context Android context instance
 * @param logger Container logger instance.
 * @return
 */
- (NSString *) onPreLogin:(Logger *)logger;

/**
 * Post-Login callback method.
 * @param context Android context instance
 * @param logger Container logger instance.
 * @param userId Logged in User Id
 * @param postLoginData : Post logout data.
 * @return
 */
- (NSString *) onPostLogin:(Logger *)logger userId:(NSString *)userId  postLoginData:(NSString *)postLoginData;

/**
 * Pre-Logout callback method.
 * @param context Android context instance
 * @param logger Container logger instance
 */
- (void) onPreLogout:(Logger *)logger;
/**
 * Post-Logout callback method.
 * @param context Android context instance
 * @param logger Container logger instance.
 */
- (void) onPostLogout:(Logger *)logger;


@end
