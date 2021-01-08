/*
 * JSONObject.h
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

@class JSONArray;

@interface JSONObject : NSObject <NSFastEnumeration>

- (id) init ;
- (id) initWithCapacity:(NSUInteger)capacity ;

- (id) initWithDictionary:(NSMutableDictionary*)dictionary ;

/*!
 * Creates a JSONObject using json string passed
 */
- (id) initWithJSONString:(NSString*)jsonString ;

/*!
 * Creates a JSONObject using json string passed
 */
- (id) initWithJSONString:(NSString*)jsonString error:(NSError**)error ;

/*
 * Returns a json string representation of the object
 */
- (NSString*) toString;
- (NSString*) description;

/**
 * Add Object to JSONObject with given key
 */
- (void) put:(NSString*)key value:(id)value ;

/**
 * Adds a boolean value to jsonobject
 */ 
- (void) putBool:(NSString*)key value:(BOOL)value ;

/**
 * Adds a Int value to jsonobject
 */
- (void) putInt:(NSString*)key value:(int)value ;

/**
 * Adds a Double value to jsonobject
 */
- (void) putDouble:(NSString*)key value:(double)value ;

/**
 * Add Object to JSONObject with given key
 */
- (void) setObject:(id)value forKey:(NSString*)key;

/**
 * Get Object for Key
 */
- (id) objectForKey:(NSString*)key ;

/**
 * Get Object for Key
 */
- (id) get:(NSString*)key ;

/*
 * Return a boolean value if the object is present in the json else return NO
 */ 
- (BOOL) getBool:(NSString*)key ;

/*
 * Returns a string value in case it is a number or string else returns a description
 */
- (NSString*) getString:(NSString*)key;
- (NSString*) optString:(NSString*)key ;
- (NSString*) optString:(NSString*)key default:(NSString*) defaultValue;

/*
 * Returns a JSONObject if the element at index is a object
 */ 
- (id)getJSONObject:(NSString*)key;

/*
 * Returns a JSONArray if the element at index is a object
 */ 
- (id)getJSONArray:(NSString*)key; 

/*
 * Returns all keys
 */
- (NSArray *)allKeys;

/**
 * Returns Key enumerator
 */
- (NSEnumerator*) keyEnumerator ;

/*
 * Do not use this
 */
- (id) getData;

- (void) removeAllObjects;

/*
 * Return all keys i.e names of the fields
 */
- (JSONArray*) names ;

/**
 * Returns a new JSONArray which is a subset of the names provided in the parameter
 */
- (JSONArray*) toJSONArray:(JSONArray*)names ;

/*
 * Returns TRUE if key is present in the JSONObject
 */
- (BOOL) has:(NSString*)key;

/*
 * Return number of keys
 */
- (NSUInteger) count;

/*
 * Remove value for a given key
 */
- (void) remove:(NSString*)key;

@end
