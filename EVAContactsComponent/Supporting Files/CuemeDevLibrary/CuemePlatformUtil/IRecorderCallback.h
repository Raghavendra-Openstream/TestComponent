//
//  IRecorderCallback.h
//  InkComponent
//
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IRecorderCallback <NSObject>
    -(void) recordStarted ;
    -(void) recordStopped ;
    -(void) errorInRecording:(NSString *)msg ;

- (BOOL) relinquishRecorderLock;
- (void) recorderLockReacquired:(NSObject *)lock;
- (void) recorderLockRelinquished;
@end
