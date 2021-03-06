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

@interface Base64Util : NSObject

+ (NSString *) encode:(const uint8_t*) input length:(NSInteger) length ;
+ (NSString *) encode:(NSData*) rawBytes ;
+ (NSData *) decode:(const char*) string length:(NSInteger) inputLength ;
+ (NSData *) decode:(NSString*) string ;

@end
