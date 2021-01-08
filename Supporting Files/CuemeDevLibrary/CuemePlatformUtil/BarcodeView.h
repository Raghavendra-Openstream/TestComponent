//
//  BarcodeView.h
//  CuemePlatformUtil
//
//  Created by Anthapu Ravindranatha Reddy on 8/5/14.
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * BarcodeView class was implemented to get a callback when orientation changes or the view is 
 * resized. The layoutSubviews is called when barcode view resizes, we hable resising the camera
 * preview view and setting the orientation for the camera in the layoutSubviews callback.
 */
@interface BarcodeView : UIView
- (void) setCameraPreviewlayer:(AVCaptureVideoPreviewLayer *)layer ;
- (AVCaptureVideoPreviewLayer *) getCameraPreviewlayer;
@end
