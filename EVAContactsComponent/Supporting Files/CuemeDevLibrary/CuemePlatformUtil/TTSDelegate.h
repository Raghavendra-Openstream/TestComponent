//
//  TTSDelegate.h
//  CuemePlatformUtil
//
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TTSDelegate <NSObject>

- (void) playStarted ;
- (void) playStopped ;
- (void) playCancelled ;
- (void) playing: (NSDictionary*) params ;

- (BOOL) relinquishTtsLock;
- (void) ttslockReacquired:(NSObject *)lock;
- (void) ttslockRelinquished;

@end
