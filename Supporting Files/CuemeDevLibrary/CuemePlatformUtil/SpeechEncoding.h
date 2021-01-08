//
//  SpeechEncoding.h
//  CuemePlatformUtil
//
//  Created by Anthapu Ravindranatha Reddy on 9/24/14.
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef CuemePlatformUtil_SpeechEncoding_h
#define CuemePlatformUtil_SpeechEncoding_h

@interface SpeechEncoding : NSObject

@property (nonatomic) float sampleRate;
@property (nonatomic) int channels;
@property (nonatomic) int bitRate;
@property (nonatomic) NSString* encoding;
@property (nonatomic) int quality ;
@property (nonatomic) NSString* extension ;

-(NSString*) toString ;

@end

#endif
