//
//  AudioUtil.h
//  CuemePlatformUtil
//
//  Created by Anthapu Ravindranatha Reddy on 5/27/14.
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Logger.h"

@interface AudioUtil : NSObject

+ (NSUInteger) getRecorderEncoding:(NSString*) encodingStr ;
+ (NSString *) getPlayerEncoding:(NSString*) encodingStr;

+ (BOOL) beginAudioSession:(Logger *)logger;
+ (BOOL) beginAudioSession:(NSString *)category withOptions:(AVAudioSessionCategoryOptions)options logger:(Logger *)logger;
+ (BOOL) endAudioSession:(Logger *)logger;
+ (BOOL) endAudioSessionWithOptions:(AVAudioSessionSetActiveOptions)activeOptions logger:(Logger *)logger;

@end

