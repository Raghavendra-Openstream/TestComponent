//
//  CameraHandler.m
//  CuemePlatformUtil
//
//  Created by Anthapu Ravindranatha Reddy on 2/19/14.
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Photos;

#import "CameraHandlerCustom.h"
#import "JSONObject.h"
#import "Base64Util.h"
#import "Logger.h"
#import "CuemeCameraCustomView.h"
#import "OSEImageProcess.h"

#define CAMERA_TRANSFORM  1.5

@interface CuemeCameraPickerCustom : UIImagePickerController <CustomViewDelegate>
{}

@property (strong) JSONObject* options;
@property (assign) NSInteger quality;
@property (strong) NSString* encodingType;
/*@property (strong) UIPopoverController* popoverController;*/
@property (assign) CGSize targetSize;
@property (assign) bool correctOrientation;
@property (assign) bool saveToPhotoAlbum;
@property (assign) bool cropToSize;
@property (assign) BOOL popoverSupported;
@property (strong) NSString *destinationType;
@property (strong) NSString *storagePath;
@property (strong) NSString *mediaType;
@property (strong) NSString *target;

@property (nonatomic) BOOL customized;
@property (nonatomic) BOOL forceLandscape;
@property (nonatomic) BOOL edgeDetection;
@property (nonatomic) BOOL enableOCR;
@property (nonatomic) CuemeCameraCustomView *customView;
@property (nonatomic) NSString *topTitle;
@property (nonatomic) UIColor *cameraTintColor;
@property (nonatomic) BOOL isVideoStarted;
@property (nonatomic, weak) CameraHandlerCustom *cameraHandler;
@property (nonatomic) BOOL enableViewFinder;
@property (nonatomic) BOOL infoButtonHidden;
@property (nonatomic) CGSize viewFinderSize;
@property (nonatomic) CAShapeLayer *viewFinderLayer;
@property (nonatomic) CAShapeLayer *backgroundImageViewLayer;
@property (nonatomic) NSString *previewMode;
@property (nonatomic) UIImage *backgroundImage;

@end

@interface CameraHandlerCustom() {
    @private
    BOOL hasPendingOperation ;
    CuemeCameraPickerCustom* pickerController ;
    UIViewController *mParentViewController_;
    id<CameraHandlerDelegate> mDelegate_;
    Logger *mLogger_;
    
}
- (BOOL)popoverSupported ;
- (void)doTakePicture:(JSONObject*)cameraOptions target:(NSString *)target;

@end

@implementation CameraHandlerCustom

static NSString * const CUEME_PHOTO_PREFIX = @"image";
static NSObject* CameraLock ;

- (id) initWithViewController:(UIViewController *)viewController andDelegate:(id<CameraHandlerDelegate>)delegate {
    self = [super init];
    if (self) {
        mParentViewController_ = viewController;
        mDelegate_ = delegate;
    }
    
    return self;
}

- (id) initWithViewController:(UIViewController *)viewController delegate:(id<CameraHandlerDelegate>)delegate logger:(Logger *)logger{
    self = [super init];
    if (self) {
        mParentViewController_ = viewController;
        mDelegate_ = delegate;
        mLogger_ = logger;
    }
    
    return self;
}

// TODO: Keyur : Implement lock relinquish
- (NSObject*) acquireLock {
    if( CameraLock == nil ) {
        CameraLock = [[NSObject alloc] init] ;
        return CameraLock ;
    }
    return nil ;
}

- (void) releaseLock: (NSObject*) lock {
    if( lock == CameraLock ) {
        CameraLock = nil ;
    }
}

/*
 * Takes a picture
 *
 * @param cameraOptions : Camera Options JSONObject
 * @param target: An optional string used to identify the capture session, this string is returned in the delegate callbacks
 */
- (void)takePicture:(NSObject *)lock cameraOptions:(JSONObject*)cameraOptions target:(NSString *)target
{
    /*if( lock != CameraLock ) {
        [NSException raise:@"Invalid Camera Lock." format:@"Camera Lock is invalid. May not be the owner of the Lock."];
    }*/
    
    if( cameraOptions == nil ) {
        cameraOptions = [[JSONObject alloc] init];
    }
    
    [self doTakePicture:cameraOptions target:target];
}

- (void)doTakePicture:(JSONObject*)cameraOptions target:(NSString *)target
{
    hasPendingOperation = NO;
    
    NSString* sourceTypeString = [cameraOptions getString:@"source"];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera; // default
    if (sourceTypeString != nil) {
        sourceType = (UIImagePickerControllerSourceType)[sourceTypeString intValue];
    }
    
    bool hasCamera = [UIImagePickerController isSourceTypeAvailable:sourceType];
    if (!hasCamera) {
        NSLog(@"Camera.getPicture: source type %d not available.", [sourceTypeString intValue]);
        //CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"no camera available"];
        //[self.commandDelegate sendPluginResult:result callbackId:callbackId];
        return;
    }
    
    bool allowEdit = [cameraOptions getString:@"allowEdit"] ? [[cameraOptions getString:@"allowEdit"] boolValue] : NO;
    NSString* targetWidth = [cameraOptions getString:@"width"];
    NSString* targetHeight = [cameraOptions getString:@"height"];
    NSString* mediaValue = [cameraOptions getString:@"media"];
    NSString* mediaType = (mediaValue) ? mediaValue : CameraHandler_MediaTypePicture;
    
    CGSize targetSize = CGSizeMake(0, 0);
    if ((targetWidth != nil) && (targetHeight != nil)) {
        targetSize = CGSizeMake([targetWidth floatValue], [targetHeight floatValue]);
    }
    
    // If a popover is already open, close it; we only want one at a time.
    /* TODO: Support popover for iPad
    if (([pickerController popoverController] != nil) && [[pickerController popoverController] isPopoverVisible]) {
        [[pickerController popoverController] dismissPopoverAnimated:YES];
        [[pickerController popoverController] setDelegate:nil];
        [pickerController setPopoverController:nil];
    }
     */
    
    CuemeCameraPickerCustom* cameraPicker = [[CuemeCameraPickerCustom alloc] init];
    pickerController = cameraPicker;
    
    //cameraPicker.quality = 0.5;
    
    // Added modalPresentationStyle to fix the issue where Pick Photo view always launched in portrait mode
//    cameraPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    cameraPicker.cameraHandler = self;
    cameraPicker.options = cameraOptions;
    cameraPicker.target = target;
    cameraPicker.delegate = self;
    cameraPicker.sourceType = sourceType;
    cameraPicker.allowsEditing = allowEdit; // THIS IS ALL IT TAKES FOR CROPPING - jm
    //cameraPicker.callbackId = callbackId;
    cameraPicker.targetSize = targetSize;
    cameraPicker.cropToSize = [cameraOptions getBool:@"cropToSize"];
    // we need to capture this state for memory warnings that dealloc this object
    //cameraPicker.webView = self.webView;
    cameraPicker.popoverSupported = [self popoverSupported];
    
    cameraPicker.correctOrientation =  [cameraOptions getString:@"correctOrientation"] ?[[cameraOptions getString:@"correctOrientation"] boolValue] :YES;
    cameraPicker.saveToPhotoAlbum = [[cameraOptions getString:@"saveToAlbum"] boolValue];
    /*** TODO  **/
    cameraPicker.encodingType = ([cameraOptions getString:@"encoding"] != nil) ? [cameraOptions getString:@"encoding"]  : CameraHandler_EncodingTypeJPEG;
    
    cameraPicker.quality = ([cameraOptions getString:@"quality"]) ? [[cameraOptions getString:@"quality"] intValue] : 50;
    cameraPicker.destinationType = ([cameraOptions getString:@"destinationType"] != nil) ? [cameraOptions getString:@"destinationType"] : CameraHandler_DestinationTypeByteData;
    
    if ([cameraPicker.destinationType isEqualToString:CameraHandler_DestinationTypeFileUri]) {
        cameraPicker.storagePath = [cameraOptions getString:@"storagePath"];
    }
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        // We only allow taking pictures (no video) in this API.
        //cameraPicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
        NSArray* mediaArray = [NSArray arrayWithObjects:(NSString*)([mediaType isEqualToString:CameraHandler_MediaTypeVideo] ? kUTTypeMovie : kUTTypeImage), nil];
        cameraPicker.mediaTypes = mediaArray;
        
        // We can only set the camera device if we're actually using the camera.
        int cameraDirection = ([cameraOptions getString:@"direction"]) ?
                                [[cameraOptions getString:@"direction"] intValue] :
                                UIImagePickerControllerCameraDeviceRear;
        cameraPicker.cameraDevice = (UIImagePickerControllerCameraDevice) cameraDirection;
        
        // Set Camera Flash Mode
        [self setCameraFlashMode:[cameraOptions getString:@"flashMode"] onPicker:cameraPicker];
        
        NSNumber *timer = [cameraOptions get:@"timer"];
        if (timer != nil) {
            cameraPicker.showsCameraControls = NO;
        }
        
        
    } else if ([mediaType isEqualToString:CameraHandler_MediaTypeAll]) {
        cameraPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    } else {
        NSArray* mediaArray = [NSArray arrayWithObjects:(NSString*)([mediaType isEqualToString:CameraHandler_MediaTypeVideo] ? kUTTypeMovie : kUTTypeImage), nil];
        cameraPicker.mediaTypes = mediaArray;
    }
    
    // TODO: Implement popover for camera
    /*** TODO
    if ([self popoverSupported] && (sourceType != UIImagePickerControllerSourceTypeCamera)) {
        if (cameraPicker.popoverController == nil) {
            cameraPicker.popoverController = [[NSClassFromString(@"UIPopoverController")alloc] initWithContentViewController:cameraPicker];
        }
        JSONObject* options = [cameraOptions getJSONObject:@"popoverOptions"];
        [self displayPopover:options];
    } else {
     TODO *****/
    
    if([cameraOptions getBool:@"customized"] || ([cameraOptions has:@"useNativeCamera"] && [cameraOptions getBool:@"useNativeCamera"] == NO)) {
        
        cameraPicker.customized = YES;
        cameraPicker.forceLandscape = [cameraOptions getBool:@"forceLandscape"];
        cameraPicker.edgeDetection = [cameraOptions getBool:@"edgeDetection"];
        cameraPicker.enableOCR = [cameraOptions getBool:@"enableOCR"];

        [self setToolbarOptions:[cameraOptions getJSONObject:@"toolbar"] cameraPicker:cameraPicker];
        
        JSONObject *viewFinderObject = [cameraOptions getJSONObject:@"viewFinder"] ;
        if (!viewFinderObject) {
            viewFinderObject = [cameraOptions getJSONObject:@"viewFinderSize"];
        }
        cameraPicker.enableViewFinder = viewFinderObject != nil;//Show View Finder View
        if(cameraPicker.enableViewFinder) {
            
            NSString* viewFinderWidth = [viewFinderObject getString:@"width"];
            NSString* viewFinderHeight = [viewFinderObject getString:@"height"];
            
            CGSize viewFinderSizeData = CGSizeMake(0, 0);
            
            if ((viewFinderWidth != nil) && (viewFinderHeight != nil)) {
                viewFinderSizeData = CGSizeMake([viewFinderWidth floatValue], [viewFinderHeight floatValue]);
            }
            
            cameraPicker.viewFinderSize = viewFinderSizeData;
        }
        
        NSString *previewModeString = [cameraOptions getString:@"previewMode"];//@"Fill";
        if(!previewModeString) {
            
            previewModeString = @"Fill";
        }
        
        cameraPicker.previewMode = previewModeString;
                
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            
            if([cameraPicker.previewMode isEqualToString:@"Fill"]) {
                
                //Change Camera aspect to Fill (Full Screen)
                CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                
                if(screenSize.width > screenSize.height) {
                    CGFloat width = screenSize.width;
                    screenSize.width = screenSize.height;
                    screenSize.height = width;
                }
                
                float cameraAspectRatio = 4.0 / 3.0;
                float imageHeight = floorf(screenSize.width * cameraAspectRatio);
                float scale = screenSize.height / imageHeight;
                float trans = (screenSize.height - imageHeight)/2;
                CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, trans);
                CGAffineTransform final = CGAffineTransformScale(translate, scale, scale);
                cameraPicker.cameraViewTransform = final;
            }
        }
        
        cameraPicker.showsCameraControls = NO;
        
    } else {
        
         cameraPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    cameraPicker.modalPresentationStyle = UIModalPresentationFullScreen;

    [mParentViewController_ presentViewController:cameraPicker animated:YES completion:^{
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            NSNumber *timer = [cameraOptions get:@"timer"];
            if (timer != nil) {
                
                // Covert milliseconds to seconds and trigger the shutter using dispatch_after
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((timer.doubleValue/1000.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [cameraPicker takePicture];
                });
            }
        }
    }];
    
    //}
}

/**
 Support the following json format
  toolbar = {
    controlsColor: '#e24083',
    backgroundColor: '#7F000000',
     title: {
        text: 'Take Picture',
        //textColor: '#00FF00'
     },
     closeButton: {
        icon: 'close', // resource:// etc bundle:// pref size:
        showIcon: true,
     //align: 'left', // Not supported on iOS
     },
     keyboardButton: {
 
     },
 
     infoButton: {
        icon: 'info', // resource:// etc bundle:// pref size:
        showIcon: true,
     }
 }
 **/
- (void) setToolbarOptions:(JSONObject *)toolbarOptions cameraPicker:(CuemeCameraPickerCustom *)cameraPicker {
    
    NSString *controlsColor = [toolbarOptions getString:@"controlsColor"];
    if(controlsColor.length > 0) {
        
        cameraPicker.cameraTintColor = [self getUIColorObjectFromHexString:controlsColor];
        
    } else {
        
        cameraPicker.cameraTintColor = [UIColor whiteColor];
    }
    

    // TODO: Set the toolbar background color :
    /*
    NSString *backgroundColorString = [[toolbarOptions getJSONObject:@"title"] getString:@"backgroundColor"];
    if (backgroundColorString.length > 0) {
        self.topTitleBgColor = [self getUIColorObjectFromHexString:backgroundColorString];
    } else {
       self.topTitleBgColor = nil;
    }
     */
    
    // Set the toolbar title text
    NSString *toolbarTitleText = [[toolbarOptions getJSONObject:@"title"] getString:@"text"];
    if (toolbarTitleText == nil) {
        toolbarTitleText = @"";
    }
    cameraPicker.topTitle =  toolbarTitleText;
    
    // Set the toolbar title font color
    /*
    NSString *titleColorString = [[toolbarOptions getJSONObject:@"title"] getString:@"textColor"];
    if (titleColorString.length > 0) {
        self.topTitleTextColor = [self getUIColorObjectFromHexString:titleColorString];
    } else {
        self.topTitleTextColor = nil;
    }
     */
    
    // Close button is not customizable
    
    // Set the Info button title
    JSONObject *infoButtonConfig = [toolbarOptions getJSONObject:@"infoButton"];
    if ([infoButtonConfig has:@"hidden"] && [infoButtonConfig getBool:@"hidden"] == YES) {
        cameraPicker.infoButtonHidden = YES;
    }
}
/*!
 @brief Sets the flash mode on camera picker
 */
- (void) setCameraFlashMode:(NSString *)flashModeOption onPicker:(CuemeCameraPickerCustom *)cameraPicker {
    if (flashModeOption) {
        
        UIImagePickerControllerCameraFlashMode cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        if ([flashModeOption isEqualToString:@"on"]) {
            cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        } else if ([flashModeOption isEqualToString:@"auto"]) {
            cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        } else if ([flashModeOption isEqualToString:@"off"]) {
            cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        }
        
        cameraPicker.cameraFlashMode = cameraFlashMode;
    }
}

- (void) cancel {
    [pickerController dismissViewControllerAnimated:YES completion:nil];
}

/**
- (void)repositionPopover:(JSONObject *)options
{
    [self displayPopover:options];
}


- (void)displayPopover:(JSONObject *)options
{
    int x = 0;
    int y = 32;
    int width = 320;
    int height = 480;
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionAny;
    
    
    if (options) {
        x = [options getString:@"x"] ? [[options getString:@"x"] intValue] : 0;
        y = [options getString:@"y"] ? [[options getString:@"y"] intValue] : 32;
        width = [options getString:@"width"] ? [[options getString:@"width"] intValue] : 320;
        height = [options getString:@"height"] ? [[options getString:@"height"] intValue] : 480;
        arrowDirection = [options getString:@"arrowDirection"] ? [[options getString:@"arrowDirection"] intValue] : UIPopoverArrowDirectionAny;
        if (arrowDirection != UIPopoverArrowDirectionAny &&
            arrowDirection != UIPopoverArrowDirectionUp &&
            arrowDirection != UIPopoverArrowDirectionDown &&
            arrowDirection != UIPopoverArrowDirectionLeft &&
            arrowDirection != UIPopoverArrowDirectionRight
            ) {
            arrowDirection = UIPopoverArrowDirectionAny;
        }
    }
    
    [[pickerController popoverController] setDelegate:self];
    [[pickerController popoverController] presentPopoverFromRect:CGRectMake(x, y, width, height)
                                                                 inView:[self.webView superview]
                                               permittedArrowDirections:arrowDirection
                                                               animated:YES];
 
}
//TODO ****/

- (BOOL)popoverSupported
{
    // TODO: Implement popover support for iPad
    //return (NSClassFromString(@"UIPopoverController") != nil) && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    return NO;
}

- (void) handleUIEvent:(NSString *)target data:(NSString *)data  {
    [mDelegate_ cameraRaiseUIEvent:target data:data];
}

- (void) closeCameraPicker:(CuemeCameraPickerCustom *)cameraPicker completion:(void (^ __nullable)(void))completion {
    
    if (cameraPicker.popoverSupported /* && (cameraPicker.popoverController != nil)*/ ) {
        /* // TODO: Implement popover support for iPad
         [cameraPicker.popoverController dismissPopoverAnimated:YES];
         cameraPicker.popoverController.delegate = nil;
         cameraPicker.popoverController = nil;
         */
        completion();
    } else {
        [[cameraPicker presentingViewController] dismissViewControllerAnimated:YES completion:^{
            if(completion) {
                completion();
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    __block CuemeCameraPickerCustom* cameraPicker = (CuemeCameraPickerCustom*)picker;
    __block id<CameraHandlerDelegate> delegate = mDelegate_;
    [self closeCameraPicker:cameraPicker completion:^{
        [delegate cameraCaptureFailure:cameraPicker.target options:cameraPicker.options mediaType:cameraPicker.mediaType reason:@"User cancelled"];
    }];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [mLogger_ debug:@"CameraHandlerCustom:imagePickerController:didFinishPickingMediaWithInfo: begin"];
    CuemeCameraPickerCustom* cameraPicker = (CuemeCameraPickerCustom*)picker;
    CGRect viewBounds = cameraPicker.view.bounds;
    
    if (cameraPicker.popoverSupported /* && (cameraPicker.popoverController != nil)*/ ) {
        /* // TODO: Implement popover support for iPad
        [cameraPicker.popoverController dismissPopoverAnimated:YES];
        cameraPicker.popoverController.delegate = nil;
        cameraPicker.popoverController = nil;
        */
    } else {
        [[cameraPicker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // IMAGE TYPE
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        
        // get the image
        UIImage* image = nil;
        if (cameraPicker.allowsEditing && [info objectForKey:UIImagePickerControllerEditedImage]) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (cameraPicker.correctOrientation) {
            image = [self imageCorrectedForCaptureOrientation:image forceLandscape:cameraPicker.forceLandscape];
        }
        
        UIImage* scaledImage = nil;
        
        if (cameraPicker.enableViewFinder && (cameraPicker.viewFinderSize.width > 0) && (cameraPicker.viewFinderSize.height > 0)) {
            
            float widthFactor = cameraPicker.viewFinderSize.width / viewBounds.size.width;
            float heightFactor = cameraPicker.viewFinderSize.height / viewBounds.size.height;
            
            /*
            CGRect targetRect = CGRectMake((viewBounds.size.width / 2) - (cameraPicker.viewFinderSize.width/2), (viewBounds.size.height / 2) - (cameraPicker.viewFinderSize.height/2),
                                           cameraPicker.viewFinderSize.width,
                                           cameraPicker.viewFinderSize.height);
           
            //CGRect scaledTargetRect = CGRectInset(targetRect, targetRect.size.width * widthFactor * -1.0, targetRect.size.height * heightFactor * -1.0);
             */
            
            float scaleFactor = 0.0;
            float newW = 0.0;
            float newH = 0.0;
            
            if (viewBounds.size.width > viewBounds.size.height) { // Landscape image
                //scaleFactor = cameraPicker.viewFinderSize.width / viewBounds.size.width;
                scaleFactor = cameraPicker.viewFinderSize.height / cameraPicker.viewFinderSize.width;
                newW = image.size.width * widthFactor;
                newH = newW * scaleFactor;
                
            } else { //Portrait
                scaleFactor = cameraPicker.viewFinderSize.width / cameraPicker.viewFinderSize.height;
                newH = image.size.height * heightFactor;
                newW = newH * scaleFactor;
            }
            
            float newX = image.size.width/2.0 - newW/ 2.0;
            float newY = image.size.height/2.0 - newH / 2.0;

            CGRect scaledTargetRect = CGRectMake(newX, newY, newW, newH);
            
            [mLogger_ debug:@"Scaling to viewfinder..."];
            scaledImage = [self imageByCropFromRect:scaledTargetRect forImage:image];
            
        } else if ((cameraPicker.targetSize.width > 0) && (cameraPicker.targetSize.height > 0)) {
            // if cropToSize, resize image and crop to target size, otherwise resize to fit target without cropping
            if (cameraPicker.cropToSize) {
                scaledImage = [self imageByScalingAndCroppingForSize:image toSize:cameraPicker.targetSize];
            } else {
                scaledImage = [self imageByScalingNotCroppingForSize:image toSize:cameraPicker.targetSize];
            }
        }
        
        UIImage *outputImage = (scaledImage == nil ? image : scaledImage);
        
        //Normal Image process without edge detection
        if(!cameraPicker.edgeDetection) {
            
            [self processOCR:outputImage andPicker:cameraPicker];
            
        } else {
            
            //Image process with edge detection
            [[OSEImageProcess sharedInstance] detectEdgeUsingVisionFramework:[[OSEImageProcess sharedInstance]
                                                             normalizedImage:outputImage]
                                                        withCompletionHandler:^(BOOL result, UIImage * _Nullable resultImage) {
                if(result && resultImage) {
                    
                    [self processOCR:resultImage andPicker:cameraPicker];
                    
                } else {
                    
                    NSLog(@"Failed to detect edges, please try again...");
                    [self processOCR:outputImage andPicker:cameraPicker];
                }
                
            }];
        }
    }
    // NOT IMAGE TYPE (MOVIE)
    else {
        NSString* moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] absoluteString];
        [mDelegate_ cameraCaptureSuccess:cameraPicker.target options:cameraPicker.options mediaType:cameraPicker.mediaType destinationType:cameraPicker.destinationType result:moviePath];
    }
    
    hasPendingOperation = NO;
    pickerController = nil;
}


// returnedImage is the image that is returned to caller and (optionally) saved to photo album
- (void)processOCR:(UIImage *)returnedImage andPicker:(CuemeCameraPickerCustom *)cameraPicker {
    
    //Normal Image process without text detection
    if(!cameraPicker.enableOCR) {
        
        [self processImage:returnedImage andPicker:cameraPicker];
        
    } else {
        
        UIImage *inputImage = returnedImage;
        if(!cameraPicker.edgeDetection) {
            
            inputImage = [[OSEImageProcess sharedInstance] normalizedImage:returnedImage];
        }
        
        //Image process with text detection
        [[OSEImageProcess sharedInstance] detectText:inputImage withCompletionHandler:^(BOOL result, NSString * _Nullable detectedText, NSArray * _Nullable arrayOfDetectedText) {
            
            if(!result) {
                
                NSLog(@"Failed to detect text, please try again...");
            } else {
                
                //TODO: Pass OCR result 'detectedText' or 'arrayOfDetectedText'
            }
            
            [self processImage:returnedImage andPicker:cameraPicker];
        }];
    }
}


// returnedImage is the image that is returned to caller and (optionally) saved to photo album
- (void)processImage:(UIImage *)returnedImage andPicker:(CuemeCameraPickerCustom *)cameraPicker {
    
    NSData* data = nil;
        
    if ([cameraPicker.encodingType isEqualToString:CameraHandler_EncodingTypePNG]) {
        data = UIImagePNGRepresentation(returnedImage);
    } else if ((cameraPicker.allowsEditing==false) && (cameraPicker.targetSize.width <= 0) && (cameraPicker.targetSize.height <= 0) && (cameraPicker.correctOrientation==false)){
        // use image unedited as requested , don't resize
        
        if (cameraPicker.quality > 0) {
            data = UIImageJPEGRepresentation(returnedImage, cameraPicker.quality / 100.0f);
        } else {
            data = UIImageJPEGRepresentation(returnedImage, 1.0);
        }
        
    } else {
        data = UIImageJPEGRepresentation(returnedImage, cameraPicker.quality / 100.0f);
    }
    
    if (cameraPicker.saveToPhotoAlbum) {
        /*
        ALAssetsLibrary *library = [ALAssetsLibrary new];
        [library writeImageToSavedPhotosAlbum:returnedImage.CGImage orientation:(ALAssetOrientation)(returnedImage.imageOrientation) completionBlock:nil];
         */
        
        __block PHObjectPlaceholder *placeholder;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:returnedImage];
            placeholder = [createAssetRequest placeholderForCreatedAsset];
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (success)
            {
                [self->mLogger_ debug:@"CameraHandlerCustom:imagePickerController:saveToPhotoAlbum complete"];
            }
            else
            {
                [self->mLogger_ error:@"CameraHandlerCustom:imagePickerController:saveToPhotoAlbum failed : %@", error];
            }
        }];
    }
    
    if ([cameraPicker.destinationType isEqualToString:CameraHandler_DestinationTypeFileUri]) {
        
        NSError* err = nil;
        NSFileManager* fileMgr = [[NSFileManager alloc] init]; // recommended by apple (vs [NSFileManager defaultManager]) to be threadsafe
        // generate unique file name
        NSString* filePath;
        
        int i = 1;
        do {
            filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", cameraPicker.storagePath, CUEME_PHOTO_PREFIX, i++, [cameraPicker.encodingType isEqualToString:CameraHandler_EncodingTypePNG] ? @"png":@"jpg"];
        } while ([fileMgr fileExistsAtPath:filePath]);
        
        [fileMgr createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
         
        // save file
        if (![data writeToFile:filePath options:NSAtomicWrite error:&err]) {
            [mLogger_ debug:@"CameraHandlerCustom:imagePickerController:didFinishPickingMediaWithInfo: cameraCaptureFailure"];
            [mDelegate_ cameraCaptureFailure:cameraPicker.target options:cameraPicker.options mediaType:cameraPicker.mediaType reason:[err localizedDescription]];
        } else {
            [mLogger_ debug:@"CameraHandlerCustom:imagePickerController:didFinishPickingMediaWithInfo: cameraCaptureSuccess"];
            [mDelegate_ cameraCaptureSuccess:cameraPicker.target options:cameraPicker.options mediaType:cameraPicker.mediaType destinationType:cameraPicker.destinationType result:[[NSURL fileURLWithPath:filePath] absoluteString]];
        }
    } else if ([cameraPicker.destinationType isEqualToString:CameraHandler_DestinationTypeDataUrl]) {
        [mDelegate_ cameraCaptureSuccess:cameraPicker.target options:cameraPicker.options mediaType:cameraPicker.mediaType destinationType:cameraPicker.destinationType result:[Base64Util encode:data]];
    } else {
        [mDelegate_ cameraCaptureSuccess:cameraPicker.target options:cameraPicker.options mediaType:cameraPicker.mediaType destinationType:cameraPicker.destinationType result:data];
    }
}

-(UIImage*)imageByCropFromRect:(CGRect)fromRect forImage:(UIImage*)anImage
{
    fromRect = CGRectMake(fromRect.origin.x * anImage.scale,
                          fromRect.origin.y * anImage.scale,
                          fromRect.size.width * anImage.scale,
                          fromRect.size.height * anImage.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(anImage.CGImage, fromRect);
    UIImage* crop = [UIImage imageWithCGImage:imageRef scale:anImage.scale orientation:anImage.imageOrientation];
    CGImageRelease(imageRef);
    return crop;
}

- (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)anImage toSize:(CGSize)targetSize
{
    UIImage* sourceImage = anImage;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

// Force lanscape is added because the image would show rotated 2 out of 5 times
- (UIImage*)imageCorrectedForCaptureOrientation:(UIImage*)anImage forceLandscape:(BOOL)forceLandscape
{
    float rotation_radians = 0;
    bool perpendicular = false;
    
    UIImageOrientation orientation = [anImage imageOrientation];
    //if (forceLandscape) {
    //    return anImage;
    //}
    
    switch (orientation) {
        case UIImageOrientationUp :
            rotation_radians = 0.0;
            break;
            
        case UIImageOrientationDown:
            rotation_radians = M_PI; // don't be scared of radians, if you're reading this, you're good at math
            break;
            
        case UIImageOrientationRight:
            rotation_radians = M_PI_2;
            perpendicular = true;
            break;
            
        case UIImageOrientationLeft:
            rotation_radians = -M_PI_2;
            perpendicular = true;
            break;
            
        default:
            break;
    }
    
    [mLogger_ debug:@"CameraHandlerCustom : imageCorrectedForCaptureOrientation : screen-orientation=%ld image-orientation=%ld perpendicular=%@", [[UIDevice currentDevice] orientation], [anImage imageOrientation], perpendicular ? @"YES" : @"NO"];
    
    UIGraphicsBeginImageContext(CGSizeMake(anImage.size.width, anImage.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Rotate around the center point
    CGContextTranslateCTM(context, anImage.size.width / 2, anImage.size.height / 2);
    CGContextRotateCTM(context, rotation_radians);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    float width = perpendicular ? anImage.size.height : anImage.size.width;
    float height = perpendicular ? anImage.size.width : anImage.size.height;
    CGContextDrawImage(context, CGRectMake(-width / 2, -height / 2, width, height), [anImage CGImage]);
    
    // Move the origin back since the rotation might've change it (if its 90 degrees)
    if (perpendicular) {
        CGContextTranslateCTM(context, -anImage.size.height / 2, -anImage.size.width / 2);
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageByScalingNotCroppingForSize:(UIImage*)anImage toSize:(CGSize)frameSize
{
    UIImage* sourceImage = anImage;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = frameSize.width;
    CGFloat targetHeight = frameSize.height;
    CGFloat scaleFactor = 0.0;
    CGSize scaledSize = frameSize;
    
    if (CGSizeEqualToSize(imageSize, frameSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        // opposite comparison to imageByScalingAndCroppingForSize in order to contain the image within the given bounds
        if (widthFactor > heightFactor) {
            scaleFactor = heightFactor; // scale to fit height
        } else {
            scaleFactor = widthFactor; // scale to fit width
        }
        scaledSize = CGSizeMake(MIN(width * scaleFactor, targetWidth), MIN(height * scaleFactor, targetHeight));
    }
    
    UIGraphicsBeginImageContext(scaledSize); // this will resize
    
    [sourceImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr
{
    // Convert hex string to an integer
    unsigned int hexInt = [self intFromHexString:hexStr];
    
    // Create a color object, specifying alpha as well
    UIColor *color = [UIColor colorWithRed:((CGFloat) ((hexInt & 0xFF0000) >> 16))/255
                                     green:((CGFloat) ((hexInt & 0xFF00) >> 8))/255
                                      blue:((CGFloat) (hexInt & 0xFF))/255
                                     alpha:1.0];
    
    return color;
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

@end

@implementation CuemeCameraPickerCustom

@synthesize quality;
/*@synthesize popoverController;*/
@synthesize targetSize;
@synthesize correctOrientation;
@synthesize saveToPhotoAlbum;
@synthesize encodingType;
@synthesize cropToSize;
@synthesize popoverSupported;
@synthesize destinationType;
@synthesize storagePath;
@synthesize options;
@synthesize mediaType;
@synthesize target;

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIViewController*)childViewControllerForStatusBarHidden {
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    SEL sel = NSSelectorFromString(@"setNeedsStatusBarAppearanceUpdate");
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel withObject:nil afterDelay:0];
    }
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFrameWithOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification//UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if(self.customized) {
        
        self.customView = [[CuemeCameraCustomView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) andBundle:[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"CameraComponentResource" withExtension:@"bundle"]]];

        self.customView.captureButton.layer.cornerRadius = self.customView.captureButton.frame.size.width / 2;
        
        self.customView.captureButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.customView.captureButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        NSString *backgroundImageBase64 = [self.options get:@"overlayImage"] ;
        if (!backgroundImageBase64) {
            backgroundImageBase64 = [self.options get:@"backgroundImage"];
        }
        if (backgroundImageBase64) {
            
            self.backgroundImage = [self getImageUsingBase64String:backgroundImageBase64];
            
            if(self.backgroundImage) {
                
                self.customView.backgroundImageView.image = self.backgroundImage;
            }
        }
        
        
        NSString *shutterRingImageBase64 = [self.options get:@"shutterRingImage"];
        
        if (shutterRingImageBase64) {
          
            UIImage *shutterRingImage = [self getImageUsingBase64String:shutterRingImageBase64];
            
            if(shutterRingImage) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.customView.captureButton setBackgroundImage:shutterRingImage forState:UIControlStateNormal];
                });
                
            } else {
                
                self.customView.captureButton.layer.borderWidth = 7;
                self.customView.captureButton.layer.borderColor = [self.cameraTintColor CGColor];
            }
            
        } else {
            
            self.customView.captureButton.layer.borderWidth = 7;
            self.customView.captureButton.layer.borderColor = [self.cameraTintColor CGColor];
        }
        
        if(self.forceLandscape && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            
            [self updateUIDependsOnOrientation:UIDeviceOrientationLandscapeRight];
            
        } else {
            
            [self updateUIDependsOnOrientation:[[UIDevice currentDevice] orientation]];
        }
        
        if(self.enableViewFinder && (self.viewFinderSize.width > 0) && (self.viewFinderSize.height > 0)) {
            
            self.customView.viewFinderView.hidden = NO;
            self.viewFinderLayer = [CAShapeLayer layer];
            self.viewFinderLayer.path = [self getViewFinderOverlayPath].CGPath;
            self.viewFinderLayer.fillRule = kCAFillRuleEvenOdd;
            self.viewFinderLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
            
            [self.customView.viewFinderView.layer addSublayer:self.viewFinderLayer];

            self.customView.topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            
            self.customView.safeareaTopView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            self.customView.backgroundImageViewFillColorView.backgroundColor = [UIColor clearColor];
            self.customView.backgroundImageView.hidden = YES;
            
        } else {
            
            self.customView.backgroundImageView.hidden = NO;
            self.backgroundImageViewLayer = [CAShapeLayer layer];
            [self setBackgroundImageViewLayer];

            self.customView.safeareaTopView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            self.customView.viewFinderView.hidden = YES;
        }
        
        self.customView.titleLabel.text = self.topTitle;
        self.customView.infoButton.hidden = self.infoButtonHidden;
        
//        self.customView.infoButton.tintColor = self.cameraTintColor;
        self.customView.delegate = self;
        [self setCameraOverlayView:self.customView];
    }
}

- (void)setBackgroundImageViewLayer {
    
    self.customView.topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.backgroundImageViewLayer.path = [self getBackgroundImageViewOverlayPath:[self sizeOfImage:self.backgroundImage inAspectFitImageView:self.customView.backgroundImageView AndOrientation:UIDeviceOrientationLandscapeRight]].CGPath;
    } else {
        self.backgroundImageViewLayer.path = [self getBackgroundImageViewOverlayPath:[self sizeOfImage:self.backgroundImage inAspectFitImageView:self.customView.backgroundImageView AndOrientation:UIDeviceOrientationPortrait]].CGPath;
    }
    
    self.backgroundImageViewLayer.fillRule = kCAFillRuleEvenOdd;
    self.backgroundImageViewLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
    [self.customView.backgroundImageViewFillColorView.layer addSublayer:self.backgroundImageViewLayer];
}

- (CGSize) sizeOfImage:(UIImage*)image inAspectFitImageView:(UIImageView*)imageView AndOrientation:(UIDeviceOrientation)orientation
{
    CGFloat imageViewWidth = imageView.bounds.size.width;
    CGFloat imageViewHeight = imageView.bounds.size.height;

    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat scaleFactor = MIN(imageViewWidth / imageWidth, imageViewHeight / imageHeight);
    CGSize imageSize = CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);
    
    // Lets round to avoid the transparent less than 1px lines
    if (imageSize.width - floor(imageSize.width) < 0.5) {
        imageSize.width = floor(imageSize.width);
    }
    
#if DEBUG
    NSLog(@"Background image Size:- width=%f, height=%f scaleFactor=%f",imageWidth, imageHeight, scaleFactor);
    NSLog(@"Background scaled Image :- width=%f, height=%f",imageSize.width, imageSize.height);
#endif
    
    return imageSize;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidChangeStatusBarOrientationNotification//UIDeviceOrientationDidChangeNotification
                                                  object:nil];

}

- (BOOL)shouldAutorotate {
    if(self.forceLandscape) {
        return NO;
    } else {
        return YES;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if(self.forceLandscape) {
#if DEBUG
        NSLog(@"CuemeCameraPickerCustom : supportedInterfaceOrientations : forceLandscape");
#endif
        return UIInterfaceOrientationMaskLandscapeRight;

    } else {
#if DEBUG
        NSLog(@"CuemeCameraPickerCustom : supportedInterfaceOrientations : UIInterfaceOrientationMaskPortrait & UIInterfaceOrientationMaskLandscapeRight");
#endif
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    if(self.forceLandscape) {
#if DEBUG
        NSLog(@"CuemeCameraPickerCustom : preferredInterfaceOrientationForPresentation : forceLandscape");
#endif
        return UIInterfaceOrientationLandscapeRight;

    } else {
#if DEBUG
        NSLog(@"CuemeCameraPickerCustom : preferredInterfaceOrientationForPresentation : orientation=%ld", (long)[[UIApplication sharedApplication] statusBarOrientation]);
#endif
        switch ([[UIApplication sharedApplication] statusBarOrientation]) {
            
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                return UIInterfaceOrientationLandscapeRight;
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
            case UIInterfaceOrientationPortrait:
                return UIInterfaceOrientationPortrait;
                
            default:
                return UIInterfaceOrientationPortrait;
                break;
        }
    }
}

- (UIImage *)getImageUsingBase64String:(NSString *)imageBase64String {
    
    NSString *base64Input = imageBase64String;
    NSRange startRange = [base64Input rangeOfString:@"," options:NSBackwardsSearch];
    if (startRange.location != NSNotFound) {
        base64Input = [base64Input substringFromIndex:((startRange.location) + 1)];
    }
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64Input options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithData:imageData];
}

- (void)didFrameWithOrientation:(NSNotification *)notification
{
    /*if(self.customized) {
        
        [self updateOrientation:[[UIDevice currentDevice] orientation]];
    }*/
    
    if(self.customized) {
#if DEBUG
        NSLog(@"CuemeCameraPickerCustom : didFrameWithOrientation : orientation=%ld", (long)[[UIDevice currentDevice] orientation]);
#endif
        [self updateUIDependsOnOrientation:[[UIDevice currentDevice] orientation]];
        if(self.enableViewFinder) {

            [self.viewFinderLayer removeFromSuperlayer];

            self.viewFinderLayer.path = [self getViewFinderOverlayPath].CGPath;
            self.viewFinderLayer.fillRule = kCAFillRuleEvenOdd;
            self.viewFinderLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;

            [self.customView.viewFinderView.layer addSublayer:self.viewFinderLayer];
                        
            self.customView.topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            
        } else {
            [self.backgroundImageViewLayer removeFromSuperlayer];
            [self setBackgroundImageViewLayer];
        }
    }
}

- (UIBezierPath *)getViewFinderOverlayPath {
    
    UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:self.customView.viewFinderView.bounds];
    UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRect:CGRectMake((self.customView.viewFinderView.bounds.size.width / 2) - (self.viewFinderSize.width/2), (self.customView.viewFinderView.bounds.size.height / 2) - (self.viewFinderSize.height/2), self.viewFinderSize.width, self.viewFinderSize.height)];
    [overlayPath appendPath:transparentPath];
    [overlayPath setUsesEvenOddFillRule:YES];
    
    return overlayPath;
}

- (UIBezierPath *)getBackgroundImageViewOverlayPath:(CGSize)layerSize {
    
    UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:self.customView.backgroundImageViewFillColorView.bounds];
    UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRect:CGRectMake((self.customView.backgroundImageViewFillColorView.bounds.size.width / 2) - (layerSize.width/2), (self.customView.backgroundImageViewFillColorView.bounds.size.height / 2) - (layerSize.height/2), layerSize.width, layerSize.height)];
    [overlayPath appendPath:transparentPath];
    [overlayPath setUsesEvenOddFillRule:YES];
    
    return overlayPath;
}

- (void)updateUIDependsOnOrientation:(UIDeviceOrientation)orientation {
    
    CGFloat bottomSafeArea = 0.0;
    
    if (@available(iOS 11.0, *)) {
        bottomSafeArea = self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            if(!self.customView.captureButtonTrailingConstraint) {
                
                self.customView.captureButtonTrailingConstraint = [NSLayoutConstraint
                                                                   constraintWithItem:self.customView.captureButton
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.customView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0f
                                                                   constant:-20.0f - bottomSafeArea];
            }
            
            if(!self.customView.captureButtonCenterYConstraint) {
                
                self.customView.captureButtonCenterYConstraint = [NSLayoutConstraint
                                                                  constraintWithItem:self.customView.captureButton
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.customView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0f
                                                                  constant:0.0f];
            }
            
            [self.customView.captureButtonBottomConstraint setActive:NO];
            [self.customView.captureButtonCenterXConstraint setActive:NO];
            
            [self.customView.captureButtonTrailingConstraint setActive:YES];
            [self.customView.captureButtonCenterYConstraint setActive:YES];
            
            //Change aspectratio view aspect to Fill (Full Screen) else default is Fit
            if([self.previewMode isEqualToString:@"Fill"]) {
                
                if(self.customView.frame.size.width > self.customView.frame.size.height) {
                    
                    self.customView.aspectRatioView.frame = CGRectMake(0, self.customView.topView.frame.size.height, self.customView.frame.size.width, self.customView.frame.size.height - self.customView.topView.frame.size.height);
                    
                } else {
                    
                    self.customView.aspectRatioView.frame = CGRectMake(0, self.customView.topView.frame.size.height, self.customView.frame.size.height, self.customView.frame.size.width - self.customView.topView.frame.size.height);
                }
                
            } else {
                
                self.customView.aspectRatioView.frame = CGRectMake(0, self.customView.topView.frame.size.height, self.customView.cameraAspectRatio.height, self.customView.cameraAspectRatio.width - self.customView.topView.frame.size.height);
            }
            
            self.customView.viewFinderView.frame = CGRectMake(0, 0, self.customView.aspectRatioView.frame.size.width, self.customView.aspectRatioView.frame.size.height);
            
            self.customView.backgroundImageViewFillColorView.frame = CGRectMake(0, 0, self.customView.aspectRatioView.frame.size.width, self.customView.aspectRatioView.frame.size.height);

            self.customView.backgroundImageView.frame = CGRectMake(0, 0, self.customView.aspectRatioView.frame.size.width, self.customView.aspectRatioView.frame.size.height);
        }
            
            break;
        default://Portrait
        {
            if(!self.customView.captureButtonBottomConstraint) {
                
                self.customView.captureButtonBottomConstraint = [NSLayoutConstraint
                                                                 constraintWithItem:self.customView.captureButton
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.customView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                 constant:-20.0f - bottomSafeArea];
            }
            
            if(!self.customView.captureButtonCenterXConstraint) {
                
                self.customView.captureButtonCenterXConstraint = [NSLayoutConstraint
                                                                  constraintWithItem:self.customView.captureButton
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.customView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0f
                                                                  constant:0.0f];
            }
            
            [self.customView.captureButtonTrailingConstraint setActive:NO];
            [self.customView.captureButtonCenterYConstraint setActive:NO];

            [self.customView.captureButtonBottomConstraint setActive:YES];
            [self.customView.captureButtonCenterXConstraint setActive:YES];
            
            //Change aspectratio view aspect to Fill (Full Screen) else default is Fit
            if([self.previewMode isEqualToString:@"Fill"]) {
                
                if(self.customView.frame.size.width > self.customView.frame.size.height) {
                    //Changes:- Updating aspectRatioView Y value to 'self.customView.topView.frame.size.height' irrespective of any orientation
                    self.customView.aspectRatioView.frame = CGRectMake(0, self.customView.customViewYValue, self.customView.frame.size.height, self.customView.frame.size.width - self.customView.customViewYValue);
                    
                } else {
                    //Changes:- Updating aspectRatioView Y value to 'self.customView.topView.frame.size.height' irrespective of any orientation
                    self.customView.aspectRatioView.frame = CGRectMake(0, self.customView.customViewYValue, self.customView.frame.size.width, self.customView.frame.size.height - self.customView.customViewYValue);
                }
                
            } else {
                //Changes:- Updating aspectRatioView Y value to 'self.customView.topView.frame.size.height' irrespective of any orientation
                self.customView.aspectRatioView.frame = CGRectMake(0, self.customView.customViewYValue, self.customView.cameraAspectRatio.width, self.customView.cameraAspectRatio.height - self.customView.customViewYValue);
            }
            
            self.customView.viewFinderView.frame = CGRectMake(0, 0, self.customView.aspectRatioView.frame.size.width, self.customView.aspectRatioView.frame.size.height);
            
            self.customView.backgroundImageViewFillColorView.frame = CGRectMake(0, 0, self.customView.aspectRatioView.frame.size.width, self.customView.aspectRatioView.frame.size.height);
            
            self.customView.backgroundImageView.frame = CGRectMake(0, 0, self.customView.aspectRatioView.frame.size.width, self.customView.aspectRatioView.frame.size.height);
            
        }
            break;
    }
    
    [self.customView.captureButton setNeedsUpdateConstraints];
    [self.customView.captureButton setNeedsLayout];
    
    [self.customView.aspectRatioView setNeedsUpdateConstraints];
    [self.customView.aspectRatioView setNeedsLayout];
}

#pragma mark - CustomView Delegate Methods -

- (void)closeButtonClicked {
    if(self.cameraHandler) {
        [self.cameraHandler handleUIEvent:@"backButton" data:@"backButton Clicked"];
    }
    
    // This call will close the UI
    if(self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

- (void)infoButtonClicked {
    if(self.cameraHandler) {
        [self.cameraHandler handleUIEvent:@"infoButton" data:@"infoButton Clicked"];
    }
    
    // This call will close the UI
    if(self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

- (void)captureButtonClicked {
    
    [UIButton animateWithDuration:0.2 animations:^{
        
        self.customView.captureButton.transform = CGAffineTransformMakeScale(0.7, 0.7);
        
    } completion:^(BOOL finished) {
        
        [UIButton animateWithDuration:.2 animations:^{
            
            self.customView.captureButton.transform = CGAffineTransformIdentity;

        }];
    }];
    
    [self takePicture];
}

@end
