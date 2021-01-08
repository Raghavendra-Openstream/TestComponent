/*
 * StoreManager.h
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
 * Created On : Jul 08, 2014
 *
 */

#import <Foundation/Foundation.h>
@class Logger;

@interface StoreManager : NSObject

+ (void) setup:(Logger *)logger;

+ (NSString *) getLogPath:(Logger *)logger;
+ (NSString *) getCuemeInstallationDirectoryPath:(Logger *)logger;
+ (NSString *) getCuemeTemporaryStoragePath:(Logger *)logger;
+ (NSString *) getCuemeResourcePath:(Logger *)logger;
+ (NSString *) getCuemeStoragePath:(Logger *)logger;
+ (NSString *) getWorkbenchStoragePath:(Logger *)logger;
+ (NSString *) getWorkbenchFileStoragePath:(Logger *)logger;
+ (NSString *) getWorkbenchTemporaryStoragePath:(Logger *)logger;
+ (void) initializeUserSandbox:(NSString *)user;
+ (NSString *) getUserBasePath;
+ (NSString *) getUserDbPath;
+ (NSString *) getUserTempPath;
+ (NSString *) getUserDataPath;
+ (void) clearState;

@end
