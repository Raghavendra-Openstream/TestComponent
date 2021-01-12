//
//  AudioPlayer.h
//  CuemePlatformUtil
//
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

#import "IPlayerCallback.h"
#import "SpeechEncoding.h"

@interface AudioPlayer : NSObject<AVAudioPlayerDelegate>

/**
 * Starts Playback for given audio URL.
 * @throws Exception: (invalid lock) Must catch exception when making this call
 */
- (void) startPlay:(NSObject*)lock encoding:(SpeechEncoding*) encoding audioURL:(NSString *)audioURL ;

/**
 * Starts Playback for Audio data.
 * @throws Exception: (invalid lock) Must catch exception when making this call
 */
- (void) startPlay:(NSObject*)lock encoding:(SpeechEncoding*) encoding audioData:(NSData *) audioData;

/**
 * Stops Playback.
 * @throws Exception: (invalid lock) Must catch exception when making this call
 */
- (void) stopPlay:(NSObject*) lock ;

/*
 * Register Callback
 */
- (void) registerCallback: (id<IPlayerCallback>) callback ;


// Lock Methods
- (void) releaseLock: (NSObject*) lock;
- (NSObject*) acquireLock ;
- (BOOL) isValidLock:(NSObject*) lock;

@end
