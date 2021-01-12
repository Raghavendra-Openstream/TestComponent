//
//  OSECSRError.m
//  ContinuousSpeechRecognitionComponent
//
//  Created by Keyur Patel on 7/18/18.
//  Copyright © 2018 Openstream Inc. All rights reserved.
//

#import "OSEContactsComponentError.h"

@interface OSEContactsComponentError()

@property (strong) NSMutableDictionary* errorObj;

@end

@implementation OSEContactsComponentError

NSString *const OSEContactsComponentErrorDomain = @"com.openstream.cueme.component.contacts";

#define KeyErrorCode  @"errorCode"
#define KeyErrorMessage   @"errorMessage"
#define KeyErrorDescription  @"errorDescription"

static NSDictionary* OSEContactsComponentErrorList;

#pragma mark Construct Error

- (instancetype)initWithErrorCode:(OSEContactsComponentErrorCode)errorCode
                         errorMsg:(NSString *)errorMsg
                 errorDescription:(NSString *)errorDescription
                          {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        OSEContactsComponentErrorList =
        @{
          
          @(OSEContactsComponentErrorCodePermissionUsageDescriptionMissing) : @{
                  KeyErrorCode: @(OSEContactsComponentErrorCodePermissionUsageDescriptionMissing),
                  KeyErrorMessage: @"permission_usage_description_missing",
                  KeyErrorDescription: @"Usage description missing in Info.plist file"
                  },
          
          @(OSEContactsComponentErrorCodePermissionDenied) : @{
                  KeyErrorCode: @(OSEContactsComponentErrorCodePermissionDenied),
                  KeyErrorMessage: @"permission_error",
                  KeyErrorDescription: @"User denied requested permissions."
                  },
          
          @(OSEContactsComponentErrorCodeInvalidEventTarget) : @{
                  KeyErrorCode: @(OSEContactsComponentErrorCodeInvalidEventTarget),
                  KeyErrorMessage: @"invalid_event_target",
                  KeyErrorDescription: @"Invalid event target"
                  },
          
          @(OSEContactsComponentErrorCodeInvalidEventData) : @{
                  KeyErrorCode: @(OSEContactsComponentErrorCodeInvalidEventData),
                  KeyErrorMessage: @"invalid_event_data",
                  KeyErrorDescription: @"Invalid event data."
                  },
          
          @(OSEContactsComponentErrorCodeUnsupported) : @{
                  KeyErrorCode: @(OSEContactsComponentErrorCodeUnsupported),
                  KeyErrorMessage: @"unsupported",
                  KeyErrorDescription: @"Unsupported operation,"
                  },
          
          @(OSEContactsComponentErrorCodeUnknown) : @{
                  KeyErrorCode: @(OSEContactsComponentErrorCodeUnknown),
                  KeyErrorMessage: @"unknown_error",
                  KeyErrorDescription: @"unknown error."
                  }
         };
    });
    
    
    self = [super init];
    if (self) {
        NSDictionary *errorObj = [OSEContactsComponentErrorList objectForKey:@(errorCode)];
        
        if (errorObj == nil) {
            errorCode = OSEContactsComponentErrorCodeUnknown;
            errorObj = [OSEContactsComponentErrorList objectForKey:@(errorCode)];
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

- (instancetype)initWithErrorCode:(OSEContactsComponentErrorCode)errorCode
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


+ (JSONObject *) constructErrorWithCode:(OSEContactsComponentErrorCode)errorCode errorDescription:(NSString *)errorDescription {
    
    OSEContactsComponentError *error = [[OSEContactsComponentError alloc] initWithErrorCode:errorCode
                                             errorDescription:errorDescription];
    
    return [error toJSON];
}

@end
