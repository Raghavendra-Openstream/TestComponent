/*
 * CoreDevUtil.h
 *
 * (C) Copyright 2010, Openstream, Inc. NJ, U.S.A.
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
 * Author: Nagesh Kharidi
 *
 * Created On : May 18, 2010
 *
 * Description:
 *
 * $Revision$  
 *
 * $Log$
 * 
 */

#import <Foundation/Foundation.h>


@interface CoreDevUtil : NSObject {

}

+ (NSString *) applicationName;
+ (NSString *) applicationVersion;
+ (NSString *) applicationId;
+ (NSString *) applicationDocumentsDirectory;
+ (NSString *) applicationTemporaryDirectory;
+ (NSString *) applicationCachesDirectory;
+ (NSString *) applicationLibraryDirectory;
+ (NSDictionary *) applicationBundlePlistDictionaryForResource:(NSString *)resourceName;
+ (NSString *) deviceOsName;
+ (NSString *) deviceOsVersion;
+ (NSString *) deviceModelName;
+ (BOOL) fileExistsInApplicationBundleWithName:(NSString *)fileName;
+ (BOOL) fileExistsInApplicationDocumentsWithName:(NSString *)fileName;
+ (BOOL) fileExistsInApplicationCachesWithName:(NSString *)fileName;
+ (BOOL) nonEmptyFileExistsInApplicationDocumentsWithName:(NSString *)fileName;
+ (BOOL) nonEmptyFileExistsInApplicationCachesWithName:(NSString *)fileName;
+ (BOOL) fileExistsAtPath:(NSString *)path;
+ (BOOL) nonEmptyFileExistsAtPath:(NSString *)path;
+ (BOOL) copyFromApplicationBundleToApplicationDocumentsFileWithName:(NSString *)fileName;
+ (BOOL) copyFromApplicationBundleToApplicationCachesFileWithName:(NSString *)fileName;
+ (BOOL) moveItemFromPath:(NSString *)fromPath toPath:(NSString *)toPath;
+ (BOOL) removeFromApplicationDocumentsFileWithName:(NSString *)fileName;
+ (BOOL) removeFromApplicationCachesFileWithName:(NSString *)fileName;
+ (BOOL) deleteFile:(NSString *)filePath;
+ (float) floatValueFromDict:(NSDictionary *)dict forKey:(id)key defaultValue:(float)dv;
+ (double) doubleValueFromDict:(NSDictionary *)dict forKey:(id)key defaultValue:(double)dv;
+ (int) intValueFromDict:(NSDictionary *)dict forKey:(id)key defaultValue:(int)dv;
+ (long) longValueFromDict:(NSDictionary *)dict forKey:(id)key defaultValue:(long)dv;
+ (NSString *) stringValueFromDict:(NSDictionary *)dict forKey:(id)key defaultValue:(NSString *)dv;
+ (BOOL) fileOrPath:(NSString *)fileOrPath hasExtension:(NSString *)ext;
+ (NSString *) applicationBundlePathForResource:(NSString *)resourceName;
+ (void) setSessionCookieWithName:(NSString *)name value:(NSString *)value forUrlString:(NSString *)urlStr;
+ (void) setSessionCookieWithName:(NSString *)name value:(NSString *)value domain:(NSString *)domain path:(NSString *)path;
+ (void) setCookie:(NSHTTPCookie *)cookie;
+ (NSArray *) cookiesForUrlString:(NSString *)urlStr;
+ (NSString *) jsonForDictionary:(NSDictionary *)dict;
+ (NSArray *) arrayFromString:(NSString *)str delimiter:(NSString *)delimiter;
+ (BOOL) setDoNotBackupAttributeForFile:(NSURL *)url;
+ (NSData *) dataFromHexString:(NSString *)hexString;
+ (NSString *) hexStringFromData:(NSData *)data;
+ (NSString *) deviceMachineName;
+ (NSDictionary *) deviceInfoDict;
+ (NSURL *) uniqueUrlByUpdatingFileName:(NSURL *)url;
+ (NSData *) sha1HashForData:(NSData *)input;
+ (NSString *) macAddressForInterface:(NSString *)ifName;
+ (NSString *) macAddressForWifi;
+ (NSArray *) networkInterfacesMonitoredByCaptiveNetwork;
+ (NSString *) nsDataDescriptionAsStringByRemovingSpacesAndBrackets:(NSData *)data;
+ (NSString *) percentEncodedUriString:(NSString *)uriStr;
@end
