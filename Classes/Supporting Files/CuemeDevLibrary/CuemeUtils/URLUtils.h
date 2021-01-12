//
//  URLUtils.h
//  CuemeUtils
//
//  Created by Anthapu Ravindranatha Reddy on 5/27/15.
//  Copyright (c) 2015 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLUtils : NSObject

/*
 * Get mime type based on extesion
 */
+ (NSString *) getMimeType:(NSString *)url;

/*
 * Removes query parameters and Fragments(i.e) from the url string
 */
+ (NSString *) stripQueryParamsAndFragmentsFromUrlString:(NSString *)urlString ;

/*
 * Removes query parameters from the url string
 */
+ (NSString *) stripQueryParamsFromUrlString:(NSString *)urlString;

/*
 * Removes Fragments(i.e #) from URL string
 */
+ (NSString *) stripFragmentsFromUrlString:(NSString *)urlString;

@end
