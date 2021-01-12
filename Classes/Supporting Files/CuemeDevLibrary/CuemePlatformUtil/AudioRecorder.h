//
//  AudioRecorder.h
//  CuemePlatformUtil
//
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>
#import "IRecorderCallback.h"

@class SpeechEncoding ;

@interface AudioRecorder : NSObject<AVAudioRecorderDelegate> {
    
}

/**
 * Starts Recording.
 * @throws Exception: (invalid lock) Must catch exception when making this call
 */
- (int) startRecording:(NSObject*) lock withEncoding:(SpeechEncoding*) encoding ;

/**
 * Stops Recording
 * @throws Exception: (invalid lock) Must catch exception when making this call
 */
- (int) stopRecording:(NSObject*) lock ;

/**
 * Cancel Recording
 * @throws Exception: (invalid lock) Must catch exception when making this call
 */
- (int) cancelRecording:(NSObject*) lock ;

/**
 * Return Audio Data
 * @throws Exception: (invalid lock) Must catch exception when making this call
 */
- (NSData*) getAudio:(NSObject*) lock ;

// Lock Methods
- (NSObject*) acquireLock ;
- (void) releaseLock: (NSObject*) lock ;
- (void) registerCallback: (id<IRecorderCallback>) callback ;
@end
