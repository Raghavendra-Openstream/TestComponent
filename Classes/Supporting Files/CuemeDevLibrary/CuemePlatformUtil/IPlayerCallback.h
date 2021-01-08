//
//  IPlayerCallback.h
//  CuemePlatformUtil
//
//  Copyright (c) 2015 Openstream Inc. All rights reserved.
//

@protocol IPlayerCallback <NSObject>

-(void) playStarted ;
-(void) playStopped ;
-(void) errorInPlaying:(NSString *)msg ;


- (BOOL) relinquishPlayerLock;
- (void) playerLockReacquired:(NSObject *)lock;
- (void) playerLockRelinquished;

@optional
- (void) playerBeginInterruption;
- (void) playerEndInterruption;
@end