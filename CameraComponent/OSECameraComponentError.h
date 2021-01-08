/*
 *
 * (C) Copyright 2018, Openstream, Inc. NJ, U.S.A.
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
 * Created On : Jun 04, 2018
 *
 */

#import <Foundation/Foundation.h>
#import "JSONObject.h"
#import "Logger.h"

extern NSString *const OSECameraComponentErrorDomain;

typedef NS_ERROR_ENUM(OSECameraComponentErrorDomain, OSECameraComponentErrorCode) {
    
    
    /*! @brief Indicates permission usage string is missing in info.plist
     */
    OSECameraComponentErrorCodePermissionUsageDescriptionMissing = 8887,
    
    /*! @brief Indicates user denied permission for a required resource.
     */
    OSECameraComponentErrorCodePermissionDenied = 8888,
    
    
    
    
    /*! @brief This error is raised when any event has a invalid target
     */
    OSECameraComponentErrorCodeInvalidEventTarget = 9000,
    
    /*! @brief This error is raised when any event has a invalid data
     */
    OSECameraComponentErrorCodeInvalidEventData = 9001,
    
    /*! @brief Unhandled errors
     */
    OSECameraComponentErrorCodeUnsupported = 9002,
    
    /*! @brief Unhandled errors
     */
    OSECameraComponentErrorCodeUnknown = 9999
    
};

@interface OSECameraComponentError : NSObject

- (instancetype)initWithErrorCode:(OSECameraComponentErrorCode)errorCode
                         errorMsg:(NSString *)errorMsg
                 errorDescription:(NSString *)errorDescription;

- (instancetype)initWithErrorCode:(OSECameraComponentErrorCode)errorCode
                 errorDescription:(NSString *)errorDescription ;

- (JSONObject *)toJSON;
- (NSString *)toJSONString;

+ (JSONObject *) constructErrorWithCode:(OSECameraComponentErrorCode)errorCode errorDescription:(NSString *)errorDescription;

@end

