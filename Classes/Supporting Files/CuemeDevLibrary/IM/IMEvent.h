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

@class Logger;

@interface IMEvent : NSObject {
  NSString * mSource_;
  NSString * mTo_;
  short mType_;
  NSString * mTypeStr_;
  NSString * mTarget_;
  NSObject * mData_;
  BOOL mSecure_;
}

@property(nonatomic, retain, readonly) NSString * source;
@property(nonatomic, readonly) short type;
@property(nonatomic, retain, readonly) NSString * typeStr;
@property(nonatomic, retain, readonly) NSString * target;
@property(nonatomic, retain, readonly) NSObject * data;
@property(nonatomic, retain, readonly) NSString * to;
@property(nonatomic, readonly) BOOL secure;

- (id) init:(NSString *)source typestr:(NSString *)typestr target:(NSString *)target data:(NSObject *)data secure:(BOOL)secure;
- (id) init:(NSString *)source to:(NSString *)to typestr:(NSString *)typestr target:(NSString *)target data:(NSObject *)data secure:(BOOL)secure;
- (void) logEvent:(Logger *)logger;
- (void) debug:(NSMutableString *)buffer;
@end
