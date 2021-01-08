//
//  CameraHandler.h
//  CuemePlatformUtil
//
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

#import "CameraHandlerDelegate.h"


@class JSONObject;
@class Logger;

static NSString * const CameraHandler_EncodingTypeJPEG = @"jpeg";
static NSString * const CameraHandler_EncodingTypePNG = @"png";

static NSString * const CameraHandler_MediaTypePicture = @"image";
static NSString * const CameraHandler_MediaTypeVideo = @"video";
static NSString * const CameraHandler_MediaTypeAll = @"all";

static NSString * const CameraHandler_DestinationTypeDataUrl = @"base64";
static NSString * const CameraHandler_DestinationTypeFileUri = @"file";
static NSString * const CameraHandler_DestinationTypeByteData = @"data";

@interface CameraHandlerCustom : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


- (id) initWithViewController:(UIViewController *)viewController andDelegate:(id<CameraHandlerDelegate>)delegate ;
- (id) initWithViewController:(UIViewController *)viewController delegate:(id<CameraHandlerDelegate>)delegate logger:(Logger *)logger;

- (NSObject*) acquireLock ;
- (void) releaseLock: (NSObject*) lock ;

/**
 * Takes a picture. 
 * 
 * lock: Lock Object obtain from acquireLock. 
 * cameraOptions: 
 * target: any string to help identify the current picture capture. 
 * 
 * @throws Exception: Must catch exception when making this call
 */
- (void)takePicture:(NSObject *)lock cameraOptions:(JSONObject*)cameraOptions target:(NSString *)target;
- (void) cancel;

@end
