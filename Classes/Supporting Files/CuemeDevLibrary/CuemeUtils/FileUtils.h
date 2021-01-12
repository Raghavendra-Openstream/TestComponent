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

@class Logger;

@interface FileUtils : NSObject
+ (BOOL) isFileExist:(NSString*)filePath ;
+ (BOOL) createDirectory:(NSString *)folderPathStr logger:(Logger *)logger;
+ (BOOL) deleteDirectory:(NSString *)folderPathStr logger:(Logger *)logger;
+ (BOOL) move:(NSURL*)sourceUrl toURL:(NSURL*)destinationUrl overwrite:(BOOL)overwrite error:(NSError**)error logger:(Logger *)logger;
+ (BOOL) moveFileAtPath:(NSString*)sourceFilePath toPath:(NSString*)destinationFilePath overwrite:(BOOL)overwrite error:(NSError**)error logger:(Logger *)logger;
+ (BOOL) copy:(NSURL*)sourceUrl toURL:(NSURL*)destinationUrl overwrite:(BOOL)overwrite error:(NSError**)error logger:(Logger *)logger;
+ (BOOL) copyFileAtPath:(NSString*)sourceFilePath toPath:(NSString*)destinationFilePath overwrite:(BOOL)overwrite error:(NSError**)error logger:(Logger *)logger;

+ (BOOL) deleteFileAtPath:(NSString *)filePath logger:(Logger *)logger;
+ (BOOL) deleteFileAtURL:(NSURL*)fileUrl logger:(Logger *)logger;
+ (NSString*) readFileStringDataAtURL:(NSURL*)fileUrl logger:(Logger *)logger;
+ (NSData*) readFileDataAtURL:(NSURL*)fileUrl logger:(Logger *)logger;
+ (NSString*) readFileStringDataAtPath:(NSString*)filePath logger:(Logger *)logger;
+ (NSData*) readFileDataAtPath:(NSString*)filePath logger:(Logger *)logger;
+ (BOOL) writeToFile:(NSString*)filePath data:(NSData *)data logger:(Logger *)logger;

@end
