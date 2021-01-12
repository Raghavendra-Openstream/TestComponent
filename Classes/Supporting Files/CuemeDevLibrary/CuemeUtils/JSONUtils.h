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

@class JSONArray;
@class JSONObject;

@interface JSONUtils : NSObject

/**
 * Checks if the Array is empty is empty
 */ 
+ (BOOL) isNotEmpty:(JSONArray*) input;

/**
 * Copies data from source to target
 */
+ (void) copyDataToTarget:(JSONObject*)target source:(JSONObject*) src;

/*
 * Returns a json string represetation of the object
 */ 
+ (NSString*) getJSONString:(id)obj;

@end
