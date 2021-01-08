/*
 *  CameraComponent.m
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
 * Author: Keyur Patel
 *
 * Created On : Jun 06, 2014
 *
 */

#import "CameraComponent.h"
#import "CameraComponentVersion.h"

#import "IApplicationContext.h"
#import "Logger.h"
#import "IMEvent.h"
#import "IM.h"
#import "MessageQueue.h"
#import "JSONObject.h"
#import "JSONArray.h"
#import "ApplicationUtil.h"
#import "StoreManager.h"
#import "CameraHandlerCustom.h"
#import "CameraHandlerDelegate.h"
#import "StringUtil.h"
#import "JSONUtils.h"
#import "OSECameraComponentError.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraComponent ()  <CameraHandlerDelegate> {
    
    id<IApplicationContext> mAppContext_;
    IM * mIMHandler_;
    MessageQueue * mEventsQueue_;
    Logger * mLogger_;
    CameraHandlerCustom *mCameraHandler_;
    NSObject *mCameraLock_;
    UIViewController *mCameraViewControler_;
    JSONObject *mCaptureState_;
}

@end


@implementation CameraComponent

static NSString* const LOGGER_NAME  = @"com.openstream.cueme.camera.CameraComponent";
static NSString* const SOURCE_ID    = @"x-camera";

static NSString *S_EventStartPictureCapture = @"startPictureCapture";
static NSString *S_EventStartVideoCapture = @"startVideoCapture";
static NSString *S_EventStartScreenCapture = @"startScreenCapture";
static NSString *S_EventPickPhoto = @"pickPhoto";
static NSString *S_EventOnPickPhotoComplete = @"onPickPhotoComplete";
static NSString *S_EventOnPictureCaptureComplete = @"onPictureCaptureComplete";
static NSString *S_EventOnPictureCaptureAborted = @"onPictureCaptureAborted";
static NSString *S_EventOnVideoCaptureComplete = @"onVideoCaptureComplete";
static NSString *S_EventOnVideoCaptureAborted = @"onVideoCaptureAborted";
static NSString *S_EventOnScreenCaptureComplete = @"onScreenCaptureComplete";
static NSString *S_EventOnPictureCaptureFail = @"onPictureCaptureFail";
static NSString *S_EventOnVideoCaptureFail = @"onVideoCaptureFail";
static NSString *S_EventOnScreenCaptureFail = @"onScreenCaptureFail";
static NSString *S_EventImageFile = @"ImageFile";
static NSString *S_EventVideoFile = @"VideoFile";
static NSString *S_EventImageData = @"ImageData";
static NSString *S_EventVideoData = @"VideoData";
static NSString *S_EventGetCameraDevices = @"getCameraDevices";
static NSString *S_EventCameraDevices = @"cameraDevices";
static NSString *S_EventGetCameraDevicesFail = @"getCameraDevicesFail";
static NSString *S_EventUIEvent = @"UIEvent";

static NSString *CameraResponseEventDataKeyRequest = @"request";
static NSString *CameraResponseEventDataKeyData = @"data";

static NSString *S_EventCameraAccessDenied = @"cameraAccessDenied";

- (id) init {
    
    if (self = [super init]) {
        mLogger_ = nil;
        mEventsQueue_ = [[MessageQueue alloc] initWithHandler:self];
        [mEventsQueue_ startRunning];
        mCaptureState_= [[JSONObject alloc] init];
    }
    
    return self;
}

- (void) initComponent:(NSDictionary *)pConfig {
    
    mAppContext_ = (id<IApplicationContext>)[pConfig objectForKey:@"appContext"];
    mLogger_ = [mAppContext_ getLogger:LOGGER_NAME];
    
    [mLogger_ debug:@"%@", [CameraComponentVersion getVersionInfoToPrint]];
    
    [mLogger_ debug:@"CameraComponent : init"];
}

- (void) setIMHandler:(IM *)pIm {
    mIMHandler_ = pIm;
}

- (void) handleEvent:(IMEvent *)evt {
    [mEventsQueue_ addMessageToQueue:evt];
}


- (int) processMessage:(NSObject *)pMessage {
    
    IMEvent *event = (IMEvent *)pMessage;
    
    // Log event received
    NSMutableString *eventStr = [[NSMutableString alloc] init];
    [event debug:eventStr];
    [mLogger_ debug:@"CameraComponent : processMessage : %@", eventStr];
    
    if ([event.typeStr isEqualToString:S_EventStartPictureCapture]) {
        
        [self performSelectorOnMainThread:@selector(capturePicture:) withObject:event waitUntilDone:NO];
        
    } else if ([event.typeStr isEqualToString:S_EventStartVideoCapture]) {
        
        [self performSelectorOnMainThread:@selector(captureVideo:) withObject:event waitUntilDone:NO];
    }
    else if ([event.typeStr isEqualToString:S_EventPickPhoto]) {
        [self performSelectorOnMainThread:@selector(pickPhoto:) withObject:event waitUntilDone:NO];
    } else if ([event.typeStr isEqualToString:S_EventGetCameraDevices]) {
        [self performSelectorOnMainThread:@selector(getCameraDevices) withObject:nil waitUntilDone:NO];
    }
    
    return 0;
}

- (void) closeUI {
    // Close UI ...
}

- (void) unInit {
    
    [mCameraHandler_ releaseLock:mCameraHandler_];
    
    [mEventsQueue_ stopQueue];
    
    [self performSelectorOnMainThread:@selector(closeUI) withObject:nil waitUntilDone:TRUE];
    
    mIMHandler_ = nil;
    mAppContext_ = nil;
    mLogger_ = nil;
}

- (NSString *) getBase {
    return nil;
}

- (NSString *) getSourceId {
    return SOURCE_ID;
}

- (void) setBase:(NSString *)pArg0 {
}

- (BOOL) addEventListener:(NSString *)nodeId eventType:(NSString *)eventType {
    return YES;
}

- (BOOL) removeEventListeners {
    return YES;
}

- (BOOL) removeEventListener:(NSString *)pArg0 eventType:(NSString *)pArg1 {
    return YES;
}

- (void) raiseIMEvent:(NSString *)event fieldId:(NSString *)fieldId data:(NSString *)data {
    [mIMHandler_ addEvent:SOURCE_ID typestr:event target:fieldId data:data];
}

- (void) raiseErrorIMEvent:(NSString *)event target:(NSString *)fieldId error:(JSONObject *)error request:(JSONObject *)request{
    [error put:CameraResponseEventDataKeyRequest value:request];
    [self raiseIMEvent:event fieldId:fieldId data:[error toString]];
}

- (void) clearStateInfo {
}

- (void) imReady {
}

- (void) initializeCameraHandler {
    
    if (mCameraHandler_ == nil) {
        //UINavigationController* navigationController = (UINavigationController*)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        //UIViewController *topController = [navigationController topViewController];
        //mCameraHandler_ = [[CameraHandler alloc] initWithViewController:topController delegate:self logger:mLogger_ ];
        
        // Nov 04, 2019 : Get rid of the UIviewcontroller and directly present on the top/presentedViewController
        //mCameraViewControler_ = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        //[[mAppContext_ getCuemeAppNavigationController] pushViewController:mCameraViewControler_ animated:NO];
        //mCameraHandler_ = [[CameraHandlerCustom alloc] initWithViewController:mCameraViewControler_ delegate:self logger:mLogger_ ];
        
        UINavigationController *navController = [mAppContext_ getCuemeAppNavigationController];
        [mLogger_ debug:@"Camera : Create View Controller : viewcontroller presented=%@ top=%@",    [navController presentedViewController], [navController topViewController] ];
        
        UIViewController *parentViewController = navController.presentedViewController ? navController.presentedViewController : navController.topViewController;
        mCameraHandler_ = [[CameraHandlerCustom alloc] initWithViewController:parentViewController
                                                                     delegate:self
                                                                       logger:mLogger_ ];
        mCameraLock_ = [mCameraHandler_ acquireLock];
        
    }
}

- (void)checkCameraPermission:(IMEvent *)event completion:(void(^)(BOOL result))completionHandler {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        // do your logic
        completionHandler(YES);
        
    } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
        // denied
        completionHandler(NO);
    } else {
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
            if(granted){
              
                completionHandler(YES);
                
            } else {
              
                completionHandler(NO);
            }
        }];
    }
}

- (void) capturePicture:(IMEvent *)event {
    [mLogger_ debug:@"CameraComponent : capturePicture"];

    [self checkCameraPermission:event completion:^(BOOL result) {
        
        if(result) {
            
            __block JSONObject *cameraOptions = [[JSONObject alloc] init];
            __block JSONObject *pictureSize = nil;
            __block NSString *target = event.target;
            __block CameraComponent *bSelf = self;
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                
                NSError *error = nil;
                if ([StringUtil isNotBlank:(NSString*)event.data]) {
                    cameraOptions = [[JSONObject alloc] initWithJSONString:(NSString*)event.data error:&error];
                    if (error == nil && [cameraOptions has:@"pictureSize"]) {
                        pictureSize = [cameraOptions getJSONObject:@"pictureSize"];
                    }
                }
                
                [bSelf initializeCameraHandler];
                
                [cameraOptions put:@"allowEdit" value:@"false"];
                [cameraOptions put:@"destinationType" value:CameraHandler_DestinationTypeByteData];
                [cameraOptions put:@"media" value:CameraHandler_MediaTypePicture];
                [cameraOptions put:@"direction" value:[[cameraOptions optString:@"facing"] isEqualToString:@"front"] ? @"1" : @"0"];
                
                if ([pictureSize count] != 0 && [pictureSize optString:@"width"] != nil && [pictureSize optString:@"height"] != nil) {
                    [cameraOptions put:@"width" value:[pictureSize optString:@"width"]];
                    [cameraOptions put:@"height" value:[pictureSize optString:@"height"]];
                }
                
                @try {
                    [bSelf->mCaptureState_ put:@"captureMode" value:@"picture"];
                    [bSelf->mCameraHandler_ takePicture:self->mCameraLock_ cameraOptions:cameraOptions target:target];
                }
                @catch (NSException *e) {
                    [bSelf->mLogger_ exception:e msg:@"CameraComponent : capturePicture : Error:"];
                }
            });
        } else {
            
             [self raiseErrorIMEvent:S_EventCameraAccessDenied target:event.target error:[OSECameraComponentError constructErrorWithCode:OSECameraComponentErrorCodePermissionDenied errorDescription:nil] request:[[JSONObject alloc]init]];
        }
        
    }];
    
    //[viewController presentModalViewController:self.videoService.cameraController animated:YES];
}

- (void) captureVideo:(IMEvent *)event {
    [mLogger_ debug:@"CameraComponent : captureVideo"];
    
    [self checkCameraPermission:event completion:^(BOOL result) {
    
        if(result) {
    
            //NSString *proposedFileName = (NSString *)event.data;
            __block JSONObject *cameraOptions = [[JSONObject alloc] init];
            __block JSONObject *pictureSize = nil;
            if ([StringUtil isNotBlank:(NSString*)event.data]) {
                NSError *error = nil;
                cameraOptions = [[JSONObject alloc] initWithJSONString:(NSString*)event.data error:&error] ;
                if (error == nil && [cameraOptions has:@"pictureSize"]) {
                    pictureSize = [cameraOptions getJSONObject:@"pictureSize"];
                }
            }
            
            __block NSString *target = event.target;
            __block CameraComponent *bSelf = self;
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                
                [self initializeCameraHandler];
                
                //    JSONObject* cameraOptions = [[JSONObject alloc] init];
                [cameraOptions put:@"allowEdit" value:@"false"];
                [cameraOptions put:@"destinationType" value:CameraHandler_DestinationTypeFileUri];
                [cameraOptions put:@"storagePath" value:[[StoreManager getUserDataPath] stringByAppendingPathComponent:@"camera"]];
                [cameraOptions put:@"media" value:CameraHandler_MediaTypeVideo];
                [cameraOptions put:@"direction" value:[[cameraOptions optString:@"facing"] isEqualToString:@"front"] ? @"1" : @"0"];
                
                if ([pictureSize count] != 0 && [pictureSize optString:@"width"] != nil && [pictureSize optString:@"height"] != nil) {
                    [cameraOptions put:@"width" value:[pictureSize optString:@"width"]];
                    [cameraOptions put:@"height" value:[pictureSize optString:@"height"]];
                }
                
                @try {
                    [bSelf->mCaptureState_ put:@"captureMode" value:@"video"];
                    [bSelf->mCameraHandler_ takePicture:bSelf->mCameraLock_ cameraOptions:cameraOptions target:target];
                }
                @catch (NSException *e) {
                    [bSelf->mLogger_ exception:e msg:@"CameraComponent : captureVideo : Error:"];
                }
            });
        } else {
            
             [self raiseErrorIMEvent:S_EventCameraAccessDenied target:event.target error:[OSECameraComponentError constructErrorWithCode:OSECameraComponentErrorCodePermissionDenied errorDescription:nil] request:[[JSONObject alloc]init]];
        }
    }];
}

-(void) getCameraDevices{
    JSONArray *cameraDevices = [[JSONArray alloc] init];
    
    JSONObject *facingfront = [[JSONObject alloc] init];
    [facingfront put:@"facing" value:@"front"];
    JSONObject *facingback = [[JSONObject alloc] init];
    [facingback put:@"facing" value:@"back"];
    
    [cameraDevices addObject:facingfront];
    [cameraDevices addObject:facingback];
    
    [self raiseIMEvent:S_EventCameraDevices fieldId:nil data:cameraDevices.toString];
}

- (void) pickPhoto:(IMEvent *)event {
    [mLogger_ debug:@"CameraComponent : pickPhoto"];
    
    // NSString *proposedFileName = (NSString *)event.data;
    NSString *target = event.target;
    [self initializeCameraHandler];
    
    JSONObject* cameraOptions = [[JSONObject alloc] init];
    [cameraOptions put:@"allowEdit" value:@"false"];
    [cameraOptions put:@"destinationType" value:CameraHandler_DestinationTypeByteData];
    [cameraOptions put:@"media" value:CameraHandler_MediaTypePicture];
    
    // Set the source to photo album
    [cameraOptions put:@"source" value:@(UIImagePickerControllerSourceTypePhotoLibrary)];
    
    @try {
        [mCaptureState_ put:@"captureMode" value:@"picture"];
        [mCameraHandler_ takePicture:mCameraLock_ cameraOptions:cameraOptions target:target];
    }
    @catch (NSException *e) {
        [mLogger_ exception:e msg:@"CameraComponent : pickPhoto : Error:"];
    }
    
}

#pragma mark -
#pragma mark CuemeHandlerDelegate methods

- (void) cameraCaptureFailure:(NSString *)target options:(JSONObject *)options mediaType:(NSString *)mediaType reason:(NSString *)reason {
    [mLogger_ debug:@"CameraComponent : cameraCaptureFailure"];
    if ([[options get:@"media"] isEqualToString:@"video"]) {
        [mIMHandler_ addEvent:SOURCE_ID typestr:S_EventOnVideoCaptureFail target:target data:reason];
    } else {
        [mIMHandler_ addEvent:SOURCE_ID typestr:S_EventOnPictureCaptureFail target:target data:reason];
    }
    [self dismissCameraViewController];
}

- (void) cameraCaptureSuccess:(NSString *)target options:(JSONObject *)options mediaType:(NSString *)mediaType destinationType:(NSString *)destinationType result:(NSObject *)result {
    [mLogger_ debug:@"CameraComponent : cameraCaptureSuccess"];
    
    if ([[options get:@"media"] isEqualToString:@"video"]) {
        [mIMHandler_ addEvent:SOURCE_ID typestr:S_EventVideoFile target:target data:result];
    }else{
        [mIMHandler_ addEvent:SOURCE_ID typestr:S_EventImageData target:target data:result];
    }
    
    //    if ([mediaType isEqualToString:CameraHandler_MediaTypeVideo]) {
    //
    //
    //        if ([destinationType isEqualToString:CameraHandler_DestinationTypeFileUri]) {
    //            [mIMHandler_ addEvent:SOURCE_ID typestr:S_EventVideoFile target:target data:result];
    //        } else {
    //            [mIMHandler_ addEvent:SOURCE_ID typestr:S_EventVideoData target:target data:result];
    //        }
    //
    //    } else {
    //
    //        if ([destinationType isEqualToString:CameraHandler_DestinationTypeFileUri]) {
    //            [mIMHandler_ addEvent:SOURCE_ID typestr:S_EventImageFile target:target data:result];
    //        } else if ([destinationType isEqualToString:CameraHandler_DestinationTypeDataUrl]) {
    //            [mIMHandler_ addEvent:SOURCE_ID typestr:S_EventImageData target:target data:result];
    //        } else {
    //            [mIMHandler_ addEvent:SOURCE_ID typestr:S_EventImageData target:target data:result];
    //        }
    //
    //    }
    
    [self dismissCameraViewController];
}

- (void) cameraRaiseUIEvent:(NSString *)target data:(NSString *)data {
    [self raiseIMEvent:S_EventUIEvent fieldId:target data:data];
}

- (void) dismissCameraViewController {
    mCaptureState_ = [[JSONObject alloc] init];
    //[[mCameraViewControler_ navigationController] popViewControllerAnimated:NO];
    //mCameraViewControler_ = nil;
    [mCameraHandler_ releaseLock:mCameraLock_];
    [mCameraHandler_ cancel];
    mCameraHandler_ = nil;
}

// Nothing to handle
- (void) onApplicationBackground {
    [mLogger_ debug:@"CameraComponent : onApplicationBackground"];
    
    if ([[mCaptureState_ optString:@"captureMode"] isEqualToString:@"picture"]) {
        [self raiseIMEvent:S_EventOnPictureCaptureAborted fieldId:nil data:nil];
    }else if ([[mCaptureState_ optString:@"captureMode"] isEqualToString:@"video"]) {
        [self raiseIMEvent:S_EventOnVideoCaptureAborted fieldId:nil data:nil];
    }
    
    [mCameraHandler_ cancel];
    [self dismissCameraViewController];
}


// Nothing to handle
- (void) onApplicationForeground {
    [mLogger_ debug:@"CameraComponent : onApplicationForeground"];
}

// Nothing to handle
- (void) onContainerForeground {
    [mLogger_ debug:@"CameraComponent : onContainerForeground"];
}

// Nothing to handle
- (void) onContainerBackground {
    [mLogger_ debug:@"CameraComponent : onContainerBackground"];
    
    if ([[mCaptureState_ optString:@"captureMode"] isEqualToString:@"picture"]) {
        [self raiseIMEvent:S_EventOnPictureCaptureAborted fieldId:nil data:nil];
    }else if ([[mCaptureState_ optString:@"captureMode"] isEqualToString:@"video"])  {
        [self raiseIMEvent:S_EventOnVideoCaptureAborted fieldId:nil data:nil];
    }
    
    [mCameraHandler_ cancel];
    [self dismissCameraViewController];
}

#pragma mark -
- (BOOL) relinquishCameraLock {
    return NO;
}

- (void) cameraLockReacquired:(NSObject *)lock {
    
}

- (void) cameraLockRelinquished {
    
}

@end

