//
//  TonePlayer.h
//  CuemePlatformUtil
//
//  Created by Anthapu Ravindranatha Reddy on 7/8/15.
//  Copyright (c) 2015 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TonePlayer : NSObject

/*!
 
 @function       playBeep
 @abstract       Play a system sound
 @discussion     Play the sound designated by the provided SystemSoundID.
 @param          beepName
    The beepName to be played. Supported values include "beep1", "beep2", "click", "vibrate"
 @param          completionBlock
                The completion block gets executed for every attempt to play a system sound irrespective
                of success or failure. The callbacks are issued on a serial queue and the client is
                responsible for handling thread safety. Works only on iOS 9.0 and later
 */
+ (void) playBeep:(nonnull NSString *)beepName completion:(nullable void (^)(void))completionBlock;

+ (void) playBeep:(nonnull NSString *)beepName blockDuration:(NSTimeInterval)blockDuration;

@end
