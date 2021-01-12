/*
 * JSONArray.h
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
 * Created On : Sep 17, 2013
 *
 */

#import <Foundation/Foundation.h>
@interface JSONArray :  NSObject<NSFastEnumeration>

- (id) init ;
- (id) initWithCapacity:(NSUInteger)capacity;

- (id) initWithArray:(NSMutableArray*)array;

- (id) initWithJSONString:(NSString*)jsonString;
/*!
 * Creates a JSONArray using json string passed
 */
- (id) initWithJSONString:(NSString*)jsonString error:(NSError**)error;

/*
 * Returns a json string representation of the object
 */
- (NSString*) toString ;

/**
 * Add Object to JSON array
 */
- (void) put:(id)object;

/**
 * Add Object to JSON array
 */
- (void) addObject:(id)value;

/**
 * Get Object at index
 */
- (id)objectAtIndex:(NSUInteger)index;

/**
 * Get Object at index
 */
- (id)get:(NSUInteger)index;

/*
 * Returns a JSONObject if the element at index is a object
 */ 
- (id)getJSONObject:(NSUInteger)index;

/*
 * Returns a JSONArray if the element at index is a object
 */ 
- (id)getJSONArray:(NSUInteger)index;

/*
 * Returns count 
 */
- (NSUInteger) count;

/*
 * Returns data
 */
- (id) getData;

- (BOOL) has:(id)obj;

- (void) removeAllObjects;

- (void) removeObjectAtIndex:(NSUInteger)index;

@end
