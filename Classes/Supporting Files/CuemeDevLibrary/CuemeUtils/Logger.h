/*
 * Logger.h
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
 * Created On : Sep 03, 2013
 *
 * Description:
 *
 */

#import <Foundation/Foundation.h>

@class LogWriter;

typedef enum LogLevel{
    Trace = 1,
    Debug = 2,
    Warning = 3,
    Error = 4
} LogLevel;

@interface Logger : NSObject

/*!
 * Set LogLevel
 */
@property (nonatomic) int logLevel;

@property (nonatomic,strong) LogWriter* logWriter;

/*!
 * Create Logger with given writer and pakage name
 */
- (id) initWithLogWriter:(LogWriter *)writer pkg:(NSString *)packageName;


- (LogWriter*) getLogWriter;
- (void) restoreLastLogLevel ;

- (void) exception:(NSException *)e msg:(NSString *)format, ...;
- (void) exception:(NSException *)e;
- (void) error:(NSString *)format, ...;
- (void) debug:(NSString *)format, ...;
- (void) warn:(NSString *)format, ...;
- (void) trace:(NSString *)format, ...;

@end

