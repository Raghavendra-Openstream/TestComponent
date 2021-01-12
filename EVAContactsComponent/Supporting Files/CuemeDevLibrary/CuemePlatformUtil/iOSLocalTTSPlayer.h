//
//  iOSLocalTTSPlayer.h
//  CuemePlatformUtil
//
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "TTSDelegate.h"

@class JSONObject ;
@class Logger;

@interface iOSLocalTTSPlayer : NSObject<AVSpeechSynthesizerDelegate> {
    
}

- (void) releaseLock: (NSObject*) lock;
- (NSObject*) acquireLock ;


-(void) setDelegate: (id<TTSDelegate>) delegate ;
-(void) playText:(NSObject*)lock text:(NSString*) text ;
-(void) playText:(NSObject*)lock text:(NSString*) text withOptions:(JSONObject*) options ;
-(void) addToPlayQueue:(NSObject*)lock text:(NSString*) text ;
-(void) addToPlayQueue:(NSObject*)lock text:(NSString*) text withOptions:(JSONObject*) options;
-(void) stopPlay:(NSObject*)lock;
-(void) pausePlay:(NSObject*)lock ;
-(void) resumePlay:(NSObject*)lock ;
- (void) setLogger:(Logger *)logger;

@end
