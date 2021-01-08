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

#import "OSECameraComponentError.h"

@interface OSECameraComponentError()

@property (strong) NSMutableDictionary* errorObj;

@end

@implementation OSECameraComponentError

NSString *const OSECameraComponentErrorDomain = @"com.openstream.cueme.component.cameracomponent";

#define KeyErrorCode  @"errorCode"
#define KeyErrorMessage   @"errorMessage"
#define KeyErrorDescription  @"errorDescription"

static NSDictionary* OSECameraComponentErrorList;

#pragma mark Construct Error

- (instancetype)initWithErrorCode:(OSECameraComponentErrorCode)errorCode
                         errorMsg:(NSString *)errorMsg
                 errorDescription:(NSString *)errorDescription
                          {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        OSECameraComponentErrorList =
        @{
          
          @(OSECameraComponentErrorCodePermissionUsageDescriptionMissing) : @{
                  KeyErrorCode: @(OSECameraComponentErrorCodePermissionUsageDescriptionMissing),
                  KeyErrorMessage: @"permission_usage_description_missing",
                  KeyErrorDescription: @"Usage description missing in Info.plist file"
                  },
          
          @(OSECameraComponentErrorCodePermissionDenied) : @{
                  KeyErrorCode: @(OSECameraComponentErrorCodePermissionDenied),
                  KeyErrorMessage: @"permission_error",
                  KeyErrorDescription: @"User denied requested permissions."
                  },
          
          @(OSECameraComponentErrorCodeInvalidEventTarget) : @{
                  KeyErrorCode: @(OSECameraComponentErrorCodeInvalidEventTarget),
                  KeyErrorMessage: @"invalid_event_target",
                  KeyErrorDescription: @"Invalid event target"
                  },
          
          @(OSECameraComponentErrorCodeInvalidEventData) : @{
                  KeyErrorCode: @(OSECameraComponentErrorCodeInvalidEventData),
                  KeyErrorMessage: @"invalid_event_data",
                  KeyErrorDescription: @"Invalid event data."
                  },
          
          @(OSECameraComponentErrorCodeUnsupported) : @{
                  KeyErrorCode: @(OSECameraComponentErrorCodeUnsupported),
                  KeyErrorMessage: @"unsupported",
                  KeyErrorDescription: @"Unsupported operation,"
                  },
          
          @(OSECameraComponentErrorCodeUnknown) : @{
                  KeyErrorCode: @(OSECameraComponentErrorCodeUnknown),
                  KeyErrorMessage: @"unknown_error",
                  KeyErrorDescription: @"unknown error."
                  }
         };
    });
    
    
    self = [super init];
    if (self) {
        NSDictionary *errorObj = [OSECameraComponentErrorList objectForKey:@(errorCode)];
        
        if (errorObj == nil) {
            errorCode = OSECameraComponentErrorCodeUnknown;
            errorObj = [OSECameraComponentErrorList objectForKey:@(errorCode)];
        }
        
        //NSLog(@"TEST TEST Before : %@", errorObj);
        _errorObj = [errorObj mutableCopy];
        
        //[_errorObj setObject:@"TEST TEST TEST" forKey:KeyErrorDescription];
        //NSLog(@"TEST TEST After1 : %@", _errorObj);
        //NSLog(@"TEST TEST After2: %@", [OSEOAuthComponentErrors objectForKey:@(errorCode)]);
        
        
        if (errorDescription != nil) {
            [_errorObj setObject:errorDescription forKey:KeyErrorDescription];
        }
        
        if (errorMsg != nil) {
            [_errorObj setObject:errorMsg forKey:KeyErrorMessage];
        }
    }
    
    return self;
}

- (instancetype)initWithErrorCode:(OSECameraComponentErrorCode)errorCode
                 errorDescription:(NSString *)errorDescription  {
    
    return [self initWithErrorCode:errorCode errorMsg:nil errorDescription:errorDescription];
}

- (JSONObject *)toJSON {
    JSONObject *jsonData = [[JSONObject alloc] initWithDictionary:[_errorObj mutableCopy]];
    return jsonData;
}

- (NSString *)toJSONString {
    JSONObject *jsonData = [self toJSON];
    
    if (!jsonData) {
        return @"{}";
    } else {
        return [jsonData toString];
    }
}


+ (JSONObject *) constructErrorWithCode:(OSECameraComponentErrorCode)errorCode errorDescription:(NSString *)errorDescription {
    
    OSECameraComponentError *error = [[OSECameraComponentError alloc] initWithErrorCode:errorCode
                                             errorDescription:errorDescription];
    
    return [error toJSON];
}


@end
