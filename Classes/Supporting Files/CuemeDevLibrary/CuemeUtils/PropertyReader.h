/*
 * PropertyReader.h
 * MMIBrowser
 * (C) Copyright 2008, Openstream, Inc. NJ, U.S.A.
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
 * Author: 
 *
 * Created On : Sept 16, 2008
 *
 * Description:
 *
 * $Revision$  
 *
 * $Log$
 * 
 */

#import <Foundation/Foundation.h>

@interface PropertyReader : NSObject {
}

+ (void) initializePropertyReader;
+ (NSString*) getProperty:(NSString *)name;
+ (NSString *) getProperty:(NSString *)name defaultValue:(NSString *)defaultValue;
+ (BOOL) getBooleanProperty:(NSString *)name defaultValue:(BOOL)defaultValue;
+ (int) getIntegerProperty:(NSString *)name defaultValue:(int)defaultValue;
@end
