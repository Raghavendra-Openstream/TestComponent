/*
 *  CuemeWorkbench.h
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
 * Created On : Jun 06, 2014
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface CuemeWorkbench : NSObject<UINavigationControllerDelegate, UNUserNotificationCenterDelegate> {
    UIViewController* mRootController_ ;
}

/*
 * Initializes the CuemeWorkbench.
 *
 * Use initializeWorkbenchWithLaunchOptions: if the container needs to handle launch options
 * eg. App Launch using a deep link or notification tap.
 */
- (void) initializeWorkbench ;

/*
 * Initializes the CuemeWorkbench and handles launch options
 *
 * eg. App Launch using a deep link or notification tap.
 */
- (void) initializeWorkbenchWithLaunchOptions:(NSDictionary *_Nullable)launchOptions;

/**
 * This method should be called from 
 * - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
 */
- (void) handleRemoteNotification:(NSDictionary *_Nonnull)userInfo;

/*
 * This method should be called from
 * - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
 */
- (void) handleRemoteNotificationToken:(NSData *_Nonnull)token;

/**
 * This method should be called from 
 * - (void)application:(NSApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
 */
- (void) handleRemoteNotificationTokenError:(NSError *_Nonnull)error;

/**
 * This method should be called from
 * - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
 */
- (BOOL) handleOpenUrl:(NSURL *_Nullable)url options:(NSDictionary *_Nullable)options;

- (void)applicationWillResignActive:(UIApplication *_Nonnull)application ;

- (void)applicationDidEnterBackground:(UIApplication *_Nonnull)application ;

- (void)applicationWillEnterForeground:(UIApplication *_Nonnull)application ;

- (void)applicationDidBecomeActive:(UIApplication *_Nonnull)application ;

- (void)applicationWillTerminate:(UIApplication *_Nonnull)application ;

-(BOOL)application:(UIApplication *_Nonnull)application continueUserActivity:(NSUserActivity *_Nonnull)userActivity restorationHandler:(void(^_Nonnull)(NSArray<id<UIUserActivityRestoring>>  *_Nonnull restorableObjects))restorationHandler;

- (void)handlePerformFetchWithCompletionHandler:(void (^_Nonnull)(UIBackgroundFetchResult))completionHandler uiApplication:(UIApplication *_Nonnull)application;

- (void)application:(UIApplication * _Nonnull)application handleWatchKitExtensionRequest:( NSDictionary * _Nonnull)userInfo reply:(void(^)(NSDictionary * _Nullable replyInfo))reply;

@property (readonly, nonatomic, retain) UINavigationController* _Nonnull navController;

@end
