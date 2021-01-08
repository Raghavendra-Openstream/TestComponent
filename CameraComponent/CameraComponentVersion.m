/*
 *
 * (C) Copyright 2016, Openstream, Inc. NJ, U.S.A.
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
 * Created On : Oct 17, 2016
 *
 */

#import "CameraComponentVersion.h"

@implementation CameraComponentVersion

#ifndef LIBRARY_VERSION
#define LIBRARY_VERSION 3.0.2
#endif

#define _TOSTRING(x) #x
#define TOSTRING(x) _TOSTRING(x)

#define COMPONENT_LIBRARY_VERSION @ TOSTRING(LIBRARY_VERSION)
#define COMPONENT_PRINT_VERSION @"Library-Version: CameraComponent: " COMPONENT_LIBRARY_VERSION

+ (NSString *) getVersionString {
    return [NSString stringWithFormat:@"%@", COMPONENT_LIBRARY_VERSION];
}

+ (NSString *) getVersionInfoToPrint {
    return [NSString stringWithFormat:@"%@", COMPONENT_PRINT_VERSION];
}


@end
