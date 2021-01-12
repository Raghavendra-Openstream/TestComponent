/*
 *  CameraComponent.h
 *
 * (C) Copyright 2014, Openstream, Inc. NJ, U.S.A.
 * All rights reserved.
 *
 * This software is confidential and proprietary information of
 * Openstream, Inc. ("Confidential Information"). You shall not disclose
 * such Confidential Information and shall use/possess it only in accordance
 * with the terms of the license/usage agreement you entered into with
 * Openstream, Inc.
 *
 * If you any have questions regarding this matter, please contact legal@openstream.com
 *
 * Author: Openstream Inc
 *
 * Created On : Aug 11, 2014
 *
 */
//

#import <Foundation/Foundation.h>

@class JSONObject;
@protocol CameraHandlerDelegate <NSObject>


- (BOOL) relinquishCameraLock;
- (void) cameraLockReacquired:(NSObject *)lock;
- (void) cameraLockRelinquished;

- (void) cameraCaptureFailure:(NSString *)target options:(JSONObject *)options mediaType:(NSString *)mediaType reason:(NSString *)reason;
- (void) cameraCaptureSuccess:(NSString *)target options:(JSONObject *)options mediaType:(NSString *)mediaType destinationType:(NSString *)destinationType result:(NSObject *)result;
- (void) cameraRaiseUIEvent:(NSString *)target data:(NSString *)data;


@end
