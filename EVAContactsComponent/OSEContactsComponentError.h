//
//  OSECSRError.h
//  ContinuousSpeechRecognitionComponent
//
//  Created by Keyur Patel on 7/18/18.
//  Copyright © 2018 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"
#import "Logger.h"

extern NSString *const OSEContactsComponentErrorDomain;

typedef NS_ERROR_ENUM(OSEContactsComponentErrorDomain, OSEContactsComponentErrorCode) {
    
    
    /*! @brief Indicates permission usage string is missing in info.plist
     */
    OSEContactsComponentErrorCodePermissionUsageDescriptionMissing = 8887,
    
    /*! @brief Indicates user denied permission for a required resource.
     */
    OSEContactsComponentErrorCodePermissionDenied = 8888,
    
    /*! @brief This error is raised when any event has a invalid target
     */
    OSEContactsComponentErrorCodeInvalidEventTarget = 9000,
    
    /*! @brief This error is raised when any event has a invalid data
     */
    OSEContactsComponentErrorCodeInvalidEventData = 9001,
    
    /*! @brief Unhandled errors
     */
    OSEContactsComponentErrorCodeUnsupported = 9002,
    
    /*! @brief Unhandled errors
     */
    OSEContactsComponentErrorCodeUnknown = 9999
    
};

@interface OSEContactsComponentError : NSObject

- (instancetype)initWithErrorCode:(OSEContactsComponentErrorCode)errorCode
                         errorMsg:(NSString *)errorMsg
                 errorDescription:(NSString *)errorDescription;

- (instancetype)initWithErrorCode:(OSEContactsComponentErrorCode)errorCode
                 errorDescription:(NSString *)errorDescription ;

- (JSONObject *)toJSON;
- (NSString *)toJSONString;

+ (JSONObject *) constructErrorWithCode:(OSEContactsComponentErrorCode)errorCode errorDescription:(NSString *)errorDescription;

@end
