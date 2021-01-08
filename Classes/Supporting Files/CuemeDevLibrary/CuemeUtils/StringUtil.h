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

@interface StringUtil : NSObject

+ (BOOL) isNotBlank:(NSString*) input;
+ (BOOL) isBlank:(NSString*) input;
+ (BOOL) equals:(NSString*) str1 str2:(NSString*) str2;
+ (NSString*) defaultIfEmpty:(NSString*) str defaultStr:(NSString*) defaultStr ;
+ (BOOL)  isEmpty:(NSString*) str;
+ (NSString*) emptyStringIfNull:(NSString*) obj ;
+ (BOOL) isBlankOrNull :(NSString*) input;
+ (NSString*) toString:(BOOL) obj;
+ (NSDate *) dateFromString:(NSString *)longDate;
+ (BOOL) equalsIgnoreCase:(NSString*) str1 andString:(NSString*) str2;
+ (NSString *) removeQueryParamsFromUrlString:(NSString *)urlString;
+ (BOOL) string:(NSString *)fullString containsString:(NSString *)substring;

@end
