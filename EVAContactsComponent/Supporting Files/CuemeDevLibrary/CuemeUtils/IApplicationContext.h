/*
 * IApplicationContext.h
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
 * Created On : May 21, 2014
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "IResourceEncryptionHandler.h"

@class Database;
@class Logger;
@class JSONObject ;

static int APPLICATIONCONTEXT_OFFLINE_CAPABLE = 0;

@protocol IApplicationContext <NSObject, IResourceEncryptionHandler>

/**
 *
 */
- (NSString *) getUniqueUserId;

/*
 * getApplicationName
 */
- (NSString *) getApplicationName;

/**
 * Returns encrypted database created using online/offline key depending upon application type.
 *
 * @param databaseName database name to open.
 * @return Database
 * @throws DBException
 */
- (Database *) getDatabase:(NSString *)databaseName;

/**
 * Check if database is already present
 *
 * @param databaseName name of the database
 * @return true if database exists
 */
-(BOOL) checkDatabaseExists:(NSString*) databaseName;

/**
 * @return Encrypted database created using given keyCapability value.
 */
-(Database*) getDatabase:(NSString*) databaseName capability:(int)keyCapability;


/*
 * Return a logger for a category
 *
 * @param category: Name of the category
 */
- (Logger *) getLogger:(NSString *)category;

/**
 * Set Log level
 */
- (void) setLogLevel:(NSString *)category level:(int)level;

/**
 * @private api
 * This is an internal method to support communication between application and container. 
 * This method should not be called by the components.
 */
- (BOOL) handleMessage:(NSObject*) lockObj messageType:(NSString*) messageType msgData:(JSONObject*) msgData ;

/**
 * Exits an application
 */
- (void) exitApplication;

/**
 * Push View Controller on top of the application navigation stack
 */
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated ;

/**
 * Pop View Controller from top of the application navigation stack
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;

/**
 * @private api
 * Use the pushViewController and popViewController to push UIViewController. 
 * Do not use the navigation controller directly, this method may be removed in future
 */
- (UINavigationController *) getCuemeAppNavigationController;

@end
