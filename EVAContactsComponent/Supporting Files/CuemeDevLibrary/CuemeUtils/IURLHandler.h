/*
 * IURLHandler.h
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
 * Author: Keyur Patel 
 *
 * Created On : Sep 18, 2013
 *
 */

#import <Foundation/Foundation.h>

#import "Logger.h"

static const int URL_METHOD_GET = 1;
static const int URL_METHOD_POST = 2;
static const int URL_METHOD_DELETE = 3;
static const int URL_METHOD_PUT = 4;
static const int URL_METHOD_HEAD = 5;

@protocol IURLHandler <NSObject>

- (void) addHeader:(NSString *)name value:(NSString *)value;
- (void) cleanup;
- (void) execute;
- (void) setCookie:(NSString *)s;
- (void) setBinaryData:(NSData *)b;
- (void) setPostData:(NSString *)postData;
- (void) setEncoding:(NSString *)data;
- (void) setProcessOutput:(BOOL)p_processOutput;
- (void) setTimeout:(int)timeout;
- (void) setLogger:(Logger *)logger;
- (void) setBinaryStream:(NSArray *)pBinaryStream;
- (void) setContentLength:(long)contentLength;
- (void) setProxySettings:(NSString *)proxyHost port:(int)port;
- (void) setReadErrorResponse:(BOOL)readResponse;
- (void) setResponseEncoding:(NSString*) encodingStr;

- (NSUInteger) getContentLength;
- (NSString*) getContentType;
- (NSString*) getCookie ;
- (NSString*) getCurrentUrl;
- (NSData*) getResponse;
- (NSInputStream*) getResponseStream ;
- (int) getStatus;
- (NSDictionary*) getResponseHeaders;
- (NSString*) getResponseDataAsString;

@end
